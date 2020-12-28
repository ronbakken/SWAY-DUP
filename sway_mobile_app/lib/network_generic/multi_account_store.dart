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

import 'package:sway_common/inf_common.dart';
import 'package:sway_mobile_app/network_mobile/multi_account_store_impl.dart';
import 'package:sway_mobile_app/network_generic/multi_account_client.dart';

export 'package:sway_mobile_app/network_generic/multi_account_client.dart';

abstract class MultiAccountStore implements MultiAccountClient {
  factory MultiAccountStore(String startupDomain) {
    return MultiAccountStoreImpl(startupDomain);
  }

  /// Fired anytime any of the accounts changed (add, remove, or update)
  @override
  Stream<void> get onAccountsChanged;

  /// Fired anytime a change in accounts is requested.
  /// This is handled by the network manager.
  Stream<LocalAccountData> get onSwitchAccount;

  /// Switch to another account
  @override
  void switchAccount(String domain, Int64 accountId);

  /// Add an account
  @override
  void addAccount([String domain]);

  /// Remove account
  @override
  void removeAccount([String domain, Int64 accountId]);

  /// List of accounts known locally
  @override
  List<LocalAccountData> get accounts;

  LocalAccountData get current;
  Uint8List getDeviceToken();
  LocalAccountData getAccount(String domain, Int64 accountId);
  LocalAccountData getLocal(String domain, int localId);
  void removeLocal(String domain, int localId);
  void setSessionId(
      String domain, int localId, Int64 sessionId, String refreshToken);
  void setAccountId(
      String domain, int localId, Int64 accountId, AccountType accountType);
  void setNameAvatar(String domain, int localId, String name,
      String blurredAvatarUrl, String avatarUrl);
  String getRefreshToken(String domain, int localId);
  Future<void> initialize();
  Future<void> dispose();
}

/* end of file */
