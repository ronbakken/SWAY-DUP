-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: inf-mariadb
-- Generation Time: Dec 04, 2018 at 07:10 AM
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

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`account_id`, `created`, `name`, `account_type`, `global_account_state`, `global_account_state_reason`, `description`, `location_id`, `avatar_key`, `website`, `email`) VALUES
(1, '2018-12-04 05:22:54', 'Jan Boon', 1, 3, 4, 'Freelance. Games and software developer.', 3, NULL, 'http://www.kaetemi.be/', 'jan.boon@kaetemi.be'),
(2, '2018-12-04 05:45:03', 'Jan Boon', 2, 3, 4, 'Freelance. Games and software developer.', 6, NULL, 'http://www.kaetemi.be/', 'jan.boon@kaetemi.be');

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

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`location_id`, `created`, `account_id`, `name`, `approximate`, `detail`, `postcode`, `region_code`, `country_code`, `latitude`, `longitude`, `s2cell_id`, `geohash`, `offer_count`) VALUES
(1, '2018-12-04 05:22:56', 1, 'Jan Boon', 'United States', 'United States', '', 'us', 'us', 37.751, -97.822, -8672572760871991391, '9ydqy025w0qndhcykc1w', 0),
(2, '2018-12-04 05:22:57', 1, 'Jan Boon', 'Pasay, Philippines', 'Pasay, Philippines', '', 'ph', 'ph', 14.568486, 121.093822, 3717659659926800337, 'wdw4gs1gdddhh1ysn4j5', 0),
(3, '2018-12-04 05:22:57', 1, 'Jan Boon', 'Batong Malake, 4030, Los Baños, Laguna, Philippines', 'Belmore, Los Baños, Laguna 4030, Philippines', '4030', 'PH-LAG', 'ph', 14.168191, 121.2415524, 3728242408594089309, 'wdw0wgjrsyjzkggmvduh', 0),
(4, '2018-12-04 05:45:05', 2, 'Jan Boon', 'United States', 'United States', '', 'us', 'us', 37.751, -97.822, -8672572760871991391, '9ydqy025w0qndhcykc1w', 0),
(5, '2018-12-04 05:45:05', 2, 'Jan Boon', 'Pasay, Philippines', 'Pasay, Philippines', '', 'ph', 'ph', 14.568486, 121.093822, 3717659659926800337, 'wdw4gs1gdddhh1ysn4j5', 0),
(6, '2018-12-04 05:45:05', 2, 'Jan Boon', 'Batong Malake, 4030, Los Baños, Laguna, Philippines', 'Belmore, Los Baños, Laguna 4030, Philippines', '4030', 'PH-LAG', 'ph', 14.1681906, 121.2415539, 3728242408594090141, 'wdw0wgjrsyphbxsf2p2k', 4);

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

--
-- Dumping data for table `oauth_connections`
--

