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

import 'package:inf_common/inf_common.dart';
import 'package:inf/network_mobile/multi_account_store_impl.dart';
import 'package:inf/network_generic/multi_account_client.dart';

export 'package:inf/network_generic/multi_account_client.dart';

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

  /// Remove account
  void removeAccount([String domain, Int64 accountId]);

  /// List of accounts known locally
  List<LocalAccountData> get accounts;

  LocalAccountData get current;
  Uint8List getDeviceToken();
  LocalAccountData getAccount(String domain, Int64 accountId);
  LocalAccountData getLocal(String domain, int localId);
  void removeLocal(String domain, int localId);
  void setSessionId(String domain, int localId, Int64 sessionId,
      Uint8List sessionCookie);
  void setAccountId(String domain, int localId, Int64 accountId,
      AccountType accountType);
  void setNameAvatar(String domain, int localId, String name,
      String blurredAvatarUrl, String avatarUrl);
  Uint8List getSessionCookie(String domain, int localId);
  Future<void> initialize();
  Future<void> dispose();
}

/* end of file */
