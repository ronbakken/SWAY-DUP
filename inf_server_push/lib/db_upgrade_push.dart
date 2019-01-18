/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';
import 'dart:core';
import 'dart:math';

import 'package:inf_server_push/db_upgrader.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;

Future<void> dbUpgradePush(sqljocky.ConnectionPool sql) async {
  final DbUpgrader upgrader = DbUpgrader('inf_server_push', sql);

  // final Random _random = Random.secure();

  upgrader.registerUpgrade('push_tokens_001',
      (sqljocky.QueriableConnection sql) async {
    await sql.query(''
        'CREATE TABLE `push_tokens` ('
        '  `session_id` bigint(20) NOT NULL,'
        '  `account_id` bigint(20) NOT NULL,'
        '  `token_type` tinyint(4) NOT NULL DEFAULT 0,'
        '  `token` varchar(512) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL'
        ') ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin');
  });

  await upgrader.run();
}

/* end of file */
