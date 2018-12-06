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
        'CREOFFER', GlobalAccountState.readWrite, _netCreateOffer);
    _r.registerProcedure('GETOFFER', GlobalAccountState.readOnly, _netGetOffer);
    _r.registerProcedure(
        'LISTOFRS', GlobalAccountState.readOnly, _netListOffers);
  }

  void dispose() {
    _r.unregisterProcedure('CREOFFER');
    _r.unregisterProcedure('GETOFFER');
    _r.unregisterProcedure('LISTOFRS');
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
    NetCreateOffer create = new NetCreateOffer()..mergeFromBuffer(message.data);
    devLog.finest(create);

    if (!create.hasOffer()) {
      opsLog.warning(
          "User $accountId did not include an offer in the offer creation message, cannot create offer.");
      channel.replyAbort(message, "Missing offer parameter.");
      return;
    }

    DataOffer offer = create.offer;
    Int64 locationId =
        offer.locationId == 0 ? account.locationId : offer.locationId;
    if (locationId == 0) {
      opsLog.warning("Location not specified.");
      channel.replyAbort(message, "Location not specified.");
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

    if (offer.coverKeys.isEmpty) {
      opsLog.warning("Missing cover key.");
      channel.replyAbort(message, "Missing cover key.");
      return;
    }

    offer.senderId = account.accountId;
    offer.senderType = account.accountType;
    offer.senderName = account.name;
    offer.senderAvatarUrl = account.avatarUrl;
    // TODO: offer.senderAvatarBlurred = account.avatarBlurred;
    // TODO: offer.senderAvatarKey

    // TODO: Scheduled open
    offer.state = OfferState.open;
    offer.stateReason = OfferStateReason.newOffer;
    offer.clearArchived();
    offer.clearDirect();

    // Custom location
    channel.replyExtend(message);
    DataLocation location = await _r.fetchLocationSummaryFromSql(locationId,
        account.accountId, account.accountType == AccountType.business);
    offer.locationId = locationId;
    if (location == null) {
      opsLog.warning("Location invalid.");
      channel.replyAbort(message, "Location invalid.");
      return;
    }

    // Fetch blurred images
    for (String coverKey in offer.coverKeys) {
      channel.replyExtend(message);
      devLog.finer(_r.makeCloudinaryBlurredCoverUrl(coverKey));
      offer.coversBlurred.add(
          await _r.downloadData(_r.makeCloudinaryBlurredCoverUrl(coverKey)));
    }

    // Thumbnail
    if (offer.thumbnailKey.isEmpty) {
      offer.thumbnailKey = offer.coverKeys[0];
    }
    channel.replyExtend(message);
    devLog.finer(_r.makeCloudinaryBlurredThumbnailUrl(offer.thumbnailKey));
    offer.thumbnailBlurred = await _r
        .downloadData(_r.makeCloudinaryBlurredThumbnailUrl(offer.thumbnailKey));

    // Insert offer, not so critical
    channel.replyExtend(message);
    String insertOffer =
        "INSERT INTO `offers`(`sender_id`, `sender_type`, `session_id`, `location_id`, `state`, `state_reason`) "
        "VALUES (?, ?, ?, ?, ?, ?)";
    sqljocky.Results insertRes = await sql.prepareExecute(insertOffer, [
      offer.senderId,
      offer.senderType.value,
      account.sessionId,
      offer.locationId,
      offer.state.value,
      offer.stateReason.value,
    ]);

    // TODO: Unexpected error in procedure 'CREOFFER': Error 1062 (23000): Duplicate entry '4-0' for key 'session_id'
    // Get existing offer, or update offer instead, or remove the session_ghost_id here...

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
      location: location,
      senderType: account.accountType,
      create: true,
      modify: false,
      sessionId: account.sessionId,
      sessionGhostId: create.sessionGhostId,
    );
    devLog.finest(doc);
    await elasticsearch.putDocument("offers", offer.offerId.toString(), doc);

    NetOffer res = new NetOffer();
    res.offer = ElasticsearchOffer.fromJson(config, doc,
        state: true,
        summary: true,
        detail: true,
        offerId: offer.offerId,
        receiver: accountId,
        private: true);
    res.state = true;
    res.summary = true;
    res.detail = true;
    devLog.finest('Create offer "${res.offer.title}".');
    channel.replyMessage(message, 'R_CREOFR', res.writeToBuffer());
  }

  Future<void> _netGetOffer(TalkMessage message) async {
    NetGetOffer getOffer = NetGetOffer()
      ..mergeFromBuffer(message.data)
      ..freeze();
    dynamic doc =
        await elasticsearch.getDocument("offers", getOffer.offerId.toString());
    NetOffer res = new NetOffer();
    res.offer = ElasticsearchOffer.fromJson(config, doc,
        state: true,
        summary: true,
        detail: true,
        offerId: getOffer.offerId,
        receiver: accountId,
        private: true);
    res.state = true;
    res.summary = true;
    res.detail = true;
    devLog.finest('Get offer "${res.offer.title}".');
    channel.replyMessage(message, 'R_GETOFR', res.writeToBuffer());
  }

  static const List<String> privateFields = [
    // Summary
    "location_id", // Private
    // State
    "state",
    "state_reason",
    "archived",
    "proposals_proposing",
    "proposals_negotiating",
    "proposals_deal",
    "proposals_rejected",
    "proposals_dispute",
    "proposals_resolved",
    "proposals_complete",
  ];

  static const List<String> summaryFields = [
    // Summary
    "offer_id",
    "sender_id",
    "sender_type",
    "title",
    "thumbnail_key",
    "thumbnail_blurred",
    "deliverables_description",
    "reward_item_or_service_description",
    "primary_categories",
    "sender_name",
    "sender_avatar_key", // TODO: Fix this
    "sender_avatar_blurred",
    "location_address",
    "latitude",
    "longitude",
  ];

  static final List<String> privateSummaryFields =
      (privateFields + summaryFields).toList();

  static const int searchSize = 255;

  Future<void> _netListOffers(TalkMessage message) async {
    final NetListOffers listOffers = NetListOffers()
      ..mergeFromBuffer(message.data)
      ..freeze();
    dynamic results = await elasticsearch.search('offers', {
      "size": searchSize,
      "_source": {
        "includes": privateSummaryFields,
      },
      "query": {
        "term": {
          "sender_id": accountId.toInt(),
        }
      },
    });
    // TODO: Possible to pre-send the total count
    List<dynamic> hits = results['hits']['hits'];
    for (dynamic hit in hits) {
      Map<String, dynamic> doc = hit['_source'] as Map<String, dynamic>;
      NetOffer res;
      try {
        res = new NetOffer();
        res.offer = ElasticsearchOffer.fromJson(config, doc,
            state: true,
            summary: true,
            detail: false,
            offerId: Int64.parseInt(hit['_id']),
            receiver: accountId,
            private: true);
      } catch (error, stackTrace) {
        res = null;
        devLog.severe("Error parsing offer: $error\n$stackTrace");
      }
      if (res != null) {
        channel.replyMessage(message, 'R_LSTOFR', res.writeToBuffer());
      }
    }
    channel.replyEndOfStream(message);
  }
}

/* end of file */
