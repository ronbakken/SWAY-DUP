/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/api.dart';
import 'package:inf/network_generic/api_internals.dart';
import 'package:inf_common/inf_common.dart';
import 'package:pedantic/pedantic.dart';
import 'package:synchronized/synchronized.dart';
import 'package:grpc/grpc.dart' as grpc;

class _CachedOffer {
  bool loading = false; // Request in progress, cleared on cache
  bool dirty = true; // May re-request on the network anytime, cleared on cache
  DataOffer offer;
  DataOffer fallback;
}

abstract class ApiOffers implements Api, ApiInternals {
  Completer<void> __clientReady = Completer<void>();
  ApiOffersClient _offersClient;
  Future<void> get _clientReady {
    return __clientReady.future;
  }

  StreamSubscription<ApiSessionToken> _sessionSubscription;
  void _onSessionChanged(ApiSessionToken session) {
    if (session == null) {
      if (__clientReady.isCompleted) {
        __clientReady = Completer<void>();
      }
      _offersClient = null;
    } else {
      if (!__clientReady.isCompleted) {
        __clientReady.complete();
      }
      _offersClient = ApiOffersClient(
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
  void initOffers() {
    _sessionSubscription = sessionChanged.listen(_onSessionChanged);
  }

  @override
  void disposeOffers() {
    _sessionSubscription.cancel();
    _sessionSubscription = null;
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  
  final Map<Int64, _CachedOffer> _cachedOffers = <Int64, _CachedOffer>{};

  @override
  bool get offersLoading {
    return _offersRefreshing;
  }

  final Lock _offersLock = Lock();
  bool _offersDirty = true;
  bool _offersRefreshing = false;
  final Set<Int64> _offers = Set<Int64>();
  bool _offersSortedDirty = false;
  List<Int64> _offersSorted = <Int64>[];

  @override
  void cacheOffer(DataOffer offer, bool detail) {
    _CachedOffer cached = _cachedOffers[offer.offerId];
    if (cached == null) {
      cached = _CachedOffer();
      _cachedOffers[offer.offerId] = cached;
    }
    cached.fallback = null;
    // This assumes that detail offers ALWAYS have
    // the state set when they are owned by the current user.
    // It is reasonable to assume this, since only
    // offers received through the explore functionality
    // will be missing state, and such offers can only
    // be from the opposite account type.
    if (detail || (cached.offer == null)) {
      cached.offer = offer;
      cached.dirty = !detail;
    } else {
      // If no detail provided, merge
      final DataTerms terms = DataTerms()
        ..mergeFromMessage(cached.offer.terms)
        ..mergeFromMessage(offer.terms);
      cached.offer = DataOffer()
        ..mergeFromMessage(cached.offer)
        ..mergeFromMessage(offer);
      cached.offer.terms = terms;
      cached.offer.freeze();
    }
    hintProfileOffer(offer);
    hintProposalOffer(offer);
    onOfferChanged(offer.offerId);
  }

  @override
  void hintOfferProposal(DataProposal proposal) {
    _CachedOffer cached = _cachedOffers[proposal.offerId];
    if (cached == null) {
      cached = _CachedOffer();
      _cachedOffers[proposal.offerId] = cached;
    }
    if (cached.offer != null) {
      final DataOffer offer = DataOffer()..mergeFromMessage(cached.offer);
      offer.proposalId = proposal.proposalId;
      cached.offer = offer..freeze();
      cached.dirty = true;
      onOfferChanged(offer.offerId);
    } else if (cached.fallback != null) {
      final DataOffer offer = DataOffer()..mergeFromMessage(cached.fallback);
      offer.proposalId = proposal.proposalId;
      cached.fallback = offer..freeze();
      onOfferChanged(offer.offerId);
    }
  }

  @override
  void resetOffersState() {
    _offers.clear();
    _offersDirty = true;
    _offersSorted.clear();
    _offersSortedDirty = true;
    _cachedOffers.clear();
  }

  @override
  void markOffersDirty() {
    _offersDirty = true;
    _offersSortedDirty = true;
    for (_CachedOffer cached in _cachedOffers.values) {
      cached.dirty = true;
    }
  }

  @override
  void markOfferDirty(Int64 offerId) {
    final _CachedOffer cached = _cachedOffers[offerId];
    if (cached != null) {
      cached.dirty = true;
    }
    onOfferChanged(offerId);
  }

  /// Get an offer, refresh set to true to always get from server, use sparingly to refresh the cache
  @override
  Future<DataOffer> getOffer(Int64 offerId, {bool refresh = true}) async {
    if (!refresh) {
      final _CachedOffer cached = _cachedOffers[offerId];
      if (cached?.offer != null && !cached.dirty) {
        return cached.offer;
      }
    }
    await _clientReady;
    final NetGetOffer request = NetGetOffer();
    request.offerId = offerId;
    final DataOffer offer = (await _offersClient.get(request)..freeze()).offer;
    cacheOffer(offer, true);
    return offer;
  }

  Future<void> _backgroundGetOffer(Int64 offerId, _CachedOffer cached) async {
    if (!cached.loading &&
        (cached.dirty || cached.offer == null) &&
        connected == NetworkConnectionState.ready) {
      cached.loading = true;
      unawaited(getOffer(offerId).then((DataOffer offer) {
        cached.loading = false;
      }).catchError((Object error, StackTrace stackTrace) {
        log.severe('Failed to get offer $offerId: $error');
        Timer(Duration(seconds: 3), () {
          cached.loading = false;
          onOfferChanged(offerId);
        });
      }));
    }
  }

  @override
  DataOffer tryGetOffer(Int64 offerId, {bool detail = true}) {
    if (offerId == Int64.ZERO) {
      return DataOffer();
    }
    _CachedOffer cached = _cachedOffers[offerId];
    if (cached == null) {
      cached = _CachedOffer();
      _cachedOffers[offerId] = cached;
    }
    if (detail || cached.offer == null) {
      _backgroundGetOffer(offerId, cached);
    }
    if (cached.offer != null) {
      return cached.offer;
    }
    if (cached.fallback == null) {
      cached.fallback = DataOffer();
      cached.fallback.offerId = offerId;
    }
    return cached.fallback;
  }

  @override
  Future<DataOffer> createOffer(NetCreateOffer createOfferReq) async {
    await _clientReady;
    final NetOffer response = await _offersClient.create(createOfferReq);
    cacheOffer(response.offer, true);
    _offers.add(response.offer.offerId);
    _offersSortedDirty = true;
    onOffersChanged();
    return response.offer;
  }

  @override
  Future<void> refreshOffers() async {
    await _offersLock.synchronized(() async {
      final NetListOffers listOffers = NetListOffers();
      listOffers.freeze();
      await _clientReady;
      await for (NetOffer response in _offersClient.list(listOffers)) {
        response.offer.freeze();
        cacheOffer(response.offer, false);
        _offers.add(response.offer.offerId);
        _offersSortedDirty = true;
        onOffersChanged();
      }
      _offersDirty = false;
    });
  }

  @override
  List<Int64> get offers {
    if (_offersDirty && !_offersRefreshing) {
      _offersRefreshing = true;
      () async {
        // Auto refresh
        try {
          await refreshOffers();
          _offersRefreshing = false;
          onOffersChanged();
        } catch (error, stackTrace) {
          log.severe('Error while refreshing offers.', error, stackTrace);
          Timer(Duration(seconds: 3), () {
            // Timeout for 3 seconds from auto refresh
            _offersRefreshing = false;
            onOffersChanged();
          });
        }
      }();
    }
    if (_offersSortedDirty) {
      _offersSorted = _offers.toList()
        ..sort((Int64 a, Int64 b) => a.compareTo(b));
      _offersSortedDirty = false;
    }
    return _offersSorted;
  }
}

/* end of file */
