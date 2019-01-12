/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'package:fixnum/fixnum.dart';
import 'package:inf_common/inf_common.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;

// TODO: This should all just come from a single call to Elasticsearch perhaps

Future<DataSocialMedia> fetchCachedSocialMedia(
    sqljocky.ConnectionPool accountDb,
    String oauthUserId,
    int oauthProvider) async {
  final sqljocky.Results selectResults = await accountDb.prepareExecute(
      'SELECT `screen_name`, `display_name`, `avatar_url`, `profile_url`, ' // 0123
      '`description`, `location`, `website`, `email`, `friends_count`, `followers_count`, ' // 456789
      '`following_count`, `posts_count`, `verified` ' // 10 11 12
      'FROM `social_media` '
      'WHERE `oauth_user_id` = ? AND `oauth_provider` = ?',
      <dynamic>[oauthUserId, oauthProvider]);
  final DataSocialMedia dataSocialMedia = DataSocialMedia();
  dataSocialMedia.providerId = oauthProvider;
  await for (sqljocky.Row row in selectResults) {
    // one row
    if (row[0] != null) {
      dataSocialMedia.screenName = row[0].toString();
    }
    if (row[1] != null) {
      dataSocialMedia.displayName = row[1].toString();
    }
    if (row[2] != null) {
      dataSocialMedia.avatarUrl = row[2].toString();
    }
    if (row[3] != null) {
      dataSocialMedia.profileUrl = row[3].toString();
    }
    if (row[4] != null) {
      dataSocialMedia.description = row[4].toString();
    }
    if (row[5] != null) {
      dataSocialMedia.location = row[5].toString();
    }
    if (row[6] != null) {
      dataSocialMedia.url = row[6].toString();
    }
    if (row[7] != null) {
      dataSocialMedia.email = row[7].toString();
    }
    dataSocialMedia.friendsCount = row[8].toInt();
    dataSocialMedia.followersCount = row[9].toInt();
    dataSocialMedia.followingCount = row[10].toInt();
    dataSocialMedia.postsCount = row[11].toInt();
    dataSocialMedia.verified = row[12].toInt() != 0;
    dataSocialMedia.connected = true;
    // devLog.finest("fetchCachedSocialMedia: $dataSocialMedia");
  }
  return dataSocialMedia;
}

Future<DataLocation> fetchLocationFromSql(sqljocky.ConnectionPool accountDb,
    Int64 locationId, Int64 accountId) async {
  final sqljocky.Results selectResults = await accountDb.prepareExecute(
      'SELECT `name`, `approximate`, `detail`, ' // 0 1 2
      '`postcode`, `region_code`, `country_code`, ' // 3 4 5
      '`latitude`, `longitude`, `s2cell_id`, geohash ' // 6 7 8 9
      'FROM `locations` '
      'WHERE `location_id` = ? AND `account_id` = ?',
      <dynamic>[locationId, accountId]);
  DataLocation location;
  await for (sqljocky.Row row in selectResults) {
    // one row
    location = DataLocation();
    location.locationId = locationId;
    location.name = row[0].toString();
    location.approximate = row[1].toString();
    location.detail = row[2].toString();
    if (row[3] != null) {
      location.postcode = row[3].toString();
    }
    location.regionCode = row[4].toString();
    location.countryCode = row[5].toString();
    location.latitude = row[6].toDouble();
    location.longitude = row[7].toDouble();
    location.s2cellId = Int64(row[8]);
    // TODO: location.geohashInt
    location.geohash = row[9].toString();
    location.freeze();
  }
  return location;
}

Future<DataLocation> fetchLocationSummaryFromSql(
    sqljocky.ConnectionPool accountDb,
    Int64 locationId,
    Int64 accountId,
    bool detail) async {
  sqljocky.Results selectResults = await accountDb.prepareExecute(
      'SELECT ' +
          (detail ? '`detail`' : '`approximate`') +
          ', ' // 0 1
          '`latitude`, `longitude` ' // 2 3
          'FROM `locations` '
          'WHERE `location_id` = ? AND `account_id` = ?',
      <dynamic>[locationId, accountId]);
  DataLocation location;
  await for (sqljocky.Row row in selectResults) {
    // one row
    location = DataLocation();
    location.locationId = locationId;
    location.approximate = row[0].toString();
    location.detail = location.approximate;
    location.latitude = row[1].toDouble();
    location.longitude = row[2].toDouble();
    location.freeze();
  }
  return location;
}

String _makeImageUrl(String template, String key) {
  final int lastIndex = key.lastIndexOf('.');
  final String keyNoExt = lastIndex > 0 ? key.substring(0, lastIndex) : key;
  return template.replaceAll('{key}', key).replaceAll('{keyNoExt}', keyNoExt);
}

