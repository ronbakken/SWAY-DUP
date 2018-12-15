-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: inf-mariadb
-- Generation Time: Dec 15, 2018 at 03:00 PM
-- Server version: 10.3.11-MariaDB-1:10.3.11+maria~bionic
-- PHP Version: 7.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `inf`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `account_id` bigint(20) NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `name` tinytext NOT NULL,
  `account_type` tinyint(4) NOT NULL,
  `global_account_state` tinyint(4) NOT NULL COMMENT 'Higher value means more access',
  `global_account_state_reason` tinyint(4) NOT NULL COMMENT 'These are for user message only',
  `description` tinytext NOT NULL DEFAULT '',
  `location_id` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Refers to the main location of this entity',
  `avatar_key` tinytext CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL,
  `website` tinytext DEFAULT NULL,
  `email` tinytext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `location_id` bigint(20) NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `account_id` bigint(20) NOT NULL,
  `name` varchar(70) NOT NULL COMMENT 'This is a user assignable name for convenience',
  `approximate` text NOT NULL,
  `detail` text NOT NULL,
  `postcode` varchar(12) CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL,
  `region_code` varchar(12) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL DEFAULT 'US-CA',
  `country_code` varchar(2) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL DEFAULT 'us' COMMENT 'https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2',
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `s2cell_id` bigint(20) NOT NULL DEFAULT -1,
  `geohash` varchar(64) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `offer_count` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Cached offer count. Used to quickly find offers'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_connections`
--

