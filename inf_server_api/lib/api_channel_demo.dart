/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:inf_server_api/api_channel_offer.dart';
import 'package:inf_server_api/elasticsearch.dart';
import 'package:inf_server_api/elasticsearch_offer.dart';
import 'package:logging/logging.dart';
import 'package:switchboard/switchboard.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;

import 'broadcast_center.dart';
import 'package:inf_common/inf_common.dart';
import 'api_channel.dart';

class ApiChannelDemo {
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

  static final Logger opsLog = Logger('InfOps.ApiChannelDemo');
  static final Logger devLog = Logger('InfDev.ApiChannelDemo');

  ApiChannelDemo(this._r) {
    _r.registerProcedure(
        'DEMOAOFF', GlobalAccountState.readOnly, _netDemoAllOffers);
  }

  void dispose() {
    _r.unregisterProcedure('DEMOAOFF');
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Network messages
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _netDemoAllOffers(TalkMessage message) async {
    devLog.fine('_netDemoAllOffers');
    /*final NetDemoAllOffers listOffers = NetDemoAllOffers()
      ..mergeFromBuffer(message.data)
      ..freeze();*/
    final dynamic results = await elasticsearch.search('offers', {
      "size": ApiChannelOffer.searchSize,
      "_source": {
        "includes": ApiChannelOffer.summaryFields,
      },
      "query": {
        "bool": {
          "must_not": {
            "term": {
              "sender_account_type": account.accountType.value,
            }
          }
        }
      },
    });
    // TODO: Possible to pre-send the total count
    final List<dynamic> hits = results['hits']['hits'];
    for (dynamic hit in hits) {
      final Map<String, dynamic> doc = hit['_source'] as Map<String, dynamic>;
      NetOffer res;
      try {
        res = NetOffer();
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
        channel.replyMessage(message, 'R_DEMAOF', res.writeToBuffer());
      }
    }
    channel.replyEndOfStream(message);
  }
}

/* end of file */
