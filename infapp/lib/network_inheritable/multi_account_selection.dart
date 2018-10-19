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
import 'package:inf/network_generic/multi_account_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

export 'package:inf/network_generic/multi_account_client.dart';

class MultiAccountSelection extends StatefulWidget {
  final MultiAccountClient client;
  final Widget child;

  const MultiAccountSelection({Key key, @required this.client, this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CrossAccountSelectionState();
  }

  static MultiAccountClient of(BuildContext context) {
    final _InheritedCrossAccountSelection inherited =
        context.inheritFromWidgetOfExactType(_InheritedCrossAccountSelection);
    return inherited != null ? inherited.client : null;
  }
}

class CrossAccountSelectionState extends State<MultiAccountSelection> {
  int _changed = 0;

  StreamSubscription<Change<LocalAccountData>> _onAccountsChanged;
  StreamSubscription<LocalAccountData> _onSwitchAccount;

  @override
  void initState() {
    super.initState();
    _onAccountsChanged = widget.client.onAccountsChanged.listen((value) {
      setState(() {
        ++_changed;
      });
    });
    /*
    // Not applicable for client
    _onSwitchAccount = widget.client.onSwitchAccount.listen((value) {
        setState(() {
          ++_changed;
        });
    });
    */
  }

  @override
  void dispose() {
    _onSwitchAccount.cancel();
    _onSwitchAccount = null;
    _onAccountsChanged.cancel();
    _onAccountsChanged = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedCrossAccountSelection(
        child: widget.child, client: widget.client, changed: _changed);
  }
}

class _InheritedCrossAccountSelection extends InheritedWidget {
  final MultiAccountClient client;
  final int _changed;

  const _InheritedCrossAccountSelection(
      {Key key, Widget child, this.client, int changed})
      : _changed = changed,
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    _InheritedCrossAccountSelection oldSelection =
        oldWidget as _InheritedCrossAccountSelection;
    return oldSelection._changed != _changed;
  }
}

/* end of file */
