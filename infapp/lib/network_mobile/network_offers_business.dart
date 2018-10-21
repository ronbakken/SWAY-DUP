/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/change.dart';
import 'package:inf/network_mobile/network_interface.dart';
import 'package:inf/network_mobile/network_internals.dart';
import 'package:inf/protobuf/inf_protobuf.dart';
import 'package:wstalk/wstalk.dart';

abstract class NetworkOffersBusiness
    implements NetworkInterface, NetworkInternals {
  @override
  bool offersLoading = false;

  bool _offersLoaded = false;
  Map<int, DataBusinessOffer> _offers = new Map<int, DataBusinessOffer>();

  void resetOffersBusinessState() {
    _offers.clear();
    _offersLoaded = false;
  }

  void markOffersBusinessDirty() {
    _offersLoaded = false;
  }

  static int _netCreateOfferReq = TalkSocket.encode("C_OFFERR");
  @override
  Future<DataBusinessOffer> createOffer(
      NetCreateOfferReq createOfferReq) async {
    TalkMessage res = await ts.sendRequest(
        _netCreateOfferReq, createOfferReq.writeToBuffer());
    DataBusinessOffer resPb = new DataBusinessOffer();
    resPb.mergeFromBuffer(res.data);
    cacheOffer(resPb);
    _offers[resPb.offerId.toInt()] = resPb;
    onOffersBusinessChanged(ChangeAction.New, new Int64(resPb.offerId));
    return resPb;
  }

  void dataBusinessOffer(TalkMessage message) {
    DataBusinessOffer pb = new DataBusinessOffer();
    pb.mergeFromBuffer(message.data);
    if (pb.accountId == account.state.accountId) {
      cacheOffer(pb);
      // Add received offer to known offers
      _offers[pb.offerId.toInt()] = pb;
      onOffersBusinessChanged(ChangeAction.New, new Int64(pb.offerId));
    } else {
      print("[INF] Received offer for other account ${pb.accountId}");
    }
  }

  static int _netLoadOffersReq = TalkSocket.encode("L_OFFERS");
  @override
  Future<void> refreshOffers() async {
    NetLoadOffersReq loadOffersReq =
        new NetLoadOffersReq(); // TODO: Specific requests for higher and lower refreshing
    await ts.sendRequest(_netLoadOffersReq,
        loadOffersReq.writeToBuffer()); // TODO: Use response data maybe
  }

  @override
  Map<int, DataBusinessOffer> get offers {
    if (_offersLoaded == false && connected == NetworkConnectionState.Ready) {
      _offersLoaded = true;
      if (account.state.accountType == AccountType.AT_BUSINESS) {
        offersLoading = true;
        refreshOffers().catchError((error, stack) {
          print("[INF] Failed to get offers: $error");
          new Timer(new Duration(seconds: 3), () {
            _offersLoaded =
                false; // Not using setState since we don't want to broadcast failure state
          });
        }).whenComplete(() {
          offersLoading = false;
          onOffersBusinessChanged(ChangeAction.RefreshAll, Int64.ZERO);
        });
      }
    }
    return _offers;
  }
}

/* end of file */
