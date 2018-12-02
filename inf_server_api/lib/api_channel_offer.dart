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
import 'package:inf_server_api/elasticsearch.dart';
import 'package:inf_server_api/elasticsearch_offer.dart';
import 'package:logging/logging.dart';
import 'package:switchboard/switchboard.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;

import 'broadcast_center.dart';
import 'package:inf_common/inf_common.dart';
import 'api_channel.dart';

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

  BroadcastCenter get bc {
    return _r.bc;
  }

  DataAccount get account {
    return _r.account;
  }

  Int64 get accountId {
    return _r.account.accountId;
  }

  Elasticsearch get elasticsearch {
    return _r.elasticsearch;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Construction
  //////////////////////////////////////////////////////////////////////////////

  static final Logger opsLog = new Logger('InfOps.ApiChannelOffer');
  static final Logger devLog = new Logger('InfDev.ApiChannelOffer');

  ApiChannelOffer(this._r) {
    _r.registerProcedure(
        "CREOFFER", GlobalAccountState.readWrite, _netCreateOffer);
  }

  void dispose() {
    _r.unregisterProcedure("CREOFFER");
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Database utilities
  //////////////////////////////////////////////////////////////////////////////

  Future<void> updateLocationOfferCount(Int64 locationId) async {
    // Only include active offers
    String updateLocation =
        "UPDATE `locations` SET `offer_count` = (SELECT COUNT(`offer_id`) FROM `offers` WHERE `location_id` = ? AND `state` = ${OfferState.open.value} AND `direct` = 0) WHERE `location_id` = ?";
    await sql.prepareExecute(updateLocation, [locationId, locationId]);
  }

  //////////////////////////////////////////////////////////////////////////////
  // Network messages
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _netCreateOffer(TalkMessage message) async {
    NetCreateOffer create = new NetCreateOffer()
      ..mergeFromBuffer(message.data)
      ..freeze();
    devLog.finest(create);

    // TODO: if (pb.locationId != null && pb.locationId != 0) {
    // TODO:   // TODO: Fetch location and verify it's owned by this user plus verify that user paid for this feature
    // TODO:   devLog.severe(
    // TODO:       "User $accountId attempt to use non-implemented offer location feature");
    // TODO:   channel.replyAbort(message, "Location not implemented.");
    // TODO:   return;
    // TODO: }

    if (!create.hasOffer()) {
      opsLog.warning(
          "User $accountId did not include an offer in the offer creation message, cannot create offer.");
      channel.replyAbort(message, "Missing offer parameter.");
      return;
    }

    DataOffer offer = create.offer;
    // Int64 locationId = offer.locationId == 0 ? account.locationId : offer.locationId;
    if (offer.locationId != 0 && offer.locationId != account.locationId) {
      opsLog.warning("Custom offer location not yet available.");
      channel.replyAbort(message, "Custom location not yet available.");
      return;
    }

    if (/*offer.locationId == 0 ||*/ account.locationId == 0) {
      opsLog.warning(
          "User $accountId has no default location set, cannot create offer.");
      channel.replyAbort(message, "No default location set.");
      return;
    }

    if (offer.title.length == 0 ||
        offer.description.length < 20 ||
        offer.terms.deliverablesDescription.length < 4 ||
        offer.terms.rewardItemOrServiceDescription.length < 4) {
      opsLog.warning("User $accountId offer parameters not validated.");
      channel.replyAbort(message, "Parameters not validated.");
      return;
    }

    offer.senderId = account.accountId;
    offer.senderType = account.accountType;
    offer.senderName = account.name;
    offer.senderAvatarUrl = account.avatarUrl;
    // TODO: offer.senderAvatarBlurred = account.avatarBlurred;

    // TODO: Scheduled open
    offer.state = OfferState.open;
    offer.stateReason = OfferStateReason.newOffer;
    offer.clearArchived();
    offer.clearDirect();

    // TODO: Custom location
    offer.locationId = account.locationId;
    offer.locationAddress = account.locationAddress;
    offer.latitude = account.latitude;
    offer.longitude = account.longitude;

    // TODO: Fetch blurred images
    // ...

    // Insert offer, not so critical
    channel.replyExtend(message);
    String insertOffer =
        "INSERT INTO `offers`(`sender_id`, `sender_type`, `session_id`, `session_ghost_id`, `location_id`, `state`, `state_reason`) "
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    sqljocky.Results insertRes = await sql.prepareExecute(insertOffer, [
      offer.senderId,
      offer.senderType,
      account.sessionId,
      create.sessionGhostId,
      offer.locationId,
      offer.state.value,
      offer.stateReason.value,
    ]);

    // Verify insertion
    Int64 offerId = new Int64(insertRes.insertId);
    if (offerId == null || offerId == Int64.ZERO) {
      opsLog.severe("User $accountId offer not inserted.");
      channel.replyAbort(message, "Not inserted.");
      return;
    }

    offer.offerId = offerId;

    // Update location `offer_count`, not so critical
    channel.replyExtend(message);
    await updateLocationOfferCount(offer.locationId);

    // Insert Elasticsearch document
    channel.replyExtend(message);
    dynamic doc = ElasticsearchOffer.toJson(
      config,
      offer,
      sender: account,
      location: null,
      senderType: account.accountType,
      create: true,
      modify: false,
      sessionId: account.sessionId,
      sessionGhostId: create.sessionGhostId,
    );
    elasticsearch.postDocument(offer.offerId.toString(), doc);

    NetOffer res = new NetOffer();
    res.offer = ElasticsearchOffer.fromJson(config, doc,
        state: true,
        summary: true,
        detail: true,
        offerId: offer.offerId,
        private: true);
    channel.replyMessage(message, 'R_CREOFR', res.writeToBuffer());
  }

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
