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

Future<void> dbUpgradeProposals(sqljocky.ConnectionPool sql) async {
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

  upgrader.registerUpgrade('offers_001',
      (sqljocky.QueriableConnection sql) async {
    await sql.query(''
        'CREATE TABLE `offers` ('
        '  `offer_id` bigint(20) NOT NULL,'
        '  `sender_account_id` bigint(20) NOT NULL,'
        '  `sender_account_type` tinyint(4) NOT NULL,'
        '  `sender_session_id` bigint(20) NOT NULL,'
        '  `location_id` bigint(20) NOT NULL,'
        '  `direct` tinyint(1) NOT NULL DEFAULT 0,'
        '  `accept_matching_proposals` tinyint(1) NOT NULL DEFAULT 0,'
        '  `allow_negotiating_proposals` tinyint(1) NOT NULL DEFAULT 1,'
        '  `state` tinyint(4) NOT NULL DEFAULT 0,'
        '  `state_reason` tinyint(4) NOT NULL DEFAULT 0,'
        '  `archived` tinyint(1) NOT NULL DEFAULT 0,'
        '  `proposals_proposing` int(11) NOT NULL DEFAULT 0,'
        '  `proposals_negotiating` int(11) NOT NULL DEFAULT 0,'
        '  `proposals_deal` int(11) NOT NULL DEFAULT 0,'
        '  `proposals_rejected` int(11) NOT NULL DEFAULT 0,'
        '  `proposals_dispute` int(11) NOT NULL DEFAULT 0,'
        '  `proposals_resolved` int(11) NOT NULL DEFAULT 0,'
        '  `proposals_complete` int(11) NOT NULL DEFAULT 0'
        ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
    await sql.query(''
        'ALTER TABLE `offers`'
        '  ADD PRIMARY KEY (`offer_id`),'
        '  ADD KEY `account_id` (`sender_account_id`)');
    await sql.query(''
        'ALTER TABLE `offers`'
        '  MODIFY `offer_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=${_random.nextInt(1 << 27) + 1}');
  });

  upgrader.registerUpgrade('proposals_001',
      (sqljocky.QueriableConnection sql) async {
    await sql.query(''
        'CREATE TABLE `proposals` ('
        '  `proposal_id` bigint(20) NOT NULL,'
        '  `offer_id` bigint(20) NOT NULL,'
        "  `sender_account_id` bigint(20) NOT NULL COMMENT 'Default value temporary until version upgrade',"
        '  `offer_account_id` bigint(20) NOT NULL,'
        "  `influencer_account_id` bigint(20) NOT NULL COMMENT 'Account of proposal',"
        '  `business_account_id` bigint(20) NOT NULL,'
        "  `influencer_name` tinytext DEFAULT NULL COMMENT 'Denormalized embedded data. Not necessarily up to date',"
        "  `business_name` tinytext DEFAULT NULL COMMENT 'Denormalized embedded data. Not necessarily up to date',"
        "  `offer_title` tinytext DEFAULT NULL COMMENT 'Denormalized embedded data. Not necessarily up to date',"
        '  `last_chat_id` bigint(20) NOT NULL DEFAULT 0,'
        '  `influencer_seen_chat_id` bigint(20) NOT NULL DEFAULT 0,'
        '  `influencer_seen_time` timestamp NULL DEFAULT NULL,'
        '  `business_seen_chat_id` bigint(20) NOT NULL DEFAULT 0,'
        '  `business_seen_time` timestamp NULL DEFAULT NULL,'
        '  `terms_chat_id` bigint(20) NOT NULL DEFAULT 0,'
        '  `influencer_wants_deal` tinyint(1) NOT NULL DEFAULT 0,'
        '  `business_wants_deal` tinyint(1) NOT NULL DEFAULT 0,'
        '  `rejecting_account_id` bigint(20) NOT NULL DEFAULT 0,'
        '  `influencer_marked_delivered` tinyint(1) NOT NULL DEFAULT 0,'
        '  `influencer_marked_rewarded` tinyint(1) NOT NULL DEFAULT 0,'
        '  `business_marked_delivered` tinyint(1) NOT NULL DEFAULT 0,'
        '  `business_marked_rewarded` tinyint(1) NOT NULL DEFAULT 0,'
        '  `influencer_gave_rating` tinyint(4) NOT NULL DEFAULT 0,'
        '  `business_gave_rating` tinyint(4) NOT NULL DEFAULT 0,'
        '  `influencer_disputed` tinyint(1) NOT NULL DEFAULT 0,'
        '  `business_disputed` tinyint(1) NOT NULL DEFAULT 0,'
        '  `state` tinyint(4) NOT NULL,'
        '  `influencer_archived` tinyint(1) NOT NULL DEFAULT 0,'
        '  `business_archived` tinyint(1) NOT NULL DEFAULT 0'
        ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
    await sql.query(''
        'ALTER TABLE `proposals`'
        '  ADD PRIMARY KEY (`proposal_id`),'
        '  ADD UNIQUE KEY `offer_id` (`offer_id`,`influencer_account_id`)');
    await sql.query(''
        'ALTER TABLE `proposals`'
        '  MODIFY `proposal_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=${_random.nextInt(1 << 27) + 1}');
  });

  upgrader.registerUpgrade('proposal_chats_001',
      (sqljocky.QueriableConnection sql) async {
    await sql.query(''
        'CREATE TABLE `proposal_chats` ('
        '  `chat_id` bigint(20) NOT NULL,'
        '  `sent` timestamp NOT NULL DEFAULT current_timestamp(),'
        "  `sender_account_id` bigint(20) NOT NULL COMMENT 'Account id of the sender',"
        '  `proposal_id` bigint(20) NOT NULL,'
        '  `sender_session_id` bigint(20) NOT NULL,'
        "  `sender_session_ghost_id` bigint(20) NOT NULL COMMENT 'Session id and ghost id only sent to account session',"
        '  `type` tinyint(4) NOT NULL,'
        '  `plain_text` text DEFAULT NULL,'
        '  `terms` blob DEFAULT NULL,'
        '  `image_key` text DEFAULT NULL,'
        '  `image_blurred` blob DEFAULT NULL,'
        '  `marker` int(11) DEFAULT NULL'
        ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
    await sql.query(''
        'ALTER TABLE `proposal_chats`'
        '  ADD PRIMARY KEY (`chat_id`),'
        '  ADD UNIQUE KEY `session_id` (`sender_session_id`,`sender_session_ghost_id`),'
        '  ADD UNIQUE KEY `proposal_id_chat_id` (`proposal_id`,`chat_id`) USING BTREE,'
        '  ADD KEY `proposal_id` (`proposal_id`)');
    await sql.query(''
        'ALTER TABLE `proposal_chats`'
        '  MODIFY `chat_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=${_random.nextInt(1 << 27) + 1}');
  });

  await upgrader.run();
}

/* end of file */
