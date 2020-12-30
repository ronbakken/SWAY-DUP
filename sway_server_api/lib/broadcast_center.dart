/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';
import 'package:pedantic/pedantic.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;
import 'package:grpc/grpc.dart' as grpc;

import 'package:sway_common/inf_backend.dart';
import 'cache_map.dart';

class _CachedProposal {
  final Int64 influencerAccountId;
  final Int64 businessAccountId;
  final Int64 senderAccountId;
  _CachedProposal(
      this.influencerAccountId, this.businessAccountId, this.senderAccountId);
}

class BroadcastCenter {
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////

  final ConfigData config;
  final sqljocky.ConnectionPool accountDb;
  final sqljocky.ConnectionPool proposalDb;
  final dospace.Bucket bucket;

  grpc.ClientChannel backendPushChannel;
  BackendPushClient backendPush;

  final CacheMap<Int64, _CachedProposal> _proposalToInfluencerBusiness =
      CacheMap<Int64, _CachedProposal>();

  static final Logger opsLog = Logger('InfOps.BroadcastCenter');
  static final Logger devLog = Logger('InfDev.BroadcastCenter');

  BroadcastCenter(this.config, this.accountDb, this.proposalDb, this.bucket) {
    final Uri backendPushUri = Uri.parse(
        Platform.environment['SWAY_BACKEND_PUSH'] ??
            config.services.backendPush);
    backendPushChannel = grpc.ClientChannel(
      backendPushUri.host,
      port: backendPushUri.port,
      options: const grpc.ChannelOptions(
        credentials: grpc.ChannelCredentials.insecure(),
      ),
    );
    backendPush = BackendPushClient(backendPushChannel);
  }

  /////////////////////////////////////////////////////////////////////////////
  // Caches (cache non-critical static-ish data only)
  /////////////////////////////////////////////////////////////////////////////

  Future<_CachedProposal> _getProposal(Int64 proposalId) async {
    _CachedProposal proposal = _proposalToInfluencerBusiness[proposalId];
    if (proposal != null) {
      return proposal;
    }
    final sqljocky.Results selectResults = await proposalDb.prepareExecute(
        'SELECT `influencer_account_id`, `business_account_id`, `sender_account_id` '
        'FROM `proposals` WHERE `proposal_id` = ?',
        <dynamic>[proposalId]);
    await for (sqljocky.Row row in selectResults) {
      proposal = _CachedProposal(Int64(row[0]), Int64(row[1]), Int64(row[2]));
      _proposalToInfluencerBusiness[proposalId] = proposal;
    }
    return proposal; // May be null if not found
  }

  /////////////////////////////////////////////////////////////////////////////
  // Senders
  /////////////////////////////////////////////////////////////////////////////

  Future<void> _push(
      Int64 senderSessionId, Int64 receiverAccountId, NetPush push) async {
    // Send to push backend
    final ReqPush push = ReqPush();
    // TODO: Proper settings
    push.skipNotificationsWhenOnline = true;
    push.skipSenderSession = true;
    push.sendNotifications = true;
    await backendPush.push(push);
  }

  Future<void> _pushAccountChanged(Int64 senderSessionId,
      Int64 receiverAccountId, DataAccount account) async {
    final NetPush push = NetPush();
    push.updateAccount = NetAccount();
    push.updateAccount.account = account;
    push.freeze();
    await _push(senderSessionId, receiverAccountId, push);
  }

  // Offer changed: Sends to same account to sync sessions when multi devicing...
  Future<void> _pushOfferChanged(
      Int64 senderSessionId, Int64 receiverAccountId, DataOffer offer) async {
    final NetPush push = NetPush();
    push.updateOffer = NetOffer();
    push.updateOffer.offer = offer;
    // TODO: Set NetOffer flags!!!
    push.freeze();
    await _push(senderSessionId, receiverAccountId, push);
  }

  Future<void> _pushProposalPosted(Int64 senderSessionId,
      Int64 receiverAccountId, NetProposal proposal) async {
    // Push to local apps and and apps on remote servers
    // (Proposal creation always causes a first haggle chat to be sent, so no Firebase post)
    final NetPush push = NetPush();
    push.newProposal = proposal;
    push.freeze();
    await _push(senderSessionId, receiverAccountId, push);
  }

  Future<void> _pushProposalChanged(Int64 senderSessionId,
      Int64 receiverAccountId, NetProposal proposal) async {
    // Push only to local apps and and apps on remote servers
    // (Important changes are posted through chat marker, so no Firebase posting here)
    final NetPush push = NetPush();
    push.updateProposal = proposal;
    push.freeze();
    await _push(senderSessionId, receiverAccountId, push);
  }

  Future<void> _pushProposalChatPosted(Int64 senderSessionId,
      Int64 receiverAccountId, NetProposalChat chat) async {
    // Push to local apps and and apps on remote servers
    final NetPush push = NetPush();
    push.newProposalChat = chat;
    push.freeze();
    await _push(senderSessionId, receiverAccountId, push);
  }

  /////////////////////////////////////////////////////////////////////////////
  // Hooks
  /////////////////////////////////////////////////////////////////////////////
/*
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
*/

  Future<void> accountFirebaseTokensChanged(Int64 accountId, Int64 sessionId,
      NetSetFirebaseToken firebaseToken) async {
    final ReqSetFirebaseToken token = ReqSetFirebaseToken();
    token.accountId = accountId;
    token.sessionId = sessionId;
    token.token = firebaseToken;
    token.freeze();
    await backendPush.setFirebaseToken(token);
  }

  // TODO: Ensure this gets called everywhere it's applicable
  /// Forwards the account to any other sessions of this user

  Future<void> accountChanged(
      Int64 senderSessionId, DataAccount account) async {
    await Future.wait<dynamic>(<Future<dynamic>>[
      _pushAccountChanged(senderSessionId, account.accountId, account),
    ]);
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
