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

class _CachedOffer {
  bool loading = false; // Request in progress, cleared on cache
  bool dirty = false; // May re-request on the network anytime, cleared on cache
  DataOffer offer;
  DataOffer fallback;
}

abstract class NetworkOffers implements ApiClient, NetworkInternals {
  Map<Int64, _CachedOffer> _cachedOffers = new Map<Int64, _CachedOffer>();

  @override
  void cacheOffer(DataOffer offer) {
    _CachedOffer cached = _cachedOffers[offer.offerId];
    if (cached == null) {
      cached = new _CachedOffer();
      _cachedOffers[offer.offerId] = cached;
    }
    cached.fallback = null;
    cached.offer = offer;
    cached.dirty = false;
    hintProfileOffer(offer);
    hintProposalOffer(offer);
    onOfferChanged(ChangeAction.upsert, offer.offerId);
  }

  @override
  void hintOfferProposal(DataProposal proposal) {
    _CachedOffer cached = _cachedOffers[proposal.offerId];
    if (cached == null) {
      cached = new _CachedOffer();
      _cachedOffers[proposal.offerId] = cached;
    }
    if (cached.offer != null) {
      DataOffer offer = new DataOffer()..mergeFromMessage(cached.offer);
      offer.proposalId = proposal.proposalId;
      cached.offer = offer..freeze();
      cached.dirty = true;
      onOfferChanged(ChangeAction.upsert, offer.offerId);
    } else if (cached.fallback != null) {
      DataOffer offer = new DataOffer()..mergeFromMessage(cached.fallback);
      offer.proposalId = proposal.proposalId;
      cached.fallback = offer..freeze();
      onOfferChanged(ChangeAction.upsert, offer.offerId);
    }
  }

  @override
  void resetOffersState() {}

  @override
  void markOffersDirty() {
    _cachedOffers.values.forEach((cached) {
      cached.dirty = true;
    });
  }

  void markOfferDirty(Int64 offerId) {
    _CachedOffer cached = _cachedOffers[offerId];
    if (cached != null) {
      cached.dirty = true;
    }
    onOfferChanged(ChangeAction.retry, offerId);
  }

  /// Get an offer, refresh set to true to always get from server, use sparingly to refresh the cache
  Future<DataOffer> getOffer(Int64 offerId, {bool refresh = true}) async {
    if (!refresh) {
      _CachedOffer cached = _cachedOffers[offerId];
      if (cached?.offer != null && !cached.dirty) {
        return cached.offer;
      }
    }
    NetGetOfferReq pbReq = new NetGetOfferReq();
    pbReq.offerId = offerId;
    TalkMessage message =
        await channel.sendRequest("GTOFFERR", pbReq.writeToBuffer());
    DataOffer offer =
        (new NetGetOfferRes()..mergeFromBuffer(message.data)).offer;
    cacheOffer(offer);
    return offer;
  }

  Future<void> _backgroundGetOffer(Int64 offerId, _CachedOffer cached) async {
    if (!cached.loading &&
        (cached.dirty || cached.offer == null) &&
        connected == NetworkConnectionState.ready) {
      cached.loading = true;
      getOffer(offerId).then((offer) {
        cached.loading = false;
      }).catchError((error, stack) {
        log.severe("Failed to get offer $offerId: $error");
        new Timer(new Duration(seconds: 3), () {
          cached.loading = false;
          onOfferChanged(ChangeAction.retry, offerId);
        });
      });
    }
  }

  @override
  DataOffer tryGetOffer(Int64 offerId) {
    if (offerId == Int64.ZERO) {
      return new DataOffer();
    }
    _CachedOffer cached = _cachedOffers[offerId];
    if (cached == null) {
      cached = new _CachedOffer();
      _cachedOffers[offerId] = cached;
    }
    _backgroundGetOffer(offerId, cached);
    if (cached.offer != null) {
      return cached.offer;
    }
    if (cached.fallback == null) {
      cached.fallback = new DataOffer();
      cached.fallback.offerId = offerId;
    }
    return cached.fallback;
  }
}

/* end of file */
