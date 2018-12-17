/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:inf_server_api/broadcast_center.dart';
// import 'package:inf_server_api/sql_proposal.dart';
// import 'package:inf_server_api/sql_util.dart';
import 'package:logging/logging.dart';
import 'package:switchboard/switchboard.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;

import 'package:inf_common/inf_common.dart';
import 'api_channel.dart';

class ApiChannelProposalTransactions {
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Inherited properties
  //////////////////////////////////////////////////////////////////////////////

  ApiChannel _r;
  ConfigData get config {
    return _r.config;
  }

  sqljocky.ConnectionPool get accountDb {
    return _r.accountDb;
  }

  sqljocky.ConnectionPool get proposalDb {
    return _r.proposalDb;
  }

  TalkChannel get channel {
    return _r.channel;
  }

  BroadcastCenter get bc {
    return _r.bc;
  }

  dospace.Bucket get bucket {
    return _r.bucket;
  }

  DataAccount get account {
    return _r.account;
  }

  Int64 get accountId {
    return _r.account.accountId;
  }

  GlobalAccountState get globalAccountState {
    return _r.account.globalAccountState;
  }

  int _nextFakeGhostId;

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Construction
  //////////////////////////////////////////////////////////////////////////////

  static final Logger opsLog = Logger('InfOps.ApiChannelProposalTransactions');
  static final Logger devLog = Logger('InfDev.ApiChannelProposalTransactions');

  ApiChannelProposalTransactions(this._r) {
    _r.registerProcedure(
        'PR_WADEA', GlobalAccountState.readWrite, _netProposalWantDeal);
    _r.registerProcedure(
        'PR_NGOTI', GlobalAccountState.readWrite, _netProposalNegotiate);
    _r.registerProcedure(
        'PR_COMPT', GlobalAccountState.readWrite, _netProposalCompletion);

    _r.registerProcedure(
        'CH_PLAIN', GlobalAccountState.readWrite, _netChatPlain);
    _r.registerProcedure(
        'CH_HAGGL', GlobalAccountState.readWrite, _netChatNegotiate);
    _r.registerProcedure(
        'CH_IMAGE', GlobalAccountState.readWrite, _netChatImageKey);

    _nextFakeGhostId =
        ((DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000) & 0xFFFFFFF) |
            0x10000000;
  }

