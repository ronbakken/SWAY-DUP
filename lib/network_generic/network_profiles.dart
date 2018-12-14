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

class _CachedProfile {
  // TODO: Timestamp
  bool loading = false;
  bool dirty = false;
  DataAccount profile;
  DataAccount fallback;
}

abstract class NetworkProfiles implements ApiClient, NetworkInternals {
  Map<Int64, _CachedProfile> _cachedProfiles = Map<Int64, _CachedProfile>();

  @override
  void cacheProfile(DataAccount profile) {
    Int64 accountId = profile.accountId;
    if (accountId == account.accountId) {
      // It's me...
      return;
    }
    if (accountId == 0) {
      // Empty...
      return;
    }
    _CachedProfile cached = _cachedProfiles[accountId];
    if (cached == null) {
      cached = _CachedProfile();
      _cachedProfiles[accountId] = cached;
    }
    cached.fallback = null;
    cached.profile = profile;
    cached.dirty = false;
    onProfileChanged(accountId);
  }

  @override
  void resetProfilesState() {
    // no-op
  }

  @override
  void markProfilesDirty() {
    _cachedProfiles.values.forEach((cached) {
      cached.dirty = true;
    });
    onProfileChanged(Int64.ZERO);
  }

  @override
  DataAccount emptyAccount([Int64 accountId = Int64.ZERO]) {
    DataAccount emptyAccount = DataAccount();
    emptyAccount.accountId = accountId;
    return emptyAccount;
  }

  @override
  void hintProfileOffer(DataOffer offer) {
    Int64 accountId = offer.senderId;
    if (accountId == Int64.ZERO) {
      return;
    }
    _CachedProfile cached;
    if (!_cachedProfiles.containsKey(accountId)) {
      cached = _CachedProfile();
      _cachedProfiles[accountId] = cached;
    } else {
      cached = _cachedProfiles[accountId];
    }
    if (cached.profile == null) {
      if (cached.fallback == null ||
          !cached.fallback.hasName() ||
          !cached.fallback.hasLocation() ||
          !cached.fallback.hasLocationId() ||
          !cached.fallback.hasLatitude() ||
          !cached.fallback.hasLongitude()) {
        DataAccount fallback = (cached.fallback == null)
            ? (emptyAccount(accountId))
            : (DataAccount()..mergeFromMessage(cached.fallback));
        fallback.accountType = AccountType.business;
        fallback.name = offer.senderName;
        fallback.location = offer.locationAddress;
        fallback.locationId = offer.locationId;
        fallback.latitude = offer.latitude;
        fallback.longitude = offer.longitude;
        fallback.freeze();
        cached.fallback = fallback;
        onProfileChanged(accountId);
      }
    }
  }

  @override
  Future<DataAccount> getPublicProfile(Int64 accountId,
      {bool refresh = true}) async {
    if (!refresh) {
      _CachedProfile cached = _cachedProfiles[accountId];
      if (cached?.profile != null && !cached.dirty) {
        return cached.profile;
      }
    }
    log.info("Get public profile $accountId");
    if (accountId == account.accountId) {
      // It's me...
      return account;
    }
    if (accountId == Int64.ZERO) {
      // Empty...
      return emptyAccount()..freeze();
    }
    if (connected != NetworkConnectionState.ready) {
      // offline...
      return tryGetProfileDetail(accountId);
    }
    NetGetProfile pbReq = NetGetProfile();
    pbReq.accountId = accountId;
    TalkMessage message =
        await switchboard.sendRequest("api", "GETPROFL", pbReq.writeToBuffer());
    NetProfile profile = NetProfile();
    profile.mergeFromBuffer(message.data);
    profile.freeze();
    if (profile.account.accountId == accountId) {
      cacheProfile(profile.account);
    } else {
      log.severe("Received invalid profile. Critical issue");
      onProfileChanged(accountId);
      return emptyAccount(accountId)..freeze();
    }
    return profile.account;
  }

  @override
  DataAccount tryGetProfileSummary(Int64 accountId) {
    // TODO
    return tryGetProfileDetail(accountId);
  }

  @override
  DataAccount tryGetProfileDetail(Int64 accountId) {
    if (accountId == account.accountId) {
      // It's me...
      return account;
    }
    if (accountId == Int64.ZERO) {
      // Empty...
      return emptyAccount()..freeze();
    }
    _CachedProfile cached;
    if (!_cachedProfiles.containsKey(accountId)) {
      cached = _CachedProfile();
      _cachedProfiles[accountId] = cached;
    } else {
      cached = _cachedProfiles[accountId];
    }
    if (cached.profile == null) {
      if (cached.fallback == null) {
        cached.fallback = emptyAccount(accountId)..freeze();
      }
    }
    if ((cached.profile == null || cached.dirty) &&
        !cached.loading &&
        connected == NetworkConnectionState.ready) {
      cached.loading = true;
      getPublicProfile(accountId).then((profile) {
        cached.loading = false;
      }).catchError((dynamic error, StackTrace stackTrace) {
        log.severe("Failed to get profile: $error\n$stackTrace");
        Timer(Duration(seconds: 3), () {
          cached.loading = false;
          onProfileChanged(accountId);
        });
      });
    }
    if (cached.profile != null) {
      return cached.profile;
    }
    return cached.fallback;
  }
}

/* end of file */
