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
import 'package:logging/logging.dart';
import 'package:wstalk/wstalk.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;

import 'package:inf_common/inf_common.dart';
import 'remote_app.dart';

class RemoteAppHaggle {
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Inherited properties
  //////////////////////////////////////////////////////////////////////////////

  RemoteApp _r;
  ConfigData get config {
    return _r.config;
  }

  sqljocky.ConnectionPool get sql {
    return _r.sql;
  }

  TalkSocket get ts {
    return _r.ts;
  }

  dospace.Bucket get bucket {
    return _r.bucket;
  }

  DataAccount get account {
    return _r.account;
  }

  Int64 get accountId {
    return _r.account.state.accountId;
  }

  GlobalAccountState get globalAccountState {
    return _r.account.state.globalAccountState;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Construction
  //////////////////////////////////////////////////////////////////////////////

  static final Logger opsLog = new Logger('InfOps.RemoteAppOAuth');
  static final Logger devLog = new Logger('InfDev.RemoteAppOAuth');
  final List<StreamSubscription<dynamic>> _subscriptions =
      new List<StreamSubscription<dynamic>>();

  RemoteAppHaggle(this._r) {
    _subscriptions.add(_r.saferListen("L_APPLIC",
        GlobalAccountState.readOnly, true, netLoadProposalReq));
    _subscriptions.add(_r.saferListen("L_APPLIS",
        GlobalAccountState.readOnly, true, netLoadProposalsReq));
    _subscriptions.add(_r.saferListen("L_APCHAT",
        GlobalAccountState.readOnly, true, netLoadProposalChatsReq));
  }

  void dispose() {
    _subscriptions.forEach((subscription) {
      subscription.cancel();
    });
    _subscriptions.clear();
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Informational network messages
  //////////////////////////////////////////////////////////////////////////////

  static int _netDataProposalUpdate = TalkSocket.encode("LU_APPLI");
  static int _netDataProposalChatUpdate = TalkSocket.encode("LU_A_CHA");

  static String _proposalSelect = "`proposal_id`, `offer_id`, " // 0 1
      "`influencer_account_id`, `business_account_id`, " // 2 3
      "`sender_account_id`, `terms_chat_id`, " // 4 5
      "`influencer_wants_deal`, `business_wants_deal`, " // 6 7
      "`influencer_marked_delivered`, `influencer_marked_rewarded`, " // 8 9
      "`business_marked_delivered`, `business_marked_rewarded`, " // 10 11
      "`influencer_gave_rating`, `business_gave_rating`, " // 12 13
      "`influencer_disputed`, `business_disputed`, " // 14 15
      "`state` "; // 15
  DataProposal _proposalFromRow(sqljocky.Row row) {
    DataProposal proposal = new DataProposal();
    proposal.proposalId = row[0].toInt();
    proposal.offerId = row[1].toInt();
    proposal.influencerAccountId = row[2].toInt();
    proposal.businessAccountId = row[3].toInt();
    proposal.senderAccountId = row[4].toInt();
    proposal.termsChatId = new Int64(row[5].toInt());
    proposal.influencerWantsDeal = row[6].toInt() != 0;
    proposal.businessWantsDeal = row[7].toInt() != 0;
    proposal.influencerMarkedDelivered = row[8].toInt() != 0;
    proposal.influencerMarkedRewarded = row[9].toInt() != 0;
    proposal.businessMarkedDelivered = row[10].toInt() != 0;
    proposal.businessMarkedRewarded = row[11].toInt() != 0;
    proposal.influencerGaveRating = row[12].toInt(); // TODO: Maybe just bool
    proposal.businessGaveRating = row[13].toInt(); // TODO: Maybe just bool
    proposal.influencerDisputed = row[14].toInt() != 0;
    proposal.businessDisputed = row[15].toInt() != 0;
    proposal.state = ProposalState.valueOf(row[16].toInt());
    return proposal;
  }

  Future<DataProposal> getProposal(Int64 proposalId) async {
    DataProposal proposal;
    String query = "SELECT "
        "$_proposalSelect"
        "FROM `proposals` "
        "WHERE `proposal_id` = ?";
    await for (sqljocky.Row row
        in await sql.prepareExecute(query, [proposalId])) {
      proposal = _proposalFromRow(row);
    }
    if (account.state.accountType == AccountType.support ||
        accountId == proposal.businessAccountId ||
        accountId == proposal.influencerAccountId) {
      return proposal;
    }
    return null;
  }

  Future<void> netLoadProposalReq(TalkMessage message) async {
    NetLoadProposalReq pb = new NetLoadProposalReq();
    pb.mergeFromBuffer(message.data);
    devLog.finest(pb);

    DataProposal proposal;

    sqljocky.RetainedConnection connection = await sql.getConnection();
    try {
      // Fetch proposal
      ts.sendExtend(message);
      String query = "SELECT "
          "$_proposalSelect"
          "FROM `proposals` "
          "WHERE `proposal_id` = ?";
      await for (sqljocky.Row row
          in await connection.prepareExecute(query, [pb.proposalId.toInt()])) {
        proposal = _proposalFromRow(row);
      }
    } finally {
      connection.release();
    }

    if (proposal == null) {
      ts.sendException("Not Found", message);
    } else if (account.state.accountType == AccountType.support ||
        accountId == proposal.businessAccountId ||
        accountId == proposal.influencerAccountId) {
      ts.sendMessage(_netDataProposalUpdate, proposal.writeToBuffer(),
          replying: message);
    } else {
      ts.sendException("Not Authorized", message);
    }
  }

  Future<void> netLoadProposalsReq(TalkMessage message) async {
    NetLoadProposalsReq pb = new NetLoadProposalsReq();
    pb.mergeFromBuffer(message.data);
    devLog.finest('NetLoadProposalsReq: $pb');

    sqljocky.RetainedConnection connection = await sql.getConnection();
    try {
      // Fetch proposal
      ts.sendExtend(message);
      String query = "SELECT "
          "$_proposalSelect"
          "FROM `proposals` "
          "WHERE `${account.state.accountType == AccountType.business ? 'business_account_id' : 'influencer_account_id'}` = ?";
      await for (sqljocky.Row row
          in await connection.prepareExecute(query, [accountId])) {
        ts.sendMessage(
            _netDataProposalUpdate, _proposalFromRow(row).writeToBuffer(),
            replying: message);
      }
    } finally {
      connection.release();
    }

    ts.sendEndOfStream(message);
  }

  // NetLoadProposalChatsReq
  Future<void> netLoadProposalChatsReq(TalkMessage message) async {
    NetLoadProposalChatsReq pb = new NetLoadProposalChatsReq();
    pb.mergeFromBuffer(message.data);
    devLog.finest(pb);

    Int64 influencerAccountId;
    Int64 businessAccountId;

    sqljocky.RetainedConnection connection = await sql.getConnection();
    try {
      // Fetch proposal
      ts.sendExtend(message);
      String query = "SELECT "
          "`influencer_account_id`, `business_account_id` "
          "FROM `proposals` "
          "WHERE `proposal_id` = ?";
      await for (sqljocky.Row row
          in await connection.prepareExecute(query, [pb.proposalId.toInt()])) {
        influencerAccountId = row[0].toInt64();
        businessAccountId = row[1].toInt64();
      }
      devLog.finest("$influencerAccountId $businessAccountId");

      // Authorize
      if (businessAccountId == null || influencerAccountId == null) {
        opsLog.severe(
            "Attempt to request invalid proposal chat by account '$accountId'");
        ts.sendException("Not Found", message);
        return; // Verify that this does call finally
      }
      if (account.state.accountType != AccountType.support &&
          accountId != businessAccountId &&
          accountId != influencerAccountId) {
        opsLog.severe(
            "Attempt to request unauthorized proposal chat by account '$accountId'");
        ts.sendException("Not Authorized", message);
        return; // Verify that this does call finally
      }

      // Fetch
      ts.sendExtend(message);
      String chatQuery = "SELECT "
          "`chat_id`, UNIX_TIMESTAMP(`sent`) AS `sent`, " // 0 1
          "`sender_id`, `session_id`, `session_ghost_id`, " // 2 3 4
          "`type`, `text` " // 5 6 7
          "FROM `proposal_haggling` "
          "WHERE `proposal_id` = ? "
          "ORDER BY `chat_id` DESC";
      await for (sqljocky.Row row
          in await connection.prepareExecute(chatQuery, [
        pb.proposalId.toInt(),
      ])) {
        DataProposalChat chat = new DataProposalChat();
        chat.proposalId = pb.proposalId;
        chat.chatId = new Int64(row[0].toInt());
        chat.sent = new Int64(row[1].toInt());
        chat.senderId = row[2].toInt();
        Int64 sessionId = row[3].toInt64();
        if (sessionId == account.state.sessionId) {
          chat.sessionId = sessionId;
          chat.sessionGhostId = row[4].toInt();
        }
        chat.type = ProposalChatType.valueOf(row[5].toInt());
        chat.text = row[6].toString();
        // if (row[7] != null) chat.seen = new Int64(row[7].toInt());
        devLog.finest("${chat.text}");
        if (chat.type == ProposalChatType.imageKey) {
          String key = Uri.splitQueryString(chat.text)['key'].toString();
          chat.text = "url=" +
              Uri.encodeQueryComponent(_r.makeCloudinaryCoverUrl(key)) +
              '&blurred_url=' +
              Uri.encodeQueryComponent(_r.makeCloudinaryBlurredCoverUrl(key));
          ;
        }
        ts.sendMessage(_netDataProposalChatUpdate, chat.writeToBuffer(),
            replying: message);
      }
    } finally {
      connection.release();
    }

    // Done
    ts.sendEndOfStream(message);
  }
}
