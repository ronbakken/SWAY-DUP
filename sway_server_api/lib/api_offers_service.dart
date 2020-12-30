/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:inf_server_api/common_account.dart';
import 'package:inf_server_api/common_storage.dart';
import 'package:logging/logging.dart';

import 'package:grpc/grpc.dart' as grpc;
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:http/http.dart' as http;
import 'package:http_client/console.dart' as http_client;

import 'package:sway_common/inf_backend.dart';

class ApiOffersService extends ApiOffersServiceBase {
  final ConfigData config;
  final sqljocky.ConnectionPool accountDb;
  final sqljocky.ConnectionPool proposalDb;
  static final Logger opsLog = Logger('InfOps.ApiOffersService');
  static final Logger devLog = Logger('InfDev.ApiOffersService');

  final http.Client httpClient = http.Client();
  final http_client.Client httpClientClient = http_client.ConsoleClient();

  grpc.ClientChannel backendExploreChannel;
  BackendExploreClient backendExplore;

  ApiOffersService(this.config, this.accountDb, this.proposalDb) {
    final Uri backendExploreUri = Uri.parse(
        Platform.environment['SWAY_BACKEND_EXPLORE'] ??
            config.services.backendExplore);
    backendExploreChannel = grpc.ClientChannel(
      backendExploreUri.host,
      port: backendExploreUri.port,
      options: const grpc.ChannelOptions(
        credentials: grpc.ChannelCredentials.insecure(),
      ),
    );
    backendExplore = BackendExploreClient(backendExploreChannel);
  }

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

    // Insert to explore backend
    final InsertOfferRequest exploreInsertRequest = InsertOfferRequest();
    exploreInsertRequest.offer = offer;
    exploreInsertRequest.senderAccount = account;
    exploreInsertRequest.senderLocation = location;
    await backendExplore.insertOffer(exploreInsertRequest);

    // Get the inserted offer
    final GetOfferRequest exploreRequest = GetOfferRequest();
    exploreRequest.offerId = offer.offerId;
    exploreRequest.receiverAccountId = auth.accountId;
    exploreRequest.state = true;
    exploreRequest.summary = true;
    exploreRequest.detail = true;
    exploreRequest.private = true;
    final GetOfferResponse exploreResponse =
        await backendExplore.getOffer(exploreRequest);
    return exploreResponse.offer;
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

    final ListOffersFromSenderRequest exploreRequest =
        ListOffersFromSenderRequest();
    exploreRequest.accountId = auth.accountId;
    exploreRequest.receiverAccountId = auth.accountId;
    exploreRequest.state = true;
    exploreRequest.summary = true;
    // exploreRequest.detail = false;
    exploreRequest.private = true;
    await for (ListOffersFromSenderResponse exploreResponse
        in backendExplore.listOffersFromSender(exploreRequest)) {
      yield exploreResponse.offer;
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
      throw grpc.GrpcError.permissionDenied('Insufficient account state');
    }
    final GetOfferRequest exploreRequest = GetOfferRequest();
    exploreRequest.offerId = request.offerId;
    exploreRequest.receiverAccountId = auth.accountId;
    exploreRequest.state = true;
    exploreRequest.summary = true;
    exploreRequest.detail = true;
    exploreRequest.private = true;
    final GetOfferResponse exploreResponse =
        await backendExplore.getOffer(exploreRequest);
    return exploreResponse.offer;
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
