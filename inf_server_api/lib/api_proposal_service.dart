/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:inf_server_api/broadcast_center.dart';
import 'package:inf_server_api/common_account.dart';
import 'package:inf_server_api/sql_proposal.dart';
import 'package:logging/logging.dart';

import 'package:grpc/grpc.dart' as grpc;
import 'package:pedantic/pedantic.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:http/http.dart' as http;
import 'package:http_client/console.dart' as http_client;

import 'package:inf_common/inf_backend.dart';

class ApiProposalService extends ApiProposalServiceBase {
  final ConfigData config;
  final sqljocky.ConnectionPool accountDb;
  final sqljocky.ConnectionPool proposalDb;
  final BroadcastCenter bc;
  static final Logger opsLog = Logger('InfOps.ApiProposalService');
  static final Logger devLog = Logger('InfDev.ApiProposalService');

  final http.Client httpClient = http.Client();
  final http_client.Client httpClientClient = http_client.ConsoleClient();

  int _nextFakeGhostId;

  ApiProposalService(this.config, this.accountDb, this.proposalDb, this.bc) {
    // TODO: This might actually conflict if we have multiple services...
    _nextFakeGhostId =
        ((DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000) & 0xFFFFFFF) |
            0x10000000;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<NetProposal> wantDeal(
      grpc.ServiceCall call, NetProposalWantDeal request) async {
    final DataAuth auth = authFromJwtPayload(call);
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readWrite.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    final Int64 proposalId = request.proposalId;
    final Int64 termsChatId = request.termsChatId;

    /* No need, already verified by first UPDATE
    if (!await _verifySender(proposalId, accountId)) {
      channel.sendException("Verification Failed", message);
      return;
    }
    */

    DataProposalChat markerChat; // Set upon success
    await proposalDb.startTransaction((sqljocky.Transaction transaction) async {
      // 1. Update deal to reflect the account wants a deal
      devLog.finest('wantDeal: Update');
      final String accountType = (auth.accountType == AccountType.influencer)
          ? 'influencer'
          : 'business';
      final String updateWants = 'UPDATE `proposals` '
          'SET `${accountType}_wants_deal` = 1 '
          'WHERE `proposal_id` = ? '
          'AND `terms_chat_id` = ? '
          'AND `${accountType}_account_id` = ? '
          'AND (`state` = ${ProposalState.negotiating.value} OR `state` = ${ProposalState.proposing.value}) '
          'AND `${accountType}_wants_deal` = 0';
      final sqljocky.Results resultWants = await transaction.prepareExecute(
        updateWants,
        <dynamic>[proposalId, termsChatId, auth.accountId],
      );
      if (resultWants.affectedRows == null || resultWants.affectedRows == 0) {
        devLog.warning(
            "Invalid want deal attempt by account '${auth.accountId}' on proposal '$proposalId'");
        return;
      }
      await resultWants.drain<void>();

      // 2. Try to see if we're can complete the deal or if it's just one sided
      devLog.finest('wantDeal: Check complete');
      final String updateDeal = 'UPDATE `proposals` '
          'SET `state` = ${ProposalState.deal.value} '
          'WHERE `proposal_id` = ? '
          'AND `influencer_wants_deal` = 1 '
          'AND `business_wants_deal` = 1 '
          'AND (`state` = ${ProposalState.negotiating.value} OR `state` = ${ProposalState.proposing.value})';
      final sqljocky.Results resultDeal = await transaction.prepareExecute(
        updateDeal,
        <dynamic>[proposalId],
      );
      final bool dealMade =
          resultDeal.affectedRows != null && resultDeal.affectedRows > 0;
      await resultDeal.drain<void>();

      // 3. Insert marker chat
      devLog.finest('wantDeal: Insert marker');
      final DataProposalChat chat = DataProposalChat();
      chat.sent = Int64(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      chat.senderAccountId = auth.accountId;
      chat.proposalId = proposalId;
      chat.senderSessionId = auth.sessionId;
      chat.senderSessionGhostId = ++_nextFakeGhostId;
      chat.type = ProposalChatType.marker;
      chat.marker =
          dealMade ? ProposalChatMarker.dealMade : ProposalChatMarker.wantDeal;
      if (await _insertChat(transaction, chat)) {
        // proposalDb, chat)) { // FIXME : !!!! transaction, chat)) { URGENT
        // Unexpected error in procedure 'PR_WADEA': MySQL Client Error: Connection #0 cannot process a request for Instance of 'QueryStreamHandler' while a request is already in progress for Instance of 'ExecuteQueryHandler'
        markerChat = chat;
        devLog.finest('wantDeal: Commit');
        await transaction.commit();
      }
    });

    if (markerChat == null) {
      throw grpc.GrpcError.internal('Not handled.');
    }
    final NetProposal response = NetProposal();
    final DataProposal proposal = await _getProposal(proposalId);
    response.proposal = proposal; // TODO: Filter
    response.chats.add(markerChat);
    response.freeze();

    unawaited(() async {
      // Publish!
      final NetProposal publishProposal = NetProposal();
      publishProposal.proposal = DataProposal()..mergeFromMessage(proposal);
      await bc.proposalChanged(auth.sessionId, publishProposal);
      final NetProposalChat publishChat = NetProposalChat();
      publishChat.chat = DataProposalChat()..mergeFromMessage(markerChat);
      await bc.proposalChatPosted(auth.sessionId, publishChat,
          await fetchSessionAccount(config, accountDb, auth.sessionId));
    }());

    // Send to current user
    return response;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<NetProposal> negotiate(
      grpc.ServiceCall call, NetProposalNegotiate request) async {
    final DataAuth auth = authFromJwtPayload(call);
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readWrite.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    final Int64 proposalId = request.proposalId;

    /* No need, already verified by first UPDATE
    if (!await _verifySender(proposalId, accountId)) {
      channel.sendException("Verification Failed", message);
      return;
    }
    */

    DataProposalChat markerChat; // Set upon success

    await proposalDb.startTransaction((sqljocky.Transaction transaction) async {
      // 1. Update deal to reflect the account wants to negotiate
      final String accountType = (auth.accountType == AccountType.influencer)
          ? 'influencer'
          : 'business';
      final String updateState = 'UPDATE `proposals` '
          'SET `state` = ${ProposalState.negotiating.value} '
          'WHERE `proposal_id` = ? '
          'AND `${accountType}_account_id` = ? '
          'AND `state` = ${ProposalState.proposing.value} '
          'AND `${accountType}_wants_deal` = 0';
      final sqljocky.Results resultState = await transaction.prepareExecute(
        updateState,
        <dynamic>[proposalId, auth.accountId],
      );
      if (resultState.affectedRows == null || resultState.affectedRows == 0) {
        devLog.warning(
            "Invalid want deal attempt by account '${auth.accountId}' on proposal '$proposalId'");
        return;
      }

      // 2. Insert marker chat
      final DataProposalChat chat = DataProposalChat();
      chat.sent = Int64(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      chat.senderAccountId = auth.accountId;
      chat.proposalId = proposalId;
      chat.senderSessionId = auth.sessionId;
      chat.senderSessionGhostId = ++_nextFakeGhostId;
      chat.type = ProposalChatType.marker;
      chat.marker = ProposalChatMarker.wantNegotiate;
      if (await _insertChat(transaction, chat)) {
        markerChat = chat;
        await transaction.commit();
      }
    });

    if (markerChat == null) {
      throw grpc.GrpcError.internal('Not handled.');
    }

    final NetProposal response = NetProposal();
    final DataProposal proposal = await _getProposal(proposalId);
    response.proposal = proposal; // TODO: Filter
    response.chats.add(markerChat);
    response.freeze();

    unawaited(() async {
      // Publish!
      final NetProposal publishProposal = NetProposal();
      publishProposal.proposal = DataProposal()..mergeFromMessage(proposal);
      await bc.proposalChanged(auth.sessionId, publishProposal);
      final NetProposalChat publishChat = NetProposalChat();
      publishChat.chat = DataProposalChat()..mergeFromMessage(markerChat);
      await bc.proposalChatPosted(auth.sessionId, publishChat,
          await fetchSessionAccount(config, accountDb, auth.sessionId));
    }());

    // Send to current user
    return response;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<NetProposal> reject(
      grpc.ServiceCall call, NetProposalReject request) async {
    final DataAuth auth = authFromJwtPayload(call);
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readWrite.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    // TODO: Reject
    throw grpc.GrpcError.unimplemented();
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<NetProposal> report(
      grpc.ServiceCall call, NetProposalReport request) async {
    final DataAuth auth = authFromJwtPayload(call);
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readWrite.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    // TODO: Report
    throw grpc.GrpcError.unimplemented();
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<NetProposal> dispute(
      grpc.ServiceCall call, NetProposalDispute request) async {
    final DataAuth auth = authFromJwtPayload(call);
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readWrite.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    // TODO: Dispute
    throw grpc.GrpcError.unimplemented();
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<NetProposal> complete(
      grpc.ServiceCall call, NetProposalCompletion request) async {
    final DataAuth auth = authFromJwtPayload(call);
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readWrite.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    final Int64 proposalId = request.proposalId;

    if (!request.hasRating()) {
      throw grpc.GrpcError.invalidArgument('No rating given.');
    }

    DataProposalChat markerChat; // Set upon successful action

    // Completion or dispute
    await proposalDb.startTransaction((sqljocky.Transaction transaction) async {
      // 1. Update deal to reflect the account marked completion
      final String accountType = (auth.accountType == AccountType.influencer)
          ? 'influencer'
          : 'business';
      final String updateMarkings = 'UPDATE `proposals` '
          'SET `${accountType}_marked_delivered` = 1, '
          '`${accountType}_marked_rewarded` = 1, '
          '`${accountType}_gave_rating` = ? '
          'WHERE `proposal_id` = ? '
          'AND `${accountType}_account_id` = ? '
          'AND `state` = ${ProposalState.deal.value} OR `state` = ${ProposalState.dispute.value}';
      final sqljocky.Results resultMarkings = await transaction.prepareExecute(
        updateMarkings,
        <dynamic>[request.rating, proposalId, auth.accountId],
      );
      if (resultMarkings.affectedRows == null ||
          resultMarkings.affectedRows == 0) {
        devLog.warning(
            "Invalid completion or invalid dispute attempt by account '${auth.accountId}' on proposal '$proposalId'");
        return;
      }

      bool dealCompleted;
      // 2. Check for deal completion
      final String updateCompletion = 'UPDATE `proposals` '
          'SET `state` = ${ProposalState.complete.value} '
          'WHERE `proposal_id` = ? '
          'AND `influencer_marked_delivered` > 0 AND `influencer_marked_rewarded` > 0 '
          'AND `business_marked_delivered` > 0 AND `business_marked_rewarded` > 0 '
          'AND `influencer_gave_rating` > 0 AND `business_gave_rating` > 0 '
          'AND `state` = ${ProposalState.deal.value}';
      final sqljocky.Results resultCompletion =
          await transaction.prepareExecute(
        updateCompletion,
        <dynamic>[proposalId],
      );
      dealCompleted = resultCompletion.affectedRows != null &&
          resultCompletion.affectedRows != 0;

      final ProposalChatMarker marker = dealCompleted
          ? ProposalChatMarker.complete
          : ProposalChatMarker.markedComplete;

      // 3. Insert marker chat
      final DataProposalChat chat = DataProposalChat();
      chat.sent = Int64(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      chat.senderAccountId = auth.accountId;
      chat.proposalId = proposalId;
      chat.senderSessionId = auth.sessionId;
      chat.senderSessionGhostId = ++_nextFakeGhostId;
      chat.type = ProposalChatType.marker;
      chat.marker = marker;
      if (await _insertChat(transaction, chat)) {
        markerChat = chat;
        await transaction.commit();
      }
    });

    if (markerChat == null) {
      throw grpc.GrpcError.internal('Not handled.');
    }

    final NetProposal response = NetProposal();
    final DataProposal proposal = await _getProposal(proposalId);
    response.proposal = proposal; // TODO: Filter
    response.chats.add(markerChat);
    response.freeze();

    unawaited(() async {
      // Publish!
      final NetProposal publishProposal = NetProposal();
      publishProposal.proposal = DataProposal()..mergeFromMessage(proposal);
      await bc.proposalChanged(auth.sessionId, publishProposal);
      final NetProposalChat publishChat = NetProposalChat();
      publishChat.chat = DataProposalChat()..mergeFromMessage(markerChat);
      await bc.proposalChatPosted(auth.sessionId, publishChat,
          await fetchSessionAccount(config, accountDb, auth.sessionId));
    }());

    return response;

    // TODO: Post rating and review to Elasticsearch
    // TODO: Write rating recalculation schedule (weighted ratings)
    // TODO: Elasticsearch proposal_reports index for statistics purposes
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<NetProposalChat> chatPlain(
      grpc.ServiceCall call, NetChatPlain request) async {
    final DataAuth auth = authFromJwtPayload(call);
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readWrite.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    if (!await _verifySender(request.proposalId, auth.accountId,
        ProposalChatType.plain, auth.accountType)) {
      throw grpc.GrpcError.permissionDenied();
    }

    final DataProposalChat chat = DataProposalChat();
    chat.sent = Int64(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
    chat.senderAccountId = auth.accountId;
    chat.proposalId = request.proposalId;
    chat.senderSessionId = auth.sessionId;
    chat.senderSessionGhostId = request.sessionGhostId;
    chat.type = ProposalChatType.plain;
    chat.plainText = request.text;

    return await _enterChat(chat, auth.sessionId,
        await fetchSessionAccount(config, accountDb, auth.sessionId));
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<NetProposal> chatNegotiate(
      grpc.ServiceCall call, NetChatNegotiate request) async {
    final DataAuth auth = authFromJwtPayload(call);
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readWrite.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    if (!await _verifySender(request.proposalId, auth.accountId,
        ProposalChatType.negotiate, auth.accountType)) {
      throw grpc.GrpcError.permissionDenied();
    }

    final DataProposalChat chat = DataProposalChat();
    chat.sent = Int64(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
    chat.senderAccountId = auth.accountId;
    chat.proposalId = request.proposalId;
    chat.senderSessionId = auth.sessionId;
    chat.senderSessionGhostId = request.sessionGhostId;
    chat.type = ProposalChatType.negotiate;
    chat.plainText = request.remarks;
    chat.terms = request.terms;

    // TODO: Maybe saner to just return the chat as before,
    // and have the client update the termsChatId whenever a new one appears.
    final NetProposal result = NetProposal();
    result.proposal = DataProposal();
    final NetProposalChat resultChat = await _enterChat(chat, auth.sessionId,
        await fetchSessionAccount(config, accountDb, auth.sessionId));
    result.chats.add(resultChat.chat);
    result.proposal.termsChatId = resultChat.chat.chatId;
    return result;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<NetProposalChat> chatImageKey(
      grpc.ServiceCall call, NetChatImageKey request) async {
    final DataAuth auth = authFromJwtPayload(call);
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readWrite.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    if (!await _verifySender(request.proposalId, auth.accountId,
        ProposalChatType.imageKey, auth.accountType)) {
      throw grpc.GrpcError.permissionDenied();
    }

    final DataProposalChat chat = DataProposalChat();
    chat.sent = Int64(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
    chat.senderAccountId = auth.accountId;
    chat.proposalId = request.proposalId;
    chat.senderSessionId = auth.sessionId;
    chat.senderSessionGhostId = request.sessionGhostId;
    chat.type = ProposalChatType.imageKey;
    chat.imageKey = request.imageKey;
    // TODO: imageBlurred

    return await _enterChat(chat, auth.sessionId,
        await fetchSessionAccount(config, accountDb, auth.sessionId));
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  Future<bool> _insertChat(
      sqljocky.QueriableConnection connection, DataProposalChat chat) async {
    // Store in database
    const String insertChat = 'INSERT INTO `proposal_chats`('
        '`sender_account_id`, `proposal_id`, '
        '`sender_session_id`, `sender_session_ghost_id`, '
        '`type`, `plain_text`, `terms`, '
        '`image_key`, `image_blurred`, '
        '`marker`) '
        'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
    devLog.finest('insertChat');
    final sqljocky.Results resultHaggle =
        await connection.prepareExecute(insertChat, <dynamic>[
      chat.senderAccountId,
      chat.proposalId,
      chat.senderSessionId,
      chat.senderSessionGhostId, // Not actually used for apply chat, but need it for consistency
      chat.type.value,
      chat.hasPlainText() ? chat.plainText : null,
      chat.hasTerms() ? chat.terms.writeToBuffer() : null,
      chat.hasImageKey() ? chat.imageKey : null,
      chat.hasImageBlurred() ? chat.imageBlurred : null,
      chat.hasMarker() ? chat.marker.value : null,
    ]);
    devLog.finest('inserted');
    final Int64 termsChatId = Int64(resultHaggle.insertId);
    if (termsChatId == Int64.ZERO) {
      return false;
    }
    chat.chatId = termsChatId;
    await resultHaggle.drain<void>();
    return true;
  }

  // TODO: Why is this depending on account???
  Future<NetProposalChat> _enterChat(
      DataProposalChat chat, Int64 senderSessionId, DataAccount account) async {
    bool publish = false;
    if (chat.type == ProposalChatType.negotiate) {
      devLog.finest('enterChat');
      await proposalDb
          .startTransaction((sqljocky.Transaction transaction) async {
        if (await _insertChat(transaction, chat)) {
          // Update haggle on proposal
          final String updateHaggleChatId = 'UPDATE `proposals` '
              'SET `terms_chat_id` = ?, `influencer_wants_deal` = 0, `business_wants_deal` = 0 '
              'WHERE `proposal_id` = ? AND `state` = ${ProposalState.negotiating.value}';
          final sqljocky.Results resultUpdateHaggleChatId =
              await transaction.prepareExecute(updateHaggleChatId, <dynamic>[
            chat.chatId,
            chat.proposalId,
          ]);
          if (resultUpdateHaggleChatId.affectedRows == null ||
              resultUpdateHaggleChatId.affectedRows == 0) {
            return; // rollback
          }
          await resultUpdateHaggleChatId.drain<void>();
          // Commit
          await transaction.commit();
          publish = true;
        } // else rollback
      });
    } else {
      if (await _insertChat(proposalDb, chat)) {
        publish = true;
      }
    }
    if (publish) {
      await _publishChat(chat, senderSessionId, account);
      if (chat.type == ProposalChatType.negotiate) {
        await _changedProposal(senderSessionId, chat.proposalId);
      }
    } else {
      // Send placeholder message to erase the ghost id to current session.
      // This is an unusual race condition case that shouldn't happen.
      chat.type = ProposalChatType.marker;
      chat.marker = ProposalChatMarker.messageDropped;
    }
    final NetProposalChat proposalChat = NetProposalChat();
    proposalChat.chat = chat;
    return proposalChat;
  }

  String _makeImageUrl(String template, String key) {
    final int lastIndex = key.lastIndexOf('.');
    final String keyNoExt = lastIndex > 0 ? key.substring(0, lastIndex) : key;
    return template.replaceAll('{key}', key).replaceAll('{keyNoExt}', keyNoExt);
  }

  Future<NetProposalChat> _publishChat(
      DataProposalChat chat, Int64 senderSessionId, DataAccount account) async {
    if (chat.imageKey != null) {
      chat.imageUrl =
          _makeImageUrl(config.services.galleryCoverUrl, chat.imageKey);
      chat.clearImageKey();
    }

    if (chat.imageUrl != null && chat.imageBlurred == null) {
      devLog.warning('Chat image blurred missing.');
    }

    // Publish to me
    final NetProposalChat proposalChat = NetProposalChat();
    proposalChat.chat = chat;

    // Clear private information from broadcast
    final DataProposalChat publicChat = DataProposalChat()
      ..mergeFromMessage(chat);
    publicChat.clearSenderSessionId();
    publicChat.clearSenderSessionGhostId();
    final NetProposalChat publishChat = NetProposalChat();
    publishChat.chat = publicChat;

    // Publish to all else
    // TODO(kaetemi): Deduplicate chat.writeToBuffer() calls on publishing
    await bc.proposalChatPosted(senderSessionId, publishChat, account);

    // Publish to me
    return proposalChat;
  }

  Future<DataProposal> _getProposal(Int64 proposalId) async {
    DataProposal proposal;
    await for (sqljocky.Row row in await proposalDb.prepareExecute(
      SqlProposal.selectProposalsQuery + ' WHERE `proposal_id` = ?',
      <dynamic>[proposalId],
    )) {
      // Returns non account specific data
      proposal = SqlProposal.proposalFromRow(row, AccountType.unknown);
    }
    if (proposal == null) {
      throw Exception('Proposal not found.');
    }
    return proposal;
  }

  Future<void> _changedProposal(Int64 senderSessionId, Int64 proposalId) async {
    // DataProposal proposal) {
    final NetProposal proposal = NetProposal();
    proposal.proposal = await _getProposal(proposalId);
    await bc.proposalChanged(senderSessionId, proposal);
  }

  /// Verify if the sender is permitted to chat in this context
  Future<bool> _verifySender(Int64 proposalId, Int64 senderAccountId,
      ProposalChatType type, AccountType senderAccountType) async {
    Int64 influencerAccountId;
    Int64 businessAccountId;
    ProposalState state;

    // Fetch proposal
    const String query = 'SELECT '
        '`influencer_account_id`, `business_account_id`, '
        '`state` '
        'FROM `proposals` '
        'WHERE `proposal_id` = ?';
    await for (sqljocky.Row row
        in await proposalDb.prepareExecute(query, <dynamic>[proposalId])) {
      influencerAccountId = Int64(row[0]);
      businessAccountId = Int64(row[1]);
      state = ProposalState.valueOf(row[2].toInt());
    }

    // Authorize
    if (businessAccountId == null || influencerAccountId == null) {
      opsLog.severe(
          'Attempt to send message to invalid proposal chat by account "$senderAccountId"');
      return false; // Not Found
    }
    if (senderAccountType != AccountType.support &&
        senderAccountId != businessAccountId &&
        senderAccountId != influencerAccountId) {
      opsLog.severe(
          'Attempt to send message to unauthorized proposal chat by account "$senderAccountId"');
      return false; // Not Authorized
    }

    switch (state) {
      case ProposalState.proposing:
        if (type != ProposalChatType.negotiate &&
            type != ProposalChatType.marker) {
          devLog.warning(
              'Attempt to send message to $state deal by "$senderAccountId"');
          return false;
        }
        break;
      case ProposalState.negotiating:
      case ProposalState.deal:
      case ProposalState.dispute:
        break;
      case ProposalState.rejected:
      case ProposalState.complete:
      case ProposalState.resolved:
        devLog.warning(
            'Attempt to send message to $state deal by "$senderAccountId"');
        return false;
    }

    return true;
  }
}

/* end of file */
