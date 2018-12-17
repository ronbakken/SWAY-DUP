/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';
import 'package:quiver/collection.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;
import 'package:synchronized/synchronized.dart';

import 'package:inf_common/inf_common.dart';
import 'api_channel.dart';
import 'cache_map.dart';

class _CachedProposal {
  final Int64 influencerAccountId;
  final Int64 businessAccountId;
  final Int64 senderAccountId;
  _CachedProposal(
      this.influencerAccountId, this.businessAccountId, this.senderAccountId);
}

/// Cached account information with the purpose of sending notifications
class _CachedAccountName {
  final String name;
  _CachedAccountName(this.name);
}

class _CachedAccountFirebaseTokens {
  final List<String> firebaseTokens;
  _CachedAccountFirebaseTokens(this.firebaseTokens);
}

class BroadcastCenter {
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////

  final ConfigData config;
  final sqljocky.ConnectionPool accountDb;
  final sqljocky.ConnectionPool proposalDb;
  final dospace.Bucket bucket;

  final HttpClient _httpClient = HttpClient();

  final Multimap<Int64, ApiChannel> _accountToApiChannels =
      Multimap<Int64, ApiChannel>();

  final CacheMap<Int64, _CachedProposal> _proposalToInfluencerBusiness =
      CacheMap<Int64, _CachedProposal>();

  final Lock _lockCachedAccountName = Lock();
  final CacheMap<Int64, _CachedAccountName> _cachedAccountName =
      CacheMap<Int64, _CachedAccountName>();
  final Lock _lockCachedAccountFirebaseTokens = Lock();
  final CacheMap<Int64, _CachedAccountFirebaseTokens>
      _cachedAccountFirebaseTokens =
      CacheMap<Int64, _CachedAccountFirebaseTokens>();

  static final Logger opsLog = Logger('InfOps.BroadcastCenter');
  static final Logger devLog = Logger('InfDev.BroadcastCenter');

  BroadcastCenter(this.config, this.accountDb, this.proposalDb, this.bucket);

  /////////////////////////////////////////////////////////////////////////////
  // Caches (cache non-critical static-ish data only)
  /////////////////////////////////////////////////////////////////////////////

  Future<_CachedProposal> _getProposal(Int64 proposalId) async {
    _CachedProposal proposal = _proposalToInfluencerBusiness[proposalId];
    if (proposal != null) return proposal;
    sqljocky.Results res = await proposalDb.prepareExecute(
        'SELECT `influencer_account_id`, `business_account_id`, `sender_account_id` '
        'FROM `proposals` WHERE `proposal_id` = ?',
        <dynamic>[proposalId]);
    await for (sqljocky.Row row in res) {
      proposal = _CachedProposal(Int64(row[0]), Int64(row[1]), Int64(row[2]));
      _proposalToInfluencerBusiness[proposalId] = proposal;
    }
    return proposal; // May be null if not found
  }

  Future<String> _getAccountName(Int64 accountId) async {
    _CachedAccountName cached = _cachedAccountName[accountId];
    if (cached != null) {
      return cached.name;
    }
    await _lockCachedAccountName.synchronized(() async {
      sqljocky.Results res = await accountDb.prepareExecute(
          "SELECT `name`" // TODO: Elasticsearch profile
          "FROM `accounts` "
          "WHERE `account_id` = ? ",
          <dynamic>[accountId]);
      await for (sqljocky.Row row in res) {
        cached = _CachedAccountName(row[0].toString());
        _cachedAccountName[accountId] = cached;
      }
    });
    return cached.name; // May be null if not found
  }

  Future<List<String>> _getAccountFirebaseTokens(Int64 accountId) async {
    _CachedAccountFirebaseTokens cached =
        _cachedAccountFirebaseTokens[accountId];
    if (cached != null) return cached.firebaseTokens;
    await _lockCachedAccountFirebaseTokens.synchronized(() async {
      Set<String> firebaseTokens = Set<String>();
      sqljocky.Results res = await accountDb.prepareExecute(
          "SELECT `firebase_token`"
          "FROM `sessions` "
          "WHERE `account_id` = ? ",
          <dynamic>[accountId]);
      await for (sqljocky.Row row in res) {
        if (row[0] != null) {
          String firebaseToken = row[0].toString();
          firebaseTokens.add(firebaseToken);
        }
      }
      cached = _CachedAccountFirebaseTokens(firebaseTokens.toList());
      _cachedAccountFirebaseTokens[accountId] = cached;
    });
    return cached.firebaseTokens;
  }

  void _dirtyAccountFirebaseTokens(Int64 accountId) {
    _lockCachedAccountFirebaseTokens.synchronized(() async {
      _cachedAccountFirebaseTokens.remove(accountId);
    });
  }

  /////////////////////////////////////////////////////////////////////////////
  // Senders
  /////////////////////////////////////////////////////////////////////////////

