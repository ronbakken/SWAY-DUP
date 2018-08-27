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

  RemoteAppBusiness(this._r) {
    _netCreateOfferReq = _r.saferListen("C_OFFERR", GlobalAccountState.GAS_READ_WRITE, true, netCreateOfferReq);
  }

  void dispose() {
     if (_netCreateOfferReq != null) {
      _netCreateOfferReq.cancel();
      _netCreateOfferReq = null;
    }
    _r = null;
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

    if (account.detail.locationId == 0) {
      opsLog.warning("User $accountId has no default location set, cannot create offer");
      ts.sendException("No default location set", message);
      return;
    }

    if (pb.title.length == 0 || pb.description.length < 20 || pb.deliverables.length < 4 || pb.reward.length < 4) {
      opsLog.warning("User $accountId offer parameters not validated");
      ts.sendException("Not validated", message);
      return;
    }

    // Insert offer, not so critical
    int locationId = account.detail.locationId.toInt();
    ts.sendExtend(message);
    String insertOffer = "INSERT INTO `offers`(`account_id`, `title`, `description`, `deliverables`, `reward`, `location_id`) "
      "VALUES (?, ?, ?, ?, ?, ?)";
    sqljocky.Results insertRes = await sql.prepareExecute(insertOffer, [
      account.state.accountId.toInt(),
      pb.title.toString(), pb.description.toString(), 
      pb.deliverables.toString(), pb.reward.toString(),
      locationId
    ]);

    // Verify insertion
    int offerId = insertRes.insertId;
    if (offerId == null || offerId == 0) {
      opsLog.severe("User $accountId offer not inserted");
      ts.sendException("Not inserted", message);
      return;
    }

    // Insert offer images
    for (String imageKey in pb.imageKeys) {
      ts.sendExtend(message);
      // TODO: Verify the image key actually exists and is owned by the user!
      String insertImage = "INSERT INTO `offer_images`(`offer_id`, `image_key`) VALUES (?, ?)";
      await sql.prepareExecute(insertImage, [
        offerId, imageKey.toString()
      ]);
    }

    // Update location `offer_count`, not so critical
    ts.sendExtend(message);
    String updateLocation = "UPDATE `addressbook` SET `offer_count` = (SELECT COUNT(`offer_id`) FROM `offers` WHERE `location_id` = ?) WHERE `location_id` = ?";
    await sql.prepareExecute(updateLocation, [ locationId, locationId ]);

    // Reply success
    NetCreateOfferRes netCreateOfferRes = new NetCreateOfferRes();
    netCreateOfferRes.offerId = offerId;
    ts.sendMessage(_netCreateOfferRes, netCreateOfferRes.writeToBuffer(), replying: message);
  }
}