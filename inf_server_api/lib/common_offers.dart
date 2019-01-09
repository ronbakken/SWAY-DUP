/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'package:fixnum/fixnum.dart';
import 'package:inf_common/inf_common.dart';
import 'package:inf_server_api/elasticsearch.dart';
import 'package:inf_server_api/elasticsearch_offer.dart';

Future<DataOffer> getOffer(ConfigData config, Elasticsearch elasticsearch, Int64 offerId, Int64 receiverAccountId) async {
  final dynamic doc = await elasticsearch.getDocument('offers', offerId.toString());
  return ElasticsearchOffer.fromJson(config, doc,
      state: true,
      summary: true,
      detail: true,
      offerId: offerId,
      receiver: receiverAccountId,
      private: true);
}

/* end of file */
