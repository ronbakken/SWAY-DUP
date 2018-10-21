/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/change.dart';
import 'package:inf/network_generic/network_interface.dart';
import 'package:inf/network_generic/network_internals.dart';
import 'package:inf/protobuf/inf_protobuf.dart';
import 'package:wstalk/wstalk.dart';

abstract class NetworkOffersDemo
    implements NetworkInterface, NetworkInternals {
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
    onOffersDemoChanged(ChangeAction.Upsert, new Int64(pb.offerId));
  }

  static int _netLoadOffersReq = TalkSocket.encode("L_OFFERS");
  @override
  Future<void> refreshDemoAllOffers() async {
    print("refreshDemoAllOffers");
    NetLoadOffersReq loadOffersReq =
        new NetLoadOffersReq(); // TODO: Specific requests for higher and lower refreshing
    Stream<TalkMessage> results = ts.sendStreamRequest(
        _netLoadOffersReq, loadOffersReq.writeToBuffer());
    
    Completer<void> completer = new Completer<void>();
    results.listen(_demoAllBusinessOffer, onDone: () {
      print("refreshDemoAllOffers done");
      completer.complete();
    });
    return completer.future;
    
    
    /*
    // FIXME: 'await for' is no longer working???
    // tracking https://github.com/dart-lang/sdk/issues/34877
    // print(results);
    await for (TalkMessage res in results) {
      _demoAllBusinessOffer(res);
    }
    print("refreshDemoAllOffers done");
    */
    
  }

  @override
  Map<int, DataBusinessOffer> get demoAllOffers {
    // print("demoAllOffers");
    if (_demoAllOffersLoaded == false &&
        connected == NetworkConnectionState.Ready) {
      _demoAllOffersLoaded = true;
      if (account.state.accountType == AccountType.AT_INFLUENCER) {
        demoAllOffersLoading = true;
        refreshDemoAllOffers().catchError((error, stack) {
          print("[INF] Failed to get offers: $error");
          new Timer(new Duration(seconds: 3), () {
            _demoAllOffersLoaded =
                false; // Not using setState since we don't want to broadcast failure state
          });
        }).whenComplete(() {
          demoAllOffersLoading = false;
          onOffersDemoChanged(ChangeAction.RefreshAll, Int64.ZERO);
        });
      }
    }
    return _demoAllOffers;
  }
}

/* end of file */
