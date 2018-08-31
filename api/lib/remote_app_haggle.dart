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
  // Construction
  //////////////////////////////////////////////////////////////////////////////

  static final Logger opsLog = new Logger('InfOps.RemoteAppOAuth');
  static final Logger devLog = new Logger('InfDev.RemoteAppOAuth');

  RemoteAppHaggle(this._r) {
    _netLoadApplicantReq = _r.saferListen("L_APPLIC",
        GlobalAccountState.GAS_READ_ONLY, true, netLoadApplicantReq);
  }

  void dispose() {
    if (_netLoadApplicantReq != null) {
      _netLoadApplicantReq.cancel();
      _netLoadApplicantReq = null;
    }
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Network messages
  //////////////////////////////////////////////////////////////////////////////

  static int _netDataApplicantUpdate = TalkSocket.encode("LU_APPLI");

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

  StreamSubscription<TalkMessage> _netLoadApplicantReq; // L_APPLIC
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
}
