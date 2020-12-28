/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:inf_server_explore/elasticsearch.dart';
import 'package:inf_server_explore/elasticsearch_offer.dart';
import 'package:logging/logging.dart';

import 'package:grpc/grpc.dart' as grpc;

import 'package:sway_common/inf_backend.dart';

class ApiExploreService extends ApiExploreServiceBase {
  final ConfigData config;
  final Elasticsearch elasticsearch;
  static final Logger opsLog = Logger('InfOps.ApiExploreService');
  static final Logger devLog = Logger('InfDev.ApiExploreService');

  ApiExploreService(this.config, this.elasticsearch);

  @override
  Stream<NetOffer> demoAll(
      grpc.ServiceCall call, NetDemoAllOffers request) async* {
    final DataAuth auth = authFromJwtPayload(call);

    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readOnly.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    final dynamic results = await elasticsearch.search('offers', {
      "size": ElasticsearchOffer.kSearchSize,
      "_source": {
        "includes": ElasticsearchOffer.kSummaryFields,
      },
      "query": {
        "bool": {
          "must_not": {
            "term": {
              "sender_account_type": auth.accountType.value,
            }
          }
        }
      },
    });

    final List<dynamic> hits = results['hits']['hits'];
    for (dynamic hit in hits) {
      final Map<String, dynamic> doc = hit['_source'] as Map<String, dynamic>;
      NetOffer response;
      try {
        response = NetOffer();
        response.offer = ElasticsearchOffer.fromJson(config, doc,
            state: true,
            summary: true,
            detail: false,
            offerId: Int64.parseInt(hit['_id']),
            receiver: auth.accountId,
            private: true);
      } catch (error, stackTrace) {
        response = null;
        devLog.severe('Error parsing offer', error, stackTrace);
      }
      if (response != null) {
        yield response;
      }
    }
  }
}

/* end of file */
