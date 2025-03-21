import 'package:flutter/material.dart';

// Fade Animation
Widget _fadeAnimation(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(opacity: animation, child: child);
}

// FIXME: [widget] is built using the passed [context] rather than by the [pageBuilder] context. This is against the Flutter API and will break things
void transitionPage(BuildContext context, Widget widget) {
  Navigator.of(context).push<void>(PageRouteBuilder(
    transitionsBuilder: _fadeAnimation,
    pageBuilder: (context, animation, secondaryAnimation) => widget,
  ));
}

void fadeToPage(BuildContext context, RoutePageBuilder builder) {
  Navigator.of(context).push<void>(PageRouteBuilder(
    transitionsBuilder: _fadeAnimation,
    pageBuilder: builder,
  ));
}
