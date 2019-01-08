/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
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

  sqljocky.ConnectionPool get accountDb {
    return _r.accountDb;
  }

  sqljocky.ConnectionPool get proposalDb {
    return _r.proposalDb;
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
    /*
    TODO: Do we need this, really?
    String updateLocation =
        "UPDATE `locations` SET `offer_count` = (SELECT COUNT(`offer_id`) FROM `offers` WHERE `location_id` = ? AND `state` = ${OfferState.open.value} AND `direct` = 0) WHERE `location_id` = ?";
    await accountDb.prepareExecute(updateLocation, [locationId, locationId]);
    */
  }

  //////////////////////////////////////////////////////////////////////////////
  // Network messages
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _netCreateOffer(TalkMessage message) async {
    
  }

  Future<DataOffer> getOffer(Int64 offerId) async {
    dynamic doc = await elasticsearch.getDocument("offers", offerId.toString());
    return ElasticsearchOffer.fromJson(config, doc,
        state: true,
        summary: true,
        detail: true,
        offerId: offerId,
        receiver: accountId,
        private: true);
  }

  Future<void> _netGetOffer(TalkMessage message) async {
    // TODO: Limit fields to used ones.
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

  Future<void> _netListOffers(TalkMessage message) async {
    /* final NetListOffers listOffers = NetListOffers()
      ..mergeFromBuffer(message.data)
      ..freeze(); */
    dynamic results = await elasticsearch.search('offers', {
      "size": ElasticsearchOffer.kSearchSize,
      "_source": {
        "includes": ElasticsearchOffer.kPrivateSummaryFields,
      },
      "query": {
        "term": {
          "sender_account_id": accountId.toInt(),
        }
      },
    });
    // TODO: Possible to pre-send the total count
    final List<dynamic> hits = results['hits']['hits'];
    for (dynamic hit in hits) {
      final Map<String, dynamic> doc = hit['_source'] as Map<String, dynamic>;
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
        devLog.severe('Error parsing offer', error, stackTrace);
      }
      if (res != null) {
        channel.replyMessage(message, 'R_LSTOFR', res.writeToBuffer());
      }
    }
    channel.replyEndOfStream(message);
  }
}

/* end of file */
