/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:async/async.dart';
import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/change.dart';
import 'package:inf/network_generic/api_client.dart';
import 'package:inf/network_generic/network_internals.dart';
import 'package:inf_common/inf_common.dart';
import 'package:switchboard/switchboard.dart';

abstract class NetworkOffersDemo implements ApiClient, NetworkInternals {
  @override
  bool demoAllOffersLoading = false;

  bool _demoAllOffersLoaded = false;
  Map<int, DataOffer> _demoAllOffers = Map<int, DataOffer>();

  @override
  void resetOffersDemoState() {
    _demoAllOffers.clear();
    _demoAllOffersLoaded = false;
  }

  @override
  void markOffersDemoDirty() {}

  void _demoAllOffer(TalkMessage message) {
    DataOffer pb = DataOffer();
    pb.mergeFromBuffer(message.data);
    cacheOffer(pb, true);
    // Add received offer to known offers
    _demoAllOffers[pb.offerId.toInt()] = pb;
    onOffersDemoChanged(ChangeAction.upsert, pb.offerId);
  }

  @override
  Future<void> refreshDemoAllOffers() async {
    log.fine("refreshDemoAllOffers");
    NetListOffers loadOffersReq =
        NetListOffers(); // TODO: Specific requests for higher and lower refreshing
    Stream<TalkMessage> results =
        channel.sendStreamRequest("L_OFFERS", loadOffersReq.writeToBuffer());

    // Workaround for failing "await for"
    StreamQueue<TalkMessage> sq = StreamQueue<TalkMessage>(results);
    while (await sq.hasNext) {
      _demoAllOffer(await sq.next);
    }

    log.fine("refreshDemoAllOffers done");

    /*
    // FIXME: 'await for' is no longer working???
    // tracking https://github.com/dart-lang/sdk/issues/34877
    // log.fine(results);
    await for (TalkMessage res in results) {
      _demoAllOffer(res);
    }
    log.fine("refreshDemoAllOffers done");
    */
  }

  @override
  Map<int, DataOffer> get demoAllOffers {
    // log.fine("demoAllOffers");
    if (_demoAllOffersLoaded == false &&
        connected == NetworkConnectionState.ready) {
      _demoAllOffersLoaded = true;
      if (account.accountType == AccountType.influencer) {
        demoAllOffersLoading = true;
        refreshDemoAllOffers().catchError((dynamic error, StackTrace stackTrace) {
          log.severe("Failed to get offers: $error");
          Timer(Duration(seconds: 3), () {
            _demoAllOffersLoaded =
                false; // Not using setState since we don't want to broadcast failure state
          });
        }).whenComplete(() {
          demoAllOffersLoading = false;
          onOffersDemoChanged(ChangeAction.refreshAll, Int64.ZERO);
        });
      }
    }
    return _demoAllOffers;
  }
}

/* end of file */