  Future<void> _push(Int64 senderSessionId, Int64 receiverAccountId,
      String procedureId, Uint8List data) async {
    // Push to apps connected locally
    for (ApiChannel apiChannel in _accountToApiChannels[receiverAccountId]) {
      try {
        if (apiChannel.account.sessionId != senderSessionId) {
          apiChannel.channel.sendMessage(procedureId, data);
        }
      } catch (error, stackTrace) {
        devLog.warning(
            "Exception while pushing to remote app", error, stackTrace);
      }
    }

    // TODO: Push to apps connected on remote servers if applicable
  }

  Future<void> _pushAccountChanged(Int64 senderSessionId,
      Int64 receiverAccountId, DataAccount account) async {
    await _push(senderSessionId, receiverAccountId, "ACCOUNTU",
        account.writeToBuffer());
  }

  // Offer changed: Sends to same account to sync sessions when multi devicing...
  Future<void> _pushOfferChanged(
      Int64 senderSessionId, Int64 receiverAccountId, DataOffer offer) async {
    await _push(
        senderSessionId, receiverAccountId, "LU_OFFER", offer.writeToBuffer());
  }

  Future<void> _pushProposalPosted(Int64 senderSessionId,
      Int64 receiverAccountId, NetProposal proposal) async {
    // Push to local apps and and apps on remote servers
    // (Proposal creation always causes a first haggle chat to be sent, so no Firebase post)
    await _push(senderSessionId, receiverAccountId, "LN_PRPSL",
        proposal.writeToBuffer());
  }

  Future<void> _pushProposalChanged(Int64 senderSessionId,
      Int64 receiverAccountId, NetProposal proposal) async {
    // Push only to local apps and and apps on remote servers
    // (Important changes are posted through chat marker, so no Firebase posting here)
    await _push(senderSessionId, receiverAccountId, "LU_PRPSL",
        proposal.writeToBuffer());
  }

