/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/change.dart';
import 'package:inf/network_generic/api_client.dart';
import 'package:inf/network_generic/network_internals.dart';
import 'package:inf_common/inf_common.dart';
import 'package:switchboard/switchboard.dart';
import 'package:synchronized/synchronized.dart';

class _CachedOffer {
  bool loading = false; // Request in progress, cleared on cache
  bool dirty = true; // May re-request on the network anytime, cleared on cache
  DataOffer offer;
  DataOffer fallback;
}

abstract class ApiClientOffer implements ApiClient, NetworkInternals {
  final Map<Int64, _CachedOffer> _cachedOffers = <Int64, _CachedOffer>{};

  @override
  bool offersLoading = false;

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
      cached.offer = DataOffer()
        ..mergeFromMessage(cached.offer)
        ..mergeFromMessage(offer)
        ..freeze();
    }
    hintProfileOffer(offer);
    hintProposalOffer(offer);
    onOfferChanged(ChangeAction.upsert, offer.offerId);
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
      onOfferChanged(ChangeAction.upsert, offer.offerId);
    } else if (cached.fallback != null) {
      final DataOffer offer = DataOffer()..mergeFromMessage(cached.fallback);
      offer.proposalId = proposal.proposalId;
      cached.fallback = offer..freeze();
      onOfferChanged(ChangeAction.upsert, offer.offerId);
    }
  }

  @override
  void resetOffersState() {
    _offers.clear();
    _offersDirty = true;
    _cachedOffers.clear();
  }

  @override
  void markOffersDirty() {
    _offersDirty = true;
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
    onOfferChanged(ChangeAction.retry, offerId);
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
    final NetGetOffer getOffer = NetGetOffer();
    getOffer.offerId = offerId;
    final TalkMessage res = await switchboard.sendRequest(
        "api", "GETOFFER", getOffer.writeToBuffer());
    final DataOffer offer = (NetOffer()..mergeFromBuffer(res.data)).offer
      ..freeze();
    cacheOffer(offer, true);
    return offer;
  }

  Future<void> _backgroundGetOffer(Int64 offerId, _CachedOffer cached) async {
    if (!cached.loading &&
        (cached.dirty || cached.offer == null) &&
        connected == NetworkConnectionState.ready) {
      cached.loading = true;
      getOffer(offerId).then((offer) {
        cached.loading = false;
      }).catchError((dynamic error, StackTrace stackTrace) {
        log.severe("Failed to get offer $offerId: $error");
        Timer(Duration(seconds: 3), () {
          cached.loading = false;
          onOfferChanged(ChangeAction.retry, offerId);
        });
      });
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
    final TalkMessage res = await switchboard.sendRequest(
        "api", "CREOFFER", createOfferReq.writeToBuffer());
    final NetOffer resPb = NetOffer();
    resPb.mergeFromBuffer(res.data);
    cacheOffer(resPb.offer, true);
    _offers.add(resPb.offer.offerId);
    _offersSortedDirty = true;
    onOffersChanged();
    return resPb.offer;
  }

  @override
  Future<void> refreshOffers() async {
    await _offersLock.synchronized(() async {
      final NetListOffers listOffers = NetListOffers();
      listOffers.freeze();
      await for (TalkMessage message in switchboard.sendStreamRequest(
          'api', 'LISTOFRS', listOffers.writeToBuffer())) {
        if (message.procedureId == 'R_LSTOFR') {
          final NetOffer offer = NetOffer.fromBuffer(message.data)..freeze();
          cacheOffer(offer.offer, false);
          _offers.add(offer.offer.offerId);
          _offersSortedDirty = true;
          onOffersChanged();
        } else {
          channel.unknownProcedure(message);
        }
      }
      _offersDirty = false;
    });
  }

  @override
  Iterable<Int64> get offers {
    if (_offersDirty && !_offersRefreshing) {
      _offersRefreshing = true;
      () async {
        // Auto refresh
        try {
          await refreshOffers();
          _offersRefreshing = false;
        } catch (error, stackTrace) {
          log.severe("Error while refreshing offers: $error\n$stackTrace");
          Timer(Duration(seconds: 3), () {
            // Timeout for 3 seconds from auto refresh
            _offersRefreshing = false;
            onOffersChanged();
          });
        }
      }();
    }
    if (_offersSortedDirty) {
      _offersSorted = _offers.toList()..sort((a, b) => a.compareTo(b));
      _offersSortedDirty = false;
    }
    return _offersSorted;
  }
}

/* end of file */
