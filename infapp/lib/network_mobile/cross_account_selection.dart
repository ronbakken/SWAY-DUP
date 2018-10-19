/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

/*

Cross Account Selection
=======================

This is an inherited state switching widget which provides the network stack with the currently selected domain and account.

The domain allows switching between development, staging, and production environment.
The account id is the id as it is on the remote domain.
Switching domain always immediately switches accounts.

Rationale for requiring cross domain support is handling incoming notifications correctly.

*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:inf/network_mobile/cross_account_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

export 'package:inf/network_mobile/cross_account_store.dart';

class CrossAccountSelection extends StatefulWidget {
  final CrossAccountStore store;
  final String startupDomain;
  final Widget child;

  const CrossAccountSelection(
      {Key key, @required this.store, @required this.startupDomain, this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CrossAccountSelectionState(startupDomain);
  }

  static CrossAccountSelectionState of(BuildContext context) {
    final _InheritedCrossAccountSelection inherited =
        context.inheritFromWidgetOfExactType(_InheritedCrossAccountSelection);
    return inherited != null ? inherited.state : null;
  }
}

class CrossAccountSelectionState extends State<CrossAccountSelection> {
  String _domain;
  Int64 _accountId;
  int _localId;
  final Lock _lock = new Lock();
  final String _startupDomain;

  SharedPreferences _prefs;

  CrossAccountSelectionState(this._startupDomain);

  @override
  initState() {
    super.initState();
    _domain = _startupDomain;
    _localId = widget.store.getLastUsed(_startupDomain);
    _accountId = widget.store.getLocal(domain, _localId).accountId;
  }

  String get domain {
    return _domain;
  }

  int get localId {
    return _localId;
  }

  CrossAccountStore get store {
    return widget.store;
  }

  List<LocalAccountData> get accounts {
    return store.getLocalAccounts();
  }

  void switchAccount(String domain, Int64 accountId) {
    assert(domain != null);
    setState(() {
      _domain = domain;
      _localId = store.getAccount(domain, accountId)?.localId ??
          store.createAccount(domain);
      _accountId = widget.store.getLocal(domain, _localId).accountId;
    });
    widget.store.setLastUsed(_domain, _localId);
  }

  void addAccount([String domain]) {
    switchAccount(domain ?? _startupDomain, new Int64(0));
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedCrossAccountSelection(
        child: widget.child, state: this, domain: domain, localId: localId);
  }
}

class _InheritedCrossAccountSelection extends InheritedWidget {
  final CrossAccountSelectionState state;
  final String domain;
  final int localId;

  const _InheritedCrossAccountSelection(
      {Key key, Widget child, this.state, this.domain, this.localId})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    _InheritedCrossAccountSelection oldSelection =
        oldWidget as _InheritedCrossAccountSelection;
    return oldSelection.domain != domain || oldSelection.localId != localId;
  }
}

/* end of file */