CREATE TABLE `oauth_connections` (
  `oauth_user_id` varchar(35) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL COMMENT 'User id native to the OAuth platform',
  `oauth_provider` tinyint(4) NOT NULL,
  `account_type` tinyint(4) NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `account_id` bigint(20) NOT NULL DEFAULT 0 COMMENT 'If 0, then match by session_id',
  `session_id` bigint(20) NOT NULL,
  `oauth_token` text CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `oauth_token_secret` text CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `oauth_token_expires` int(11) NOT NULL DEFAULT 0,
  `expired` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `offers`
--

CREATE TABLE `offers` (
  `offer_id` bigint(20) NOT NULL,
  `sender_account_id` bigint(20) NOT NULL,
  `sender_account_type` tinyint(4) NOT NULL,
  `sender_session_id` bigint(20) NOT NULL,
  `location_id` bigint(20) NOT NULL,
  `direct` tinyint(1) NOT NULL DEFAULT 0,
  `accept_matching_proposals` tinyint(1) NOT NULL DEFAULT 0,
  `allow_negotiating_proposals` tinyint(1) NOT NULL DEFAULT 1,
  `state` tinyint(4) NOT NULL DEFAULT 0,
  `state_reason` tinyint(4) NOT NULL DEFAULT 0,
  `archived` tinyint(1) NOT NULL DEFAULT 0,
  `proposals_proposing` int(11) NOT NULL DEFAULT 0,
  `proposals_negotiating` int(11) NOT NULL DEFAULT 0,
  `proposals_deal` int(11) NOT NULL DEFAULT 0,
  `proposals_rejected` int(11) NOT NULL DEFAULT 0,
  `proposals_dispute` int(11) NOT NULL DEFAULT 0,
  `proposals_resolved` int(11) NOT NULL DEFAULT 0,
  `proposals_complete` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `proposals`
--

CREATE TABLE `proposals` (
  `proposal_id` bigint(20) NOT NULL,
  `offer_id` bigint(20) NOT NULL,
  `sender_account_id` bigint(20) NOT NULL COMMENT 'Default value temporary until version upgrade',
  `offer_account_id` bigint(20) NOT NULL,
  `influencer_account_id` bigint(20) NOT NULL COMMENT 'Account of proposal',
  `business_account_id` bigint(20) NOT NULL,
  `influencer_name` tinytext DEFAULT NULL COMMENT 'Denormalized embedded data. Not necessarily up to date',
  `business_name` tinytext DEFAULT NULL COMMENT 'Denormalized embedded data. Not necessarily up to date',
  `offer_title` tinytext DEFAULT NULL COMMENT 'Denormalized embedded data. Not necessarily up to date',
  `last_chat_id` bigint(20) NOT NULL DEFAULT 0,
  `influencer_seen_chat_id` bigint(20) NOT NULL DEFAULT 0,
  `influencer_seen_time` timestamp NULL DEFAULT NULL,
  `business_seen_chat_id` bigint(20) NOT NULL DEFAULT 0,
  `business_seen_time` timestamp NULL DEFAULT NULL,
  `terms_chat_id` bigint(20) NOT NULL DEFAULT 0,
  `influencer_wants_deal` tinyint(1) NOT NULL DEFAULT 0,
  `business_wants_deal` tinyint(1) NOT NULL DEFAULT 0,
  `rejecting_account_id` bigint(20) NOT NULL DEFAULT 0,
  `influencer_marked_delivered` tinyint(1) NOT NULL DEFAULT 0,
  `influencer_marked_rewarded` tinyint(1) NOT NULL DEFAULT 0,
  `business_marked_delivered` tinyint(1) NOT NULL DEFAULT 0,
  `business_marked_rewarded` tinyint(1) NOT NULL DEFAULT 0,
  `influencer_gave_rating` tinyint(4) NOT NULL DEFAULT 0,
  `business_gave_rating` tinyint(4) NOT NULL DEFAULT 0,
  `influencer_disputed` tinyint(1) NOT NULL DEFAULT 0,
  `business_disputed` tinyint(1) NOT NULL DEFAULT 0,
  `state` tinyint(4) NOT NULL,
  `influencer_archived` tinyint(1) NOT NULL DEFAULT 0,
  `business_archived` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `proposal_chats`
--

CREATE TABLE `proposal_chats` (
  `chat_id` bigint(20) NOT NULL,
  `sent` timestamp NOT NULL DEFAULT current_timestamp(),
  `sender_account_id` bigint(20) NOT NULL COMMENT 'Account id of the sender',
  `proposal_id` bigint(20) NOT NULL,
  `sender_session_id` bigint(20) NOT NULL,
  `sender_session_ghost_id` bigint(20) NOT NULL COMMENT 'Session id and ghost id only sent to account session',
  `type` tinyint(4) NOT NULL,
  `plain_text` text DEFAULT NULL,
  `terms` blob DEFAULT NULL,
  `image_key` text DEFAULT NULL,
  `image_blurred` blob DEFAULT NULL,
  `marker` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `self_test`
--

CREATE TABLE `self_test` (
  `self_test_id` bigint(20) NOT NULL,
  `message` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `self_test`
--

INSERT INTO `self_test` (`self_test_id`, `message`) VALUES
(1, 'Zipper Sorting 😏');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `session_id` bigint(20) NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `cookie_hash` blob NOT NULL,
  `device_hash` blob NOT NULL COMMENT 'A device generated value to identify devices',
  `name` text NOT NULL COMMENT 'Should be modifyable by the user',
  `account_type` int(11) NOT NULL DEFAULT 0,
  `account_id` bigint(20) NOT NULL DEFAULT 0,
  `firebase_token` text CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL COMMENT 'TBD',
  `info` text NOT NULL COMMENT 'Arbitrary information from session, not important'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `social_media`
--

CREATE TABLE `social_media` (
  `oauth_user_id` varchar(35) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `oauth_provider` tinyint(4) NOT NULL,
  `updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `screen_name` tinytext DEFAULT NULL,
  `display_name` tinytext DEFAULT NULL,
  `avatar_url` tinytext CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL,
  `profile_url` tinytext CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL,
  `description` text DEFAULT NULL,
  `location` tinytext DEFAULT NULL,
  `website` tinytext CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL,
  `email` tinytext CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL,
  `friends_count` int(11) NOT NULL DEFAULT 0,
  `followers_count` int(11) NOT NULL DEFAULT 0,
  `following_count` int(11) NOT NULL DEFAULT 0,
  `posts_count` int(11) NOT NULL DEFAULT 0,
  `verified` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data that may be shared by bsiness and influencer account';

--
-- Dumping data for table `social_media`
--

INSERT INTO `social_media` (`oauth_user_id`, `oauth_provider`, `updated`, `screen_name`, `display_name`, `avatar_url`, `profile_url`, `description`, `location`, `website`, `email`, `friends_count`, `followers_count`, `following_count`, `posts_count`, `verified`) VALUES
('10155420278436734', 2, '2018-09-05 07:15:42', NULL, 'Pepijn Rijnders', 'https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=10155420278436734&height=1440&ext=1538723742&hash=AeRGb1IqYlx2IR4S', 'https://www.facebook.com/app_scoped_user_id/YXNpZADpBWEZAqZAnp1Sm1RSmNSV2VaUmR4d3UzNVBESVZAuVWRFX3BKbkVGb0lsblNvdi15MkNwVEpubTMyMlE5ZAG1XUDdaUkNKSmZAFZAjB3M1RHVDNZAdWZAnOUpFbVFYdFhqNXZAyOXQ0U040TGw1egZDZD/', NULL, NULL, NULL, 'pepijnrijnders@hotmail.com', 295, 0, 0, 0, 0),
('10155696703021547', 2, '2018-12-01 07:54:59', NULL, 'Jan Boon', 'https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=10155696703021547&height=1440&ext=1546242898&hash=AeTmrwfWWBpwi98c', 'https://www.facebook.com/app_scoped_user_id/YXNpZADpBWEg5S0hhXzlQRjZAUMENhZA3lLdHJibHNEME92eWN2dkFEYzFOVXRGa3lSa2RVYzR1aGs0TXA1V3JpNi1FQl9QZAERKY1NlcjVuRVJqcnYzdG9TR2lxVmhjWkxCNGlkZAUVJVHB6U1ZAqMgZDZD/', NULL, NULL, NULL, 'kaetemi@gmail.com', 221, 0, 0, 0, 0),
('1037518766064586754', 1, '2018-09-06 01:56:39', 'justche92665522', 'justchecking', NULL, 'https://twitter.com/justche92665522', 'take a look', 'San Diego, CA', NULL, NULL, 0, 0, 0, 0, 0),
('173902647', 1, '2018-11-01 22:11:48', 'deanmartinuk', 'Dean Martin', 'http://pbs.twimg.com/profile_images/897803563036016640/_NkruCLD.jpg', 'https://twitter.com/deanmartinuk', 'Web and App Designer and builder of things! #basketball #design', 'Earth', 'http://www.pocketpixels.co.uk', 'deelow@me.com', 0, 1116, 423, 829, 0),
('29934316', 1, '2018-10-27 20:27:22', 'plattwit', 'David Platt', 'http://pbs.twimg.com/profile_images/131457645/david2.jpg', 'https://twitter.com/plattwit', NULL, 'Los Angeles', NULL, 'david@davidlplatt.com', 0, 181, 25, 32, 0),
('37972401', 1, '2018-12-15 09:20:09', 'kaetemi', 'Jan Boon', 'http://pbs.twimg.com/profile_images/804102860229275649/_GqXxuGP.jpg', 'https://twitter.com/kaetemi', 'Freelance. Games and software developer.', 'Pasay, Philippines', 'http://www.kaetemi.be/', 'jan.boon@kaetemi.be', 0, 371, 721, 1525, 0),
('703122697232863233', 1, '2018-10-30 08:14:15', 'ThomasBurkhartB', 'Thomas Burkhart', 'http://pbs.twimg.com/profile_images/703124108402266112/871VjZx0.jpg', 'https://twitter.com/ThomasBurkhartB', 'Xamarin and Flutter devloper, totally amazed by https://t.co/s9vPO20GtV', NULL, 'https://www.burkharts.net/apps/blog', 'thomas@burkharts.net', 0, 957, 251, 10745, 0),
('921014179145945089', 1, '2018-11-01 22:32:17', 'No28Games', 'No. 28 Games', 'http://pbs.twimg.com/profile_images/921015068111843329/LcfSG9r_.jpg', 'https://twitter.com/No28Games', 'We know our product, because we made it.', 'Antwerp, Belgium', 'http://no28.games/', 'info@no28.games', 0, 24, 340, 18, 0),
('953908032160714754', 1, '2018-10-12 12:10:55', 'kennykenken37', 'Kenneth Amiel Santos', 'http://pbs.twimg.com/profile_images/953909620682104833/zbwp_OQQ.jpg', 'https://twitter.com/kennykenken37', NULL, 'Makati City', NULL, 'kennethamiel.santos@gmail.com', 0, 0, 4, 2, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`account_id`);

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`location_id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `s2cell_id` (`s2cell_id`);

--
-- Indexes for table `oauth_connections`
--
ALTER TABLE `oauth_connections`
  ADD PRIMARY KEY (`oauth_user_id`,`oauth_provider`,`account_type`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `session_id` (`session_id`);

--
-- Indexes for table `offers`
--
ALTER TABLE `offers`
  ADD PRIMARY KEY (`offer_id`),
  ADD KEY `account_id` (`sender_account_id`);

--
-- Indexes for table `proposals`
--
ALTER TABLE `proposals`
  ADD PRIMARY KEY (`proposal_id`),
  ADD UNIQUE KEY `offer_id` (`offer_id`,`influencer_account_id`);

--
-- Indexes for table `proposal_chats`
--
ALTER TABLE `proposal_chats`
  ADD PRIMARY KEY (`chat_id`),
  ADD UNIQUE KEY `session_id` (`sender_session_id`,`sender_session_ghost_id`),
  ADD UNIQUE KEY `proposal_id_chat_id` (`proposal_id`,`chat_id`) USING BTREE,
  ADD KEY `proposal_id` (`proposal_id`);

--
-- Indexes for table `self_test`
--
ALTER TABLE `self_test`
  ADD PRIMARY KEY (`self_test_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`session_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Indexes for table `social_media`
--
ALTER TABLE `social_media`
  ADD PRIMARY KEY (`oauth_user_id`,`oauth_provider`);
ALTER TABLE `social_media` ADD FULLTEXT KEY `fulltext` (`screen_name`,`display_name`,`description`,`location`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `account_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1020304050;

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `location_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1020304050;

--
-- AUTO_INCREMENT for table `offers`
--
ALTER TABLE `offers`
  MODIFY `offer_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1020304050;

--
-- AUTO_INCREMENT for table `proposals`
--
ALTER TABLE `proposals`
  MODIFY `proposal_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1020304050;

--
-- AUTO_INCREMENT for table `proposal_chats`
--
ALTER TABLE `proposal_chats`
  MODIFY `chat_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1020304050;

--
-- AUTO_INCREMENT for table `self_test`
--
ALTER TABLE `self_test`
  MODIFY `self_test_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1020304050;

--
-- AUTO_INCREMENT for table `sessions`
--
ALTER TABLE `sessions`
  MODIFY `session_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1020304050;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
