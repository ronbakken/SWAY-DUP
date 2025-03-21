/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

/*

Multi account client, used by the client application to switch accounts.

*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sway_common/inf_common.dart';
import 'package:sway_mobile_app/network_generic/multi_account_store.dart';
export 'package:sway_mobile_app/network_generic/multi_account_store.dart';

class _LocalAccountDataImpl implements LocalAccountData {
  @override
  String domain;

  @override
  int localId = 0;

  @override
  Int64 sessionId = Int64.ZERO;

  @override
  Int64 accountId = Int64.ZERO;

  @override
  AccountType accountType = AccountType.unknown;

  @override
  String name;

  @override
  String blurredAvatarUrl;

  @override
  String avatarUrl;
}

class _LocalDomainDataImpl {
  String domain;
  int nextLocalId;
  final Map<Int64, _LocalAccountDataImpl> accounts =
      <Int64, _LocalAccountDataImpl>{};
  final Map<int, _LocalAccountDataImpl> local = <int, _LocalAccountDataImpl>{};
}

class MultiAccountStoreImpl implements MultiAccountStore {
  SharedPreferences _prefs;
  final Map<String, _LocalDomainDataImpl> _domains =
      <String, _LocalDomainDataImpl>{};
  final Random _random = Random.secure();
  final String _startupDomain;

  _LocalAccountDataImpl _current;

  /// Fired anytime any of the accounts changed (add, remove, or update.)
  @override
  Stream<void> get onAccountsChanged {
    return _onAccountsChanged.stream;
  }

  /// Fired anytime a change in accounts is requested.
  /// This is handled by the network manager.
  /// Does not mean the current account has actually changed yet!
  @override
  Stream<LocalAccountData> get onSwitchAccount {
    return _onSwitchAccount.stream;
  }

  @override
  List<LocalAccountData> get accounts {
    return getLocalAccounts();
  }

  @override
  LocalAccountData get current {
    return _current;
  }

  final StreamController<void> _onAccountsChanged =
      StreamController<void>.broadcast(sync: true);

  final StreamController<LocalAccountData> _onSwitchAccount =
      StreamController<LocalAccountData>.broadcast(sync: true);

  MultiAccountStoreImpl(this._startupDomain);

  @override
  Future<void> initialize() async {
    assert(_prefs == null);
    assert(_startupDomain != null);
    _prefs = await SharedPreferences.getInstance();

    // Initialize local accounts list
    await _initLocalData(_startupDomain);
    _onAccountsChanged.add(null);

    // Initialize current account
    int localId = getLastUsed(_startupDomain);
    _current = getLocal(_startupDomain, localId);
    if (_current == null) {
      localId = _createAccount(_startupDomain);
      _current = getLocal(_startupDomain, localId);
      _setLastUsed(_startupDomain, localId);
    }
    assert(_current != null);
    _onSwitchAccount.add(_current);
    /*
    _domain = _startupDomain;
    _localId = widget.store.getLastUsed(_startupDomain);
    _accountId = widget.store.getLocal(domain, _localId).accountId;
    */
  }

  @override
  Future<void> dispose() async {
    await _onAccountsChanged.close();
    await _onSwitchAccount.close();
  }

  @override
  Uint8List getDeviceToken() {
    String deviceTokenStr;
    try {
      deviceTokenStr = _prefs.getString('device_token');
    } catch (_, __) {
      // empty
    }
    Uint8List deviceToken;
    if (deviceTokenStr == null || deviceTokenStr.isEmpty) {
      deviceToken = Uint8List(32);
      for (int i = 0; i < deviceToken.length; ++i) {
        deviceToken[i] = _random.nextInt(256);
      }
      deviceTokenStr = base64.encode(deviceToken);
      _prefs.setString('device_token', deviceTokenStr);
    } else {
      deviceToken = base64.decode(deviceTokenStr);
    }
    return deviceToken;
  }

  Future<void> _initLocalData(String startupDomain) async {
    List<String> localDomains;
    try {
      localDomains = _prefs.getStringList('known_domains') ?? <String>[];
    } catch (error) {
      localDomains = <String>[];
    }
    final Directory tempDir = await getTemporaryDirectory();
    for (String domain in localDomains.toList()) {
      // NOTE: Domains are only switchable to locally when their config is saved, so verify them
      final File domainConfig = File('$tempDir/${domain}_config.bin');
      if (!await domainConfig.exists()) {
        localDomains.remove(domain);
      }
    }
    if (!localDomains.contains(startupDomain)) {
      // The startup domain config is in the APK
      localDomains.add(startupDomain);
      await _prefs.setStringList('known_domains', localDomains);
    }
    for (String domain in localDomains) {
      final _LocalDomainDataImpl domainData = _LocalDomainDataImpl();
      domainData.domain = domain;
      try {
        domainData.nextLocalId = _prefs.getInt('${domain}_next_id') ?? 1;
      } catch (error) {
        domainData.nextLocalId = 1;
      }
      for (int localId = 1; localId < domainData.nextLocalId; ++localId) {
        final _LocalAccountDataImpl accountData = _LocalAccountDataImpl();
        accountData.domain = domain;
        accountData.localId = localId;
        try {
          accountData.sessionId = Int64.parseInt(
                  _prefs.getString('${domain}_${localId}_session_id') ?? '0') ??
              Int64.ZERO;
        } catch (_, __) {
          // empty
        }
        if (accountData.sessionId != null &&
            accountData.sessionId != Int64.ZERO) {
          try {
            accountData.accountId = Int64.parseInt(
                    _prefs.getString('${domain}_${localId}_account_id') ??
                        '0') ??
                Int64.ZERO;
            accountData.accountType = AccountType.valueOf(
                _prefs.getInt('${domain}_${localId}_account_type') ?? 0);
            accountData.name = _prefs.getString('${domain}_${localId}_name');
            accountData.blurredAvatarUrl =
                _prefs.getString('${domain}_${localId}_blurred_avatar_url');
            accountData.avatarUrl =
                _prefs.getString('${domain}_${localId}_avatar_url');
          } catch (_, __) {
            // empty
          }
          domainData.accounts[accountData.accountId] = accountData;
          domainData.local[localId] = accountData;
        }
      }
      _domains[domain] = domainData;
    }
  }

  List<LocalAccountData> getLocalAccounts() {
    final List<LocalAccountData> list = <LocalAccountData>[];
    for (_LocalDomainDataImpl domain in _domains.values) {
      list.addAll(domain.accounts.values);
    }
    return list;
  }

  @override
  LocalAccountData getAccount(String domain, Int64 accountId) {
    return _domains[domain]?.accounts[accountId];
  }

  @override
  LocalAccountData getLocal(String domain, int localId) {
    return _domains[domain]?.local[localId];
  }

  @override
  void removeLocal(String domain, int localId) {
    _domains[domain].local.remove(localId);
    _domains[domain].accounts.removeWhere(
        (Int64 accountId, _LocalAccountDataImpl data) =>
            data.localId == localId);
    _prefs.remove('${domain}_${localId}_session_id');
    _prefs.remove('${domain}_${localId}_device_cookie'); // Deprecated
    _prefs.remove('${domain}_${localId}_refresh_token');
    _prefs.remove('${domain}_${localId}_account_id');
    _prefs.remove('${domain}_${localId}_account_type');
    _prefs.remove('${domain}_${localId}_name');
    _prefs.remove('${domain}_${localId}_blurred_avatar_url');
    _prefs.remove('${domain}_${localId}_avatar_url');
    _onAccountsChanged.add(null); // Change(ChangeAction.refreshAll, null));
  }

  @override
  void setSessionId(
      String domain, int localId, Int64 sessionId, String refreshToken) {
    _domains[domain].local[localId].sessionId = sessionId;
    _prefs.setString('${domain}_${localId}_session_id', sessionId.toString());
    _prefs.setString('${domain}_${localId}_refresh_token', refreshToken);
    _onAccountsChanged.add(
        null); // Change(ChangeAction.upsert, _domains[domain].local[localId]));
  }

  @override
  void setAccountId(
      String domain, int localId, Int64 accountId, AccountType accountType) {
    _domains[domain].accounts.removeWhere(
        (Int64 accountId, _LocalAccountDataImpl data) =>
            data.localId == localId);
    _domains[domain].local[localId].accountId = accountId;
    _domains[domain].local[localId].accountType = accountType;
    _domains[domain].accounts[accountId] = _domains[domain].local[localId];
    _prefs.setString('${domain}_${localId}_account_id', accountId.toString());
    _prefs.setInt('${domain}_${localId}_account_type', accountType.value);
    if (_current.domain == domain &&
        _current.localId == localId &&
        accountId != Int64.ZERO) {
      _setLastUsed(domain, localId);
    }
    _onAccountsChanged.add(
        null); // Change(ChangeAction.upsert, _domains[domain].local[localId]));
  }

  @override
  void setNameAvatar(String domain, int localId, String name,
      String blurredAvatarUrl, String avatarUrl) {
    _domains[domain].local[localId].name = name;
    _domains[domain].local[localId].blurredAvatarUrl = blurredAvatarUrl;
    _domains[domain].local[localId].avatarUrl = avatarUrl;
    _prefs.setString('${domain}_${localId}_name', name.toString());
    _prefs.setString(
        '${domain}_${localId}_blurred_avatar_url', blurredAvatarUrl.toString());
    _prefs.setString('${domain}_${localId}_avatar_url', avatarUrl.toString());
    _onAccountsChanged.add(
        null); // Change(ChangeAction.upsert, _domains[domain].local[localId]));
  }

