/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'package:quiver/collection.dart';
import 'package:wstalk/wstalk.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;

import 'inf.pb.dart';
import 'remote_app.dart';

class BroadcastCenter {
  
  final ConfigData config;
  final sqljocky.ConnectionPool sql;
  final dospace.Bucket bucket;

  Multimap<int, RemoteApp> accountToRemoteApps = new Multimap<int, RemoteApp>();

  static final Logger opsLog = new Logger('InfOps.BroadcastCenter');
  static final Logger devLog = new Logger('InfDev.BroadcastCenter');

  BroadcastCenter(this.config, this.sql, this.bucket) {
  }

  void accountConnected(RemoteApp remoteApp) {
    accountToRemoteApps.add(remoteApp.account.state.accountId, remoteApp);
  }

  void accountDisconnected(RemoteApp remoteApp) {
    if (accountToRemoteApps.remove(remoteApp.account.state.accountId, remoteApp)) {
      // ...
    }
  }

}

/* end of file */