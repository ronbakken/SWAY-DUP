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
import 'package:synchronized/synchronized.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

import 'package:inf/protobuf/inf_protobuf.dart';
import 'package:inf/network_generic/multi_account_store.dart';
export 'package:inf/network_generic/multi_account_store.dart';

class _LocalAccountDataImpl implements LocalAccountData {
  @override
  String domain;

  @override
  int localId = 0;

  @override
  Int64 deviceId = new Int64(0);

  @override
  Int64 accountId = new Int64(0);

  @override
  AccountType accountType = AccountType.AT_UNKNOWN;

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
      new Map<Int64, _LocalAccountDataImpl>();
  final Map<int, _LocalAccountDataImpl> local =
      new Map<int, _LocalAccountDataImpl>();
}

class MultiAccountStoreImpl implements MultiAccountStore {
  SharedPreferences _prefs;
  final Map<String, _LocalDomainDataImpl> _domains =
      new Map<String, _LocalDomainDataImpl>();
  final _random = new Random.secure();
  final String _startupDomain;

  _LocalAccountDataImpl _current;

  /// Fired anytime any of the accounts changed (add, remove, or update.)
  @override
  Stream<Change<LocalAccountData>> get onAccountsChanged {
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

  final StreamController<Change<LocalAccountData>> _onAccountsChanged =
      new StreamController<Change<LocalAccountData>>.broadcast();

  final StreamController<LocalAccountData> _onSwitchAccount =
      new StreamController<LocalAccountData>.broadcast();

  MultiAccountStoreImpl(this._startupDomain);

  @override
  Future<void> initialize() async {
    assert(_prefs == null);
    assert(_startupDomain != null);
    _prefs = await SharedPreferences.getInstance();

    // Initialize local accounts list
    await _initLocalData(_startupDomain);
    _onAccountsChanged.add(new Change(null, ChangeAction.RefreshAll));

    // Initialize current account
    int localId = getLastUsed(_startupDomain);
    _current = getLocal(_startupDomain, localId);
    _onSwitchAccount.add(_current);
    /*
    _domain = _startupDomain;
    _localId = widget.store.getLastUsed(_startupDomain);
    _accountId = widget.store.getLocal(domain, _localId).accountId;
    */
  }

  @override
  Future<void> dispose() async {
    _onAccountsChanged.close();
    _onSwitchAccount.close();
  }

  @override
  Uint8List getCommonDeviceId() {
    String commonDeviceIdStr;
    try {
      commonDeviceIdStr = _prefs.getString('common_device_id');
    } catch (e) {}
    Uint8List commonDeviceId;
    if (commonDeviceIdStr == null || commonDeviceIdStr.length == 0) {
      commonDeviceId = new Uint8List(32);
      for (int i = 0; i < commonDeviceId.length; ++i) {
        commonDeviceId[i] = _random.nextInt(256);
      }
      commonDeviceIdStr = base64.encode(commonDeviceId);
      _prefs.setString('common_device_id', commonDeviceIdStr);
    } else {
      commonDeviceId = base64.decode(commonDeviceIdStr);
    }
    return commonDeviceId;
  }

  Future<void> _initLocalData(String startupDomain) async {
    List<String> localDomains;
    try {
      localDomains =
          _prefs.getStringList("known_domains") ?? new List<String>();
    } catch (error) {
      localDomains = new List<String>();
    }
    Directory tempDir = await getTemporaryDirectory();
    for (String domain in localDomains.toList()) {
      // NOTE: Domains are only switchable to locally when their config is saved, so verify them
      File domainConfig = File("$tempDir/${domain}_config.bin");
      if (!await domainConfig.exists()) {
        localDomains.remove(domain);
      }
    }
    if (!localDomains.contains(startupDomain)) {
      // The startup domain config is in the APK
      localDomains.add(startupDomain);
      _prefs.setStringList("known_domains", localDomains);
    }
    for (String domain in localDomains) {
      _LocalDomainDataImpl domainData = new _LocalDomainDataImpl();
      domainData.domain = domain;
      try {
        domainData.nextLocalId = _prefs.getInt("${domain}_next_id") ?? 1;
      } catch (error) {
        domainData.nextLocalId = 1;
      }
      for (int localId = 1; localId < domainData.nextLocalId; ++localId) {
        _LocalAccountDataImpl accountData = new _LocalAccountDataImpl();
        accountData.domain = domain;
        accountData.localId = localId;
        try {
          accountData.deviceId = Int64.parseInt(
                  _prefs.getString("${domain}_${localId}_device_id") ?? "0") ??
              new Int64(0);
        } catch (error) {}
        if (accountData.deviceId != null &&
            accountData.deviceId != new Int64(0)) {
          try {
            accountData.accountId = Int64.parseInt(
                    _prefs.getString("${domain}_${localId}_account_id") ??
                        "0") ??
                new Int64(0);
            accountData.accountType = AccountType.valueOf(
                _prefs.getInt("${domain}_${localId}_account_type") ?? 0);
            accountData.name = _prefs.getString("${domain}_${localId}_name");
            accountData.blurredAvatarUrl =
                _prefs.getString("${domain}_${localId}_blurred_avatar_url");
            accountData.avatarUrl =
                _prefs.getString("${domain}_${localId}_avatar_url");
          } catch (error) {}
          domainData.accounts[accountData.accountId] = accountData;
          domainData.local[localId] = accountData;
        }
      }
      _domains[domain] = domainData;
    }
  }

  List<LocalAccountData> getLocalAccounts() {
    List<LocalAccountData> list = new List<LocalAccountData>();
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
    _prefs.remove("${domain}_${localId}_device_id");
    _prefs.remove("${domain}_${localId}_device_cookie");
    _prefs.remove("${domain}_${localId}_account_id");
    _prefs.remove("${domain}_${localId}_account_type");
    _prefs.remove("${domain}_${localId}_name");
    _prefs.remove("${domain}_${localId}_blurred_avatar_url");
    _prefs.remove("${domain}_${localId}_avatar_url");
    _onAccountsChanged.add(new Change(null, ChangeAction.RefreshAll));
  }

  @override
  void setDeviceId(
      String domain, int localId, Int64 deviceId, Uint8List deviceCookie) {
    _domains[domain].local[localId].deviceId = deviceId;
    _prefs.setString("${domain}_${localId}_device_id", deviceId.toString());
    _prefs.setString(
        "${domain}_${localId}_device_cookie", base64.encode(deviceCookie));
    _onAccountsChanged
        .add(new Change(_domains[domain].local[localId], ChangeAction.Upsert));
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
    _prefs.setString("${domain}_${localId}_account_id", accountId.toString());
    _prefs.setInt("${domain}_${localId}_account_type", accountType.value);
    if (_current.domain == domain &&
        _current.localId == localId &&
        accountId != new Int64(0)) {
      _setLastUsed(domain, localId);
    }
    _onAccountsChanged
        .add(new Change(_domains[domain].local[localId], ChangeAction.Upsert));
  }

  @override
  void setNameAvatar(String domain, int localId, String name,
      String blurredAvatarUrl, String avatarUrl) {
    _domains[domain].local[localId].name = name;
    _domains[domain].local[localId].blurredAvatarUrl = blurredAvatarUrl;
    _domains[domain].local[localId].avatarUrl = avatarUrl;
    _prefs.setString("${domain}_${localId}_name", name.toString());
    _prefs.setString(
        "${domain}_${localId}_blurred_avatar_url", blurredAvatarUrl.toString());
    _prefs.setString("${domain}_${localId}_avatar_url", avatarUrl.toString());
    _onAccountsChanged
        .add(new Change(_domains[domain].local[localId], ChangeAction.Upsert));
  }

  @override
  Uint8List getDeviceCookie(String domain, int localId) {
    try {
      return base64
          .decode(_prefs.getString("${domain}_${localId}_device_cookie"));
    } catch (error) {}
    Uint8List deviceCookie;
    if (deviceCookie == null || deviceCookie.length == 0) {
      deviceCookie = new Uint8List(32);
      for (int i = 0; i < deviceCookie.length; ++i) {
        deviceCookie[i] = _random.nextInt(256);
      }
    }
    return deviceCookie;
  }

  int getLastUsed(String domain) {
    int localId;
    try {
      localId = _prefs.getInt("${domain}_last_used");
    } catch (error) {}
    if (localId == null || localId == 0) {
      localId = _createAccount(domain);
      // _setLastUsed(domain, localId);
    }
    return localId;
  }

  void _setLastUsed(String domain, int localId) {
    _prefs.setInt("${domain}_last_used", localId);
  }

  int _createAccount(String domain) {
    int localId = _domains[domain].nextLocalId++;
    _prefs.setInt("${domain}_next_id", _domains[domain].nextLocalId);
    _LocalAccountDataImpl accountData = new _LocalAccountDataImpl();
    accountData.domain = domain;
    accountData.localId = localId;
    _domains[domain].accounts[new Int64(0)] = accountData;
    _domains[domain].local[localId] = accountData;
    _onAccountsChanged.add(new Change(accountData, ChangeAction.New));
    return localId;
  }

  @override
  void switchAccount(String domain, Int64 accountId) {
    assert(domain != null);
    assert(accountId != null);
    int localId =
        getAccount(domain, accountId)?.localId ?? _createAccount(domain);
    _current = getLocal(domain, localId);
    if (_current.accountId != 0) {
      _setLastUsed(domain, localId);
    }
    _onSwitchAccount.add(_current);
  }

  @override
  void addAccount([String domain]) {
    switchAccount(domain ?? _startupDomain, new Int64(0));
  }
}

/* end of file */
