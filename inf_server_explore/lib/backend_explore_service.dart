/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:inf_server_explore/elasticsearch.dart';
import 'package:inf_server_explore/elasticsearch_offer.dart';
import 'package:pedantic/pedantic.dart';
import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';

import 'package:grpc/grpc.dart' as grpc;

import 'package:inf_common/inf_backend.dart';

class BackendExploreService extends BackendExploreServiceBase {
  final ConfigData config;
  final Elasticsearch elasticsearch;
  static final Logger opsLog = Logger('InfOps.BackendExploreService');
  static final Logger devLog = Logger('InfDev.BackendExploreService');

  final HttpClient _httpClient = HttpClient();

  BackendExploreService(this.config, this.elasticsearch);

  @override
  Future<InsertProfileResponse> insertProfile(
      grpc.ServiceCall call, InsertProfileRequest request) async {
    throw grpc.GrpcError.unimplemented();
  }

  @override
  Future<UpdateProfileResponse> updateProfile(
      grpc.ServiceCall call, UpdateProfileRequest request) async {
    throw grpc.GrpcError.unimplemented();
  }

  @override
  Future<GetProfileResponse> getProfile(
      grpc.ServiceCall call, GetProfileRequest request) async {
    throw grpc.GrpcError.unimplemented();
  }

  @override
  Future<InsertOfferResponse> insertOffer(
      grpc.ServiceCall call, InsertOfferRequest request) async {
    final dynamic doc = ElasticsearchOffer.toJson(
      config,
      request.offer,
      sender: request.senderAccount,
      location: request.senderLocation,
      senderAccountType: request.senderAccount.accountType,
      create: true,
      modify: false,
      sessionId: request.senderAccount.sessionId,
    );
    devLog.finest(doc);
    await elasticsearch.putDocument('offers', request.offer.offerId.toString(), doc);
    final InsertOfferResponse response = InsertOfferResponse();
    return response;
  }

  @override
  Future<UpdateOfferResponse> updateOffer(
      grpc.ServiceCall call, UpdateOfferRequest request) async {
    throw grpc.GrpcError.unimplemented();
  }

  @override
  Future<GetOfferResponse> getOffer(
      grpc.ServiceCall call, GetOfferRequest request) async {
    // TODO: Fetch only the requested fields
    final dynamic doc =
        await elasticsearch.getDocument('offers', request.offerId.toString());
    final GetOfferResponse response = GetOfferResponse();
    response.offer = NetOffer();
    response.offer.state = request.state;
    response.offer.summary = request.summary;
    response.offer.detail = request.detail;
    response.offer.offer = ElasticsearchOffer.fromJson(
      config,
      doc,
      state: request.state,
      summary: request.summary,
      detail: request.detail,
      offerId: request.offerId,
      receiver: request.receiverAccountId,
      private: request.private,
    );
    return response;
  }

  @override
  Stream<ListOffersFromSenderResponse> listOffersFromSender(
      grpc.ServiceCall call, ListOffersFromSenderRequest request) async* {
    final dynamic query = {
      "size": ElasticsearchOffer.kSearchSize,
      "query": {
        "term": {
          "sender_account_id": request.accountId.toInt(),
        }
      },
    };
    if (!request.detail) {
      // TODO: Also filter detail fields
      query['_source'] = {
        "includes": ElasticsearchOffer.kPrivateSummaryFields,
      };
    }
    final dynamic results = await elasticsearch.search('offers', query);
    final List<dynamic> hits = results['hits']['hits'];
    for (dynamic hit in hits) {
      final Map<String, dynamic> doc = hit['_source'] as Map<String, dynamic>;
      NetOffer result;
      try {
        result = NetOffer();
        result.offer = ElasticsearchOffer.fromJson(config, doc,
            state: request.state,
            summary: request.summary,
            detail: request.detail,
            offerId: Int64.parseInt(hit['_id']),
            receiver: request.receiverAccountId,
            private: request.private);
        result.state = request.state;
        result.summary = request.summary;
        result.detail = request.detail;
      } catch (error, stackTrace) {
        result = null;
        devLog.severe('Error parsing offer', error, stackTrace);
      }
      if (result != null) {
        final ListOffersFromSenderResponse response = ListOffersFromSenderResponse();
        response.offer = result;
        yield response;
      }
    }
  }
}

/* end of file */
