/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';
import 'package:switchboard/switchboard.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;

import 'broadcast_center.dart';
import 'package:inf_common/inf_common.dart';
import 'api_channel.dart';

class ApiChannelBusiness {
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

  BroadcastCenter get bc {
    return _r.bc;
  }

  DataAccount get account {
    return _r.account;
  }

  Int64 get accountId {
    return _r.account.accountId;
  }

  GlobalAccountState get globalAccountState {
    return _r.account.globalAccountState;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Construction
  //////////////////////////////////////////////////////////////////////////////

  static final Logger opsLog = new Logger('InfOps.ApiChannelBusiness');
  static final Logger devLog = new Logger('InfDev.ApiChannelBusiness');

  // Cached list of offers
  Map<Int64, DataOffer> offers = new Map<Int64, DataOffer>();

  ApiChannelBusiness(this._r) {
    // _r.registerProcedure(
    //     "CREOFFER", GlobalAccountState.readWrite, netCreateOffer);
    // _r.registerProcedure(
    //     "LISTOFRS", GlobalAccountState.readOnly, netListOffers);
  }

  void dispose() {
    // _r.unregisterProcedure("C_OFFERR");
    // _r.unregisterProcedure("L_OFFERS");
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Database utilities
  //////////////////////////////////////////////////////////////////////////////

/*
  Future<void> updateLocationOfferCount(Int64 locationId) async {
    // TODO: Only include active offers... :)
    String updateLocation =
        "UPDATE `locations` SET `offer_count` = (SELECT COUNT(`offer_id`) FROM `offers` WHERE `location_id` = ?) WHERE `location_id` = ?";
    await sql.prepareExecute(updateLocation, [locationId, locationId]);
  }
  */

  //////////////////////////////////////////////////////////////////////////////
  // Network messages
  //////////////////////////////////////////////////////////////////////////////

/*
  Future<void> netCreateOffer(TalkMessage message) async {
    NetCreateOffer pb = new NetCreateOffer();
    pb.mergeFromBuffer(message.data);
    devLog.finest(pb);

    // TODO: if (pb.locationId != null && pb.locationId != 0) {
    // TODO:   // TODO: Fetch location and verify it's owned by this user plus verify that user paid for this feature
    // TODO:   devLog.severe(
    // TODO:       "User $accountId attempt to use non-implemented offer location feature");
    // TODO:   channel.replyAbort(message, "Location not implemented.");
    // TODO:   return;
    // TODO: }

    if (account.locationId == 0) {
      opsLog.warning(
          "User $accountId has no default location set, cannot create offer");
      channel.replyAbort(message, "No default location set.");
      return;
    }

    if (pb.offer.title.length == 0 ||
        pb.offer.description.length < 20 ||
        pb.offer.terms.deliverablesDescription.length < 4 ||
        pb.offer.terms.rewardItemOrServiceDescription.length < 4) {
      opsLog.warning("User $accountId offer parameters not validated");
      channel.replyAbort(message, "Not validated.");
      return;
    }

    // Insert offer, not so critical
    // TODO: Set the offer state options... :)
    Int64 locationId = account.locationId;
    channel.replyExtend(message);
    String insertOffer =
        "INSERT INTO `offers`(`account_id`, `title`, `description`, `deliverables`, `reward`, `location_id`, `state`) "
        "VALUES (?, ?, ?, ?, ?, ?, ?)";
    sqljocky.Results insertRes = await sql.prepareExecute(insertOffer, [
      account.accountId,
      pb.offer.title.toString(),
      pb.offer.description.toString(),
      pb.offer.terms.deliverablesDescription.toString(),
      pb.offer.terms.rewardItemOrServiceDescription.toString(),
      locationId,
      OfferState.open.value.toInt()
    ]);

    // Verify insertion
    Int64 offerId = new Int64(insertRes.insertId);
    if (offerId == null || offerId == Int64.ZERO) {
      opsLog.severe("User $accountId offer not inserted");
      channel.replyAbort(message, "Not inserted.");
      return;
    }

    List<String> filteredImageKeys = pb.offer.coverKeys
        .where((imageKey) =>
            imageKey != null &&
            !imageKey.isEmpty &&
            imageKey.startsWith("${config.services.domain}/user/$accountId/") &&
            !imageKey.contains(".."))
        .toList();

    // Insert offer images
    for (String imageKey in filteredImageKeys) {
      channel.replyExtend(message);
      // TODO: Verify the image key actually exists and is owned by the user!
      String insertImage =
          "INSERT INTO `offer_images`(`offer_id`, `image_key`) VALUES (?, ?)";
      await sql.prepareExecute(insertImage, [offerId, imageKey.toString()]);
    }

    // Update location `offer_count`, not so critical
    channel.replyExtend(message);
    await updateLocationOfferCount(locationId);

    // Reply success
    NetOffer netCreateOfferRes = new NetOffer();
    netCreateOfferRes.offer.offerId = offerId;
    netCreateOfferRes.offer.senderId = accountId;
    netCreateOfferRes.offer.locationId = locationId;
    // TODO: netCreateOfferRes.title = pb.title;
    // TODO: netCreateOfferRes.description = pb.description;
    // TODO: if (filteredImageKeys.length > 0) {
    // TODO:   netCreateOfferRes.thumbnailUrl =
    // TODO:       _r.makeCloudinaryThumbnailUrl(filteredImageKeys[0]);
    // TODO:   netCreateOfferRes.blurredThumbnailUrl =
    // TODO:       _r.makeCloudinaryBlurredThumbnailUrl(filteredImageKeys[0]);
    // TODO: }
    // TODO: netCreateOfferRes.deliverables = pb.deliverables;
    // TODO: netCreateOfferRes.reward = pb.reward;
    // TODO: netCreateOfferRes.location = account.location;
    netCreateOfferRes.offer.latitude = account.latitude;
    netCreateOfferRes.offer.longitude = account.longitude;
    netCreateOfferRes.offer.coverUrls
        .addAll(filteredImageKeys.map((v) => _r.makeCloudinaryCoverUrl(v)));
    // TODO: netCreateOfferRes.blurredCoverUrls.addAll(
    // TODO:     filteredImageKeys.map((v) => _r.makeCloudinaryBlurredCoverUrl(v)));
    // TODO: categories
    netCreateOfferRes.offer.state = OfferState.open;
    netCreateOfferRes.offer.stateReason = OfferStateReason.newOffer;
    // netCreateOfferRes.proposalsNew = 0;
    // netCreateOfferRes.proposalsAccepted = 0;
    // netCreateOfferRes.proposalsCompleted = 0;
    // netCreateOfferRes.proposalsRefused = 0;
    offers[offerId] = netCreateOfferRes.offer;
    channel.replyMessage(
        message, "R_CREOFR", netCreateOfferRes.writeToBuffer());
  }
  */
/*
  Future<void> netListOffers(TalkMessage message) async {
    NetLoadOffers pb = new NetLoadOffers();
    pb.mergeFromBuffer(message.data);

    // TODO: New offers
    channel.replyEndOfStream(message);
    return;
    
    // TODO: Limit number of results
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
            "`offers`.`state`, `offers`.`state_reason`, `locations`.`name` " // 9 10 11
            "FROM `offers` "
            "INNER JOIN `locations` ON `locations`.`location_id` = `offers`.`location_id` "
            "WHERE `offers`.`account_id` = ? "
            "ORDER BY `offer_id` DESC";
        sqljocky.Results offerResults =
            await sql.prepareExecute(selectOffers, [accountId]);
        await for (sqljocky.Row offerRow in offerResults) {
          channel.replyExtend(message);
          DataOffer offer = new DataOffer();
          offer.offerId = new Int64(offerRow[0]);
          offer.senderId = new Int64(offerRow[1]);
          offer.locationId = new Int64(offerRow[6]);
          offer.title = offerRow[2].toString();
          offer.description = offerRow[3].toString();
          // TODO: offer.deliverables = offerRow[4].toString();
          // TODO: offer.reward = offerRow[5].toString();
          offer.locationName = offerRow[11].toString();
          // TODO: offer.location = offerRow[7].toString();
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
          offer.state = OfferState.valueOf(offerRow[9].toInt());
          offer.stateReason = OfferStateReason.valueOf(offerRow[10].toInt());
          // offer.proposalsNew = 0; // TODO
          // offer.proposalsAccepted = 0; // TODO
          // offer.proposalsCompleted = 0; // TODO
          // offer.proposalsRefused = 0; // TODO
          
          sqljocky.Results imageKeyResults =
              await selectImageKeys.execute([offer.offerId]);
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
          // Cache offer for use (is this really necessary?)
          offers[offer.offerId] = offer;
          // Send offer to user
          channel.replyMessage(message, "R_LSTOFR", offer.writeToBuffer());
        }
        channel.replyExtend(message);
      } finally {
        await selectImageKeys.close();
      }
    } finally {
      await connection.release();
    }

    // TODO: NetOffer loadOffersRes = new NetOffer();
    // TODO: channel.replyMessage(message, "L_R_OFFE", loadOffersRes.writeToBuffer());
    channel.replyAbort(message, "Not implemented");
  }*/
}
