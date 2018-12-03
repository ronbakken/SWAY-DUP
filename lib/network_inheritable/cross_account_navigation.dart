/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf_app/network_inheritable/multi_account_selection.dart';
import 'package:inf_app/network_generic/cross_account_navigator.dart';

export 'package:inf_app/network_generic/cross_account_navigator.dart';

class CrossAccountNavigation extends StatefulWidget {
  final Widget child;

  const CrossAccountNavigation({Key key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CrossAccountNavigator();
  }

  static CrossAccountNavigator of(BuildContext context) {
    final _CrossAccountNavigationInherited inherited =
        context.inheritFromWidgetOfExactType(_CrossAccountNavigationInherited);
    return inherited?.navigator?.navigator;
  }
}

class _CrossAccountNavigator extends State<CrossAccountNavigation> {
  final CrossAccountNavigator navigator = CrossAccountNavigator();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    navigator.multiAccountClient = MultiAccountSelection.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return _CrossAccountNavigationInherited(
        child: widget.child, navigator: this);
  }

  @override
  void dispose() {
    navigator.dispose();
    super.dispose();
  }
}

class _CrossAccountNavigationInherited extends InheritedWidget {
  final _CrossAccountNavigator navigator;

  const _CrossAccountNavigationInherited(
      {Key key, Widget child, this.navigator})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}

/* end of file */
