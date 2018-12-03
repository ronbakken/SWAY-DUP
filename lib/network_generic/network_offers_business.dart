/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:inf_app/network_generic/change.dart';
import 'package:inf_app/network_generic/api_client.dart';
import 'package:inf_app/network_generic/network_internals.dart';
import 'package:inf_common/inf_common.dart';
import 'package:switchboard/switchboard.dart';

abstract class NetworkOffersBusiness implements ApiClient, NetworkInternals {
  @override
  bool offersLoading = false;

  bool _offersLoaded = false;
  Map<Int64, DataOffer> _offers = Map<Int64, DataOffer>();

  void resetOffersBusinessState() {
    _offers.clear();
    _offersLoaded = false;
  }

  void markOffersBusinessDirty() {
    _offersLoaded = false;
  }

  @override
  Future<DataOffer> createOffer(NetCreateOffer createOfferReq) async {
    TalkMessage res =
        await channel.sendRequest("C_OFFERR", createOfferReq.writeToBuffer());
    DataOffer resPb = DataOffer();
    resPb.mergeFromBuffer(res.data);
    cacheOffer(resPb);
    _offers[resPb.offerId] = resPb;
    onOffersBusinessChanged(ChangeAction.add, resPb.offerId);
    return resPb;
  }

  void dataOffer(TalkMessage message) {
    DataOffer pb = DataOffer();
    pb.mergeFromBuffer(message.data);
    if (pb.senderId == account.accountId) {
      cacheOffer(pb);
      // Add received offer to known offers
      _offers[pb.offerId] = pb;
      onOffersBusinessChanged(ChangeAction.add, pb.offerId);
    } else {
      log.fine("Received offer for other account ${pb.senderId}");
    }
  }

  @override
  Future<void> refreshOffers() async {
    /*
    NetLoadOffers loadOffersReq =
        new NetLoadOffers(); // TODO: Specific requests for higher and lower refreshing
    await channel.sendRequest("L_OFFERS",
        loadOffersReq.writeToBuffer()); // TODO: Use response data maybe
        */
  }

  @override
  Map<Int64, DataOffer> get offers {
    if (_offersLoaded == false && connected == NetworkConnectionState.ready) {
      _offersLoaded = true;
      if (account.accountType == AccountType.business) {
        offersLoading = true;
        refreshOffers().catchError((dynamic error, StackTrace stackTrace) {
          log.severe("Failed to get offers: $error");
          Timer(Duration(seconds: 3), () {
            _offersLoaded =
                false; // Not using setState since we don't want to broadcast failure state
          });
        }).whenComplete(() {
          offersLoading = false;
          onOffersBusinessChanged(ChangeAction.refreshAll, Int64.ZERO);
        });
      }
    }
    return _offers;
  }
}

/* end of file */