/*
  @override
  Uint8List getSessionCookie(String domain, int localId) {
    try {
      return base64
          .decode(_prefs.getString("${domain}_${localId}_device_cookie"));
    } catch (error) {}
    Uint8List sessionCookie;
    if (sessionCookie == null || sessionCookie.length == 0) {
      sessionCookie = Uint8List(32);
      for (int i = 0; i < sessionCookie.length; ++i) {
        sessionCookie[i] = _random.nextInt(256);
      }
    }
    return sessionCookie;
  }
*/

  @override
  String getRefreshToken(String domain, int localId) {
    String refreshToken;
    try {
      refreshToken = _prefs.getString('${domain}_${localId}_refresh_token');
    } catch (_, __) {
      // empty
    }
    if (refreshToken != null && refreshToken.isEmpty) {
      refreshToken = null;
    }
    return refreshToken;
  }

  int getLastUsed(String domain) {
    int localId;
    try {
      localId = _prefs.getInt('${domain}_last_used');
    } catch (_, __) {
      // empty
    }
    if (localId == null || localId == 0) {
      localId = _createAccount(domain);
      _setLastUsed(domain, localId);
    }
    return localId;
  }

  void _setLastUsed(String domain, int localId) {
    _prefs.setInt('${domain}_last_used', localId);
  }

  int _createAccount(String domain) {
    final int localId = _domains[domain].nextLocalId++;
    _prefs.setInt('${domain}_next_id', _domains[domain].nextLocalId);
    final _LocalAccountDataImpl accountData = _LocalAccountDataImpl();
    accountData.domain = domain;
    accountData.localId = localId;
    _domains[domain].accounts[Int64.ZERO] = accountData;
    _domains[domain].local[localId] = accountData;
    _onAccountsChanged.add(null); // Change(ChangeAction.add, accountData));
    return localId;
  }

  @override
  void switchAccount(String domain, Int64 accountId) {
    assert(domain != null);
    assert(accountId != null);
    if (_current?.domain == domain && current?.accountId == accountId) {
      return; // no-op
    }
    final int localId =
        getAccount(domain, accountId)?.localId ?? _createAccount(domain);
    _current = getLocal(domain, localId);
    assert(_current != null);
    if (_current.accountId != 0) {
      _setLastUsed(domain, localId);
    }
    _onSwitchAccount.add(_current);
  }

  @override
  void addAccount([String domain]) {
    switchAccount(domain ?? _startupDomain, Int64.ZERO);
  }

  /// Remove account
  @override
  void removeAccount([String domain, Int64 accountId]) {
    final _LocalAccountDataImpl remove = _current;
    switchAccount(domain ?? _startupDomain, Int64.ZERO);
    removeLocal(remove.domain, remove.localId);
  }
}

/* end of file */
