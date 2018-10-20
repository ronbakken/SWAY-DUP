/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:flutter/material.dart';

/// From dialog.dart
class _DialogRoute extends PopupRoute {
  _DialogRoute({
    @required this.theme,
    bool barrierDismissible: true,
    this.barrierLabel,
    @required this.child,
    RouteSettings settings,
  })  : assert(barrierDismissible != null),
        _barrierDismissible = barrierDismissible,
        super(settings: settings);

  final Widget child;
  final ThemeData theme;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 150);

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  Color get barrierColor => Colors.black54;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new SafeArea(
      child: new Builder(builder: (BuildContext context) {
        final Widget annotatedChild = new Semantics(
          child: child,
          scopesRoute: true,
          explicitChildNodes: true,
        );
        return theme != null
            ? new Theme(data: theme, child: annotatedChild)
            : annotatedChild;
      }),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(
        opacity: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child);
  }
}

int _currentProgressDialog = 0;
NavigatorState _navigator;

/// Very persistently shows a progress dialog that stays visible. Returns identifier used to stop it.
dynamic showProgressDialog({
  @required BuildContext context,
  WidgetBuilder builder,
}) {
  ++_currentProgressDialog;
  int ref = _currentProgressDialog;
  if (_navigator != null && _navigator.mounted) {
    _navigator.pop();
    _navigator = null;
  }
  NavigatorState navigator = Navigator.of(context, rootNavigator: true);
  _navigator = navigator;
  ThemeData theme = Theme.of(context, shadowThemeOnly: true);
  MaterialLocalizations localizations = MaterialLocalizations.of(context);
  () async {
    do {
      await navigator.push(new _DialogRoute(
        child: new Builder(builder: builder),
        theme: theme,
        barrierDismissible: false,
        barrierLabel: localizations.modalBarrierDismissLabel,
      ));
    } while (ref == _currentProgressDialog &&
        navigator == _navigator &&
        navigator.mounted);
    if (navigator == _navigator && !navigator.mounted) {
      _navigator = null;
    }
  }();
  return ref;
}

void closeProgressDialog(dynamic progressDialog) {
  if (progressDialog == _currentProgressDialog) {
    ++_currentProgressDialog;
    if (_navigator != null && _navigator.mounted) {
      _navigator.pop();
      _navigator = null;
    }
  }
}

/* end of file */
