/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/
/*
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'package:switchboard/switchboard.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;

import 'package:inf_common/inf_common.dart';
import 'api_channel.dart';

class ApiDataService {
  final ApiContext _context;

  ApiDataService(this._context) {}

  ApiDataChannel createChannel(ApiChannel apiChannel);
}

class ApiDataChannel {
  final ApiContext _context;
  final ApiDataService _service;
  final ApiChannel _remote;

  ApiDataChannel(this._context, this._service, this._remote) {}

  void onMessage(TalkMessage message) {}
}
*/
/*
class ApiChannelOffer {
  //////////////////////////////////////////////////////////////////////////////
  // Inherited properties
  //////////////////////////////////////////////////////////////////////////////

  ApiChannel _r;
  ConfigData get config {
    return _r.config;
  }

  sqljocky.ConnectionPool get sql {
    return _r.sql;
  }

  TalkChannel get channel {
    return _r.channel;
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
  // Construction
  //////////////////////////////////////////////////////////////////////////////

  static final Logger opsLog = new Logger('InfOps.ApiChannelOAuth');
  static final Logger devLog = new Logger('InfDev.ApiChannelOAuth');

  ApiChannelOffer(this._r) {
    _netLoadPublicOfferReq = _r.registerProcedure("L_OFFERR",
        GlobalAccountState.readWrite, true, netLoadPublicOfferReq);
  }

  void dispose() {
    if (_netLoadPublicOfferReq != null) {
      _netLoadPublicOfferReq.cancel();
      _netLoadPublicOfferReq = null;
    }
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Network messages
  //////////////////////////////////////////////////////////////////////////////

  static int _netLoadOfferRes = TalkSocket.encode("L_R_OFFR");
  Future<void> netLoadPublicOfferReq(TalkMessage message) async {


    
    NetLoadOfferReq pb = new NetLoadOfferReq();
    pb.mergeFromBuffer(message.data);
    devLog.finest(pb);

    DataAccount account = new DataAccount();
    account.state = new DataAccountState();
    account.summary = new DataAccountSummary();
    account.detail = new DataAccountDetail();

    account.state.accountId = pb.accountId;
    for (int i = 0; i < config.oauthProviders.all.length; ++i) {
      account.detail.socialMedia.add(new DataSocialMedia());
    }

    channel.replyExtend(message);
    sqljocky.RetainedConnection connection = await sql.getConnection();
    try {
      // Fetch public profile info
      channel.replyExtend(message);
      sqljocky.Results accountResults = await connection.prepareExecute(
          "SELECT `accounts`.`name`, `accounts`.`account_type`, " // 0 1
          "`accounts`.`description`, `accounts`.`location_id`, " // 2 3
          "`accounts`.`avatar_key`, `accounts`.`website`, " // 4 5
          "`locations`.`approximate`, `locations`.`detail`, " // 6 7
          "`locations`.`point` " // 8
          "FROM `accounts` "
          "INNER JOIN `locations` ON `locations`.`location_id` = `accounts`.`location_id` "
          "WHERE `accounts`.`account_id` = ? ",
          [pb.accountId.toInt()]);
      await for (sqljocky.Row row in accountResults) {
        account.summary.name = row[0].toString();
        account.state.accountType = AccountType.valueOf(row[1].toInt());
        account.summary.description = row[2].toString();
        account.detail.locationId = row[3].toInt();
        if (row[4] != null) {
          account.summary.avatarThumbnailUrl =
              _r.makeCloudinaryThumbnailUrl(row[4].toString());
          account.detail.avatarCoverUrl =
              _r.makeCloudinaryCoverUrl(row[4].toString());
        }
        if (row[5] != null) account.detail.url = row[5].toString();
        if (account.state.accountType != AccountType.AT_SUPPORT) {
          account.summary.location =
              account.state.accountType == AccountType.influencer
                  ? row[6].toString()
                  : row[7].toString();
          if (account.state.accountType == AccountType.business) {
            Uint8List point = row[8];
            if (point != null) {
              // Attempt to parse point, see https://dev.mysql.com/doc/refman/5.7/en/gis-data-formats.html#gis-wkb-format
              ByteData data = new ByteData.view(point.buffer);
              Endian endian = data.getInt8(4) == 0 ? Endian.big : Endian.little;
              int type = data.getUint32(4 + 1, endian = endian);
              if (type == 1) {
                account.detail.latitude =
                    data.getFloat64(4 + 5 + 8, endian = endian);
                account.detail.longitude =
                    data.getFloat64(4 + 5, endian = endian);
              }
            }
          }
        }
      }
      // Fetch public social media info
      channel.replyExtend(message);
      sqljocky.Results connectionResults = await connection.prepareExecute(
          "SELECT `social_media`.`oauth_provider`, " // 0
          "`social_media`.`display_name`, `social_media`.`profile_url`, " // 1 2
          "`social_media`.`friends_count`, `social_media`.`followers_count`, " // 3 4
          "`social_media`.`following_count`, `social_media`.`posts_count`, " // 5 6
          "`social_media`.`verified` " // 7 8
          "FROM `oauth_connections` "
          "INNER JOIN `social_media` "
          "ON `social_media`.`oauth_user_id` = `oauth_connections`.`oauth_user_id` "
          "AND `social_media`.`oauth_provider` = `oauth_connections`.`oauth_provider` "
          "WHERE `oauth_connections`.`account_id` = ? ",
          [pb.accountId.toInt()]);
      await for (sqljocky.Row row in connectionResults) {
        int oauthProvider = row[0].toInt();
        if (row[1] != null)
          account.detail.socialMedia[oauthProvider].displayName =
              row[1].toString();
        if (row[2] != null)
          account.detail.socialMedia[oauthProvider].profileUrl =
              row[2].toString();
        account.detail.socialMedia[oauthProvider].friendsCount = row[3].toInt();
        account.detail.socialMedia[oauthProvider].followersCount =
            row[4].toInt();
        account.detail.socialMedia[oauthProvider].followingCount =
            row[5].toInt();
        account.detail.socialMedia[oauthProvider].postsCount = row[6].toInt();
        account.detail.socialMedia[oauthProvider].verified =
            row[7].toInt() != 0;
        account.detail.socialMedia[oauthProvider].connected =
            true; // TODO: Expired state, TODO: Visibility state
      }
    } finally {
      connection.release();
    }

    channel.sendMessage(_netOfferImageRes, account.writeToBuffer(),
        replying: message);
  }
}*/
