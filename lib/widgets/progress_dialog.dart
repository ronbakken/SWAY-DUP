/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';

/// From dialog.dart
class _DialogRoute extends PopupRoute<void> {
  _DialogRoute({
    @required this.theme,
    bool barrierDismissible = true,
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
    return SafeArea(
      child: Builder(builder: (BuildContext context) {
        final Widget annotatedChild = Semantics(
          child: child,
          scopesRoute: true,
          explicitChildNodes: true,
        );
        return theme != null
            ? Theme(data: theme, child: annotatedChild)
            : annotatedChild;
      }),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
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
  final int ref = _currentProgressDialog;
  if (_navigator != null && _navigator.mounted) {
    _navigator.pop();
    _navigator = null;
  }
  final NavigatorState navigator = Navigator.of(context, rootNavigator: true);
  _navigator = navigator;
  final ThemeData theme = Theme.of(context, shadowThemeOnly: true);
  final MaterialLocalizations localizations = MaterialLocalizations.of(context);
  () async {
    do {
      await navigator.push(_DialogRoute(
        child: Builder(builder: builder),
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

bool closeProgressDialog(dynamic progressDialog) {
  if (progressDialog == _currentProgressDialog) {
    ++_currentProgressDialog;
    if (_navigator != null && _navigator.mounted) {
      _navigator.pop();
      _navigator = null;
      return true;
    }
  }
  return false;
}

Widget Function(BuildContext context) genericProgressBuilder({String message}) {
  return (BuildContext context) {
    return Dialog(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.all(24.0),
              child: const CircularProgressIndicator()),
          Text(message),
        ],
      ),
    );
  };
}

Widget Function(BuildContext context) genericMessageBuilder({
  String title = 'Action Failed',
  List<String> messages = const <String>[
    'An error has occured.',
    'Please try again later.'
  ],
  String button = 'Ok',
}) {
  final String buttonText = button.toUpperCase();
  return (BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: messages.map<Widget>((String message) {
            return Text(message);
          }),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(buttonText),
            ],
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  };
}

Future<T> wrapProgressAndError<T>({
  @required BuildContext context,
  Widget Function(BuildContext context) progressBuilder,
  Widget Function(BuildContext context) errorBuilder,
  Widget Function(BuildContext context) successBuilder,
  Future<T> Function() task,
}) async {
  bool success = false;
  final NavigatorState navigator = Navigator.of(context, rootNavigator: true);
  final dynamic progressDialog = showProgressDialog(
    context: context,
    builder: progressBuilder,
  );
  T result;
  try {
    try {
      result = await task();
      success = true;
    } catch (error, _) {
      // Can log here
      rethrow;
    }
  } finally {
    final bool closed = closeProgressDialog(progressDialog);
    if (closed && navigator.mounted) {
      if (!success) {
        await showDialog<void>(
          context: context,
          builder: errorBuilder,
        );
      } else if (successBuilder != null) {
        await showDialog<void>(
          context: context,
          builder: successBuilder,
        );
      }
    }
  }
  return result;
}

/* end of file */
