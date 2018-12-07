/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:inf_server_api/broadcast_center.dart';
import 'package:inf_server_api/sql_proposal.dart';
import 'package:inf_server_api/sql_util.dart';
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

  static final Logger opsLog =
      new Logger('InfOps.ApiChannelProposalTransactions');
  static final Logger devLog =
      new Logger('InfDev.ApiChannelProposalTransactions');

  ApiChannelProposalTransactions(this._r) {
    _r.registerProcedure(
        'PR_WADEA', GlobalAccountState.readWrite, _netProposalWantDeal);
    _r.registerProcedure(
        'PR_NGOTI', GlobalAccountState.readWrite, _netProposalNegotiate);
    _r.registerProcedure(
        'PR_COMPT', GlobalAccountState.readWrite, _netProposalCompletion);

    _nextFakeGhostId =
        ((new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000) &
                0xFFFFFFF) |
            0x10000000;
  }

  void dispose() {
    _r.unregisterProcedure('PR_WADEA');
    _r.unregisterProcedure('PR_NGOTI');
    _r.unregisterProcedure('PR_COMPT');
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
    String insertChat = "INSERT INTO `proposal_chats`("
        "`sender_account_id`, `proposal_id`, "
        "`sender_session_id`, `sender_session_ghost_id`, "
        '`type`, `plain_text`, `terms`, '
        '`image_key`, `image_blurred`, '
        '`marker`) '
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    sqljocky.Results resultHaggle =
        await connection.prepareExecute(insertChat, [
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
    Int64 termsChatId = new Int64(resultHaggle.insertId);
    if (termsChatId == Int64.ZERO) {
      return false;
    }
    chat.chatId = termsChatId;
    return true;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Want deal
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _netProposalWantDeal(TalkMessage message) async {
    NetProposalWantDeal wantDeal = new NetProposalWantDeal()
      ..mergeFromBuffer(message.data);

    Int64 proposalId = wantDeal.proposalId;
    Int64 termsChatId = wantDeal.termsChatId;

    /* No need, already verified by first UPDATE
    if (!await _verifySender(proposalId, accountId)) {
      channel.sendException("Verification Failed", message);
      return;
    }
    */

    DataProposalChat markerChat; // Set upon success

    channel.replyExtend(message);
    await proposalDb.startTransaction((transaction) async {
      // 1. Update deal to reflect the account wants a deal
      channel.replyExtend(message);
      String accountType = (account.accountType == AccountType.influencer)
          ? 'influencer'
          : 'business';
      String updateWants = 'UPDATE `proposals` '
          'SET `${accountType}_wants_deal` = 1 '
          'WHERE `proposal_id` = ? '
          'AND `terms_chat_id` = ? '
          'AND `${accountType}_account_id` = ? '
          'AND (`state` = ${ProposalState.negotiating.value} OR `state` = ${ProposalState.proposing.value}) '
          'AND `${accountType}_wants_deal` = 0';
      sqljocky.Results resultWants = await transaction.prepareExecute(
        updateWants,
        [proposalId, termsChatId, accountId],
      );
      if (resultWants.affectedRows == null || resultWants.affectedRows == 0) {
        devLog.warning(
            "Invalid want deal attempt by account '$accountId' on proposal '$proposalId'");
        return;
      }

      // 2. Try to see if we're can complete the deal or if it's just one sided
      channel.replyExtend(message);
      String updateDeal = "UPDATE `proposals` "
          "SET `state` = ${ProposalState.deal.value} "
          "WHERE `proposal_id` = ? "
          "AND `influencer_wants_deal` = 1 "
          "AND `business_wants_deal` = 1 "
          "AND (`state` = ${ProposalState.negotiating.value} OR `state` = ${ProposalState.proposing.value})";
      sqljocky.Results resultDeal = await transaction.prepareExecute(
        updateDeal,
        [proposalId],
      );
      bool dealMade =
          (resultDeal.affectedRows != null && resultDeal.affectedRows > 0);

      // 3. Insert marker chat
      channel.replyExtend(message);
      DataProposalChat chat = new DataProposalChat();
      chat.sent =
          new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      chat.senderAccountId = accountId;
      chat.proposalId = proposalId;
      chat.senderSessionId = account.sessionId;
      chat.senderSessionGhostId = ++_nextFakeGhostId;
      chat.type = ProposalChatType.marker;
      chat.marker = (dealMade
          ? ProposalChatMarker.dealMade
          : ProposalChatMarker.wantDeal);
      if (await _insertChat(transaction, chat)) {
        channel.replyExtend(message);
        markerChat = chat;
        transaction.commit();
      }
    });

    if (markerChat == null) {
      channel.replyAbort(message, "Not handled.");
      _r.pushProposal(proposalId); // Refresh user side, possibly out of sync
    } else {
      NetProposal res = new NetProposal();
      DataProposal proposal = await _r.getProposal(proposalId);
      res.updateProposal = proposal; // TODO: Filter
      res.newChats.add(markerChat);
      try {
        // Send to current user
        channel.replyMessage(message, 'PR_R_WAD', res.writeToBuffer());
      } catch (error, stackTrace) {
        devLog.severe("$error\n$stackTrace");
      }
      // Publish!
      _r.bc.proposalChanged(account.sessionId, proposal);
      _r.bc.proposalChatPosted(account.sessionId, markerChat, account);
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Want to negotiate
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _netProposalNegotiate(TalkMessage message) async {
    NetProposalNegotiate negotiate = new NetProposalNegotiate()
      ..mergeFromBuffer(message.data);

    Int64 proposalId = negotiate.proposalId;

    /* No need, already verified by first UPDATE
    if (!await _verifySender(proposalId, accountId)) {
      channel.sendException("Verification Failed", message);
      return;
    }
    */

    DataProposalChat markerChat; // Set upon success

    channel.replyExtend(message);
    await proposalDb.startTransaction((transaction) async {
      // 1. Update deal to reflect the account wants to negotiate
      channel.replyExtend(message);
      String accountType = (account.accountType == AccountType.influencer)
          ? 'influencer'
          : 'business';
      String updateState = 'UPDATE `proposals` '
          'SET `state` = ${ProposalState.negotiating.value} '
          'WHERE `proposal_id` = ? '
          'AND `${accountType}_account_id` = ? '
          'AND `state` = ${ProposalState.proposing.value} '
          'AND `${accountType}_wants_deal` = 0';
      sqljocky.Results resultState = await transaction.prepareExecute(
        updateState,
        [proposalId, accountId],
      );
      if (resultState.affectedRows == null || resultState.affectedRows == 0) {
        devLog.warning(
            "Invalid want deal attempt by account '$accountId' on proposal '$proposalId'");
        return;
      }

      // 2. Insert marker chat
      channel.replyExtend(message);
      DataProposalChat chat = new DataProposalChat();
      chat.sent =
          new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      chat.senderAccountId = accountId;
      chat.proposalId = proposalId;
      chat.senderSessionId = account.sessionId;
      chat.senderSessionGhostId = ++_nextFakeGhostId;
      chat.type = ProposalChatType.marker;
      chat.marker = ProposalChatMarker.wantNegotiate;
      if (await _insertChat(transaction, chat)) {
        channel.replyExtend(message);
        markerChat = chat;
        transaction.commit();
      }
    });

    if (markerChat == null) {
      channel.replyAbort(message, "Not handled.");
      _r.pushProposal(proposalId); // Refresh user side, possibly out of sync
    } else {
      NetProposal res = new NetProposal();
      DataProposal proposal = await _r.getProposal(proposalId);
      res.updateProposal = proposal; // TODO: Filter
      res.newChats.add(markerChat);
      try {
        // Send to current user
        channel.replyMessage(message, 'PR_R_NGT', res.writeToBuffer());
      } catch (error, stackTrace) {
        devLog.severe("$error\n$stackTrace");
      }
      // Publish!
      _r.bc.proposalChanged(account.sessionId, proposal);
      _r.bc.proposalChatPosted(account.sessionId, markerChat, account);
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Mark as complete
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _netProposalCompletion(TalkMessage message) async {
    NetProposalCompletion completion = new NetProposalCompletion()
      ..mergeFromBuffer(message.data);

    Int64 proposalId = completion.proposalId;

    if (!completion.hasRating()) {
      channel.replyAbort(message, "No rating given.");
      return;
    }

    DataProposalChat markerChat; // Set upon successful action

    // Completion or dispute
    channel.replyExtend(message);
    await proposalDb.startTransaction((transaction) async {
      // 1. Update deal to reflect the account marked completion
      channel.replyExtend(message);
      String accountType = (account.accountType == AccountType.influencer)
          ? 'influencer'
          : 'business';
      String updateMarkings = "UPDATE `proposals` "
          "SET `${accountType}_marked_delivered` = 1, "
          "`${accountType}_marked_rewarded` = 1, "
          "`${accountType}_gave_rating` = ?"
          "WHERE `proposal_id` = ? "
          "AND `${accountType}_account_id` = ?"
          "AND `state` = ${ProposalState.deal.value} OR `state` = ${ProposalState.dispute.value}";
      sqljocky.Results resultMarkings = await transaction.prepareExecute(
        updateMarkings,
        [completion.rating, proposalId, accountId],
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
      String updateCompletion = "UPDATE `proposals` "
          "SET `state` = ${ProposalState.complete.value} "
          "WHERE `proposal_id` = ? "
          "AND `influencer_marked_delivered` > 0 AND `influencer_marked_rewarded` > 0 "
          "AND `business_marked_delivered` > 0 AND `business_marked_rewarded` > 0 "
          "AND `influencer_gave_rating` > 0 AND `business_gave_rating` > 0 "
          "AND `state` = ${ProposalState.deal.value}";
      sqljocky.Results resultCompletion = await transaction.prepareExecute(
        updateCompletion,
        [proposalId],
      );
      dealCompleted = resultCompletion.affectedRows != null &&
          resultCompletion.affectedRows != 0;

      ProposalChatMarker marker = dealCompleted
          ? ProposalChatMarker.complete
          : ProposalChatMarker.markedComplete;

      // 3. Insert marker chat
      channel.replyExtend(message);
      DataProposalChat chat = new DataProposalChat();
      chat.sent =
          new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      chat.senderAccountId = accountId;
      chat.proposalId = proposalId;
      chat.senderSessionId = account.sessionId;
      chat.senderSessionGhostId = ++_nextFakeGhostId;
      chat.type = ProposalChatType.marker;
      chat.marker = marker;
      if (await _insertChat(transaction, chat)) {
        channel.replyExtend(message);
        markerChat = chat;
        transaction.commit();
      }
    });

    if (markerChat == null) {
      channel.replyAbort(message, "Not handled.");
      _r.pushProposal(proposalId); // Refresh user side, possibly out of sync
    } else {
      NetProposal res = new NetProposal();
      try {
        channel.replyExtend(message);
      } catch (error, stackTrace) {
        devLog.severe("$error\n$stackTrace");
      }
      DataProposal proposal = await _r.getProposal(proposalId);
      res.updateProposal = proposal;
      res.newChats.add(markerChat);
      try {
        // Send to current user
        channel.replyMessage(message, "PR_R_COM", res.writeToBuffer());
      } catch (error, stackTrace) {
        devLog.severe("$error\n$stackTrace");
      }
      // Publish!
      _r.bc.proposalChanged(account.sessionId, proposal);
      _r.bc.proposalChatPosted(account.sessionId, markerChat, account);

      // TODO: Post rating and review to Elasticsearch
      // TODO: Write rating recalculation schedule (weighted ratings)
      // TODO: Elasticsearch proposal_reports index for statistics purposes
    }
  }
}

/* end of file */
