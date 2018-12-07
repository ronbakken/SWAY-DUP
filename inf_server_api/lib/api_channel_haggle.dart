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
import 'package:switchboard/switchboard.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;

import 'package:inf_common/inf_common.dart';
import 'api_channel.dart';

class ApiChannelHaggle {
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

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Construction
  //////////////////////////////////////////////////////////////////////////////

  static final Logger opsLog = new Logger('InfOps.ApiChannelOAuth');
  static final Logger devLog = new Logger('InfDev.ApiChannelOAuth');

  ApiChannelHaggle(this._r) {
    _r.registerProcedure(
        "L_APCHAT", GlobalAccountState.readOnly, netLoadProposalChatsReq);
  }

  void dispose() {
    _r.unregisterProcedure("L_APCHAT");
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Informational network messages
  //////////////////////////////////////////////////////////////////////////////

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
          "`sender_account_id`, `sender_session_id`, `sender_session_ghost_id`, " // 2 3 4
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
        chat.senderAccountId = new Int64(row[2]);
        Int64 sessionId = new Int64(row[3]);
        if (sessionId == account.sessionId) {
          chat.senderSessionId = sessionId;
          chat.senderSessionGhostId = row[4].toInt();
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
  }
}

/* end of file */