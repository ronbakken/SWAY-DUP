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
import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';
import 'package:switchboard/switchboard.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;

import 'package:inf_common/inf_common.dart';
import 'api_channel.dart';

class ApiChannelProfile {
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

  Int64 get accountId {
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

  ApiChannelProfile(this._r) {
    _r.registerProcedure(
        "L_PROFIL", GlobalAccountState.readOnly, netLoadPublicProfileReq);
    _r.registerProcedure(
        "GTOFFERR", GlobalAccountState.readOnly, netGetOfferReq);
  }

  void dispose() {
    _r.unregisterProcedure("L_PROFIL");
    _r.unregisterProcedure("GTOFFERR");
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Network messages
  //////////////////////////////////////////////////////////////////////////////

  Future<void> netLoadPublicProfileReq(TalkMessage message) async {
    NetGetAccountReq pb = new NetGetAccountReq();
    pb.mergeFromBuffer(message.data);
    devLog.finest(pb);

    DataAccount account = new DataAccount();
    account.state = new DataAccountState();
    account.summary = new DataAccountSummary();
    account.detail = new DataAccountDetail();

    account.state.accountId = pb.accountId;
    for (int i = 0; i < config.oauthProviders.length; ++i) {
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
          [pb.accountId]);
      await for (sqljocky.Row row in accountResults) {
        account.summary.name = row[0].toString();
        account.state.accountType = AccountType.valueOf(row[1].toInt());
        account.summary.description = row[2].toString();
        account.detail.locationId = new Int64(row[3]);
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
        if (row[5] != null) account.detail.website = row[5].toString();
        if (account.state.accountType != AccountType.support) {
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
          [pb.accountId]);
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

    channel.replyMessage(message, "L_R_PROF", account.writeToBuffer());
  }

  Future<void> netGetOfferReq(TalkMessage message) async {
    NetGetOfferReq pb = new NetGetOfferReq()..mergeFromBuffer(message.data);
    devLog.finest(pb);
    Int64 offerId = pb.offerId;
    DataOffer offer;

    channel.replyExtend(message);
    sqljocky.RetainedConnection connection = await sql.getConnection();
    try {
      channel.replyExtend(message);
      sqljocky.Query selectImageKeys = await connection.prepare(
          "SELECT `image_key` FROM `offer_images` WHERE `offer_id` = ?");
      try {
        String selectOffers =
            "SELECT `offers`.`offer_id`, `offers`.`account_id`, " // 0 1
            "`offers`.`title`, `offers`.`description`, `offers`.`deliverables`, `offers`.`reward`, " // 2 3 4 5
            "`offers`.`location_id`, `locations`.`detail`, `locations`.`point`, " // 6 7 8
            "`offers`.`state`, `offers`.`state_reason`, " // 9 10
            "`locations`.`offer_count`, `locations`.`name`, " // 11 12
            "`proposals`.`proposal_id` " // 13
            "FROM `offers` "
            "INNER JOIN `locations` ON `locations`.`location_id` = `offers`.`location_id` "
            "LEFT OUTER JOIN `proposals` "
            "ON `proposals`.`offer_id` = `offers`.`offer_id` AND `proposals`.`influencer_account_id` = ? " // TODO: Cache will also cache a list of all proposals per offer...
            "WHERE `offers`.`offer_id` = ? "
            "ORDER BY `offer_id` DESC";
        sqljocky.Results offerResults =
            await sql.prepareExecute(selectOffers, [accountId, offerId]);
        await for (sqljocky.Row offerRow in offerResults) {
          channel.replyExtend(message);
          offer = new DataOffer();
          offer.offerId = new Int64(offerRow[0]);
          offer.senderId = new Int64(offerRow[1]);
          offer.locationId = new Int64(offerRow[6]);
          offer.title = offerRow[2].toString();
          offer.description = offerRow[3].toString();
          //TODO: offer.deliverables = offerRow[4].toString();
          //TODO: offer.reward = offerRow[5].toString();
          offer.locationName = offerRow[12].toString();
          //TODO: offer.location = offerRow[7].toString();
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
          //TODO: offer.locationOfferCount = offerRow[11].toInt();
          // offer.coverUrls.addAll(filteredImageKeys.map((v) => _r.makeCloudinaryCoverUrl(v)));
          // offer.blurredCoverUrls.addAll(filteredImageKeys.map((v) => _r.makeCloudinaryBlurredCoverUrl(v)));
          // TODO: categories
          offer.state = OfferState.valueOf(offerRow[9].toInt());
          offer.stateReason = OfferStateReason.valueOf(offerRow[10].toInt());
          /*offer.proposalsNew = 0; // TODO
          offer.proposalsAccepted = 0; // TODO
          offer.proposalsCompleted = 0; // TODO
          offer.proposalsRefused = 0; // TODO
          */
          sqljocky.Results imageKeyResults =
              await selectImageKeys.execute([offerId]);
          await for (sqljocky.Row imageKeyRow in imageKeyResults) {
            if (!offer.hasThumbnailUrl()) {
              offer.thumbnailUrl =
                  _r.makeCloudinaryThumbnailUrl(imageKeyRow[0]);
              // TODO: offer.blurredThumbnailUrl =
              // TODO:     _r.makeCloudinaryBlurredThumbnailUrl(imageKeyRow[0]);
            }
            offer.coverUrls.add(_r.makeCloudinaryCoverUrl(imageKeyRow[0]));
            // TODO: offer.blurredCoverUrls
            // TODO:     .add(_r.makeCloudinaryBlurredCoverUrl(imageKeyRow[0]));
          }
          if (offerRow[13] != null) {
            // TODO: offer.influencerProposalId = new Int64(offerRow[13]);
          }
        }
        channel.replyExtend(message);
      } finally {
        await selectImageKeys.close();
      }
    } finally {
      await connection.release();
    }

    if (offer == null) {
      channel.replyAbort(message, "Offer not found.");
      return;
    }

    NetGetOfferRes getOffersRes = new NetGetOfferRes();
    getOffersRes.offer = offer;
    channel.replyMessage(message, "GTOFFE_R", getOffersRes.writeToBuffer());
  }
}
