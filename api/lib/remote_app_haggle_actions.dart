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

class RemoteAppHaggleActions {
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

  RemoteAppHaggleActions(this._r) {
    /*
    _subscriptions.add(_r.saferListen("L_APPLIC",
        GlobalAccountState.GAS_READ_ONLY, true, netLoadApplicantReq));
    _subscriptions.add(_r.saferListen("L_APPLIS",
        GlobalAccountState.GAS_READ_ONLY, true, netLoadApplicantsReq));
    _subscriptions.add(_r.saferListen("L_APCHAT",
        GlobalAccountState.GAS_READ_ONLY, true, netLoadApplicantChatsReq));*/
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
  // User actions
  //////////////////////////////////////////////////////////////////////////////

  // Response messages
  static int _netDataApplicantUpdate = TalkSocket.encode("LU_APPLI");
  static int _netDataApplicantChatUpdate = TalkSocket.encode("LU_A_CHA");
  static int _netDataApplicantChatNew = TalkSocket.encode("LN_A_CHA");

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
