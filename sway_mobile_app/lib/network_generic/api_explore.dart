/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:sway_mobile_app/network_generic/api.dart';
import 'package:sway_mobile_app/network_generic/api_internals.dart';
import 'package:inf_common/inf_common.dart';
import 'package:synchronized/synchronized.dart';
import 'package:grpc/grpc.dart' as grpc;

abstract class ApiExplore implements Api, ApiInternals {
  Completer<void> __clientReady = Completer<void>();
  ApiExploreClient _exploreClient;
  Future<void> get _clientReady {
    return __clientReady.future;
  }

  StreamSubscription<ApiSessionToken> _sessionSubscription;
  void _onSessionChanged(ApiSessionToken session) {
    if (session == null) {
      if (__clientReady.isCompleted) {
        __clientReady = Completer<void>();
      }
      _exploreClient = null;
    } else {
      if (!__clientReady.isCompleted) {
        __clientReady.complete();
      }
      _exploreClient = ApiExploreClient(
        session.channel,
        options: grpc.CallOptions(
          metadata: <String, String>{
            'authorization': 'Bearer ${session.token}'
          },
        ),
      );
    }
  }

  @override
  void initExplore() {
    _sessionSubscription = sessionChanged.listen(_onSessionChanged);
  }

  @override
  void disposeExplore() {
    _sessionSubscription.cancel();
    _sessionSubscription = null;
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////

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
  void resetExploreState() {
    _demoAllOffers.clear();
    _demoAllOffersDirty = true;
    _demoAllOffersSorted.clear();
    _demoAllOffersSortedDirty = true;
  }

  @override
  void markExploreDirty() {
    _demoAllOffersDirty = true;
    _demoAllOffersSortedDirty = true;
  }

  @override
  Future<void> refreshDemoAllOffers() async {
    await _demoAllOffersLock.synchronized(() async {
      final NetDemoAllOffers request = NetDemoAllOffers();
      request.freeze();
      await _clientReady;
      await for (NetOffer response in _exploreClient.demoAll(request)) {
        log.fine(response);
        cacheOffer(response.offer, false);
        _demoAllOffers.add(response.offer.offerId);
        _demoAllOffersSortedDirty = true;
        onDemoAllOffersChanged();
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
          log.severe(
              'Error while refreshing demoAllOffers.', error, stackTrace);
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
