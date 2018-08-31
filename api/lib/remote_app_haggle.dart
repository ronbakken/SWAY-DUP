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

import 'inf.pb.dart';
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

  int get accountId {
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
        GlobalAccountState.GAS_READ_ONLY, true, netLoadApplicantReq));
    _subscriptions.add(_r.saferListen("L_APPLIS",
        GlobalAccountState.GAS_READ_ONLY, true, netLoadApplicantsReq));
    _subscriptions.add(_r.saferListen("L_APCHAT",
        GlobalAccountState.GAS_READ_ONLY, true, netLoadApplicantChatsReq));
  }

  void dispose() {
    _subscriptions.forEach((subscription) {
      subscription.cancel();
    });
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Informational network messages
  //////////////////////////////////////////////////////////////////////////////

  static int _netDataApplicantUpdate = TalkSocket.encode("LU_APPLI");
  static int _netDataApplicantChatUpdate = TalkSocket.encode("LU_A_CHA");

  static String _applicantSelect = "`applicant_id`, `offer_id`, " // 0 1
      "`influencer_account_id`, `business_account_id`, " // 2 3
      "`haggle_chat_id`, " // 4
      "`influencer_wants_deal`, `business_wants_deal`, " // 5 6
      "`influencer_marked_delivered`, `influencer_marked_rewarded`, " // 7 8
      "`business_marked_delivered`, `business_marked_rewarded`, " // 9 10
      "`influencer_gave_rating`, `business_gave_rating`, " // 11 12
      "`influencer_disputed`, `business_disputed`, " // 13 14
      "`state` "; // 15
  DataApplicant _applicantFromRow(sqljocky.Row row) {
    DataApplicant applicant = new DataApplicant();
    applicant.applicantId = row[0].toInt();
    applicant.offerId = row[1].toInt();
    applicant.influencerAccountId = row[2].toInt();
    applicant.businessAccountId = row[3].toInt();
    applicant.haggleChatId = new Int64(row[4].toInt());
    applicant.influencerWantsDeal = row[5].toInt() != 0;
    applicant.businessWantsDeal = row[6].toInt() != 0;
    applicant.influencerMarkedDelivered = row[7].toInt() != 0;
    applicant.influencerMarkedRewarded = row[8].toInt() != 0;
    applicant.businessMarkedDelivered = row[9].toInt() != 0;
    applicant.businessMarkedRewarded = row[10].toInt() != 0;
    applicant.influencerGaveRating = row[11].toInt();
    applicant.businessGaveRating = row[12].toInt();
    applicant.influencerDisputed = row[13].toInt() != 0;
    applicant.businessDisputed = row[14].toInt() != 0;
    applicant.state = ApplicantState.valueOf(row[15].toInt());
    return applicant;
  }

  Future<void> netLoadApplicantReq(TalkMessage message) async {
    NetLoadApplicantReq pb = new NetLoadApplicantReq();
    pb.mergeFromBuffer(message.data);
    devLog.finest(pb);

    DataApplicant applicant;

    sqljocky.RetainedConnection connection = await sql.getConnection();
    try {
      // Fetch applicant
      ts.sendExtend(message);
      String query = "SELECT "
          "$_applicantSelect"
          "FROM `applicants` "
          "WHERE `applicant_id` = ?";
      await for (sqljocky.Row row
          in await connection.prepareExecute(query, [pb.applicantId.toInt()])) {
        applicant = _applicantFromRow(row);
      }
    } finally {
      connection.release();
    }

    if (applicant == null) {
      ts.sendException("Not Found", message);
    } else if (account.state.accountType == AccountType.AT_SUPPORT ||
        accountId == applicant.businessAccountId ||
        accountId == applicant.influencerAccountId) {
      ts.sendMessage(_netDataApplicantUpdate, applicant.writeToBuffer(),
          replying: message);
    } else {
      ts.sendException("Not Authorized", message);
    }
  }

  Future<void> netLoadApplicantsReq(TalkMessage message) async {
    NetLoadApplicantsReq pb = new NetLoadApplicantsReq();
    pb.mergeFromBuffer(message.data);
    devLog.finest('NetLoadApplicantsReq: $pb');

    sqljocky.RetainedConnection connection = await sql.getConnection();
    try {
      // Fetch applicant
      ts.sendExtend(message);
      String query = "SELECT "
          "$_applicantSelect"
          "FROM `applicants` "
          "WHERE `${account.state.accountType == AccountType.AT_BUSINESS ? 'business_account_id' : 'influencer_account_id'}` = ?";
      await for (sqljocky.Row row
          in await connection.prepareExecute(query, [accountId])) {
        ts.sendMessage(
            _netDataApplicantUpdate, _applicantFromRow(row).writeToBuffer(),
            replying: message);
      }
    } finally {
      connection.release();
    }

    ts.sendEndOfStream(message);
  }

  // NetLoadApplicantChatsReq
  Future<void> netLoadApplicantChatsReq(TalkMessage message) async {
    NetLoadApplicantChatsReq pb = new NetLoadApplicantChatsReq();
    pb.mergeFromBuffer(message.data);
    devLog.finest(pb);

    int influencerAccountId;
    int businessAccountId;

    sqljocky.RetainedConnection connection = await sql.getConnection();
    try {
      // Fetch applicant
      ts.sendExtend(message);
      String query = "SELECT "
          "`influencer_account_id`, `business_account_id` "
          "FROM `applicants` "
          "WHERE `applicant_id` = ?";
      await for (sqljocky.Row row
          in await connection.prepareExecute(query, [pb.applicantId.toInt()])) {
        influencerAccountId = row[0].toInt();
        businessAccountId = row[1].toInt();
      }
      devLog.finest("$influencerAccountId $businessAccountId");

      // Authorize
      if (businessAccountId == null || influencerAccountId == null) {
        ts.sendException("Not Found", message);
        return; // Verify that this does call finally
      }
      if (account.state.accountType != AccountType.AT_SUPPORT &&
          accountId != businessAccountId &&
          accountId != influencerAccountId) {
        ts.sendException("Not Authorized", message);
        return; // Verify that this does call finally
      }

      // Fetch
      ts.sendExtend(message);
      String chatQuery = "SELECT "
          "`chat_id`, UNIX_TIMESTAMP(`sent`) AS `sent`, " // 0 1
          "`sender_id`, `device_id`, `device_ghost_id`, " // 2 3 4
          "`type`, `text`, UNIX_TIMESTAMP(`seen`) AS `seen` " // 5 6 7
          "FROM `applicant_haggling` "
          "WHERE `applicant_id` = ?";
      await for (sqljocky.Row row
          in await connection.prepareExecute(chatQuery, [
        pb.applicantId.toInt(),
      ])) {
        DataApplicantChat chat = new DataApplicantChat();
        chat.applicantId = pb.applicantId;
        chat.chatId = new Int64(row[0].toInt());
        chat.sent = new Int64(row[1].toInt());
        chat.senderId = row[2].toInt();
        int deviceId = row[3].toInt();
        if (deviceId == account.state.deviceId) {
          chat.deviceId = deviceId;
          chat.deviceGhostId = row[4].toInt();
        }
        chat.type = ApplicantChatType.valueOf(row[5].toInt());
        chat.text = row[6].toString();
        if (row[7] != null) chat.seen = new Int64(row[7].toInt());
        devLog.finest("${chat.text}");
        if (chat.type == ApplicantChatType.ACT_IMAGE_KEY) {
          chat.text = "url=" +
              Uri.encodeQueryComponent(_r.makeCloudinaryCoverUrl(
                  Uri.splitQueryString(chat.text)['key'].toString()));
        }
        ts.sendMessage(_netDataApplicantChatUpdate, chat.writeToBuffer(),
            replying: message);
      }
    } finally {
      connection.release();
    }

    // Done
    ts.sendEndOfStream(message);
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // User actions
  //////////////////////////////////////////////////////////////////////////////

  // Client should respond to live updates and posts from broadcast center
  // LN_APPLI, LN_A_CHA, LU_APPLI, LU_A_CHA
  // Also post to FCM

  /*
  final Function(String text) onSendPlain; -> CH_PLAIN
  final Function(String key) onSendImageKey; -> CH_IMAGE

  final Function(DataApplicantChat haggleChat) onBeginHaggle; -> UI -> CH_HAGGL
  final Function(DataApplicantChat haggleChat) onWantDeal; -- not yet defined -- only succeeds if picked chat is the current one

  final Function() onReject; -- not yet defined
  final Function() onBeginReport; -- not yet defined -- posts to freshdesk // FCM email verification service?
  final Function() onBeginMarkCompleted; -> AP_COMPL
  */

}
