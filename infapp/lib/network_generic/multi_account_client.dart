/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/change.dart';
import 'package:inf_common/inf_common.dart';

export 'package:inf/network_generic/change.dart';

enum NavigationTarget {
  Profile,
  Offer,
  Proposal, // aka Haggle Chat
}

class CrossNavigationRequest {
  final String environment;
  final Int64 accountId;
  final NavigationTarget target;
  final Int64 id;
  const CrossNavigationRequest(
      this.environment, this.accountId, this.target, this.id);
}

abstract class LocalAccountData {
  String get environment;
  int get localId;
  Int64 get sessionId;
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
  void switchAccount(String environment, Int64 accountId);

  /// Add an account
  void addAccount([String environment]);

  /// List of accounts known locally
  List<LocalAccountData> get accounts;
}

/* end of file */
