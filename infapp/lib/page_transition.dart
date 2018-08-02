import 'package:flutter/material.dart';

// Fade Animation
Widget _fadeAnimation(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return new FadeTransition(opacity: animation, child: child);
}

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

