/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:async/async.dart';
import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/change.dart';
import 'package:inf/network_generic/network_interface.dart';
import 'package:inf/network_generic/network_internals.dart';
import 'package:inf/protobuf/inf_protobuf.dart';
import 'package:wstalk/wstalk.dart';

abstract class NetworkOffersDemo implements NetworkInterface, NetworkInternals {
  @override
  bool demoAllOffersLoading = false;

  bool _demoAllOffersLoaded = false;
  Map<int, DataBusinessOffer> _demoAllOffers =
      new Map<int, DataBusinessOffer>();

  @override
  void resetOffersDemoState() {
    _demoAllOffers.clear();
    _demoAllOffersLoaded = false;
  }

  @override
  void markOffersDemoDirty() {}

  void _demoAllBusinessOffer(TalkMessage message) {
    DataBusinessOffer pb = new DataBusinessOffer();
    pb.mergeFromBuffer(message.data);
    cacheOffer(pb);
    // Add received offer to known offers
    _demoAllOffers[pb.offerId.toInt()] = pb;
    onOffersDemoChanged(ChangeAction.upsert, new Int64(pb.offerId));
  }

  static int _netLoadOffersReq = TalkSocket.encode("L_OFFERS");
  @override
  Future<void> refreshDemoAllOffers() async {
    log.fine("refreshDemoAllOffers");
    NetLoadOffersReq loadOffersReq =
        new NetLoadOffersReq(); // TODO: Specific requests for higher and lower refreshing
    Stream<TalkMessage> results =
        ts.sendStreamRequest(_netLoadOffersReq, loadOffersReq.writeToBuffer());

    // Workaround for failing "await for"
    StreamQueue<TalkMessage> sq = StreamQueue<TalkMessage>(results);
    while (await sq.hasNext) {
      _demoAllBusinessOffer(await sq.next);
    }

    log.fine("refreshDemoAllOffers done");

    /*
    // FIXME: 'await for' is no longer working???
    // tracking https://github.com/dart-lang/sdk/issues/34877
    // log.fine(results);
    await for (TalkMessage res in results) {
      _demoAllBusinessOffer(res);
    }
    log.fine("refreshDemoAllOffers done");
    */
  }

  @override
  Map<int, DataBusinessOffer> get demoAllOffers {
    // log.fine("demoAllOffers");
    if (_demoAllOffersLoaded == false &&
        connected == NetworkConnectionState.ready) {
      _demoAllOffersLoaded = true;
      if (account.state.accountType == AccountType.AT_INFLUENCER) {
        demoAllOffersLoading = true;
        refreshDemoAllOffers().catchError((error, stack) {
          log.severe("Failed to get offers: $error");
          new Timer(new Duration(seconds: 3), () {
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
