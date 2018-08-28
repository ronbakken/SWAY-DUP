/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'package:wstalk/wstalk.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;

import 'broadcast_center.dart';
import 'inf.pb.dart';
import 'remote_app.dart';

class RemoteAppBusiness {
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

  BroadcastCenter get bc {
    return _r.bc;
  }

  DataAccount get account {
    return _r.account;
  }

  int get accountId {
    return _r.account.state.accountId.toInt();
  }

  GlobalAccountState get globalAccountState {
    return _r.account.state.globalAccountState;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Construction
  //////////////////////////////////////////////////////////////////////////////

  static final Logger opsLog = new Logger('InfOps.RemoteAppBusiness');
  static final Logger devLog = new Logger('InfDev.RemoteAppBusiness');

  // Cached list of offers
  Map<int, DataBusinessOffer> offers = new Map<int, DataBusinessOffer>();

  RemoteAppBusiness(this._r) {
    _netCreateOfferReq = _r.saferListen(
        "C_OFFERR", GlobalAccountState.GAS_READ_WRITE, true, netCreateOfferReq);
    _netLoadOffersReq = _r.saferListen(
        "L_OFFERS", GlobalAccountState.GAS_READ_WRITE, true, netLoadOffersReq);
  }

  void dispose() {
    if (_netCreateOfferReq != null) {
      _netCreateOfferReq.cancel();
      _netCreateOfferReq = null;
    }
    if (_netLoadOffersReq != null) {
      _netLoadOffersReq.cancel();
      _netLoadOffersReq = null;
    }
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Database utilities
  //////////////////////////////////////////////////////////////////////////////

  Future<void> updateLocationOfferCount(int locationId) async {
    // TODO: Only include active offers... :)
    String updateLocation =
        "UPDATE `addressbook` SET `offer_count` = (SELECT COUNT(`offer_id`) FROM `offers` WHERE `location_id` = ?) WHERE `location_id` = ?";
    await sql.prepareExecute(updateLocation, [locationId, locationId]);
  }

  //////////////////////////////////////////////////////////////////////////////
  // Network messages
  //////////////////////////////////////////////////////////////////////////////

  StreamSubscription<TalkMessage> _netCreateOfferReq; // C_OFFERR
  static int _netCreateOfferRes = TalkSocket.encode("C_R_OFFE");
  Future<void> netCreateOfferReq(TalkMessage message) async {
    NetCreateOfferReq pb = new NetCreateOfferReq();
    pb.mergeFromBuffer(message.data);
    devLog.finest(pb);

    if (pb.locationId != null && pb.locationId != 0) {
      // TODO: Fetch location and verify it's owned by this user plus verify that user paid for this feature
      devLog.severe(
          "User $accountId attempt to use non-implemented offer location feature");
      ts.sendException("Location not implemented", message);
      return;
    }

    if (account.detail.locationId == 0) {
      opsLog.warning(
          "User $accountId has no default location set, cannot create offer");
      ts.sendException("No default location set", message);
      return;
    }

    if (pb.title.length == 0 ||
        pb.description.length < 20 ||
        pb.deliverables.length < 4 ||
        pb.reward.length < 4) {
      opsLog.warning("User $accountId offer parameters not validated");
      ts.sendException("Not validated", message);
      return;
    }

    // Insert offer, not so critical
    // TODO: Set the offer state options... :)
    int locationId = account.detail.locationId.toInt();
    ts.sendExtend(message);
    String insertOffer =
        "INSERT INTO `offers`(`account_id`, `title`, `description`, `deliverables`, `reward`, `location_id`) "
        "VALUES (?, ?, ?, ?, ?, ?)";
    sqljocky.Results insertRes = await sql.prepareExecute(insertOffer, [
      account.state.accountId.toInt(),
      pb.title.toString(),
      pb.description.toString(),
      pb.deliverables.toString(),
      pb.reward.toString(),
      locationId
    ]);

    // Verify insertion
    int offerId = insertRes.insertId;
    if (offerId == null || offerId == 0) {
      opsLog.severe("User $accountId offer not inserted");
      ts.sendException("Not inserted", message);
      return;
    }

    List<String> filteredImageKeys = pb.imageKeys
        .where((imageKey) =>
            imageKey != null &&
            !imageKey.isEmpty &&
            imageKey.startsWith("user/$accountId/"))
        .toList();

    // Insert offer images
    for (String imageKey in filteredImageKeys) {
      ts.sendExtend(message);
      // TODO: Verify the image key actually exists and is owned by the user!
      String insertImage =
          "INSERT INTO `offer_images`(`offer_id`, `image_key`) VALUES (?, ?)";
      await sql.prepareExecute(insertImage, [offerId, imageKey.toString()]);
    }

    // Update location `offer_count`, not so critical
    ts.sendExtend(message);
    await updateLocationOfferCount(locationId);

    // Reply success
    DataBusinessOffer netCreateOfferRes = new DataBusinessOffer();
    netCreateOfferRes.offerId = offerId;
    netCreateOfferRes.accountId = accountId;
    netCreateOfferRes.locationId = locationId;
    netCreateOfferRes.title = pb.title;
    netCreateOfferRes.description = pb.description;
    if (filteredImageKeys.length > 0)
      netCreateOfferRes.thumbnailUrl =
          _r.makeCloudinaryThumbnailUrl(filteredImageKeys[0]);
    netCreateOfferRes.deliverables = pb.deliverables;
    netCreateOfferRes.reward = pb.reward;
    netCreateOfferRes.location = account.summary.location;
    netCreateOfferRes.latitude = account.detail.latitude;
    netCreateOfferRes.longitude = account.detail.longitude;
    netCreateOfferRes.coverUrls
        .addAll(filteredImageKeys.map((v) => _r.makeCloudinaryCoverUrl(v)));
    // TODO: categories
    netCreateOfferRes.state = BusinessOfferState.BOS_OPEN;
    netCreateOfferRes.stateReason = BusinessOfferStateReason.BOSR_NEW_OFFER;
    netCreateOfferRes.applicantsNew = 0;
    netCreateOfferRes.applicantsAccepted = 0;
    netCreateOfferRes.applicantsCompleted = 0;
    netCreateOfferRes.applicantsRefused = 0;
    offers[offerId] = netCreateOfferRes;
    ts.sendMessage(_netCreateOfferRes, netCreateOfferRes.writeToBuffer(),
        replying: message);
  }

  StreamSubscription<TalkMessage> _netLoadOffersReq; // C_OFFERR
  static int _dataBusinessOffer = TalkSocket.encode("DB_OFFER");
  static int _netLoadOffersRes = TalkSocket.encode("L_R_OFFE");
  Future<void> netLoadOffersReq(TalkMessage message) async {
    NetLoadOffersReq pb = new NetLoadOffersReq();
    pb.mergeFromBuffer(message.data);

    // TODO: Limit number of results
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
            "`offers`.`location_id`, `addressbook`.`detail`, `addressbook`.`point` " // 6 7 8
            "FROM `offers` "
            "INNER JOIN `addressbook` ON `addressbook`.`location_id` = `offers`.`location_id` "
            "WHERE `offers`.`account_id` = ?"; // TODO: Order highest offer id first
        sqljocky.Results offerResults =
            await sql.prepareExecute(selectOffers, [accountId]);
        await for (sqljocky.Row offerRow in offerResults) {
          ts.sendExtend(message);
          DataBusinessOffer offer = new DataBusinessOffer();
          offer.offerId = offerRow[0].toInt();
          offer.accountId = offerRow[1].toInt();
          offer.locationId = offerRow[6].toInt();
          offer.title = offerRow[2].toString();
          offer.description = offerRow[3].toString();
          offer.deliverables = offerRow[4].toString();
          offer.reward = offerRow[5].toString();
          offer.location = offerRow[7].toString();
          offer.latitude = 0.0; // offerRow[8]; // TODO: parse
          offer.longitude = 0.0; // offerRow[8]; // TODO: parse
          // offer.coverUrls.addAll(filteredImageKeys.map((v) => _r.makeCloudinaryCoverUrl(v)));
          // TODO: categories
          offer.state = BusinessOfferState.BOS_OPEN; // TODO
          offer.stateReason = BusinessOfferStateReason.BOSR_NEW_OFFER; // TODO
          offer.applicantsNew = 0; // TODO
          offer.applicantsAccepted = 0; // TODO
          offer.applicantsCompleted = 0; // TODO
          offer.applicantsRefused = 0; // TODO
          sqljocky.Results imageKeyResults =
              await selectImageKeys.execute([offer.offerId.toInt()]);
          await for (sqljocky.Row imageKeyRow in imageKeyResults) {
            if (!offer.hasThumbnailUrl()) {
              offer.thumbnailUrl =
                  _r.makeCloudinaryThumbnailUrl(imageKeyRow[0]);
            }
            offer.coverUrls.add(_r.makeCloudinaryCoverUrl(imageKeyRow[0]));
          }
          // Cache offer for use (is this really necessary?)
          offers[offer.offerId] = offer;
          // Send offer to user
          ts.sendMessage(_dataBusinessOffer, offer.writeToBuffer());
        }
        ts.sendExtend(message);
      } finally {
        await selectImageKeys.close();
      }
    } finally {
      await connection.release();
    }

    NetLoadOffersRes loadOffersRes = new NetLoadOffersRes();
    ts.sendMessage(_netLoadOffersRes, loadOffersRes.writeToBuffer(),
        replying: message);
  }
}
