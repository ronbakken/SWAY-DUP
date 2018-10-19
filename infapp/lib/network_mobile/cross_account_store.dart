/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:inf/protobuf/inf_protobuf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class LocalAccountData {
  String domain;
  int localId = 0;
  Int64 deviceId = new Int64(0);
  Int64 accountId = new Int64(0);
  AccountType accountType = AccountType.AT_UNKNOWN;
  String name;
  String blurredAvatarUrl;
  String avatarUrl;
}

class LocalDomainData {
  String domain;
  int nextLocalId;
  final Map<Int64, LocalAccountData> accounts =
      new Map<Int64, LocalAccountData>();
  final Map<int, LocalAccountData> local = new Map<int, LocalAccountData>();
}

class CrossAccountStore {
  SharedPreferences _prefs;
  final Map<String, LocalDomainData> _domains =
      new Map<String, LocalDomainData>();
  final _random = new Random.secure();

  Future<void> initialize(String startupDomain) async {
    _prefs = await SharedPreferences.getInstance();
    await initLocalData(startupDomain);
  }

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

  Future<void> initLocalData(String startupDomain) async {
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
      LocalDomainData domainData = new LocalDomainData();
      domainData.domain = domain;
      try {
        domainData.nextLocalId = _prefs.getInt("${domain}_next_id") ?? 1;
      } catch (error) {
        domainData.nextLocalId = 1;
      }
      for (int localId = 1; localId < domainData.nextLocalId; ++localId) {
        LocalAccountData accountData = new LocalAccountData();
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
            accountData.accountType = AccountType.valueOf(_prefs.getInt("${domain}_${localId}_account_type") ?? 0);
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
    for (LocalDomainData domain in _domains.values) {
      list.addAll(domain.accounts.values);
    }
    return list;
  }

  LocalAccountData getAccount(String domain, Int64 accountId) {
    return _domains[domain]?.accounts[accountId];
  }

  LocalAccountData getLocal(String domain, int localId) {
    return _domains[domain]?.local[localId];
  }

  void removeLocal(String domain, int localId) {
    _domains[domain].local.remove(localId);
    _domains[domain].accounts.removeWhere(
        (Int64 accountId, LocalAccountData data) => data.localId == localId);
    _prefs.remove("${domain}_${localId}_device_id");
    _prefs.remove("${domain}_${localId}_device_cookie");
    _prefs.remove("${domain}_${localId}_account_id");
    _prefs.remove("${domain}_${localId}_account_type");
    _prefs.remove("${domain}_${localId}_name");
    _prefs.remove("${domain}_${localId}_blurred_avatar_url");
    _prefs.remove("${domain}_${localId}_avatar_url");
  }

  void setDeviceId(
      String domain, int localId, Int64 deviceId, Uint8List deviceCookie) {
    _domains[domain].local[localId].deviceId = deviceId;
    _prefs.setString("${domain}_${localId}_device_id", deviceId.toString());
    _prefs.setString(
        "${domain}_${localId}_device_cookie", base64.encode(deviceCookie));
  }

  void setAccountId(String domain, int localId, Int64 accountId, AccountType accountType) {
    _domains[domain].accounts.removeWhere(
        (Int64 accountId, LocalAccountData data) => data.localId == localId);
    _domains[domain].local[localId].accountId = accountId;
    _domains[domain].accounts[accountId] = _domains[domain].local[localId];
    _prefs.setString("${domain}_${localId}_account_id", accountId.toString());
    _prefs.setInt("${domain}_${localId}_account_type", accountType.value);
  }

  void setNameAvatar(String domain, int localId, String name,
      String blurredAvatarUrl, String avatarUrl) {
    _domains[domain].local[localId].name = name;
    _domains[domain].local[localId].blurredAvatarUrl = blurredAvatarUrl;
    _domains[domain].local[localId].avatarUrl = avatarUrl;
    _prefs.setString("${domain}_${localId}_name", name.toString());
    _prefs.setString(
        "${domain}_${localId}_blurred_avatar_url", blurredAvatarUrl.toString());
    _prefs.setString("${domain}_${localId}_avatar_url", avatarUrl.toString());
  }

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
      localId = createAccount(domain);
      setLastUsed(domain, localId);
    }
    return localId;
  }

  void setLastUsed(String domain, int localId) {
    _prefs.setInt("${domain}_last_used", localId);
  }

  int createAccount(String domain) {
    int localId = _domains[domain].nextLocalId++;
    _prefs.setInt("${domain}_next_id", _domains[domain].nextLocalId);
    LocalAccountData accountData = new LocalAccountData();
    accountData.domain = domain;
    accountData.localId = localId;
    _domains[domain].accounts[new Int64(0)] = accountData;
    _domains[domain].local[localId] = accountData;
    return localId;
  }
}

/* end of file */
