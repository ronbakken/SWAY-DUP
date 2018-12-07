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

class ApiChannelProposal {
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Inherited properties
  //////////////////////////////////////////////////////////////////////////////

  ApiChannel _r;
  ConfigData get config {
    return _r.config;
  }

  sqljocky.ConnectionPool get sql {
    return _r.sql;
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

  static final Logger opsLog = new Logger('InfOps.ApiChannelProposal');
  static final Logger devLog = new Logger('InfDev.ApiChannelProposal');

  ApiChannelProposal(this._r) {
    _r.registerProcedure(
        'APLYPROP', GlobalAccountState.readWrite, _netApplyProposal);
    _r.registerProcedure(
        'LISTPROP', GlobalAccountState.readOnly, _netListProposals);
    _r.registerProcedure(
        'GETPRPSL', GlobalAccountState.readOnly, _netGetProposal);
    _nextFakeGhostId =
        ((new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000) &
                0xFFFFFFF) |
            0x10000000;
  }

  void dispose() {
    _r.unregisterProcedure('APLYPROP');
    _r.unregisterProcedure('LISTPROP');
    _r.unregisterProcedure('GETPRPSL');
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Apply
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _netApplyProposal(TalkMessage message) async {
    NetApplyProposal applyProposal = new NetApplyProposal();
    applyProposal.mergeFromBuffer(message.data);

    // Fetch some offer info
    channel.replyExtend(message);
    DataOffer offer = await _r.getOffer(applyProposal.offerId);
    if (offer.senderId == Int64.ZERO) {
      // Should not happen. Database issue likely
      opsLog.severe(
          'Request for offer "${applyProposal.offerId}" returned empty sender account id.');
      channel.replyAbort(message, 'Offer not valid.');
    }
    if (offer.state != OfferState.open) {
      channel.replyAbort(message, 'Offer not open.');
    }
    if (offer.senderType == account.accountType) {
      // Business cannot apply to business
      channel.replyAbort(message, 'Account type mismatch.');
    }

    DataProposal proposal = new DataProposal();
    proposal.offerId = applyProposal.offerId;
    proposal.senderAccountId = accountId;
    proposal.offerAccountId = offer.senderId;
    if (offer.senderType == AccountType.business) {
      proposal.influencerAccountId = accountId;
      proposal.businessAccountId = offer.senderId;
      proposal.influencerName = account.name;
      proposal.businessName = offer.senderName;
    } else {
      proposal.influencerAccountId = offer.senderId;
      proposal.businessAccountId = accountId;
      proposal.influencerName = offer.senderName;
      proposal.businessName = account.name;
    }
    proposal.offerTitle = offer.title;
    proposal.state = ProposalState.proposing;
    DataProposalChat chat = new DataProposalChat();
    chat.senderAccountId = accountId;
    chat.sessionId = account.sessionId;
    chat.sessionGhostId = applyProposal.sessionGhostId;
    chat.type = ProposalChatType.negotiate;
    chat.plainText = applyProposal.remarks;
    if (applyProposal.hasTerms()) {
      chat.terms = applyProposal.terms;
    } else {
      chat.terms = offer.terms;
    }

    channel.replyExtend(message);
    await sql.startTransaction((transaction) async {
      // 1. Insert into proposals
      channel.replyExtend(message);
      sqljocky.Results resultProposal = await transaction.prepareExecute(
        SqlProposal.insertProposalQuery,
        SqlProposal.makeInsertProposalParameters(proposal),
      );
      Int64 proposalId = new Int64(resultProposal.insertId);
      if (proposalId == null || proposalId == Int64.ZERO) {
        throw new Exception("Proposal not inserted");
      }
      proposal.proposalId = proposalId;
      chat.proposalId = proposalId;

      // 2. Insert terms into chat
      channel.replyExtend(message);
      sqljocky.Results resultNegotiate = await transaction.prepareExecute(
        SqlProposal.insertNegotiateChatQuery,
        SqlProposal.makeInsertNegotiateChatParameters(chat),
      );
      Int64 negotiateChatId = new Int64(resultNegotiate.insertId);
      if (negotiateChatId == null || negotiateChatId == Int64.ZERO) {
        throw new Exception("Terms chat not inserted");
      }
      proposal.termsChatId = negotiateChatId;
      chat.chatId = negotiateChatId;
      chat.sent =
          new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);

      // 3. Update haggle on proposal
      channel.replyExtend(message);
      String updateTermsChatId = "UPDATE `proposals` "
          "SET `terms_chat_id` = ? "
          "WHERE `proposal_id` = ?";
      sqljocky.Results resultUpdateTermsChatId =
          await transaction.prepareExecute(
        updateTermsChatId,
        [
          negotiateChatId,
          proposalId,
        ],
      );
      if (resultUpdateTermsChatId.affectedRows == null ||
          resultUpdateTermsChatId.affectedRows == 0) {
        throw new Exception("Failed to update terms chat id");
      }

      channel.replyExtend(message);
      transaction.commit();
    });

    NetProposal res = NetProposal();
    res.updateProposal = proposal;
    res.newChats.add(chat);
    devLog.finest("Applied for offer successfully: $res");
    channel.replyMessage(message, "R_APLPRP", res.writeToBuffer());

    // Clear private information from broadcast
    chat.sessionId = Int64.ZERO;
    chat.sessionGhostId = 0;

    // Broadcast
    await bc.proposalPosted(account.sessionId, proposal, account);
    await bc.proposalChatPosted(account.sessionId, chat, account);

    // TODO: Update offer proposal count
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // List proposals
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _netListProposals(TalkMessage message) async {
    NetListProposals listProposals = new NetListProposals()
      ..mergeFromBuffer(message.data);
    devLog.finest('NetListProposals: $listProposals');

    channel.replyExtend(message);
    sqljocky.RetainedConnection connection = await sql.getConnection();
    try {
      // Fetch proposal
      channel.replyExtend(message);
      // TODO: Limit result count
      String query = SqlProposal.getSelectProposalsQuery(account.accountType) +
          " WHERE `${account.accountType == AccountType.business ? 'business_account_id' : 'influencer_account_id'}` = ?";
      await for (sqljocky.Row row
          in await connection.prepareExecute(query, [accountId])) {
        NetProposal res = NetProposal();
        res.updateProposal =
            SqlProposal.proposalFromRow(row, account.accountType);
        channel.replyMessage(message, 'R_LSTPRP', res.writeToBuffer());
      }
    } finally {
      connection.release();
    }

    channel.replyEndOfStream(message);
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Get proposal
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _netGetProposal(TalkMessage message) async {
    NetGetProposal getProposal = new NetGetProposal()
      ..mergeFromBuffer(message.data);
    devLog.finest('NetGetProposal: $getProposal');

    NetProposal res;

    channel.replyExtend(message);
    sqljocky.RetainedConnection connection = await sql.getConnection();
    try {
      // Fetch proposal
      channel.replyExtend(message);
      String query = SqlProposal.getSelectProposalsQuery(account.accountType) +
          ' WHERE `proposal_id` = ?'
          ' AND `${account.accountType == AccountType.business ? 'business_account_id' : 'influencer_account_id'}` = ?';
      await for (sqljocky.Row row in await connection.prepareExecute(
        query,
        [getProposal.proposalId, accountId],
      )) {
        res = NetProposal();
        res.updateProposal =
            SqlProposal.proposalFromRow(row, account.accountType);
      }
    } finally {
      connection.release();
    }

    if (res == null) {
      channel.replyAbort(message, 'Proposal not found, or not authorized.');
    }

    channel.replyMessage(message, 'R_GETPRP', res.writeToBuffer());
  }

  Future<DataProposal> getProposal(Int64 proposalId) async {
    DataProposal proposal;
    await for (sqljocky.Row row in await sql.prepareExecute(
      SqlProposal.selectProposalsQuery + ' WHERE `proposal_id` = ?',
      [proposalId],
    )) {
      // Returns non account specific data
      proposal = SqlProposal.proposalFromRow(row, AccountType.unknown);
    }
    if (proposal == null) {
      throw new Exception("Proposal not found.");
    }
    return proposal;
  }

  /*

  // NetLoadProposalChatsReq
  Future<void> netLoadProposalChatsReq(TalkMessage message) async {
    NetListChats pb = new NetListChats();
    pb.mergeFromBuffer(message.data);
    devLog.finest(pb);

    Int64 influencerAccountId;
    Int64 businessAccountId;

    sqljocky.RetainedConnection connection = await sql.getConnection();
    try {
      // Fetch proposal
      channel.replyExtend(message);
      String query = "SELECT "
          "`influencer_account_id`, `business_account_id` "
          "FROM `proposals` "
          "WHERE `proposal_id` = ?";
      await for (sqljocky.Row row
          in await connection.prepareExecute(query, [pb.proposalId])) {
        influencerAccountId = new Int64(row[0]);
        businessAccountId = new Int64(row[1]);
      }
      devLog.finest("$influencerAccountId $businessAccountId");

      // Authorize
      if (businessAccountId == null || influencerAccountId == null) {
        opsLog.severe(
            "Attempt to request invalid proposal chat by account '$accountId'");
        channel.replyAbort(message, "Not found.");
        return; // Verify that this does call finally
      }
      if (account.accountType != AccountType.support &&
          accountId != businessAccountId &&
          accountId != influencerAccountId) {
        opsLog.severe(
            "Attempt to request unauthorized proposal chat by account '$accountId'");
        channel.replyAbort(message, "Not authorized");
        return; // Verify that this does call finally
      }

      // Fetch
      channel.replyExtend(message);
      String chatQuery = "SELECT "
          "`chat_id`, UNIX_TIMESTAMP(`sent`) AS `sent`, " // 0 1
          "`sender_id`, `session_id`, `session_ghost_id`, " // 2 3 4
          "`type`, `plain_text`, `terms`, " // 5 6 7
          "`image_key`, `image_blurred`, " // 8 9
          "`marker` " // 10
          "FROM `proposal_chats` "
          "WHERE `proposal_id` = ? "
          "ORDER BY `chat_id` DESC";
      await for (sqljocky.Row row
          in await connection.prepareExecute(chatQuery, [
        pb.proposalId,
      ])) {
        DataProposalChat chat = new DataProposalChat();
        chat.proposalId = pb.proposalId;
        chat.chatId = new Int64(row[0]);
        chat.sent = new Int64(row[1]);
        chat.senderId = new Int64(row[2]);
        Int64 sessionId = new Int64(row[3]);
        if (sessionId == account.sessionId) {
          chat.sessionId = sessionId;
          chat.sessionGhostId = row[4].toInt();
        }
        chat.type = ProposalChatType.valueOf(row[5].toInt());
        if (row[6] != null) chat.plainText = row[6].toString();
        if (row[7] != null) chat.terms = DataTerms()..mergeFromBuffer(row[7]);
        if (row[8] != null) chat.imageUrl = _r.makeCloudinaryCoverUrl(row[8]);
        if (row[9] != null) chat.imageBlurred = row[9];
        if (row[10] != null) chat.marker = row[10].toInt();
        channel.replyMessage(message, "LU_A_CHA", chat.writeToBuffer());
      }
    } finally {
      connection.release();
    }

    // Done
    channel.replyEndOfStream(message);
  }*/
}
