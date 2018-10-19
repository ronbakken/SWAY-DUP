/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/change.dart';
import 'package:inf/protobuf/enum_protobuf.pbenum.dart';

export 'package:inf/network_generic/change.dart';

abstract class LocalAccountData {
  String get domain;
  int get localId;
  Int64 get deviceId;
  Int64 get accountId;
  AccountType get accountType;
  String get name;
  String get blurredAvatarUrl;
  String get avatarUrl;
}

abstract class MultiAccountClient {
  /// Fired anytime any of the accounts changed (add, remove, or update)
  Stream<Change<LocalAccountData>> get onAccountsChanged;

  /// Switch to another account
  void switchAccount(String domain, Int64 accountId);

  /// Add an account
  void addAccount([String domain]);

  /// List of accounts known locally
  List<LocalAccountData> get accounts;
}

/* end of file */
