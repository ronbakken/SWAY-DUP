/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';

import 'package:grpc/grpc.dart' as grpc;
import 'package:sqljocky5/sqljocky.dart' as sqljocky;

import 'package:inf_common/inf_common.dart';

class ApiProfilesService extends ApiProfilesServiceBase {
  final ConfigData config;
  final sqljocky.ConnectionPool accountDb;
  static final Logger opsLog = Logger('InfOps.ApiProfilesService');
  static final Logger devLog = Logger('InfDev.ApiProfilesService');

  ApiProfilesService(this.config, this.accountDb);

  String _makeImageUrl(String template, String key) {
    final int lastIndex = key.lastIndexOf('.');
    final String keyNoExt = lastIndex > 0 ? key.substring(0, lastIndex) : key;
    return template.replaceAll('{key}', key).replaceAll('{keyNoExt}', keyNoExt);
  }

  @override
  Future<NetProfile> get(grpc.ServiceCall call, NetGetProfile request) async {
    final DataAuth auth =
        DataAuth.fromJson(call.clientMetadata['x-jwt-payload'] ?? '{}');
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readOnly.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    final DataAccount account = DataAccount();
    account.accountId = request.accountId;

    final sqljocky.RetainedConnection connection =
        await accountDb.getConnection();
    try {
      // Fetch public profile info
      final sqljocky.Results accountResults = await connection.prepareExecute(
          'SELECT `accounts`.`name`, `accounts`.`account_type`, ' // 0 1
          '`accounts`.`description`, `accounts`.`location_id`, ' // 2 3
          '`accounts`.`avatar_key`, `accounts`.`website`, ' // 4 5
          '`locations`.`approximate`, `locations`.`detail`, ' // 6 7
          '`locations`.`latitude`, `locations`.`longitude` ' // 8 9
          'FROM `accounts` '
          'INNER JOIN `locations` ON `locations`.`location_id` = `accounts`.`location_id` '
          'WHERE `accounts`.`account_id` = ? ',
          <dynamic>[request.accountId]);
      await for (sqljocky.Row row in accountResults) {
        account.name = row[0].toString();
        account.accountType = AccountType.valueOf(row[1].toInt());
        account.description = row[2].toString();
        account.locationId = Int64(row[3]);
        if (row[4] != null) {
          account.avatarUrl = _makeImageUrl(
              config.services.galleryThumbnailUrl, row[4].toString());
          account.blurredAvatarUrl = _makeImageUrl(
              config.services.galleryThumbnailBlurredUrl, row[4].toString());
          account.coverUrls.clear();
          account.coverUrls.add(_makeImageUrl(
              config.services.galleryCoverUrl, row[4].toString()));
          account.blurredCoverUrls.clear();
          account.blurredCoverUrls.add(_makeImageUrl(
              config.services.galleryCoverBlurredUrl, row[4].toString()));
        }
        if (row[5] != null) {
          account.website = row[5].toString();
        }
        if (account.accountType != AccountType.support) {
          account.location = account.accountType == AccountType.influencer
              ? row[6].toString()
              : row[7].toString();
          if (account.accountType == AccountType.business) {
            account.latitude = row[8];
            account.longitude = row[9];
            /*
            Uint8List point = row[8];
            if (point != null) {
              // Attempt to parse point, see https://dev.mysql.com/doc/refman/5.7/en/gis-data-formats.html#gis-wkb-format
              ByteData data = new ByteData.view(point.buffer);
              Endian endian = data.getInt8(4) == 0 ? Endian.big : Endian.little;
              int type = data.getUint32(4 + 1, endian = endian);
              if (type == 1) {
                account.latitude = data.getFloat64(4 + 5 + 8, endian = endian);
                account.longitude = data.getFloat64(4 + 5, endian = endian);
              }
            }*/
          }
        }
      }
      // Fetch public social media info
      final sqljocky.Results connectionResults = await connection.prepareExecute(
          'SELECT `social_media`.`oauth_provider`, ' // 0
          '`social_media`.`display_name`, `social_media`.`profile_url`, ' // 1 2
          '`social_media`.`friends_count`, `social_media`.`followers_count`, ' // 3 4
          '`social_media`.`following_count`, `social_media`.`posts_count`, ' // 5 6
          '`social_media`.`verified` ' // 7 8
          'FROM `oauth_connections` '
          'INNER JOIN `social_media` '
          'ON `social_media`.`oauth_user_id` = `oauth_connections`.`oauth_user_id` '
          'AND `social_media`.`oauth_provider` = `oauth_connections`.`oauth_provider` '
          'WHERE `oauth_connections`.`account_id` = ? ',
          <dynamic>[request.accountId]);
      await for (sqljocky.Row row in connectionResults) {
        final int oauthProvider = row[0].toInt();
        account.socialMedia[oauthProvider] = DataSocialMedia();
        account.socialMedia[oauthProvider].providerId = oauthProvider;
        if (row[1] != null)
          account.socialMedia[oauthProvider].displayName = row[1].toString();
        if (row[2] != null)
          account.socialMedia[oauthProvider].profileUrl = row[2].toString();
        account.socialMedia[oauthProvider].friendsCount = row[3].toInt();
        account.socialMedia[oauthProvider].followersCount = row[4].toInt();
        account.socialMedia[oauthProvider].followingCount = row[5].toInt();
        account.socialMedia[oauthProvider].postsCount = row[6].toInt();
        account.socialMedia[oauthProvider].verified = row[7].toInt() == 1;
        account.socialMedia[oauthProvider].connected =
            true; // TODO: Expired state, TODO: Visibility state
      }
      account.socialMedia[0] = DataSocialMedia();
    } finally {
      await connection.release();
    }

    final NetProfile response = NetProfile();
    response.account = account;
    return response;
  }
}

/* end of file */
