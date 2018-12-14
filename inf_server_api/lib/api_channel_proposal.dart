/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:inf_server_api/broadcast_center.dart';
import 'package:inf_server_api/sql_proposal.dart';
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

  // int _nextFakeGhostId;

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Construction
  //////////////////////////////////////////////////////////////////////////////

  static final Logger opsLog = Logger('InfOps.ApiChannelProposal');
  static final Logger devLog = Logger('InfDev.ApiChannelProposal');

  ApiChannelProposal(this._r) {
    _r.registerProcedure(
        'APLYPROP', GlobalAccountState.readWrite, _netApplyProposal);
    _r.registerProcedure(
        'LISTPROP', GlobalAccountState.readOnly, _netListProposals);
    _r.registerProcedure(
        'GETPRPSL', GlobalAccountState.readOnly, _netGetProposal);
    _r.registerProcedure(
        'LISTCHAT', GlobalAccountState.readOnly, _netListChats);
    /*
    _nextFakeGhostId =
        ((new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000) &
                0xFFFFFFF) |
            0x10000000;
    */
  }

  void dispose() {
    _r.unregisterProcedure('APLYPROP');
    _r.unregisterProcedure('LISTPROP');
    _r.unregisterProcedure('GETPRPSL');
    _r.unregisterProcedure('LISTCHAT');
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Apply
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _netApplyProposal(TalkMessage message) async {
    final NetApplyProposal applyProposal = NetApplyProposal()
      ..mergeFromBuffer(message.data);

    // Fetch some offer info
    channel.replyExtend(message);
    final DataOffer offer = await _r.getOffer(applyProposal.offerId);
    if (offer.senderAccountId == Int64.ZERO) {
      // Should not happen. Database issue likely
      opsLog.severe(
          'Request for offer "${applyProposal.offerId}" returned empty sender account id.');
      channel.replyAbort(message, 'Offer not valid.');
    }
    if (offer.state != OfferState.open) {
      channel.replyAbort(message, 'Offer not open.');
    }
    if (offer.senderAccountType == account.accountType) {
      // Business cannot apply to business
      channel.replyAbort(message, 'Account type mismatch.');
    }
    if (applyProposal.hasTerms() && !offer.allowNegotiatingProposals) {
      channel.replyAbort(message, 'Cannot negotiate with this offer.');
    }

    // TODO(kaetemi): Forbid negotiate when not allowed
    final DataProposal proposal = DataProposal();
    proposal.offerId = applyProposal.offerId;
    proposal.senderAccountId = accountId;
    proposal.offerAccountId = offer.senderAccountId;
    if (offer.senderAccountType == AccountType.business) {
      proposal.influencerAccountId = accountId;
      proposal.businessAccountId = offer.senderAccountId;
      proposal.influencerName = account.name;
      proposal.businessName = offer.senderName;
    } else {
      proposal.influencerAccountId = offer.senderAccountId;
      proposal.businessAccountId = accountId;
      proposal.influencerName = offer.senderName;
      proposal.businessName = account.name;
    }
    proposal.offerTitle = offer.title;
    proposal.state = // Accept matching proposals automatically
        (!applyProposal.hasTerms() && offer.acceptMatchingProposals)
            ? ProposalState.deal
            : ProposalState.proposing;
    final DataProposalChat chat = DataProposalChat();
    chat.senderAccountId = accountId;
    chat.senderSessionId = account.sessionId;
    chat.senderSessionGhostId = applyProposal.sessionGhostId;
    chat.type = ProposalChatType.negotiate;
    chat.plainText = applyProposal.remarks;
    if (applyProposal.hasTerms()) {
      chat.terms = applyProposal.terms;
    } else {
      chat.terms = offer.terms;
    }

    channel.replyExtend(message);
    await proposalDb.startTransaction((sqljocky.Transaction transaction) async {
      // 1. Insert into proposals
      channel.replyExtend(message);
      final sqljocky.Results resultProposal = await transaction.prepareExecute(
        SqlProposal.insertProposalQuery,
        SqlProposal.makeInsertProposalParameters(proposal),
      );
      final Int64 proposalId = Int64(resultProposal.insertId);
      if (proposalId == Int64.ZERO) {
        throw Exception('Proposal not inserted.');
      }
      proposal.proposalId = proposalId;
      chat.proposalId = proposalId;

      // 2. Insert terms into chat
      channel.replyExtend(message);
      final sqljocky.Results resultNegotiate = await transaction.prepareExecute(
        SqlProposal.insertNegotiateChatQuery,
        SqlProposal.makeInsertNegotiateChatParameters(chat),
      );
      final Int64 termsChatId = Int64(resultNegotiate.insertId);
      if (termsChatId == Int64.ZERO) {
        throw Exception('Terms chat not inserted.');
      }
      proposal.termsChatId = termsChatId;
      chat.chatId = termsChatId;
      chat.sent = Int64(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);

      // 3. Update haggle on proposal
      // On automatic accept we're not updating business_wants_deal here, it's not necessary
      channel.replyExtend(message);
      final String updateTermsChatId = 'UPDATE `proposals` '
          'SET `terms_chat_id` = ?, '
          '`${account.accountType == AccountType.business ? 'business_wants_deal' : 'influencer_wants_deal'}` = 1 '
          'WHERE `proposal_id` = ?';
      final sqljocky.Results resultUpdateTermsChatId =
          await transaction.prepareExecute(
        updateTermsChatId,
        <dynamic>[
          termsChatId,
          proposalId,
        ],
      );
      if (resultUpdateTermsChatId.affectedRows == null ||
          resultUpdateTermsChatId.affectedRows == 0) {
        throw Exception('Failed to update terms chat id.');
      }

      channel.replyExtend(message);
      transaction.commit();
    });

    final NetProposal res = NetProposal();
    res.updateProposal = proposal;
    res.newChats.add(chat);
    devLog.finest('Applied for offer successfully: $res');
    channel.replyMessage(message, 'R_APLPRP', res.writeToBuffer());

    // Clear private information from broadcast
    chat.senderSessionId = Int64.ZERO;
    chat.senderSessionGhostId = 0;

    // Broadcast
    final NetProposal publishProposal = NetProposal();
    publishProposal.updateProposal = res.updateProposal;
    bc.proposalChanged(account.sessionId, publishProposal);
    final NetProposalChat publishChat = NetProposalChat();
    publishChat.chat = chat;
    bc.proposalChatPosted(account.sessionId, publishChat, account);

    // TODO(kaetemi): Update offer proposal count
    // TODO(kaetemi): Add to proposal_sender_account_ids lookup
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // List proposals
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _netListProposals(TalkMessage message) async {
    final NetListProposals listProposals = NetListProposals()
      ..mergeFromBuffer(message.data);
    devLog.finest('NetListProposals: $listProposals');

    channel.replyExtend(message);
    final sqljocky.RetainedConnection connection =
        await proposalDb.getConnection();
    try {
      // Fetch proposal
      channel.replyExtend(message);
      // TODO(kaetemi): Limit result count
      final String query = SqlProposal.getSelectProposalsQuery(
              account.accountType) +
          ' WHERE `${account.accountType == AccountType.business ? 'business_account_id' : 'influencer_account_id'}` = ?';
      await for (sqljocky.Row row
          in await connection.prepareExecute(query, <dynamic>[accountId])) {
        final NetProposal res = NetProposal();
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
    final NetGetProposal getProposal = NetGetProposal()
      ..mergeFromBuffer(message.data);
    devLog.finest('NetGetProposal: $getProposal');

    NetProposal res;

    channel.replyExtend(message);
    final sqljocky.RetainedConnection connection =
        await proposalDb.getConnection();
    try {
      // Fetch proposal
      channel.replyExtend(message);
      final String query = SqlProposal.getSelectProposalsQuery(
              account.accountType) +
          ' WHERE `proposal_id` = ?'
          ' AND `${account.accountType == AccountType.business ? 'business_account_id' : 'influencer_account_id'}` = ?';
      await for (sqljocky.Row row in await connection.prepareExecute(
        query,
        <dynamic>[getProposal.proposalId, accountId],
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

  /// Dirty proposal push, use in case of trouble
  Future<void> pushProposal(Int64 proposalId) async {
    NetProposal proposal;
    await for (sqljocky.Row row in await proposalDb.prepareExecute(
      SqlProposal.getSelectProposalsQuery(account.accountType) +
          ' WHERE `proposal_id` = ?',
      <dynamic>[proposalId],
    )) {
      // Returns non account specific data
      proposal = NetProposal();
      proposal.updateProposal =
          SqlProposal.proposalFromRow(row, account.accountType);
    }
    if (proposal == null) {
      throw Exception('Proposal not found.');
    }
    channel.sendMessage('LU_PRPSL', proposal.writeToBuffer());
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // List proposal chat
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _netListChats(TalkMessage message) async {
    final NetListChats listChats = NetListChats()
      ..mergeFromBuffer(message.data);
    devLog.finest(listChats);

    Int64 influencerAccountId;
    Int64 businessAccountId;
    ProposalState state;

    final sqljocky.RetainedConnection connection =
        await proposalDb.getConnection();
    try {
      // Fetch proposal access
      channel.replyExtend(message);
      const String query = 'SELECT '
          '`influencer_account_id`, `business_account_id`, `state` '
          'FROM `proposals` '
          'WHERE `proposal_id` = ?';
      await for (sqljocky.Row row in await connection
          .prepareExecute(query, <dynamic>[listChats.proposalId])) {
        influencerAccountId = Int64(row[0]);
        businessAccountId = Int64(row[1]);
        state = ProposalState.valueOf(row[2].toInt());
      }
      devLog.finest('$influencerAccountId $businessAccountId');

      // Authorize
      if (businessAccountId == null || influencerAccountId == null) {
        opsLog.severe(
            'Attempt to request invalid proposal chat by account "$accountId".');
        channel.replyAbort(message, 'Not found.');
        return; // Verify that this does call finally
      }
      final bool supportAccess = account.accountType == AccountType.support &&
          state == ProposalState.dispute;
      if (!supportAccess &&
          accountId != businessAccountId &&
          accountId != influencerAccountId) {
        opsLog.severe(
            'Attempt to request unauthorized proposal chat by account "$accountId".');
        channel.replyAbort(message, 'Not authorized.');
        return; // Verify that this does call finally
      }

      // Fetch
      channel.replyExtend(message);
      const String chatQuery = 'SELECT '
          '`chat_id`, UNIX_TIMESTAMP(`sent`) AS `sent`, ' // 0 1
          '`sender_account_id`, `sender_session_id`, `sender_session_ghost_id`, ' // 2 3 4
          '`type`, `plain_text`, `terms`, ' // 5 6 7
          '`image_key`, `image_blurred`, ' // 8 9
          '`marker` ' // 10
          'FROM `proposal_chats` '
          'WHERE `proposal_id` = ? '
          'ORDER BY `chat_id` DESC';
      await for (sqljocky.Row row
          in await connection.prepareExecute(chatQuery, <dynamic>[
        listChats.proposalId,
      ])) {
        final DataProposalChat chat = DataProposalChat();
        chat.proposalId = listChats.proposalId;
        chat.chatId = Int64(row[0]);
        chat.sent = Int64(row[1]);
        chat.senderAccountId = Int64(row[2]);
        final Int64 sessionId = Int64(row[3]);
        if (sessionId == account.sessionId) {
          chat.senderSessionId = sessionId;
          chat.senderSessionGhostId = row[4].toInt();
        }
        chat.type = ProposalChatType.valueOf(row[5].toInt());
        if (row[6] != null) {
          chat.plainText = row[6].toString();
        }
        if (row[7] != null) {
          chat.terms = DataTerms()..mergeFromBuffer(row[7]);
        }
        if (row[8] != null) {
          chat.imageUrl = _r.makeCloudinaryCoverUrl(row[8]);
        }
        if (row[9] != null) {
          chat.imageBlurred = row[9];
        }
        if (row[10] != null) {
          chat.marker = ProposalChatMarker.valueOf(row[10].toInt());
        }
        channel.replyMessage(message, 'R_LSTCHA', chat.writeToBuffer());
      }
    } finally {
      connection.release();
    }

    // Done
    channel.replyEndOfStream(message);
  }
}

/* end of file */
