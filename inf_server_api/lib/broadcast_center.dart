/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';
import 'package:quiver/collection.dart';
import 'package:switchboard/switchboard.dart';

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
  final sqljocky.ConnectionPool sql;
  final dospace.Bucket bucket;

  final HttpClient _httpClient = new HttpClient();

  Multimap<Int64, ApiChannel> _accountToApiChannels =
      new Multimap<Int64, ApiChannel>();

  CacheMap<Int64, _CachedProposal> _proposalToInfluencerBusiness =
      new CacheMap<Int64, _CachedProposal>();

  final _lockCachedAccountName = new Lock();
  CacheMap<Int64, _CachedAccountName> _cachedAccountName =
      new CacheMap<Int64, _CachedAccountName>();
  final _lockCachedAccountFirebaseTokens = new Lock();
  CacheMap<Int64, _CachedAccountFirebaseTokens> _cachedAccountFirebaseTokens =
      new CacheMap<Int64, _CachedAccountFirebaseTokens>();

  static final Logger opsLog = new Logger('InfOps.BroadcastCenter');
  static final Logger devLog = new Logger('InfDev.BroadcastCenter');

  BroadcastCenter(this.config, this.sql, this.bucket) {}

  /////////////////////////////////////////////////////////////////////////////
  // Caches (cache non-critical static-ish data only)
  /////////////////////////////////////////////////////////////////////////////

  Future<_CachedProposal> _getProposal(Int64 proposalId) async {
    _CachedProposal proposal = _proposalToInfluencerBusiness[proposalId];
    if (proposal != null) return proposal;
    sqljocky.Results res = await sql.prepareExecute(
        "SELECT `influencer_account_id`, `business_account_id`, `sender_account_id` "
        "FROM `proposals` WHERE `proposal_id` = ?",
        [proposalId]);
    await for (sqljocky.Row row in res) {
      proposal = new _CachedProposal(
          new Int64(row[0]), new Int64(row[1]), new Int64(row[2]));
      _proposalToInfluencerBusiness[proposalId] = proposal;
    }
    return proposal; // May be null if not found
  }

  Future<String> _getAccountName(Int64 accountId) async {
    _CachedAccountName cached = _cachedAccountName[accountId];
    if (cached != null) return cached.name;
    await _lockCachedAccountName.synchronized(() async {
      sqljocky.Results res = await sql.prepareExecute(
          "SELECT `name`"
          "FROM `accounts` "
          "WHERE `account_id` = ? ",
          [accountId]);
      await for (sqljocky.Row row in res) {
        cached = new _CachedAccountName(row[0].toString());
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
      Set<String> firebaseTokens = new Set<String>();
      sqljocky.Results res = await sql.prepareExecute(
          "SELECT `firebase_token`"
          "FROM `sessions` "
          "WHERE `account_id` = ? ",
          [accountId]);
      await for (sqljocky.Row row in res) {
        if (row[0] != null) {
          String firebaseToken = row[0].toString();
          firebaseTokens.add(firebaseToken);
        }
      }
      cached = new _CachedAccountFirebaseTokens(firebaseTokens.toList());
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

  Future<void> _push(Int64 senderDeviceId, Int64 receiverAccountId,
      String procedureId, Uint8List data) async {
    // Push to apps connected locally
    for (ApiChannel apiChannel in _accountToApiChannels[receiverAccountId]) {
      try {
        if (apiChannel.account.state.sessionId != senderDeviceId) {
          apiChannel.channel.sendMessage(procedureId, data);
        }
      } catch (error, stackTrace) {
        devLog.warning("Exception while pushing to remote app: $error\n$stackTrace");
      }
    }

    // TODO: Push to apps connected on remote servers if applicable
  }

  // TODO: Offer changed: Sends to same account to sync sessions when multi devicing...

  Future<void> _pushProposalPosted(Int64 senderDeviceId,
      Int64 receiverAccountId, DataProposal proposal) async {
    // Push to local apps and and apps on remote servers
    // (Proposal creation always causes a first haggle chat to be sent, so no Firebase post)
    await _push(senderDeviceId, receiverAccountId, "LN_APPLI",
        proposal.writeToBuffer());
  }

  Future<void> _pushProposalChanged(Int64 senderDeviceId,
      Int64 receiverAccountId, DataProposal proposal) async {
    // Push only to local apps and and apps on remote servers
    // (Important changes are posted through chat marker, so no Firebase posting here)
    await _push(senderDeviceId, receiverAccountId, "LU_APPLI",
        proposal.writeToBuffer());
  }

  Future<void> _pushProposalChatPosted(Int64 senderDeviceId,
      Int64 receiverAccountId, DataProposalChat chat) async {
    // Push to local apps and and apps on remote servers
    await _push(
        senderDeviceId, receiverAccountId, "LN_A_CHA", chat.writeToBuffer());

    // Push Firebase (even if sent directly, Firebase notifications don't show while the app is running)
    // Don't send notifications to the sender
    if (receiverAccountId != chat.senderId) {
      // TODO: && !_accountToApiChannels.contains(receiverAccountId) - once clients disconnect in the background!
      String senderName = await _getAccountName(chat.senderId);
      List<String> receiverFirebaseTokens =
          await _getAccountFirebaseTokens(receiverAccountId);
      Map<String, dynamic> notification = new Map<String, dynamic>();
      notification['title'] = senderName;
      notification['body'] = chat.text;
      notification['click_action'] = 'FLUTTER_NOTIFICATION_CLICK';
      notification['android_channel_id'] = 'chat';
      Map<String, dynamic> data = new Map<String, dynamic>();
      data['sender_id'] = chat.senderId;
      data['account_id'] = receiverAccountId;
      data['proposal_id'] = chat.proposalId;
      data['type'] = chat.type.value;
      data['environment'] = config.services.environment;
      Map<String, dynamic> message = new Map<String, dynamic>();
      message['registration_ids'] = receiverFirebaseTokens;
      message['collapse_key'] = 'proposal_id=' + chat.proposalId.toString();
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
      BytesBuilder responseBuilder = new BytesBuilder(copy: false);
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

/*
  Future<void> _pushProposalChatSeen(int accountId, DataProposalChat chat) async {
    // TODO: Push Locally
    // TODO: Push Remote Server
  }
  */

  /////////////////////////////////////////////////////////////////////////////
  // Hooks
  /////////////////////////////////////////////////////////////////////////////

  void accountConnected(ApiChannel apiChannel) {
    _accountToApiChannels.add(apiChannel.account.state.accountId, apiChannel);

    // TODO: Signal remote servers (if only first session for account here)
  }

  void accountDisconnected(ApiChannel apiChannel) {
    if (_accountToApiChannels.remove(
        apiChannel.account.state.accountId, apiChannel)) {
      // TODO: Signal remote servers (if no more sessions for account here)
    }
  }

  void accountFirebaseTokensChanged(ApiChannel apiChannel) {
    // TODO: Signal remote servers
    _dirtyAccountFirebaseTokens(apiChannel.account.state.accountId);
  }

  Future<void> proposalPosted(Int64 senderDeviceId, DataProposal proposal,
      DataAccount influencerAccount) async {
    // Store cache
    _proposalToInfluencerBusiness[proposal.proposalId] = new _CachedProposal(
        proposal.influencerAccountId,
        proposal.businessAccountId,
        proposal.senderAccountId);

    // Push notifications
    await _pushProposalPosted(
        senderDeviceId, proposal.influencerAccountId, proposal);
    await _pushProposalPosted(
        senderDeviceId, proposal.businessAccountId, proposal);
    if (proposal.senderAccountId != proposal.influencerAccountId &&
        proposal.senderAccountId != proposal.businessAccountId &&
        proposal.senderAccountId != 0 /* Temporary != 0 check */) {
      await _pushProposalPosted(
          senderDeviceId, proposal.senderAccountId, proposal);
    }

    devLog.fine(
        "Pushed proposal ${proposal.proposalId}: '${influencerAccount.summary.name}'");
  }

  Future<void> proposalChanged(
      Int64 senderDeviceId, DataProposal proposal) async {
    // Store cache
    _proposalToInfluencerBusiness[proposal.proposalId] = new _CachedProposal(
        proposal.influencerAccountId,
        proposal.businessAccountId,
        proposal.senderAccountId);

    // Push notifications
    await _pushProposalChanged(
        senderDeviceId, proposal.influencerAccountId, proposal);
    await _pushProposalChanged(
        senderDeviceId, proposal.businessAccountId, proposal);
    if (proposal.senderAccountId != proposal.influencerAccountId &&
        proposal.senderAccountId != proposal.businessAccountId &&
        proposal.senderAccountId != 0 /* Temporary != 0 check */) {
      await _pushProposalChanged(
          senderDeviceId, proposal.senderAccountId, proposal);
    }
  }

  Future<void> proposalChatPosted(Int64 senderDeviceId, DataProposalChat chat,
      DataAccount senderAccount) async {
    // Get cache
    _CachedProposal proposal = await _getProposal(chat.proposalId);
    if (proposal == null) return; // Ignore

    // Push notifications
    await _pushProposalChatPosted(
        senderDeviceId, proposal.influencerAccountId, chat);
    await _pushProposalChatPosted(
        senderDeviceId, proposal.businessAccountId, chat);
    if (chat.senderId != proposal.influencerAccountId &&
        chat.senderId != proposal.businessAccountId)
      // Unusual case, sender is neither of influencer or business...
      await _pushProposalChatPosted(senderDeviceId, chat.senderId, chat);

    devLog.fine(
        "Pushed proposal '${senderAccount.summary.name}' chat '${chat.text}'");
  }

/*
  Future<void> proposalChatSeen(int senderId, DataProposalChat chat) async {
    // Get cache
    _CachedProposal proposal = await _getProposal(chat.proposalId);
    if (proposal == null) return; // Ignore
    
    // Push notifications
    if (proposal.senderId != senderId)
      _pushProposalChatPosted(proposal.influencerAccountId, chat);
    if (proposal.businessAccountId != senderId)
      _pushProposalChatPosted(proposal.businessAccountId, chat);
  }
  */

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
}

/* end of file */
