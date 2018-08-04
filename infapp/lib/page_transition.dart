import 'package:flutter/material.dart';

// Fade Animation
Widget _fadeAnimation(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return new FadeTransition(opacity: animation, child: child);
}

// FIXME: [widget] is built using the passed [context] rather than by the [pageBuilder] context. This is against the Flutter API and will break things
void transitionPage(BuildContext context, Widget widget) {
  Navigator
    .of(context)
    .push(
      PageRouteBuilder(
        transitionsBuilder: _fadeAnimation,
        pageBuilder: (context, animation, secondaryAnimation) => widget,
      )
    );
}

