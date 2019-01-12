/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:inf_server_api/common_account.dart';
import 'package:inf_server_api/common_storage.dart';
import 'package:inf_server_api/elasticsearch.dart';
import 'package:inf_server_api/elasticsearch_offer.dart';
import 'package:logging/logging.dart';

import 'package:grpc/grpc.dart' as grpc;
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:http/http.dart' as http;
import 'package:http_client/console.dart' as http_client;

import 'package:inf_common/inf_backend.dart';

class ApiOffersService extends ApiOffersServiceBase {
  final ConfigData config;
  final sqljocky.ConnectionPool accountDb;
  final sqljocky.ConnectionPool proposalDb;
  final Elasticsearch elasticsearch;
  static final Logger opsLog = Logger('InfOps.ApiOffersService');
  static final Logger devLog = Logger('InfDev.ApiOffersService');

  final http.Client httpClient = http.Client();
  final http_client.Client httpClientClient = http_client.ConsoleClient();

  ApiOffersService(
      this.config, this.accountDb, this.proposalDb, this.elasticsearch);

  String _makeImageUrl(String template, String key) {
    final int lastIndex = key.lastIndexOf('.');
    final String keyNoExt = lastIndex > 0 ? key.substring(0, lastIndex) : key;
    return template.replaceAll('{key}', key).replaceAll('{keyNoExt}', keyNoExt);
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<NetOffer> create(grpc.ServiceCall call, NetCreateOffer request) async {
    final DataAuth auth = authFromJwtPayload(call);
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readWrite.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    final DataAccount account =
        await fetchSessionAccount(config, accountDb, auth.sessionId);
    if (account.accountId != auth.accountId) {
      throw grpc.GrpcError.dataLoss();
    }

    if (!request.hasOffer()) {
      opsLog.warning(
          'User ${auth.accountId} did not include an offer in the offer creation message, cannot request offer.');
      throw grpc.GrpcError.invalidArgument('Missing offer parameter.');
    }

    final DataOffer offer = request.offer;
    final Int64 locationId =
        offer.locationId == Int64.ZERO ? account.locationId : offer.locationId;
    if (locationId == Int64.ZERO) {
      opsLog.warning('Location not specified.');
      throw grpc.GrpcError.invalidArgument('Location not specified.');
    }

    if (offer.title.isEmpty ||
        offer.description.length < 12 ||
        offer.terms.deliverablesDescription.length < 4 ||
        offer.terms.rewardItemOrServiceDescription.length < 4) {
      opsLog.warning('User ${auth.accountId} offer parameters not validated.');
      throw grpc.GrpcError.invalidArgument('Parameters not validated.');
    }

    if (offer.coverKeys.isEmpty) {
      opsLog.warning('Missing cover key.');
      throw grpc.GrpcError.invalidArgument('Missing cover key.');
    }

    offer.senderAccountId = account.accountId;
    offer.senderAccountType = account.accountType;
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
    final DataLocation location = await fetchLocationSummaryFromSql(
        accountDb,
        locationId,
        account.accountId,
        account.accountType == AccountType.business);
    offer.locationId = locationId;
    if (location == null) {
      opsLog.warning('Location invalid.');
      throw grpc.GrpcError.failedPrecondition('Location invalid.');
    }

    // Fetch blurred images
    for (String coverKey in offer.coverKeys) {
      offer.coversBlurred.add(await downloadData(httpClientClient,
          _makeImageUrl(config.services.galleryCoverBlurredUrl, coverKey)));
    }

    // Thumbnail
    if (offer.thumbnailKey.isEmpty) {
      offer.thumbnailKey = offer.coverKeys[0];
    }
    offer.thumbnailBlurred = await downloadData(
        httpClientClient,
        _makeImageUrl(
            config.services.galleryThumbnailBlurredUrl, offer.thumbnailKey));

    // Insert offer, not so critical
    const String insertOffer =
        'INSERT INTO `offers`(`sender_account_id`, `sender_account_type`, `sender_session_id`, `location_id`, `state`, `state_reason`) '
        'VALUES (?, ?, ?, ?, ?, ?)';
    final sqljocky.Results insertResults =
        await proposalDb.prepareExecute(insertOffer, <dynamic>[
      offer.senderAccountId,
      offer.senderAccountType.value,
      account.sessionId,
      offer.locationId,
      offer.state.value,
      offer.stateReason.value,
    ]);

    // Verify insertion
    final Int64 offerId = Int64(insertResults.insertId);
    if (offerId == Int64.ZERO) {
      opsLog.severe('User ${auth.accountId} offer not inserted.');
      throw grpc.GrpcError.internal('Not inserted.');
    }

    offer.offerId = offerId;

    // Update location `offer_count`, not so critical
    // await updateLocationOfferCount(offer.locationId);

    // Insert Elasticsearch document
    final dynamic doc = ElasticsearchOffer.toJson(
      config,
      offer,
      sender: account,
      location: location,
      senderAccountType: account.accountType,
      create: true,
      modify: false,
      sessionId: account.sessionId,
    );
    devLog.finest(doc);
    await elasticsearch.putDocument('offers', offer.offerId.toString(), doc);

    final NetOffer result = NetOffer();
    result.offer = ElasticsearchOffer.fromJson(config, doc,
        state: true,
        summary: true,
        detail: true,
        offerId: offer.offerId,
        receiver: auth.accountId,
        private: true);
    result.state = true;
    result.summary = true;
    result.detail = true;
    return result;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Stream<NetOffer> list(grpc.ServiceCall call, NetListOffers request) async* {
    final DataAuth auth = authFromJwtPayload(call);
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readOnly.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    final dynamic results = await elasticsearch.search('offers', {
      "size": ElasticsearchOffer.kSearchSize,
      "_source": {
        "includes": ElasticsearchOffer.kPrivateSummaryFields,
      },
      "query": {
        "term": {
          "sender_account_id": auth.accountId.toInt(),
        }
      },
    });
    final List<dynamic> hits = results['hits']['hits'];
    for (dynamic hit in hits) {
      final Map<String, dynamic> doc = hit['_source'] as Map<String, dynamic>;
      NetOffer result;
      try {
        result = NetOffer();
        result.offer = ElasticsearchOffer.fromJson(config, doc,
            state: true,
            summary: true,
            detail: false,
            offerId: Int64.parseInt(hit['_id']),
            receiver: auth.accountId,
            private: true);
      } catch (error, stackTrace) {
        result = null;
        devLog.severe('Error parsing offer', error, stackTrace);
      }
      if (result != null) {
        yield result;
      }
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<NetOffer> get(grpc.ServiceCall call, NetGetOffer request) async {
    final DataAuth auth = authFromJwtPayload(call);
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readOnly.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    final dynamic doc =
        await elasticsearch.getDocument('offers', request.offerId.toString());
    final NetOffer result = NetOffer();
    result.offer = ElasticsearchOffer.fromJson(config, doc,
        state: true,
        summary: true,
        detail: true,
        offerId: request.offerId,
        receiver: auth.accountId,
        private: true);
    result.state = true;
    result.summary = true;
    result.detail = true;
    return result;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<NetReport> report(
      grpc.ServiceCall call, NetReportOffer request) async {
    final DataAuth auth = authFromJwtPayload(call);
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readWrite.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    throw grpc.GrpcError.unimplemented();
  }
}

/* end of file */
