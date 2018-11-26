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

import 'package:inf_common/inf_common.dart';
import 'package:inf/network_generic/multi_account_store.dart';
export 'package:inf/network_generic/multi_account_store.dart';

class _LocalAccountDataImpl implements LocalAccountData {
  @override
  String environment;

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
  String environment;
  int nextLocalId;
  final Map<Int64, _LocalAccountDataImpl> accounts =
      new Map<Int64, _LocalAccountDataImpl>();
  final Map<int, _LocalAccountDataImpl> local =
      new Map<int, _LocalAccountDataImpl>();
}

class MultiAccountStoreImpl implements MultiAccountStore {
  SharedPreferences _prefs;
  final Map<String, _LocalDomainDataImpl> _environments =
      new Map<String, _LocalDomainDataImpl>();
  final _random = new Random.secure();
  final String _startupEnvironment;

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

  MultiAccountStoreImpl(this._startupEnvironment);

  @override
  Future<void> initialize() async {
    assert(_prefs == null);
    assert(_startupEnvironment != null);
    _prefs = await SharedPreferences.getInstance();

    // Initialize local accounts list
    await _initLocalData(_startupEnvironment);
    _onAccountsChanged.add(new Change(ChangeAction.refreshAll, null));

    // Initialize current account
    int localId = getLastUsed(_startupEnvironment);
    _current = getLocal(_startupEnvironment, localId);
    if (_current == null) {
      localId = _createAccount(_startupEnvironment);
      _current = getLocal(_startupEnvironment, localId);
      _setLastUsed(_startupEnvironment, localId);
    }
    assert(_current != null);
    _onSwitchAccount.add(_current);
    /*
    _environment = _startupEnvironment;
    _localId = widget.store.getLastUsed(_startupEnvironment);
    _accountId = widget.store.getLocal(environment, _localId).accountId;
    */
  }

  @override
  Future<void> dispose() async {
    _onAccountsChanged.close();
    _onSwitchAccount.close();
  }

  @override
  Uint8List getDeviceToken() {
    String deviceTokenStr;
    try {
      deviceTokenStr = _prefs.getString('device_token');
    } catch (e) {}
    Uint8List deviceToken;
    if (deviceTokenStr == null || deviceTokenStr.length == 0) {
      deviceToken = new Uint8List(32);
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
      localDomains =
          _prefs.getStringList("known_environments") ?? new List<String>();
    } catch (error) {
      localDomains = new List<String>();
    }
    Directory tempDir = await getTemporaryDirectory();
    for (String environment in localDomains.toList()) {
      // NOTE: Domains are only switchable to locally when their config is saved, so verify them
      File environmentConfig = File("$tempDir/${environment}_config.bin");
      if (!await environmentConfig.exists()) {
        localDomains.remove(environment);
      }
    }
    if (!localDomains.contains(startupDomain)) {
      // The startup environment config is in the APK
      localDomains.add(startupDomain);
      _prefs.setStringList("known_environments", localDomains);
    }
    for (String environment in localDomains) {
      _LocalDomainDataImpl environmentData = new _LocalDomainDataImpl();
      environmentData.environment = environment;
      try {
        environmentData.nextLocalId =
            _prefs.getInt("${environment}_next_id") ?? 1;
      } catch (error) {
        environmentData.nextLocalId = 1;
      }
      for (int localId = 1; localId < environmentData.nextLocalId; ++localId) {
        _LocalAccountDataImpl accountData = new _LocalAccountDataImpl();
        accountData.environment = environment;
        accountData.localId = localId;
        try {
          accountData.sessionId = Int64.parseInt(
                  _prefs.getString("${environment}_${localId}_session_id") ??
                      "0") ??
              Int64.ZERO;
        } catch (error) {}
        if (accountData.sessionId != null &&
            accountData.sessionId != Int64.ZERO) {
          try {
            accountData.accountId = Int64.parseInt(
                    _prefs.getString("${environment}_${localId}_account_id") ??
                        "0") ??
                Int64.ZERO;
            accountData.accountType = AccountType.valueOf(
                _prefs.getInt("${environment}_${localId}_account_type") ?? 0);
            accountData.name =
                _prefs.getString("${environment}_${localId}_name");
            accountData.blurredAvatarUrl = _prefs
                .getString("${environment}_${localId}_blurred_avatar_url");
            accountData.avatarUrl =
                _prefs.getString("${environment}_${localId}_avatar_url");
          } catch (error) {}
          environmentData.accounts[accountData.accountId] = accountData;
          environmentData.local[localId] = accountData;
        }
      }
      _environments[environment] = environmentData;
    }
  }

  List<LocalAccountData> getLocalAccounts() {
    List<LocalAccountData> list = new List<LocalAccountData>();
    for (_LocalDomainDataImpl environment in _environments.values) {
      list.addAll(environment.accounts.values);
    }
    return list;
  }

  @override
  LocalAccountData getAccount(String environment, Int64 accountId) {
    return _environments[environment]?.accounts[accountId];
  }

  @override
  LocalAccountData getLocal(String environment, int localId) {
    return _environments[environment]?.local[localId];
  }

