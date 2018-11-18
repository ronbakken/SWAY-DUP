/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

/*

Cross Account Selection
=======================

This is an inherited state switching widget which provides the network stack with the currently selected environment and account.

The environment allows switching between development, staging, and production environment.
The account id is the id as it is on the remote environment.
Switching environment always immediately switches accounts.

Rationale for requiring cross environment support is handling incoming notifications correctly.

*/

import 'dart:async';

import 'package:inf/network_generic/multi_account_client.dart';
import 'package:flutter/widgets.dart';

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
    return inherited?.client;
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