Future<DataAccount> fetchSessionAccount(ConfigData config,
    sqljocky.ConnectionPool accountDb, Int64 sessionId) async {
  // First get the account id (and account type, in case the account id has not been created yet)
  final sqljocky.RetainedConnection connection =
      await accountDb.getConnection();
  final DataAccount account = DataAccount();
  account.sessionId = sessionId;
  account.socialMedia[0] = DataSocialMedia();
  try {
    final sqljocky.Results sessionResults = await connection.prepareExecute(
        'SELECT `account_id`, `account_type`, `firebase_token` FROM `sessions` WHERE `session_id` = ?',
        <dynamic>[sessionId]);
    await for (sqljocky.Row row in sessionResults) {
      account.accountId = Int64(row[0]);
      account.accountType = AccountType.valueOf(row[1].toInt());
      if (row[2] != null) {
        account.firebaseToken = row[2].toString();
      }
    }

    // Fetch account-specific info (overwrites session accountType, although it cannot possibly be different)
    if (account.accountId != Int64.ZERO) {
      final sqljocky.Results accountResults = await connection.prepareExecute(
          'SELECT `name`, `account_type`, `global_account_state`, `global_account_state_reason`, '
          '`description`, `location_id`, `avatar_key`, `website`, `email` FROM `accounts` '
          'WHERE `account_id` = ?',
          <dynamic>[account.accountId]);
      // int locationId;
      await for (sqljocky.Row row in accountResults) {
        // one
        account.name = row[0].toString();
        account.accountType = AccountType.valueOf(row[1].toInt());
        account.globalAccountState = GlobalAccountState.valueOf(row[2].toInt());
        account.globalAccountStateReason =
            GlobalAccountStateReason.valueOf(row[3].toInt());
        account.description = row[4].toString();
        account.locationId = Int64(row[5]);
        if (row[6] != null) {
          account.avatarUrl = _makeImageUrl(
              config.services.galleryThumbnailUrl, row[6].toString());
          account.blurredAvatarUrl = _makeImageUrl(
              config.services.galleryThumbnailBlurredUrl, row[6].toString());
          account.coverUrls.clear();
          account.coverUrls.add(_makeImageUrl(
              config.services.galleryCoverUrl, row[6].toString()));
          account.blurredCoverUrls.clear();
          account.blurredCoverUrls.add(_makeImageUrl(
              config.services.galleryCoverBlurredUrl, row[6].toString()));
        }
        if (row[7] != null) {
          account.website = row[7].toString();
        }
        if (row[8] != null) {
          account.email = row[8].toString();
        }
      }
      if (account.locationId != Int64.ZERO) {
        final DataLocation location = await fetchLocationSummaryFromSql(
            accountDb,
            account.locationId,
            account.accountId,
            account.accountType == AccountType.business);
        if (location == null) {
          // devLog.severe("Account ${account.accountId} has an unknown location_id set");
          account.location = 'Earth';
        }
      } else {
        // devLog.severe("Account ${account.accountId} does not have a location_id set");
        account.location = 'Earth';
      }
    }
    // Find all connected social media accounts
    final sqljocky.Results connectionResults = await connection.prepareExecute(
        // The additional `account_id` = 0 here is required in order not to load halfway failed connected sessions
        "SELECT `oauth_user_id`, `oauth_provider`, `oauth_token_expires`, `expired` FROM `oauth_connections` WHERE ${account.accountId == 0 ? '`account_id` = 0 AND `session_id`' : '`account_id`'} = ?",
        <dynamic>[
          account.accountId == 0 ? account.sessionId : account.accountId
        ]);
    final List<sqljocky.Row> connectionRows = await connectionResults
        .toList(); // Load to avoid blocking connections recursively
    for (sqljocky.Row row in connectionRows) {
      final String oauthUserId = row[0].toString();
      final int oauthProvider = row[1].toInt();
      final int oauthTokenExpires = row[2].toInt();
      final bool expired = row[3].toInt() != 0 ||
          oauthTokenExpires >=
              (DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      if (oauthProvider < config.oauthProviders.length) {
        account.socialMedia[oauthProvider] =
            await fetchCachedSocialMedia(accountDb, oauthUserId, oauthProvider);
        account.socialMedia[oauthProvider].expired = expired;
      } else {
        // devLog.severe("Invalid attempt to update session state with no session id, skip, this indicates an incorrent database entry caused by a bug");
      }
    }
  } finally {
    await connection.release();
  }

  return account;
}

/* end of file */