  @override
  void removeLocal(String environment, int localId) {
    _environments[environment].local.remove(localId);
    _environments[environment].accounts.removeWhere(
        (Int64 accountId, _LocalAccountDataImpl data) =>
            data.localId == localId);
    _prefs.remove("${environment}_${localId}_session_id");
    _prefs.remove("${environment}_${localId}_device_cookie");
    _prefs.remove("${environment}_${localId}_account_id");
    _prefs.remove("${environment}_${localId}_account_type");
    _prefs.remove("${environment}_${localId}_name");
    _prefs.remove("${environment}_${localId}_blurred_avatar_url");
    _prefs.remove("${environment}_${localId}_avatar_url");
    _onAccountsChanged.add(new Change(ChangeAction.refreshAll, null));
  }

  @override
  void setSessionId(String environment, int localId, Int64 sessionId,
      Uint8List sessionCookie) {
    _environments[environment].local[localId].sessionId = sessionId;
    _prefs.setString(
        "${environment}_${localId}_session_id", sessionId.toString());
    _prefs.setString("${environment}_${localId}_device_cookie",
        base64.encode(sessionCookie));
    _onAccountsChanged.add(new Change(
        ChangeAction.upsert, _environments[environment].local[localId]));
  }

  @override
  void setAccountId(String environment, int localId, Int64 accountId,
      AccountType accountType) {
    _environments[environment].accounts.removeWhere(
        (Int64 accountId, _LocalAccountDataImpl data) =>
            data.localId == localId);
    _environments[environment].local[localId].accountId = accountId;
    _environments[environment].local[localId].accountType = accountType;
    _environments[environment].accounts[accountId] =
        _environments[environment].local[localId];
    _prefs.setString(
        "${environment}_${localId}_account_id", accountId.toString());
    _prefs.setInt("${environment}_${localId}_account_type", accountType.value);
    if (_current.environment == environment &&
        _current.localId == localId &&
        accountId != Int64.ZERO) {
      _setLastUsed(environment, localId);
    }
    _onAccountsChanged.add(new Change(
        ChangeAction.upsert, _environments[environment].local[localId]));
  }

  @override
  void setNameAvatar(String environment, int localId, String name,
      String blurredAvatarUrl, String avatarUrl) {
    _environments[environment].local[localId].name = name;
    _environments[environment].local[localId].blurredAvatarUrl =
        blurredAvatarUrl;
    _environments[environment].local[localId].avatarUrl = avatarUrl;
    _prefs.setString("${environment}_${localId}_name", name.toString());
    _prefs.setString("${environment}_${localId}_blurred_avatar_url",
        blurredAvatarUrl.toString());
    _prefs.setString(
        "${environment}_${localId}_avatar_url", avatarUrl.toString());
    _onAccountsChanged.add(new Change(
        ChangeAction.upsert, _environments[environment].local[localId]));
  }

  @override
  Uint8List getSessionCookie(String environment, int localId) {
    try {
      return base64
          .decode(_prefs.getString("${environment}_${localId}_device_cookie"));
    } catch (error) {}
    Uint8List sessionCookie;
    if (sessionCookie == null || sessionCookie.length == 0) {
      sessionCookie = new Uint8List(32);
      for (int i = 0; i < sessionCookie.length; ++i) {
        sessionCookie[i] = _random.nextInt(256);
      }
    }
    return sessionCookie;
  }

  int getLastUsed(String environment) {
    int localId;
    try {
      localId = _prefs.getInt("${environment}_last_used");
    } catch (error) {}
    if (localId == null || localId == 0) {
      localId = _createAccount(environment);
      _setLastUsed(environment, localId);
    }
    return localId;
  }

  void _setLastUsed(String environment, int localId) {
    _prefs.setInt("${environment}_last_used", localId);
  }

  int _createAccount(String environment) {
    int localId = _environments[environment].nextLocalId++;
    _prefs.setInt(
        "${environment}_next_id", _environments[environment].nextLocalId);
    _LocalAccountDataImpl accountData = new _LocalAccountDataImpl();
    accountData.environment = environment;
    accountData.localId = localId;
    _environments[environment].accounts[Int64.ZERO] = accountData;
    _environments[environment].local[localId] = accountData;
    _onAccountsChanged.add(new Change(ChangeAction.add, accountData));
    return localId;
  }

  @override
  void switchAccount(String environment, Int64 accountId) {
    assert(environment != null);
    assert(accountId != null);
    if (_current?.environment == environment &&
        current?.accountId == accountId) {
      return; // no-op
    }
    int localId = getAccount(environment, accountId)?.localId ??
        _createAccount(environment);
    _current = getLocal(environment, localId);
    assert(_current != null);
    if (_current.accountId != 0) {
      _setLastUsed(environment, localId);
    }
    _onSwitchAccount.add(_current);
  }

  @override
  void addAccount([String environment]) {
    switchAccount(environment ?? _startupEnvironment, Int64.ZERO);
  }

  /// Remove account
  void removeAccount([String environment, Int64 accountId]) {
    _LocalAccountDataImpl remove = _current;
    switchAccount(environment ?? _startupEnvironment, Int64.ZERO);
    removeLocal(remove.environment, remove.localId);
  }
}

/* end of file */
