-- phpMyAdmin SQL Dump
-- version 4.6.6deb5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Aug 30, 2018 at 11:53 AM
-- Server version: 10.3.8-MariaDB-1:10.3.8+maria~bionic
-- PHP Version: 7.2.7-0ubuntu0.18.04.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
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
  `account_id` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `name` tinytext NOT NULL,
  `account_type` tinyint(4) NOT NULL,
  `global_account_state` tinyint(4) NOT NULL COMMENT 'Higher value means more access',
  `global_account_state_reason` tinyint(4) NOT NULL COMMENT 'These are for user message only',
  `description` tinytext NOT NULL DEFAULT '',
  `location_id` int(11) NOT NULL DEFAULT 0 COMMENT 'Refers to the main location of this entity',
  `avatar_key` tinytext CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL,
  `url` tinytext DEFAULT NULL,
  `email` tinytext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `accounts`
--

-- --------------------------------------------------------

--
-- Table structure for table `addressbook`
--

CREATE TABLE `addressbook` (
  `location_id` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `account_id` int(11) NOT NULL,
  `name` varchar(70) NOT NULL,
  `detail` text NOT NULL,
  `approximate` text NOT NULL,
  `postcode` varchar(12) CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL,
  `region_code` varchar(12) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL DEFAULT 'US-CA',
  `country_code` varchar(2) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL DEFAULT 'us' COMMENT 'https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2',
  `point` point NOT NULL,
  `s2cell_id` bigint(20) NOT NULL DEFAULT -1,
  `offer_count` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Cached offer count. Used to quickly find offers'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `addressbook`
--

-- --------------------------------------------------------

--
-- Table structure for table `applicants`
--

CREATE TABLE `applicants` (
  `applicant_id` int(11) NOT NULL,
  `offer_id` int(11) NOT NULL,
  `influencer_account_id` int(11) NOT NULL COMMENT 'Account of applicant',
  `business_account_id` int(11) NOT NULL,
  `haggle_chat_id` bigint(20) NOT NULL DEFAULT 0,
  `influencer_wants_deal` tinyint(1) NOT NULL DEFAULT 0,
  `business_wants_deal` tinyint(1) NOT NULL DEFAULT 0,
  `influencer_marked_delivered` tinyint(1) NOT NULL DEFAULT 0,
  `influencer_marked_rewarded` tinyint(1) NOT NULL DEFAULT 0,
  `business_marked_delivered` tinyint(1) NOT NULL DEFAULT 0,
  `business_marked_rewarded` tinyint(1) NOT NULL DEFAULT 0,
  `influencer_gave_rating` tinyint(4) NOT NULL DEFAULT 0,
  `business_gave_rating` tinyint(4) NOT NULL DEFAULT 0,
  `influencer_disputed` tinyint(1) NOT NULL DEFAULT 0,
  `business_disputed` tinyint(1) NOT NULL DEFAULT 0,
  `state` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `applicant_haggling`
--

CREATE TABLE `applicant_haggling` (
  `chat_id` bigint(19) NOT NULL,
  `sent` timestamp NOT NULL DEFAULT current_timestamp(),
  `sender_id` int(11) NOT NULL COMMENT 'Account id of the sender',
  `applicant_id` int(11) NOT NULL,
  `device_id` int(11) NOT NULL,
  `device_ghost_id` int(11) NOT NULL COMMENT 'Device and ghost id only sent to account device',
  `type` tinyint(4) NOT NULL,
  `text` text NOT NULL,
  `seen` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `devices`
--

CREATE TABLE `devices` (
  `device_id` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `aes_key` text CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `common_device_id` text CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `name` text NOT NULL,
  `account_type` int(11) NOT NULL DEFAULT 0,
  `account_id` int(11) NOT NULL DEFAULT 0,
  `firebase_instance_id` text CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL COMMENT 'TBD',
  `info` text NOT NULL COMMENT 'Arbitrary information from device, not important'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `devices`
--

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
  `account_id` int(11) NOT NULL DEFAULT 0 COMMENT 'If 0, then match by device_id',
  `device_id` int(11) NOT NULL,
  `oauth_token` text CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `oauth_token_secret` text CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `oauth_token_expires` int(11) NOT NULL DEFAULT 0,
  `expired` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `oauth_connections`
--

-- --------------------------------------------------------

--
-- Table structure for table `offers`
--

CREATE TABLE `offers` (
  `offer_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `title` tinytext NOT NULL,
  `description` text NOT NULL,
  `deliverables` text NOT NULL,
  `reward` text NOT NULL,
  `location_id` int(11) NOT NULL,
  `state` tinyint(4) NOT NULL DEFAULT 0,
  `state_reason` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `offers`
--

-- --------------------------------------------------------

--
-- Table structure for table `offer_images`
--

CREATE TABLE `offer_images` (
  `offer_id` int(11) NOT NULL,
  `image_key` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `offer_images`
--

-- --------------------------------------------------------

--
-- Table structure for table `self_test`
--

CREATE TABLE `self_test` (
  `self_test_id` int(11) NOT NULL,
  `message` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `self_test`
--

INSERT INTO `self_test` (`self_test_id`, `message`) VALUES
(1, 'Zipper Sorting 😏');

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
  `url` tinytext CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL,
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

INSERT INTO `social_media` (`oauth_user_id`, `oauth_provider`, `updated`, `screen_name`, `display_name`, `avatar_url`, `profile_url`, `description`, `location`, `url`, `email`, `friends_count`, `followers_count`, `following_count`, `posts_count`, `verified`) VALUES
('10155420278436734', 2, '2018-08-27 01:03:38', NULL, 'Pepijn Rijnders', 'https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=10155420278436734&height=1440&ext=1536581667&hash=AeQJnZoGuMbCjRpf', 'https://www.facebook.com/app_scoped_user_id/YXNpZADpBWEdFR1d0YWVQSDFzTU1wUDlHTmdydHIxbVpfRWxRR0laQ2U1X045bDlMM21WemFFTlNzV2ZAPMGNaTXRjVHBkLUljQ3lDdXhnT0pRcmhOWmRaaGxXZA3R5dlhlWUJrdHdfSzRMS2tWawZDZD/', NULL, NULL, NULL, 'pepijnrijnders@hotmail.com', 299, 0, 0, 0, 0),
('10155696703021547', 2, '2018-08-27 01:03:38', NULL, 'Jan Boon', 'https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=10155696703021547&height=1440&ext=1536567017&hash=AeRKK-ZNA86C-lYj', 'https://www.facebook.com/app_scoped_user_id/YXNpZADpBWEZAoVjdma2tlT2kyeUplNFFYdmpUSk1rQzFybVYtYjYyVkk1R284X1JpbkZAmc3oyWnNCN0NBenlBT3c5eC0yR0RiQ2Q2RDR1YUhoSUlCZAVVPZAHlnQl82allyZAE1iX2FSR3FpVjdvegZDZD/', NULL, NULL, NULL, 'kaetemi@gmail.com', 220, 0, 0, 0, 0),
('29934316', 1, '2018-08-28 00:31:47', 'plattwit', 'David Platt', 'http://pbs.twimg.com/profile_images/131457645/david2.jpg', 'https://twitter.com/plattwit', NULL, 'Los Angeles', NULL, 'david@davidlplatt.com', 0, 177, 24, 33, 0),
('37972401', 1, '2018-08-29 10:41:25', 'kaetemi', 'Jan Boon', 'http://pbs.twimg.com/profile_images/804102860229275649/_GqXxuGP.jpg', 'https://twitter.com/kaetemi', 'Freelance. Games and software developer.', 'Pasay, Philippines', 'http://www.kaetemi.be/', 'jan.boon@kaetemi.be', 0, 381, 709, 1517, 0),
('921014179145945089', 1, '2018-08-28 05:55:48', 'No28Games', 'No. 28 Games', 'http://pbs.twimg.com/profile_images/921015068111843329/LcfSG9r_.jpg', 'https://twitter.com/No28Games', 'We know our product, because we made it.', 'Antwerp, Belgium', 'http://no28.games/', 'info@no28.games', 0, 24, 342, 18, 0),
('953908032160714754', 1, '2018-08-27 01:03:38', 'kennykenken37', 'Kenneth Amiel Santos', 'http://pbs.twimg.com/profile_images/953909620682104833/zbwp_OQQ.jpg', 'https://twitter.com/kennykenken37', NULL, 'Makati City', NULL, 'kennethamiel.santos@gmail.com', 0, 0, 4, 2, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`account_id`);

--
-- Indexes for table `addressbook`
--
ALTER TABLE `addressbook`
  ADD PRIMARY KEY (`location_id`),
  ADD SPATIAL KEY `point` (`point`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `s2cell_id` (`s2cell_id`);

--
-- Indexes for table `applicants`
--
ALTER TABLE `applicants`
  ADD PRIMARY KEY (`applicant_id`),
  ADD UNIQUE KEY `offer_id` (`offer_id`,`influencer_account_id`);

--
-- Indexes for table `applicant_haggling`
--
ALTER TABLE `applicant_haggling`
  ADD PRIMARY KEY (`chat_id`),
  ADD UNIQUE KEY `device_id` (`device_id`,`device_ghost_id`),
  ADD KEY `applicant_id` (`applicant_id`);

--
-- Indexes for table `devices`
--
ALTER TABLE `devices`
  ADD PRIMARY KEY (`device_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Indexes for table `oauth_connections`
--
ALTER TABLE `oauth_connections`
  ADD PRIMARY KEY (`oauth_user_id`,`oauth_provider`,`account_type`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `device_id` (`device_id`);

--
-- Indexes for table `offers`
--
ALTER TABLE `offers`
  ADD PRIMARY KEY (`offer_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Indexes for table `offer_images`
--
ALTER TABLE `offer_images`
  ADD PRIMARY KEY (`offer_id`,`image_key`) USING BTREE,
  ADD KEY `offer_id` (`offer_id`);

--
-- Indexes for table `self_test`
--
ALTER TABLE `self_test`
  ADD PRIMARY KEY (`self_test_id`);

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
  MODIFY `account_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT for table `addressbook`
--
ALTER TABLE `addressbook`
  MODIFY `location_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;
--
-- AUTO_INCREMENT for table `applicants`
--
ALTER TABLE `applicants`
  MODIFY `applicant_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `applicant_haggling`
--
ALTER TABLE `applicant_haggling`
  MODIFY `chat_id` bigint(19) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `devices`
--
ALTER TABLE `devices`
  MODIFY `device_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;
--
-- AUTO_INCREMENT for table `offers`
--
ALTER TABLE `offers`
  MODIFY `offer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `self_test`
--
ALTER TABLE `self_test`
  MODIFY `self_test_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
