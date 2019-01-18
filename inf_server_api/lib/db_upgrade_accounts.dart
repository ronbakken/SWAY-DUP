/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';
import 'dart:core';
import 'dart:math';

import 'package:inf_server_api/db_upgrader.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;

Future<void> dbUpgradeAccounts(sqljocky.ConnectionPool sql) async {
  final DbUpgrader upgrader = DbUpgrader('inf_server_api', sql);

  final Random _random = Random.secure();

  upgrader.registerUpgrade('self_test_001',
      (sqljocky.QueriableConnection sql) async {
    await sql.query(''
        'CREATE TABLE `self_test` ('
        '  `self_test_id` bigint(20) NOT NULL,'
        '  `message` text NOT NULL'
        ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
    await sql.query(''
        "INSERT INTO `self_test` (`self_test_id`, `message`) VALUES (1, 'Zipper Sorting 😏')");
    await sql.query(''
        'ALTER TABLE `self_test`'
        '  ADD PRIMARY KEY (`self_test_id`)');
    await sql.query(''
        'ALTER TABLE `self_test`'
        '  MODIFY `self_test_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=${_random.nextInt(1 << 27) + 2}');
  });

  upgrader.registerUpgrade('sessions_001',
      (sqljocky.QueriableConnection sql) async {
    await sql.query(''
        'CREATE TABLE `sessions` ('
        '  `session_id` bigint(20) NOT NULL,'
        '  `created` timestamp NOT NULL DEFAULT current_timestamp(),'
        '  `cookie_hash` blob NOT NULL,'
        "  `device_hash` blob NOT NULL COMMENT 'A device generated value to identify devices',"
        "  `name` text NOT NULL COMMENT 'Should be modifyable by the user',"
        '  `account_type` int(11) NOT NULL DEFAULT 0,'
        '  `account_id` bigint(20) NOT NULL DEFAULT 0,'
        "  `firebase_token` text CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL COMMENT 'TBD',"
        "  `info` text NOT NULL COMMENT 'Arbitrary information from session, not important'"
        ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
    await sql.query(''
        'ALTER TABLE `sessions`'
        '  ADD PRIMARY KEY (`session_id`),'
        '  ADD KEY `account_id` (`account_id`)');
    await sql.query(''
        'ALTER TABLE `sessions`'
        '  MODIFY `session_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=${_random.nextInt(1 << 27) + 1}');
  });

  upgrader.registerUpgrade('sessions_002',
      (sqljocky.QueriableConnection sql) async {
    // Change to latin1_bin
    await sql.query(''
        'ALTER TABLE `sessions`'
        "  CHANGE `firebase_token` `firebase_token` TEXT CHARACTER SET latin1 COLLATE latin1_bin NULL DEFAULT NULL COMMENT 'TBD'");
  });

  upgrader.registerUpgrade('accounts_001',
      (sqljocky.QueriableConnection sql) async {
    await sql.query(''
        'CREATE TABLE `accounts` ('
        '  `account_id` bigint(20) NOT NULL,'
        '  `created` timestamp NOT NULL DEFAULT current_timestamp(),'
        '  `name` tinytext NOT NULL,'
        '  `account_type` tinyint(4) NOT NULL,'
        "  `global_account_state` tinyint(4) NOT NULL COMMENT 'Higher value means more access',"
        "  `global_account_state_reason` tinyint(4) NOT NULL COMMENT 'These are for user message only',"
        "  `description` tinytext NOT NULL DEFAULT '',"
        "  `location_id` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Refers to the main location of this entity',"
        '  `avatar_key` tinytext CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL,'
        '  `website` tinytext DEFAULT NULL,'
        '  `email` tinytext DEFAULT NULL'
        ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
    await sql.query(''
        'ALTER TABLE `accounts`'
        '  ADD PRIMARY KEY (`account_id`)');
    await sql.query(''
        'ALTER TABLE `accounts`'
        '  MODIFY `account_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=${_random.nextInt(1 << 27) + 1}');
  });

  upgrader.registerUpgrade('social_media_001',
      (sqljocky.QueriableConnection sql) async {
    await sql.query(''
        'CREATE TABLE `social_media` ('
        '  `oauth_user_id` varchar(35) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,'
        '  `oauth_provider` tinyint(4) NOT NULL,'
        '  `updated` timestamp NOT NULL DEFAULT current_timestamp(),'
        '  `screen_name` tinytext DEFAULT NULL,'
        '  `display_name` tinytext DEFAULT NULL,'
        '  `avatar_url` tinytext CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL,'
        '  `profile_url` tinytext CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL,'
        '  `description` text DEFAULT NULL,'
        '  `location` tinytext DEFAULT NULL,'
        '  `website` tinytext CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL,'
        '  `email` tinytext CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL,'
        '  `friends_count` int(11) NOT NULL DEFAULT 0,'
        '  `followers_count` int(11) NOT NULL DEFAULT 0,'
        '  `following_count` int(11) NOT NULL DEFAULT 0,'
        '  `posts_count` int(11) NOT NULL DEFAULT 0,'
        '  `verified` tinyint(1) NOT NULL DEFAULT 0'
        ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
    await sql.query(''
        'ALTER TABLE `social_media`'
        '  ADD PRIMARY KEY (`oauth_user_id`,`oauth_provider`)');
    await sql.query(''
        'ALTER TABLE `social_media` ADD FULLTEXT KEY `fulltext` (`screen_name`,`display_name`,`description`,`location`)');
  });

  upgrader.registerUpgrade('locations_001',
      (sqljocky.QueriableConnection sql) async {
    await sql.query(''
        'CREATE TABLE `locations` ('
        '  `location_id` bigint(20) NOT NULL,'
        '  `created` timestamp NOT NULL DEFAULT current_timestamp(),'
        '  `account_id` bigint(20) NOT NULL,'
        "  `name` varchar(70) NOT NULL COMMENT 'This is a user assignable name for convenience',"
        '  `approximate` text NOT NULL,'
        '  `detail` text NOT NULL,'
        '  `postcode` varchar(12) CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL,'
        "  `region_code` varchar(12) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL DEFAULT 'US-CA',"
        "  `country_code` varchar(2) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL DEFAULT 'us' COMMENT 'https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2',"
        '  `latitude` double NOT NULL,'
        '  `longitude` double NOT NULL,'
        '  `s2cell_id` bigint(20) NOT NULL DEFAULT -1,'
        "  `geohash` varchar(64) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL DEFAULT '',"
        "  `offer_count` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Cached offer count. Used to quickly find offers'"
        ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
    await sql.query(''
        'ALTER TABLE `locations`'
        '  ADD PRIMARY KEY (`location_id`),'
        '  ADD KEY `account_id` (`account_id`),'
        '  ADD KEY `s2cell_id` (`s2cell_id`)');
    await sql.query(''
        'ALTER TABLE `locations`'
        '  MODIFY `location_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=${_random.nextInt(1 << 27) + 1}');
  });

  upgrader.registerUpgrade('oauth_connections_001',
      (sqljocky.QueriableConnection sql) async {
    await sql.query(''
        'CREATE TABLE `oauth_connections` ('
        "  `oauth_user_id` varchar(35) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL COMMENT 'User id native to the OAuth platform',"
        '  `oauth_provider` tinyint(4) NOT NULL,'
        '  `account_type` tinyint(4) NOT NULL,'
        '  `created` timestamp NOT NULL DEFAULT current_timestamp(),'
        '  `updated` timestamp NOT NULL DEFAULT current_timestamp(),'
        "  `account_id` bigint(20) NOT NULL DEFAULT 0 COMMENT 'If 0, then match by session_id',"
        '  `session_id` bigint(20) NOT NULL,'
        '  `oauth_token` text CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,'
        "  `oauth_token_secret` text CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL DEFAULT '',"
        '  `oauth_token_expires` int(11) NOT NULL DEFAULT 0,'
        '  `expired` tinyint(1) NOT NULL DEFAULT 0'
        ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
    await sql.query(''
        'ALTER TABLE `oauth_connections`'
        '  ADD PRIMARY KEY (`oauth_user_id`,`oauth_provider`,`account_type`),'
        '  ADD KEY `account_id` (`account_id`),'
        '  ADD KEY `session_id` (`session_id`)');
  });

  upgrader.registerUpgrade('oauth_connections_002',
      (sqljocky.QueriableConnection sql) async {
    // Change to latin1_bin
    await sql.query(''
        'ALTER TABLE `oauth_connections`'
        '  CHANGE `oauth_token` `oauth_token` TEXT CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,'
        "  CHANGE `oauth_token_secret` `oauth_token_secret` TEXT CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '\'\'';");
  });

  await upgrader.run();
}

/* end of file */