INSERT INTO `oauth_connections` (`oauth_user_id`, `oauth_provider`, `account_type`, `created`, `updated`, `account_id`, `session_id`, `oauth_token`, `oauth_token_secret`, `oauth_token_expires`, `expired`) VALUES
('37972401', 1, 1, '2018-12-04 05:17:45', '2018-12-04 05:17:45', 1, 2, '37972401-cRRkeMMq8nSlVQlde0VrhX4oY7sdcWGzIGkDkZk1R', 'Wf9w3RVpwcQH50leIMxJ1yFAOMZwhCSD1XEUsDScvaTrk', 0, 0),
('37972401', 1, 2, '2018-12-04 05:44:51', '2018-12-04 05:44:51', 2, 3, '37972401-cRRkeMMq8nSlVQlde0VrhX4oY7sdcWGzIGkDkZk1R', 'Wf9w3RVpwcQH50leIMxJ1yFAOMZwhCSD1XEUsDScvaTrk', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `offers`
--

CREATE TABLE `offers` (
  `offer_id` bigint(20) NOT NULL,
  `sender_id` bigint(20) NOT NULL,
  `sender_type` tinyint(4) NOT NULL,
  `session_id` bigint(20) NOT NULL,
  `location_id` bigint(20) NOT NULL,
  `direct` tinyint(1) NOT NULL DEFAULT 0,
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

--
-- Dumping data for table `offers`
--

INSERT INTO `offers` (`offer_id`, `sender_id`, `sender_type`, `session_id`, `location_id`, `direct`, `state`, `state_reason`, `archived`, `proposals_proposing`, `proposals_negotiating`, `proposals_deal`, `proposals_rejected`, `proposals_dispute`, `proposals_resolved`, `proposals_complete`) VALUES
(1, 2, 2, 3, 6, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 2, 2, 3, 6, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 2, 2, 3, 6, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 2, 2, 3, 6, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `proposals`
--

CREATE TABLE `proposals` (
  `proposal_id` bigint(20) NOT NULL,
  `offer_id` bigint(20) NOT NULL,
  `influencer_account_id` bigint(20) NOT NULL COMMENT 'Account of proposal',
  `business_account_id` bigint(20) NOT NULL,
  `sender_account_id` bigint(20) NOT NULL COMMENT 'Default value temporary until version upgrade',
  `influencer_seen_chat_id` bigint(20) NOT NULL DEFAULT 0,
  `influencer_seen_time` timestamp NULL DEFAULT NULL,
  `business_seen_chat_id` bigint(20) NOT NULL DEFAULT 0,
  `business_seen_time` timestamp NULL DEFAULT NULL,
  `terms_chat_id` bigint(20) NOT NULL DEFAULT 0,
  `rejecting_account_id` bigint(20) NOT NULL DEFAULT 0,
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
-- Table structure for table `proposal_chats`
--

CREATE TABLE `proposal_chats` (
  `chat_id` bigint(20) NOT NULL,
  `sent` timestamp NOT NULL DEFAULT current_timestamp(),
  `sender_id` bigint(20) NOT NULL COMMENT 'Account id of the sender',
  `proposal_id` bigint(20) NOT NULL,
  `session_id` bigint(20) NOT NULL,
  `session_ghost_id` bigint(20) NOT NULL COMMENT 'Session id and ghost id only sent to account session',
  `type` tinyint(4) NOT NULL,
  `plain_text` text DEFAULT NULL,
  `terms` blob DEFAULT NULL,
  `image_key` text DEFAULT NULL,
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
(1, 'Zipper Sorting ??');

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

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`session_id`, `created`, `cookie_hash`, `device_hash`, `name`, `account_type`, `account_id`, `firebase_token`, `info`) VALUES
(1, '2018-12-04 03:38:16', 0x0aa4da06c3753790b12dd4345dcf5598038d1de5c8c83c8002ed52da7de8b0a4, 0xfab9fd0ba2119e5f518994f77d4364a29a84445459a61428cd26018fb04763f9, 'T07', 0, 0, NULL, '{ debug: \'default_info\' }'),
(2, '2018-12-04 03:40:35', 0x1bfb3133c2cd1cf7ea62797150ff861ba7f0187bae2e924fb00bd17cd80c680b, 0xfab9fd0ba2119e5f518994f77d4364a29a84445459a61428cd26018fb04763f9, 'T07', 1, 1, 'fuXlNzFKYJY:APA91bHQjZXRzmiz1-7GZaxFsOsk0jEsKJb4DpF6q6D9GBkSrezhZAYAq1TZPTxzWWEiC0hsKC43h2FOVLr6nn4URH1NH8ZNjyg8MlS0g6svJ7BiXTNxbmiPrhDtL1TEfHlYOreIlLn1', '{ debug: \'default_info\' }'),
(3, '2018-12-04 05:43:32', 0x2de29ea37b7972a02f7349733f9d4f272d764abb37697a0694d0a82491b72623, 0xfab9fd0ba2119e5f518994f77d4364a29a84445459a61428cd26018fb04763f9, 'T07', 2, 2, 'fuXlNzFKYJY:APA91bHQjZXRzmiz1-7GZaxFsOsk0jEsKJb4DpF6q6D9GBkSrezhZAYAq1TZPTxzWWEiC0hsKC43h2FOVLr6nn4URH1NH8ZNjyg8MlS0g6svJ7BiXTNxbmiPrhDtL1TEfHlYOreIlLn1', '{ debug: \'default_info\' }');

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
('37972401', 1, '2018-12-04 05:44:53', 'kaetemi', 'Jan Boon', 'http://pbs.twimg.com/profile_images/804102860229275649/_GqXxuGP.jpg', 'https://twitter.com/kaetemi', 'Freelance. Games and software developer.', 'Pasay, Philippines', 'http://www.kaetemi.be/', 'jan.boon@kaetemi.be', 0, 372, 718, 1523, 0),
('703122697232863233', 1, '2018-10-30 08:14:15', 'ThomasBurkhartB', 'Thomas Burkhart', 'http://pbs.twimg.com/profile_images/703124108402266112/871VjZx0.jpg', 'https://twitter.com/ThomasBurkhartB', 'Xamarin and Flutter devloper, totally amazed by https://t.co/s9vPO20GtV', NULL, 'https://www.burkharts.net/apps/blog', 'thomas@burkharts.net', 0, 957, 251, 10745, 0),
('921014179145945089', 1, '2018-11-01 22:32:17', 'No28Games', 'No. 28 Games', 'http://pbs.twimg.com/profile_images/921015068111843329/LcfSG9r_.jpg', 'https://twitter.com/No28Games', 'We know our product, because we made it.', 'Antwerp, Belgium', 'http://no28.games/', 'info@no28.games', 0, 24, 340, 18, 0),
('953908032160714754', 1, '2018-10-12 12:10:55', 'kennykenken37', 'Kenneth Amiel Santos', 'http://pbs.twimg.com/profile_images/953909620682104833/zbwp_OQQ.jpg', 'https://twitter.com/kennykenken37', NULL, 'Makati City', NULL, 'kennethamiel.santos@gmail.com', 0, 0, 4, 2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `_old_offers`
--

CREATE TABLE `_old_offers` (
  `offer_id` bigint(20) NOT NULL,
  `account_id` bigint(20) NOT NULL,
  `title` tinytext NOT NULL,
  `description` text NOT NULL,
  `deliverables` text NOT NULL,
  `reward` text NOT NULL,
  `location_id` bigint(20) NOT NULL,
  `state` tinyint(4) NOT NULL DEFAULT 0,
  `state_reason` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `_old_offers`
--

INSERT INTO `_old_offers` (`offer_id`, `account_id`, `title`, `description`, `deliverables`, `reward`, `location_id`, `state`, `state_reason`) VALUES
(1, 23, 'Get Rich Quick', 'Oh yeah, baby, get rich quick. Buy our things.', 'Money.', 'More money.', 47, 3, 2),
(2, 23, 'Another Good Offer', 'Oh yeah baby, this is it. Get your stuff.', 'Booty.', 'Pirate hat.', 47, 3, 2),
(3, 23, 'Peanut Butter', 'Get your free peanut butter. ', 'Post', 'Butter', 47, 3, 3),
(4, 23, 'post a pic on your social media with my great product ', 'I sell  cheese.   I will send you a box of bunch of vegan cheese that tastes delicious has a retail value of  $100.  You just need to make a story on your social media mentionting and hopefully genuinely praising the cheese when you try it. ', 'post story across all relevant social media.\ntag our company Instagram or twitter account in post', 'we will send you a huge assortment of our best vegan cheese.  when you finish it if you liked it we will send you another.', 47, 1, 0),
(5, 23, 'try our beer', 'we make beer it\'s award-winning it\'s delicious we put fruit in there and we want you to try it we will send you a case of our beer and $100 if you mention us on your social media in a hopefully positive or at least neutral way when you try it', 'post about the beer on social media\nmention our social media handles in your posts.', 'free case of beer$100 another case of beer if you loved it and want some more', 47, 1, 0),
(6, 23, 'Try our clothes', 'Stop by our retail location and pick out any one item up to $200 for free if you post about it on social media.', 'post about our store in your social media\ntag us in your post', 'one item up to 200', 47, 1, 0),
(7, 23, 'Windows', 'This is a window bla bla', 'More windows ', 'Windows ', 47, 3, 1),
(8, 23, 'fitness gear', 'need a pro to promote our new fitness gear', 'should be a short video of about 3 minutes showing our logo.', 'free gear', 47, 1, 0),
(9, 23, 'Green', 'Everything is green today. What will you do?', 'Apples', 'Bananas', 47, 1, 0),
(10, 23, 'Quality brand goods', 'Show off our totally legitimate high quality brand goods on your channel ', 'Advertise our shop on your channel ', 'Free quality brand goods', 47, 1, 0),
(11, 23, 'check my meter', 'it is a meter that needs to be checked. I took a picture of it.. can anyone check it for me', 'a video on how to check a meter. at least 5 hours long', 'a banana', 47, 1, 0),
(12, 23, 'coffee', 'one free coffee. decaf only ', 'photo with yourself enjoying our coffee', 'fifty dollars', 47, 1, 0),
(13, 23, 'slightly used shoe ', 'you can own a slightly used shoe... just the left NOT THE RIGHT!', 'photo of yoy walking down ghe road waearing my killer kick', 'free', 47, 1, 0),
(14, 23, 'spoon ice tea', 'free Ice tea if you post about blah blah', 'post on Instagram', 'iced tea', 47, 1, 0),
(15, 23, 'Car Wash', 'Our car wash is the best car wash in the universe of car washes', 'Video of your car clean', '5 pesos plus free car wash ', 47, 1, 0),
(16, 23, 'BBQ', 'Barbecue party at Rick\'s place', 'A video on Facebook', '$1000\nFreee food', 47, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `_old_offer_images`
--

CREATE TABLE `_old_offer_images` (
  `offer_id` bigint(20) NOT NULL,
  `image_key` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `_old_offer_images`
--

INSERT INTO `_old_offer_images` (`offer_id`, `image_key`) VALUES
(1, 'user/11/48516a92a9ef680d985f7d33e5e12d06ddc2ec571e9e4bb0489190f4c193e0f1.jpg'),
(2, 'user/11/48516a92a9ef680d985f7d33e5e12d06ddc2ec571e9e4bb0489190f4c193e0f1.jpg'),
(3, 'user/11/af6e6ca2823ff856a44f1eae1eb195f346fa8a338f7d5c9acdf29ab2b2ad3ab0.jpg'),
(4, 'user/11/af6e6ca2823ff856a44f1eae1eb195f346fa8a338f7d5c9acdf29ab2b2ad3ab0.jpg'),
(5, 'user/12/2c286d0bdf631c57cf26a08b771f657a00b5530711daf7b33ce0b0fa084efe62.png'),
(6, 'user/12/f179d6df4e62f4fd99a334f1f601730aeb8e5b5f404a761509861f2a0eb2bf00.jpg'),
(7, 'user/11/b33de8f15a16dd75db5b2e3b990cad6c42daee683c354ea86435583f393f66e3.jpg'),
(8, 'user/13/42b64be60c29ed823bfc6c79a16a0cbed79cb833a667f2bc6da0a1f39bbaa3d6.jpg'),
(9, 'user/11/99897002a2a089cd05d4e787bbecaa4eaeac3b9d20846dd3bebb418ac084a38c.jpg'),
(10, 'user/11/b908c81495be2e86c796e8fa92e2cc60a01b31beb26a099eb2bacc6e3d1806b3.jpg'),
(11, 'user/13/6b9e60fcb044814eb36b4adc19762cf29ef97bf7653e570960d59e71fa584871.jpg'),
(12, 'user/16/76ec61fc0337a0466c3962294fd21ff80e46b661d135926e36ba210ad1858652.jpg'),
(13, 'user/16/72ffb4c558ae64a9e555c18caaf120818863235b98e2e3890b6cac35f76a00e9.jpg'),
(14, 'user/12/d3709c02ad1c83fb6e69a8502f9ca50d6e0958a91c3d72633babd625a14817b8.jpg'),
(15, 'user/11/8fc4a6adac5b1cf558a06eaf5a6b6b1f5f1157627933cb7fe79e2248c473d6bd.jpg'),
(16, 'user/11/cf939263a34da570060984c3d93a758b71a2772589221ea660cecf489fbc40cd.jpg');

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
  ADD KEY `account_id` (`sender_id`);

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
  ADD UNIQUE KEY `session_id` (`session_id`,`session_ghost_id`),
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
-- Indexes for table `_old_offers`
--
ALTER TABLE `_old_offers`
  ADD PRIMARY KEY (`offer_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Indexes for table `_old_offer_images`
--
ALTER TABLE `_old_offer_images`
  ADD PRIMARY KEY (`offer_id`,`image_key`) USING BTREE,
  ADD KEY `offer_id` (`offer_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `account_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `location_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `offers`
--
ALTER TABLE `offers`
  MODIFY `offer_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `proposals`
--
ALTER TABLE `proposals`
  MODIFY `proposal_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `proposal_chats`
--
ALTER TABLE `proposal_chats`
  MODIFY `chat_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `self_test`
--
ALTER TABLE `self_test`
  MODIFY `self_test_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `sessions`
--
ALTER TABLE `sessions`
  MODIFY `session_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `_old_offers`
--
ALTER TABLE `_old_offers`
  MODIFY `offer_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
