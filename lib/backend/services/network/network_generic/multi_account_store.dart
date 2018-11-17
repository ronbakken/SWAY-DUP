/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

/*

Multi account store, used by the network manager.

*/

import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:inf/backend/services/network/network_generic/change.dart';
import 'package:inf/backend/services/network/network_mobile/multi_account_store_impl.dart';
import 'package:inf/backend/services/network/protobuf/inf_protobuf.dart';

export 'package:inf/backend/services/network/network_generic/multi_account_client.dart';

abstract class MultiAccountStore implements MultiAccountClient {
  factory MultiAccountStore(String startupDomain) {
    return new MultiAccountStoreImpl(startupDomain);
  }

  /// Fired anytime any of the accounts changed (add, remove, or update)
  Stream<Change<LocalAccountData>> get onAccountsChanged;

  /// Fired anytime a change in accounts is requested.
  /// This is handled by the network manager.
  Stream<LocalAccountData> get onSwitchAccount;

  /// Switch to another account
  void switchAccount(String domain, Int64 accountId);

  /// Add an account
  void addAccount([String domain]);

  /// List of accounts known locally
  List<LocalAccountData> get accounts;

  LocalAccountData get current;
  Uint8List getCommonDeviceId();
  LocalAccountData getAccount(String domain, Int64 accountId);
  LocalAccountData getLocal(String domain, int localId);
  void removeLocal(String domain, int localId);
  void setDeviceId(
      String domain, int localId, Int64 deviceId, Uint8List deviceCookie);
  void setAccountId(
      String domain, int localId, Int64 accountId, AccountType accountType);
  void setNameAvatar(String domain, int localId, String name,
      String blurredAvatarUrl, String avatarUrl);
  Uint8List getDeviceCookie(String domain, int localId);
  Future<void> initialize();
  Future<void> dispose();
}

/* end of file */
