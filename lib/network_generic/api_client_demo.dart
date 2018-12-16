/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/api_client.dart';
import 'package:inf/network_generic/network_internals.dart';
import 'package:inf_common/inf_common.dart';
import 'package:switchboard/switchboard.dart';
import 'package:synchronized/synchronized.dart';

abstract class ApiClientDemo implements ApiClient, NetworkInternals {
  @override
  bool get demoAllOffersLoading {
    return _demoAllOffersRefreshing;
  }

  final Lock _demoAllOffersLock = Lock();
  bool _demoAllOffersDirty = true;
  bool _demoAllOffersRefreshing = false;
  final Set<Int64> _demoAllOffers = Set<Int64>();
  bool _demoAllOffersSortedDirty = false;
  List<Int64> _demoAllOffersSorted = <Int64>[];

  @override
  void resetDemoAllOffersState() {
    _demoAllOffers.clear();
    _demoAllOffersDirty = true;
  }

  @override
  void markDemoAllOffersDirty() {
    _demoAllOffersDirty = true;
  }

  @override
  Future<void> refreshDemoAllOffers() async {
    await _demoAllOffersLock.synchronized(() async {
      final NetDemoAllOffers listDemoAllOffers = NetDemoAllOffers();
      listDemoAllOffers.freeze();
      await for (TalkMessage message in switchboard.sendStreamRequest(
          'api', 'DEMOAOFF', listDemoAllOffers.writeToBuffer())) {
        if (message.procedureId == 'R_DEMAOF') {
          final NetOffer offer = NetOffer.fromBuffer(message.data)..freeze();
          cacheOffer(offer.offer, false);
          _demoAllOffers.add(offer.offer.offerId);
          _demoAllOffersSortedDirty = true;
          onDemoAllOffersChanged();
        } else {
          channel.unknownProcedure(message);
        }
      }
      _demoAllOffersDirty = false;
    });
  }

  @override
  List<Int64> get demoAllOffers {
    if (_demoAllOffersDirty && !_demoAllOffersRefreshing) {
      _demoAllOffersRefreshing = true;
      () async {
        // Auto refresh
        try {
          await refreshDemoAllOffers();
          _demoAllOffersRefreshing = false;
          onDemoAllOffersChanged();
        } catch (error, stackTrace) {
          log.severe('Error while refreshing demoAllOffers: $error\n$stackTrace');
          Timer(Duration(seconds: 3), () {
            // Timeout for 3 seconds from auto refresh
            _demoAllOffersRefreshing = false;
            onDemoAllOffersChanged();
          });
        }
      }();
    }
    if (_demoAllOffersSortedDirty) {
      _demoAllOffersSorted = _demoAllOffers.toList()
        ..sort((Int64 a, Int64 b) => a.compareTo(b));
      _demoAllOffersSortedDirty = false;
    }
    return _demoAllOffersSorted;
  }
}

/* end of file */
