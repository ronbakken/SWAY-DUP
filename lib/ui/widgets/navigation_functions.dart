import 'dart:async';

import 'package:flutter/material.dart';

Future replacePage(BuildContext context, Widget newPage) {
  return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => newPage,
          transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          }));
}

Future<T> pushPage<T>(BuildContext context, Widget newPage) {
  return Navigator.push<T>(
      context,
      PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => newPage,
          transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          }));
}