  void dispose() {
    _r.unregisterProcedure('PR_WADEA');
    _r.unregisterProcedure('PR_NGOTI');
    _r.unregisterProcedure('PR_COMPT');
    _r.unregisterProcedure('CH_PLAIN');
    _r.unregisterProcedure('CH_HAGGL');
    _r.unregisterProcedure('CH_IMAGE');
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Chat utility
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
      chat.hasMarker() ? chat.marker : null,
    ]);
    final Int64 termsChatId = Int64(resultHaggle.insertId);
    if (termsChatId == Int64.ZERO) {
      return false;
    }
    chat.chatId = termsChatId;
    return true;
  }

  Future<void> _enterChat(DataProposalChat chat) async {
    bool publish = false;
    if (chat.type == ProposalChatType.negotiate) {
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
      await _publishChat(chat);
      if (chat.type == ProposalChatType.negotiate) {
        await _changedProposal(chat.proposalId);
      }
    } else {
      // Send placeholder message to erase the ghost id to current session.
      // This is an unusual race condition case that shouldn't happen.
      chat.type = ProposalChatType.marker;
      chat.marker = ProposalChatMarker.messageDropped;
      final NetProposalChat proposalChat = NetProposalChat();
      proposalChat.chat = chat;
      channel.sendMessage('LN_P_CHA', proposalChat.writeToBuffer());
    }
  }

  Future<void> _publishChat(DataProposalChat chat) async {
    if (chat.imageKey != null) {
      chat.imageKey = null;
      chat.imageUrl = _r.makeCloudinaryCoverUrl(chat.imageKey);
    }

    if (chat.imageUrl != null && chat.imageBlurred == null) {
      devLog.warning('Chat image blurred missing.');
    }

    // Publish to me
    final NetProposalChat proposalChat = NetProposalChat();
    proposalChat.chat = chat;
    channel.sendMessage('LN_P_CHA', proposalChat.writeToBuffer());

    // Clear private information from broadcast
    chat.senderSessionId = Int64.ZERO;
    chat.senderSessionGhostId = 0;

    // Publish to all else
    // TODO(kaetemi): Deduplicate chat.writeToBuffer() calls on publishing
    await _r.bc.proposalChatPosted(account.sessionId, proposalChat, account);
  }

  Future<void> _changedProposal(Int64 proposalId) async {
    // DataProposal proposal) {
    final NetProposal proposal = NetProposal();
    proposal.proposal = await _r.getProposal(proposalId);
    channel.sendMessage(
        'LU_PRPSL',
        proposal
            .writeToBuffer()); // TODO(kaetemi): Filter sensitive info from business and influencer
    await _r.bc.proposalChanged(account.sessionId, proposal);
  }

  /// Verify if the sender is permitted to chat in this context
  Future<bool> _verifySender(
      Int64 proposalId, Int64 senderId, ProposalChatType type) async {
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
          'Attempt to send message to invalid proposal chat by account "$senderId"');
      return false; // Not Found
    }
    if (account.accountType != AccountType.support &&
        accountId != businessAccountId &&
        accountId != influencerAccountId) {
      opsLog.severe(
          'Attempt to send message to unauthorized proposal chat by account "$senderId"');
      return false; // Not Authorized
    }

    switch (state) {
      case ProposalState.proposing:
        if (type != ProposalChatType.negotiate &&
            type != ProposalChatType.marker) {
          devLog
              .warning('Attempt to send message to $state deal by "$senderId"');
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
        devLog.warning('Attempt to send message to $state deal by "$senderId"');
        return false;
    }

    return true;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Want deal
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _netProposalWantDeal(TalkMessage message) async {
    final NetProposalWantDeal wantDeal = NetProposalWantDeal()
      ..mergeFromBuffer(message.data);

    final Int64 proposalId = wantDeal.proposalId;
    final Int64 termsChatId = wantDeal.termsChatId;

    /* No need, already verified by first UPDATE
    if (!await _verifySender(proposalId, accountId)) {
      channel.sendException("Verification Failed", message);
      return;
    }
    */

    DataProposalChat markerChat; // Set upon success

    channel.replyExtend(message);
    await proposalDb.startTransaction((sqljocky.Transaction transaction) async {
      // 1. Update deal to reflect the account wants a deal
      channel.replyExtend(message);
      final String accountType = (account.accountType == AccountType.influencer)
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
        <dynamic>[proposalId, termsChatId, accountId],
      );
      if (resultWants.affectedRows == null || resultWants.affectedRows == 0) {
        devLog.warning(
            "Invalid want deal attempt by account '$accountId' on proposal '$proposalId'");
        return;
      }

      // 2. Try to see if we're can complete the deal or if it's just one sided
      channel.replyExtend(message);
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

      // 3. Insert marker chat
      channel.replyExtend(message);
      final DataProposalChat chat = DataProposalChat();
      chat.sent = Int64(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      chat.senderAccountId = accountId;
      chat.proposalId = proposalId;
      chat.senderSessionId = account.sessionId;
      chat.senderSessionGhostId = ++_nextFakeGhostId;
      chat.type = ProposalChatType.marker;
      chat.marker =
          dealMade ? ProposalChatMarker.dealMade : ProposalChatMarker.wantDeal;
      if (await _insertChat(transaction, chat)) {
        channel.replyExtend(message);
        markerChat = chat;
        await transaction.commit();
      }
    });

    if (markerChat == null) {
      channel.replyAbort(message, 'Not handled.');
      await _r
          .pushProposal(proposalId); // Refresh user side, possibly out of sync
      return;
    } else {
      final NetProposal res = NetProposal();
      final DataProposal proposal = await _r.getProposal(proposalId);
      res.proposal = proposal; // TODO(kaetemi): Filter
      res.chats.add(markerChat);
      try {
        // Send to current user
        channel.replyMessage(message, 'PR_R_WAD', res.writeToBuffer());
      } catch (error, stackTrace) {
        devLog.severe('$error\n$stackTrace');
      }
      // Publish!
      final NetProposal publishProposal = NetProposal();
      publishProposal.proposal = res.proposal;
      await _r.bc.proposalChanged(account.sessionId, publishProposal);
      final NetProposalChat publishChat = NetProposalChat();
      publishChat.chat = markerChat;
      await _r.bc.proposalChatPosted(account.sessionId, publishChat, account);
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Want to negotiate
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _netProposalNegotiate(TalkMessage message) async {
    final NetProposalNegotiate negotiate = NetProposalNegotiate()
      ..mergeFromBuffer(message.data);

    final Int64 proposalId = negotiate.proposalId;

    /* No need, already verified by first UPDATE
    if (!await _verifySender(proposalId, accountId)) {
      channel.sendException("Verification Failed", message);
      return;
    }
    */

    DataProposalChat markerChat; // Set upon success

    channel.replyExtend(message);
    await proposalDb.startTransaction((sqljocky.Transaction transaction) async {
      // 1. Update deal to reflect the account wants to negotiate
      channel.replyExtend(message);
      final String accountType = (account.accountType == AccountType.influencer)
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
        <dynamic>[proposalId, accountId],
      );
      if (resultState.affectedRows == null || resultState.affectedRows == 0) {
        devLog.warning(
            "Invalid want deal attempt by account '$accountId' on proposal '$proposalId'");
        return;
      }

      // 2. Insert marker chat
      channel.replyExtend(message);
      final DataProposalChat chat = DataProposalChat();
      chat.sent = Int64(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      chat.senderAccountId = accountId;
      chat.proposalId = proposalId;
      chat.senderSessionId = account.sessionId;
      chat.senderSessionGhostId = ++_nextFakeGhostId;
      chat.type = ProposalChatType.marker;
      chat.marker = ProposalChatMarker.wantNegotiate;
      if (await _insertChat(transaction, chat)) {
        channel.replyExtend(message);
        markerChat = chat;
        await transaction.commit();
      }
    });

    if (markerChat == null) {
      channel.replyAbort(message, 'Not handled.');
      await _r
          .pushProposal(proposalId); // Refresh user side, possibly out of sync
      return;
    } else {
      final NetProposal res = NetProposal();
      final DataProposal proposal = await _r.getProposal(proposalId);
      res.proposal = proposal; // TODO(kaetemi): Filter
      res.chats.add(markerChat);
      try {
        // Send to current user
        channel.replyMessage(message, 'PR_R_NGT', res.writeToBuffer());
      } catch (error, stackTrace) {
        devLog.severe('$error\n$stackTrace');
      }
      // Publish!
      final NetProposal publishProposal = NetProposal();
      publishProposal.proposal = res.proposal;
      await _r.bc.proposalChanged(account.sessionId, publishProposal);
      final NetProposalChat publishChat = NetProposalChat();
      publishChat.chat = markerChat;
      await _r.bc.proposalChatPosted(account.sessionId, publishChat, account);
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Mark as complete
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _netProposalCompletion(TalkMessage message) async {
    final NetProposalCompletion completion = NetProposalCompletion()
      ..mergeFromBuffer(message.data);

    final Int64 proposalId = completion.proposalId;

    if (!completion.hasRating()) {
      channel.replyAbort(message, 'No rating given.');
      return;
    }

    DataProposalChat markerChat; // Set upon successful action

    // Completion or dispute
    channel.replyExtend(message);
    await proposalDb.startTransaction((sqljocky.Transaction transaction) async {
      // 1. Update deal to reflect the account marked completion
      channel.replyExtend(message);
      final String accountType = (account.accountType == AccountType.influencer)
          ? 'influencer'
          : 'business';
      final String updateMarkings = 'UPDATE `proposals` '
          'SET `${accountType}_marked_delivered` = 1, '
          '`${accountType}_marked_rewarded` = 1, '
          '`${accountType}_gave_rating` = ?'
          'WHERE `proposal_id` = ? '
          'AND `${accountType}_account_id` = ?'
          'AND `state` = ${ProposalState.deal.value} OR `state` = ${ProposalState.dispute.value}';
      final sqljocky.Results resultMarkings = await transaction.prepareExecute(
        updateMarkings,
        <dynamic>[completion.rating, proposalId, accountId],
      );
      if (resultMarkings.affectedRows == null ||
          resultMarkings.affectedRows == 0) {
        devLog.warning(
            "Invalid completion or invalid dispute attempt by account '$accountId' on proposal '$proposalId'");
        return;
      }

      bool dealCompleted;
      // 2. Check for deal completion
      channel.replyExtend(message);
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
      channel.replyExtend(message);
      final DataProposalChat chat = DataProposalChat();
      chat.sent = Int64(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      chat.senderAccountId = accountId;
      chat.proposalId = proposalId;
      chat.senderSessionId = account.sessionId;
      chat.senderSessionGhostId = ++_nextFakeGhostId;
      chat.type = ProposalChatType.marker;
      chat.marker = marker;
      if (await _insertChat(transaction, chat)) {
        channel.replyExtend(message);
        markerChat = chat;
        await transaction.commit();
      }
    });

    if (markerChat == null) {
      channel.replyAbort(message, 'Not handled.');
      await _r
          .pushProposal(proposalId); // Refresh user side, possibly out of sync
      return;
    } else {
      final NetProposal res = NetProposal();
      try {
        channel.replyExtend(message);
      } catch (error, stackTrace) {
        devLog.severe('$error\n$stackTrace');
      }
      final DataProposal proposal = await _r.getProposal(proposalId);
      res.proposal = proposal;
      res.chats.add(markerChat);
      try {
        // Send to current user
        channel.replyMessage(message, 'PR_R_COM', res.writeToBuffer());
      } catch (error, stackTrace) {
        devLog.severe('$error\n$stackTrace');
      }
      // Publish!
      final NetProposal publishProposal = NetProposal();
      publishProposal.proposal = res.proposal;
      await _r.bc.proposalChanged(account.sessionId, publishProposal);
      final NetProposalChat publishChat = NetProposalChat();
      publishChat.chat = markerChat;
      await _r.bc.proposalChatPosted(account.sessionId, publishChat, account);

      // TODO(kaetemi): Post rating and review to Elasticsearch
      // TODO(kaetemi): Write rating recalculation schedule (weighted ratings)
      // TODO(kaetemi): Elasticsearch proposal_reports index for statistics purposes
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Chat
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _netChatPlain(TalkMessage message) async {
    final NetChatPlain chatPlain = NetChatPlain()
      ..mergeFromBuffer(message.data);

    if (!await _verifySender(
        chatPlain.proposalId, accountId, ProposalChatType.plain)) {
      return;
    }

    final DataProposalChat chat = DataProposalChat();
    chat.sent = Int64(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
    chat.senderAccountId = accountId;
    chat.proposalId = chatPlain.proposalId;
    chat.senderSessionId = account.sessionId;
    chat.senderSessionGhostId = chatPlain.sessionGhostId;
    chat.type = ProposalChatType.plain;
    chat.plainText = chatPlain.text;

    await _enterChat(chat);
  }

  Future<void> _netChatNegotiate(TalkMessage message) async {
    final NetChatNegotiate chatNegotiate = NetChatNegotiate()
      ..mergeFromBuffer(message.data);

    if (!await _verifySender(
        chatNegotiate.proposalId, accountId, ProposalChatType.negotiate)) {
      return;
    }

    final DataProposalChat chat = DataProposalChat();
    chat.sent = Int64(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
    chat.senderAccountId = accountId;
    chat.proposalId = chatNegotiate.proposalId;
    chat.senderSessionId = account.sessionId;
    chat.senderSessionGhostId = chatNegotiate.sessionGhostId;
    chat.type = ProposalChatType.negotiate;
    chat.plainText = chatNegotiate.remarks;
    chat.terms = chatNegotiate.terms;

    await _enterChat(chat);
  }

  Future<void> _netChatImageKey(TalkMessage message) async {
    final NetChatImageKey chatImageKey = NetChatImageKey();
    chatImageKey.mergeFromBuffer(message.data);

    if (!await _verifySender(
        chatImageKey.proposalId, accountId, ProposalChatType.imageKey)) {
      return;
    }

    final DataProposalChat chat = DataProposalChat();
    chat.sent = Int64(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
    chat.senderAccountId = accountId;
    chat.proposalId = chatImageKey.proposalId;
    chat.senderSessionId = account.sessionId;
    chat.senderSessionGhostId = chatImageKey.sessionGhostId;
    chat.type = ProposalChatType.imageKey;
    chat.imageKey = chatImageKey.imageKey;
    // TODO(kaetemi): imageBlurred

    await _enterChat(chat);
  }
}

/* end of file */
