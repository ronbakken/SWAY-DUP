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

class _CachedProfile {
  // TODO: Timestamp
  bool loading = false;
  bool dirty = false;
  DataAccount profile;
  DataAccount fallback;
}

abstract class NetworkProfiles implements NetworkInterface, NetworkInternals {
  Map<Int64, _CachedProfile> _cachedProfiles = new Map<Int64, _CachedProfile>();

  @override
  void cacheProfile(DataAccount profile) {
    Int64 accountId = new Int64(profile.state.accountId);
    if (accountId == account.state.accountId) {
      // It's me...
      return;
    }
    if (accountId == 0) {
      // Empty...
      return;
    }
    _CachedProfile cached = _cachedProfiles[accountId];
    if (cached == null) {
      cached = new _CachedProfile();
      _cachedProfiles[accountId] = cached;
    }
    cached.fallback = null;
    cached.profile = profile;
    cached.dirty = false;
    onProfileChanged(ChangeAction.Upsert, accountId);
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
    onProfileChanged(ChangeAction.RefreshAll, Int64.ZERO);
  }

  @override
  DataAccount emptyAccount([Int64 accountId = Int64.ZERO]) {
    DataAccount emptyAccount = new DataAccount();
    emptyAccount.state = new DataAccountState();
    emptyAccount.summary = new DataAccountSummary();
    emptyAccount.detail = new DataAccountDetail();
    emptyAccount.state.accountId = accountId.toInt();
    return emptyAccount;
  }

  @override
  void hintProfileOffer(DataBusinessOffer offer) {
    Int64 accountId = new Int64(offer.accountId);
    if (accountId == Int64.ZERO) {
      return;
    }
    _CachedProfile cached;
    if (!_cachedProfiles.containsKey(accountId)) {
      cached = new _CachedProfile();
      _cachedProfiles[accountId] = cached;
    } else {
      cached = _cachedProfiles[accountId];
    }
    if (cached.profile == null) {
      if (cached.fallback == null ||
          !cached.fallback.summary.hasName() ||
          !cached.fallback.summary.hasLocation() ||
          !cached.fallback.detail.hasLocationId() ||
          !cached.fallback.detail.hasLatitude() ||
          !cached.fallback.detail.hasLongitude()) {
        DataAccount fallback = (cached.fallback == null)
            ? (emptyAccount(accountId))
            : (new DataAccount()..mergeFromMessage(cached.fallback));
        fallback.state.accountType = AccountType.AT_BUSINESS;
        fallback.summary.name = offer.locationName;
        fallback.summary.location = offer.location;
        fallback.detail.locationId = offer.locationId;
        fallback.detail.latitude = offer.latitude;
        fallback.detail.longitude = offer.longitude;
        fallback.freeze();
        cached.fallback = fallback;
        onProfileChanged(ChangeAction.Retry, accountId);
      }
    }
  }

  static int _netLoadPublicProfileReq = TalkSocket.encode("L_PROFIL");
  @override
  Future<DataAccount> getPublicProfile(Int64 accountId, { bool refresh = true }) async {
    if (!refresh) {
      _CachedProfile cached = _cachedProfiles[accountId];
      if (cached?.profile != null && !cached.dirty) {
        return cached.profile;
      }
    }
    print("[INF] Get public profile $accountId");
    if (accountId == account.state.accountId) {
      // It's me...
      return account;
    }
    if (accountId == Int64.ZERO) {
      // Empty...
      return emptyAccount()..freeze();
    }
    if (connected != NetworkConnectionState.Ready) {
      // Offline...
      return tryGetPublicProfile(accountId);
    }
    NetGetAccountReq pbReq = new NetGetAccountReq();
    pbReq.accountId = accountId.toInt();
    TalkMessage message =
        await ts.sendRequest(_netLoadPublicProfileReq, pbReq.writeToBuffer());
    DataAccount profile = new DataAccount();
    profile.mergeFromBuffer(message.data);
    profile.freeze();
    if (new Int64(profile.state.accountId) == accountId) {
      cacheProfile(profile);
    } else {
      print("[INF] Received invalid profile. Critical issue");
      onProfileChanged(ChangeAction.Retry, accountId);
      return emptyAccount(accountId)..freeze();
    }
    return profile;
  }

  @override
  DataAccount tryGetPublicProfile(Int64 accountId) {
    if (accountId == account.state.accountId) {
      // It's me...
      return account;
    }
    if (accountId == Int64.ZERO) {
      // Empty...
      return emptyAccount()..freeze();
    }
    _CachedProfile cached;
    if (!_cachedProfiles.containsKey(accountId)) {
      cached = new _CachedProfile();
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
        connected == NetworkConnectionState.Ready) {
      cached.loading = true;
      getPublicProfile(accountId).then((profile) {
        cached.loading = false;
      }).catchError((error, stack) {
        print("[INF] Failed to get profile: $error, $stack");
        new Timer(new Duration(seconds: 3), () {
          cached.loading = false;
          onProfileChanged(ChangeAction.Retry, accountId);
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
