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

class _CachedAccount {
  // TODO: Timestamp
  bool loading = false;
  bool dirty = false;
  DataAccount account;
  DataAccount fallback;
}

abstract class NetworkProfiles implements NetworkInterface, NetworkInternals {
  Map<Int64, _CachedAccount> _cachedAccounts = new Map<Int64, _CachedAccount>();

  void _cacheAccount(DataAccount account) {
    Int64 accountId = new Int64(account.state.accountId);
    if (accountId == this.account.state.accountId) {
      // It's me...
      return;
    }
    if (accountId == 0) {
      // Empty...
      return;
    }
    _CachedAccount cached = _cachedAccounts[accountId];
    if (cached == null) {
      cached = new _CachedAccount();
      _cachedAccounts[accountId] = cached;
    }
    cached.fallback = null;
    cached.account = account;
    cached.dirty = false;
    onProfileChanged(ChangeAction.Upsert, accountId);
  }

  void markCachedAccountsDirty() {
    _cachedAccounts.values.forEach((cached) {
      cached.dirty = true;
    });
  }

  DataAccount emptyAccount([Int64 accountId = Int64.ZERO]) {
    DataAccount emptyAccount = new DataAccount();
    emptyAccount.state = new DataAccountState();
    emptyAccount.summary = new DataAccountSummary();
    emptyAccount.detail = new DataAccountDetail();
    emptyAccount.state.accountId = accountId.toInt();
    return emptyAccount;
  }

  void profileFallbackHint(DataBusinessOffer offer) {
    Int64 accountId = new Int64(offer.accountId);
    if (accountId == new Int64(0)) {
      return;
    }
    _CachedAccount cached;
    if (!_cachedAccounts.containsKey(accountId)) {
      cached = new _CachedAccount();
      _cachedAccounts[accountId] = cached;
    } else {
      cached = _cachedAccounts[accountId];
    }
    if (cached.account == null) {
      if (cached.fallback == null ||
          !cached.fallback.summary.hasName() ||
          !cached.fallback.summary.hasLocation() ||
          !cached.fallback.detail.hasLocationId() ||
          !cached.fallback.detail.hasLatitude() ||
          !cached.fallback.detail.hasLongitude()) {
        DataAccount fallback = (cached.fallback == null) ? (emptyAccount(accountId)) : (new DataAccount()..mergeFromMessage(cached.fallback));
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
  Future<DataAccount> getPublicProfile(Int64 accountId) async {
    print("[INF] Get public profile $accountId");
    if (accountId == this.account.state.accountId) {
      // It's me...
      return this.account;
    }
    if (accountId == new Int64(0)) {
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
    DataAccount account = new DataAccount();
    account.mergeFromBuffer(message.data);
    account.freeze();
    if (new Int64(account.state.accountId) == accountId) {
      _cacheAccount(account);
    } else {
      print("[INF] Received invalid profile. Critical issue");
      return emptyAccount(accountId)..freeze();
    }
    return account;
  }

  @override
  DataAccount tryGetPublicProfile(Int64 accountId) {
    if (accountId == this.account.state.accountId) {
      // It's me...
      return this.account;
    }
    if (accountId == new Int64(0)) {
      // Empty...
      return emptyAccount()..freeze();
    }
    _CachedAccount cached;
    if (!_cachedAccounts.containsKey(accountId)) {
      cached = new _CachedAccount();
      _cachedAccounts[accountId] = cached;
    } else {
      cached = _cachedAccounts[accountId];
    }
    if (cached.account == null) {
      if (cached.fallback == null) {
        cached.fallback = emptyAccount(accountId)..freeze();
      }
    }
    if ((cached.account == null || cached.dirty) &&
        !cached.loading &&
        connected == NetworkConnectionState.Ready) {
      cached.loading = true;
      getPublicProfile(accountId).then((account) {
        cached.loading = false;
      }).catchError((error, stack) {
        print("[INF] Failed to get account: $error, $stack");
        new Timer(new Duration(seconds: 3), () {
          cached.loading = false;
          onProfileChanged(ChangeAction.Retry, accountId);
        });
      });
    }
    if (cached.account != null) {
      return cached.account;
    }
    return cached.fallback;
  }
}

/* end of file */