  Future<void> _pushProposalChatPosted(Int64 senderSessionId,
      Int64 receiverAccountId, NetProposalChat chat) async {
    // Push to local apps and and apps on remote servers
    await _push(
        senderSessionId, receiverAccountId, "LN_P_CHA", chat.writeToBuffer());

    // Push Firebase (even if sent directly, Firebase notifications don't show while the app is running)
    // Don't send notifications to the sender
    if (receiverAccountId != chat.chat.senderAccountId) {
      // TODO: && !_accountToApiChannels.contains(receiverAccountId) - once clients disconnect in the background!
      String senderName = await _getAccountName(chat.chat.senderAccountId);
      List<String> receiverFirebaseTokens =
          await _getAccountFirebaseTokens(receiverAccountId);
      Map<String, dynamic> notification = Map<String, dynamic>();
      notification['title'] = senderName;
      notification['body'] = chat.chat.plainText ??
          "A proposal has been updated."; // TODO: Generate text version of non-text messages
      notification['click_action'] = 'FLUTTER_NOTIFICATION_CLICK';
      notification['android_channel_id'] = 'chat';
      Map<String, dynamic> data = Map<String, dynamic>();
      data['sender_account_id'] = chat.chat.senderAccountId.toInt();
      data['receiver_account_id'] = receiverAccountId.toInt();
      data['proposal_id'] = chat.chat.proposalId.toInt();
      data['type'] = chat.chat.type.value;
      // TODO: Include image key, terms, etc, or not?
      data['domain'] = config.services.domain;
      Map<String, dynamic> message = Map<String, dynamic>();
      message['registration_ids'] = receiverFirebaseTokens;
      message['collapse_key'] =
          'proposal_id=' + chat.chat.proposalId.toString();
      message['notification'] = notification;
      message['data'] = data;
      String jm = json.encode(message);
      devLog.finest(jm);
      HttpClientRequest req = await _httpClient
          .postUrl(Uri.parse(config.services.firebaseLegacyApi));
      req.headers.add('Content-Type', 'application/json');
      req.headers.add(
          'Authorization', 'key=' + config.services.firebaseLegacyServerKey);
      req.add(utf8.encode(jm));
      HttpClientResponse res = await req.close();
      BytesBuilder responseBuilder = BytesBuilder(copy: false);
      await res.forEach(responseBuilder.add);
      if (res.statusCode != 200) {
        opsLog.warning(
            "Status code ${res.statusCode}, request: $jm, response: ${utf8.decode(responseBuilder.toBytes())}");
      }
      String rs = utf8.decode(responseBuilder.toBytes());
      devLog.finest("Firebase sent OK, response: ${rs}");
      Map<dynamic, dynamic> doc = json.decode(rs);
      if (doc['failure'].toInt() > 0) {
        devLog.warning(
            "Failed to send Firebase notification to ${doc['failure']} recipient sessions, validate all tokens.");
        // TODO: Validate all registrations
      }
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  // Hooks
  /////////////////////////////////////////////////////////////////////////////

  void accountConnected(ApiChannel apiChannel) {
    _accountToApiChannels.add(apiChannel.account.accountId, apiChannel);

    // TODO: Signal remote servers (if only first session for account here)
  }

  void accountDisconnected(ApiChannel apiChannel) {
    if (_accountToApiChannels.remove(
        apiChannel.account.accountId, apiChannel)) {
      // TODO: Signal remote servers (if no more sessions for account here)
    }
  }

  void accountFirebaseTokensChanged(ApiChannel apiChannel) {
    // TODO: Signal remote servers
    _dirtyAccountFirebaseTokens(apiChannel.account.accountId);
  }

  // TODO: Ensure this gets called everywhere it's applicable
  /// Forwards the account to any other sessions of this user
  Future<void> accountChanged(
      Int64 senderSessionId, DataAccount account) async {
    await _pushAccountChanged(senderSessionId, account.accountId, account);
  }

  // TODO: Ensure this gets called everywhere it's applicable
  /// Forwards the offer to any other sessions of this user
  Future<void> offerChanged(Int64 senderSessionId, DataOffer offer) async {
    await _pushOfferChanged(senderSessionId, offer.senderAccountId, offer);
  }

  /// TODO: Filter business and influencer options for proposal if applicable (provide two parameters)
  Future<void> proposalPosted(Int64 senderSessionId, NetProposal proposal,
      DataAccount influencerAccount) async {
    // Store cache
    _proposalToInfluencerBusiness[proposal.proposal.proposalId] =
        _CachedProposal(
            proposal.proposal.influencerAccountId,
            proposal.proposal.businessAccountId,
            proposal.proposal.senderAccountId);

    // Push notifications
    await _pushProposalPosted(
        senderSessionId, proposal.proposal.influencerAccountId, proposal);
    await _pushProposalPosted(
        senderSessionId, proposal.proposal.businessAccountId, proposal);
    if (proposal.proposal.senderAccountId !=
            proposal.proposal.influencerAccountId &&
        proposal.proposal.senderAccountId !=
            proposal.proposal.businessAccountId &&
        proposal.proposal.senderAccountId != Int64.ZERO) {
      await _pushProposalPosted(
          senderSessionId, proposal.proposal.senderAccountId, proposal);
    }
    if (proposal.proposal.offerAccountId !=
            proposal.proposal.influencerAccountId &&
        proposal.proposal.offerAccountId !=
            proposal.proposal.businessAccountId &&
        proposal.proposal.offerAccountId != proposal.proposal.senderAccountId &&
        proposal.proposal.offerAccountId != Int64.ZERO) {
      await _pushProposalPosted(
          senderSessionId, proposal.proposal.senderAccountId, proposal);
    }

    devLog.fine(
        "Pushed proposal ${proposal.proposal.proposalId}: '${influencerAccount.name}'");
  }

  /// TODO: Filter business and influencer values from proposal
  /// This feature takes diff changes. Changes to lastChatId must not be sent
  Future<void> proposalChanged(
      Int64 senderSessionId, NetProposal proposal) async {
    // Store cache
    _proposalToInfluencerBusiness[proposal.proposal.proposalId] =
        _CachedProposal(
            proposal.proposal.influencerAccountId,
            proposal.proposal.businessAccountId,
            proposal.proposal.senderAccountId);

    // Push notifications
    await _pushProposalChanged(
        senderSessionId, proposal.proposal.influencerAccountId, proposal);
    await _pushProposalChanged(
        senderSessionId, proposal.proposal.businessAccountId, proposal);
    if (proposal.proposal.senderAccountId !=
            proposal.proposal.influencerAccountId &&
        proposal.proposal.senderAccountId !=
            proposal.proposal.businessAccountId &&
        proposal.proposal.senderAccountId != Int64.ZERO) {
      await _pushProposalChanged(
          senderSessionId, proposal.proposal.senderAccountId, proposal);
    }
    if (proposal.proposal.offerAccountId !=
            proposal.proposal.influencerAccountId &&
        proposal.proposal.offerAccountId !=
            proposal.proposal.businessAccountId &&
        proposal.proposal.offerAccountId != proposal.proposal.senderAccountId &&
        proposal.proposal.offerAccountId != Int64.ZERO) {
      await _pushProposalChanged(
          senderSessionId, proposal.proposal.senderAccountId, proposal);
    }
  }

  Future<void> proposalChatPosted(Int64 senderSessionId, NetProposalChat chat,
      DataAccount senderAccount) async {
    // Get cache
    final _CachedProposal proposal = await _getProposal(chat.chat.proposalId);
    if (proposal == null) {
      return; // Ignore
    }

    // Push notifications
    await _pushProposalChatPosted(
        senderSessionId, proposal.influencerAccountId, chat);
    await _pushProposalChatPosted(
        senderSessionId, proposal.businessAccountId, chat);
    if (chat.chat.senderAccountId != proposal.influencerAccountId &&
        chat.chat.senderAccountId != proposal.businessAccountId)
      // Unusual case, sender is neither of influencer or business...
      await _pushProposalChatPosted(
          senderSessionId, chat.chat.senderAccountId, chat);

    devLog.fine('Pushed proposal "${senderAccount.name}" chat "${chat.chat}"');
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
}

/* end of file */
