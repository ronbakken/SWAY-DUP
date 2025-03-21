/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:sway_mobile_app/network_generic/api.dart';
import 'package:sway_mobile_app/network_generic/api_internals.dart';
import 'package:sway_common/inf_common.dart';
import 'package:grpc/grpc.dart' as grpc;

class _CachedProfile {
  // TODO: Timestamp
  bool loading = false;
  bool dirty = false;
  DataAccount profile;
  DataAccount fallback;
}

abstract class ApiProfiles implements Api, ApiInternals {
  Completer<void> __clientReady = Completer<void>();
  ApiProfilesClient _profilesClient;
  Future<void> get _clientReady {
    return __clientReady.future;
  }

  StreamSubscription<ApiSessionToken> _sessionSubscription;
  void _onSessionChanged(ApiSessionToken session) {
    if (session == null) {
      if (__clientReady.isCompleted) {
        __clientReady = Completer<void>();
      }
      _profilesClient = null;
    } else {
      if (!__clientReady.isCompleted) {
        __clientReady.complete();
      }
      _profilesClient = ApiProfilesClient(
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
  void initProfiles() {
    _sessionSubscription = sessionChanged.listen(_onSessionChanged);
  }

  @override
  void disposeProfiles() {
    _sessionSubscription.cancel();
    _sessionSubscription = null;
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////

  final Map<Int64, _CachedProfile> _cachedProfiles = <Int64, _CachedProfile>{};

  @override
  void cacheProfile(DataAccount profile) {
    final Int64 accountId = profile.accountId;
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
    for (_CachedProfile cached in _cachedProfiles.values) {
      cached.dirty = true;
    }
    onProfileChanged(Int64.ZERO);
  }

  @override
  DataAccount emptyAccount([Int64 accountId = Int64.ZERO]) {
    final DataAccount emptyAccount = DataAccount();
    emptyAccount.accountId = accountId;
    return emptyAccount;
  }

  @override
  void hintProfileOffer(DataOffer offer) {
    final Int64 accountId = offer.senderAccountId;
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
        final DataAccount fallback = (cached.fallback == null)
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
      final _CachedProfile cached = _cachedProfiles[accountId];
      if (cached?.profile != null && !cached.dirty) {
        return cached.profile;
      }
    }
    log.info('Get public profile $accountId');
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
    await _clientReady;
    final NetGetProfile request = NetGetProfile();
    request.accountId = accountId;
    final NetProfile profile = await _profilesClient.get(request)
      ..freeze();
    if (profile.account.accountId == accountId) {
      cacheProfile(profile.account);
    } else {
      log.severe('Received invalid profile $accountId. Critical issue');
      onProfileChanged(accountId);
      return emptyAccount(accountId)..freeze();
    }
    return profile.account;
  }

  @override
  DataAccount tryGetProfileSummary(Int64 accountId) {
    // TODO: Summary edition
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
      cached.fallback ??= emptyAccount(accountId)..freeze();
    }
    if ((cached.profile == null || cached.dirty) &&
        !cached.loading &&
        connected == NetworkConnectionState.ready) {
      cached.loading = true;
      getPublicProfile(accountId).then((DataAccount profile) {
        cached.loading = false;
      }).catchError((Object error, StackTrace stackTrace) {
        log.severe('Failed to get profile.', error, stackTrace);
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
