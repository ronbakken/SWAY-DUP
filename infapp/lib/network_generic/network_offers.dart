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

class _CachedOffer {
  bool loading = false; // Request in progress, cleared on cache
  bool dirty = false; // May re-request on the network anytime, cleared on cache
  DataBusinessOffer offer;
  DataBusinessOffer fallback;
}

abstract class NetworkOffers implements NetworkInterface, NetworkInternals {
  Map<Int64, _CachedOffer> _cachedOffers = new Map<Int64, _CachedOffer>();

  @override
  void cacheOffer(DataBusinessOffer offer) {
    _CachedOffer cached = _cachedOffers[offer.offerId];
    if (cached == null) {
      cached = new _CachedOffer();
      _cachedOffers[new Int64(offer.offerId)] = cached;
    }
    cached.fallback = null;
    cached.offer = offer;
    cached.dirty = false;
    hintProfileOffer(offer);
    onOfferChanged(ChangeAction.upsert, new Int64(offer.offerId));
  }

  @override
  void hintOfferProposal(DataApplicant proposal) {
    _CachedOffer cached = _cachedOffers[new Int64(proposal.offerId)];
    if (cached != null) {
      if (cached.offer != null) {
        DataBusinessOffer offer = new DataBusinessOffer()
          ..mergeFromMessage(cached.offer);
        offer.influencerApplicantId = proposal.applicantId;
        cached.offer = offer..freeze();
        cached.dirty = true;
        onOfferChanged(ChangeAction.upsert, new Int64(offer.offerId));
      } else if (cached.fallback != null) {
        DataBusinessOffer offer = new DataBusinessOffer()
          ..mergeFromMessage(cached.fallback);
        offer.influencerApplicantId = proposal.applicantId;
        cached.fallback = offer..freeze();
        onOfferChanged(ChangeAction.upsert, new Int64(offer.offerId));
      }
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

  static int _netGetOfferReq = TalkSocket.encode("GTOFFERR");

  /// Get an offer, refresh set to true to always get from server, use sparingly to refresh the cache
  Future<DataBusinessOffer> getOffer(Int64 offerId,
      {bool refresh = true}) async {
    if (!refresh) {
      _CachedOffer cached = _cachedOffers[offerId];
      if (cached?.offer != null && !cached.dirty) {
        return cached.offer;
      }
    }
    NetGetOfferReq pbReq = new NetGetOfferReq();
    pbReq.offerId = offerId.toInt();
    TalkMessage message =
        await ts.sendRequest(_netGetOfferReq, pbReq.writeToBuffer());
    DataBusinessOffer offer =
        (new NetGetOfferRes()..mergeFromBuffer(message.data)).offer;
    cacheOffer(offer);
    return offer;
  }

  Future<void> _backgroundGetOffer(Int64 offerId, _CachedOffer cached) async {
    if (!cached.loading &&
        (cached.dirty || cached.offer == null) &&
        connected == NetworkConnectionState.Ready) {
      cached.loading = true;
      getOffer(offerId).then((offer) {
        cached.loading = false;
      }).catchError((error, stack) {
        print("[INF] Failed to get offer $offerId: $error");
        new Timer(new Duration(seconds: 3), () {
          cached.loading = false;
          onOfferChanged(ChangeAction.retry, offerId);
        });
      });
    }
  }

  @override
  DataBusinessOffer tryGetOffer(Int64 offerId) {
    if (offerId == Int64.ZERO) {
      return new DataBusinessOffer();
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
      cached.fallback = new DataBusinessOffer();
      cached.fallback.offerId = offerId.toInt();
    }
    return cached.fallback;
  }
}

/* end of file */
