/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

///////////////////////////////////////
/// DEPRECATED
/// DEPRECATED
/// DEPRECATED
///////////////////////////////////////

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'package:wstalk/wstalk.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;

import 'protobuf/inf_protobuf.dart';
import 'remote_app.dart';

class RemoteAppProfile {
  //////////////////////////////////////////////////////////////////////////////
  // Inherited properties
  //////////////////////////////////////////////////////////////////////////////

  RemoteApp _r;
  ConfigData get config {
    return _r.config;
  }

  sqljocky.ConnectionPool get sql {
    return _r.sql;
  }

  TalkSocket get ts {
    return _r.ts;
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

  static final Logger opsLog = new Logger('InfOps.RemoteAppOAuth');
  static final Logger devLog = new Logger('InfDev.RemoteAppOAuth');

  RemoteAppProfile(this._r) {
    _netLoadPublicProfileReq = _r.saferListen("L_PROFIL",
        GlobalAccountState.GAS_READ_ONLY, true, netLoadPublicProfileReq);
    _netGetOfferReq = _r.saferListen(
        "GTOFFERR", GlobalAccountState.GAS_READ_ONLY, true, netGetOfferReq);
  }

  void dispose() {
    if (_netLoadPublicProfileReq != null) {
      _netLoadPublicProfileReq.cancel();
      _netLoadPublicProfileReq = null;
    }
    if (_netGetOfferReq != null) {
      _netGetOfferReq.cancel();
      _netGetOfferReq = null;
    }
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Network messages
  //////////////////////////////////////////////////////////////////////////////

  StreamSubscription<TalkMessage> _netLoadPublicProfileReq; // L_PROFIL
  static int _netProfileImageRes = TalkSocket.encode("L_R_PROF");
  Future<void> netLoadPublicProfileReq(TalkMessage message) async {
    NetGetAccountReq pb = new NetGetAccountReq();
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

    ts.sendExtend(message);
    sqljocky.RetainedConnection connection = await sql.getConnection();
    try {
      // Fetch public profile info
      ts.sendExtend(message);
      sqljocky.Results accountResults = await connection.prepareExecute(
          "SELECT `accounts`.`name`, `accounts`.`account_type`, " // 0 1
          "`accounts`.`description`, `accounts`.`location_id`, " // 2 3
          "`accounts`.`avatar_key`, `accounts`.`url`, " // 4 5
          "`addressbook`.`approximate`, `addressbook`.`detail`, " // 6 7
          "`addressbook`.`point` " // 8
          "FROM `accounts` "
          "INNER JOIN `addressbook` ON `addressbook`.`location_id` = `accounts`.`location_id` "
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
          account.summary.blurredAvatarThumbnailUrl =
              _r.makeCloudinaryBlurredThumbnailUrl(row[4].toString());
          account.detail.avatarCoverUrl =
              _r.makeCloudinaryCoverUrl(row[4].toString());
          account.detail.blurredAvatarCoverUrl =
              _r.makeCloudinaryBlurredCoverUrl(row[4].toString());
        }
        if (row[5] != null) account.detail.url = row[5].toString();
        if (account.state.accountType != AccountType.AT_SUPPORT) {
          account.summary.location =
              account.state.accountType == AccountType.AT_INFLUENCER
                  ? row[6].toString()
                  : row[7].toString();
          if (account.state.accountType == AccountType.AT_BUSINESS) {
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
      ts.sendExtend(message);
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

    ts.sendMessage(_netProfileImageRes, account.writeToBuffer(),
        replying: message);
  }

  StreamSubscription<TalkMessage> _netGetOfferReq;
  static int _netGetOfferRes = TalkSocket.encode("GTOFFE_R");
  Future<void> netGetOfferReq(TalkMessage message) async {
    NetGetOfferReq pb = new NetGetOfferReq()..mergeFromBuffer(message.data);
    devLog.finest(pb);
    int offerId = pb.offerId.toInt();
    DataBusinessOffer offer;

    ts.sendExtend(message);
    sqljocky.RetainedConnection connection = await sql.getConnection();
    try {
      ts.sendExtend(message);
      sqljocky.Query selectImageKeys = await connection.prepare(
          "SELECT `image_key` FROM `offer_images` WHERE `offer_id` = ?");
      try {
        String selectOffers =
            "SELECT `offers`.`offer_id`, `offers`.`account_id`, " // 0 1
            "`offers`.`title`, `offers`.`description`, `offers`.`deliverables`, `offers`.`reward`, " // 2 3 4 5
            "`offers`.`location_id`, `addressbook`.`detail`, `addressbook`.`point`, " // 6 7 8
            "`offers`.`state`, `offers`.`state_reason`, `addressbook`.`name` " // 9 10 11
            "FROM `offers` "
            "INNER JOIN `addressbook` ON `addressbook`.`location_id` = `offers`.`location_id` "
            "WHERE `offers`.`offer_id` = ? "
            "ORDER BY `offer_id` DESC";
        sqljocky.Results offerResults =
            await sql.prepareExecute(selectOffers, [offerId]);
        await for (sqljocky.Row offerRow in offerResults) {
          ts.sendExtend(message);
          offer = new DataBusinessOffer();
          offer.offerId = offerRow[0].toInt();
          offer.accountId = offerRow[1].toInt();
          offer.locationId = offerRow[6].toInt();
          offer.title = offerRow[2].toString();
          offer.description = offerRow[3].toString();
          offer.deliverables = offerRow[4].toString();
          offer.reward = offerRow[5].toString();
          offer.locationName = offerRow[11].toString();
          offer.location = offerRow[7].toString();
          print(offerRow[8].toString());
          Uint8List point = offerRow[8];
          if (point != null) {
            // Attempt to parse point, see https://dev.mysql.com/doc/refman/5.7/en/gis-data-formats.html#gis-wkb-format
            ByteData data = new ByteData.view(point.buffer);
            Endian endian = data.getInt8(4) == 0 ? Endian.big : Endian.little;
            int type = data.getUint32(4 + 1, endian = endian);
            if (type == 1) {
              offer.latitude = data.getFloat64(4 + 5 + 8, endian = endian);
              offer.longitude = data.getFloat64(4 + 5, endian = endian);
            }
          }
          // offer.coverUrls.addAll(filteredImageKeys.map((v) => _r.makeCloudinaryCoverUrl(v)));
          // offer.blurredCoverUrls.addAll(filteredImageKeys.map((v) => _r.makeCloudinaryBlurredCoverUrl(v)));
          // TODO: categories
          offer.state = BusinessOfferState.valueOf(offerRow[9].toInt());
          offer.stateReason =
              BusinessOfferStateReason.valueOf(offerRow[10].toInt());
          offer.applicantsNew = 0; // TODO
          offer.applicantsAccepted = 0; // TODO
          offer.applicantsCompleted = 0; // TODO
          offer.applicantsRefused = 0; // TODO
          sqljocky.Results imageKeyResults =
              await selectImageKeys.execute([offerId]);
          await for (sqljocky.Row imageKeyRow in imageKeyResults) {
            if (!offer.hasThumbnailUrl()) {
              offer.thumbnailUrl =
                  _r.makeCloudinaryThumbnailUrl(imageKeyRow[0]);
              offer.blurredThumbnailUrl =
                  _r.makeCloudinaryBlurredThumbnailUrl(imageKeyRow[0]);
            }
            offer.coverUrls.add(_r.makeCloudinaryCoverUrl(imageKeyRow[0]));
            offer.blurredCoverUrls
                .add(_r.makeCloudinaryBlurredCoverUrl(imageKeyRow[0]));
          }
        }
        ts.sendExtend(message);
      } finally {
        await selectImageKeys.close();
      }
    } finally {
      await connection.release();
    }

    if (offer == null) {
      ts.sendException("Offer not found", message);
      return;
    }

    NetGetOfferRes getOffersRes = new NetGetOfferRes();
    getOffersRes.offer = offer;
    ts.sendMessage(_netGetOfferRes, getOffersRes.writeToBuffer(),
        replying: message);
  }
}
