import 'package:flutter/material.dart';

class NoTransitionRoute<T> extends PageRouteBuilder<T> {
  NoTransitionRoute({
    @required WidgetBuilder builder,
    RouteSettings settings = const RouteSettings(),
    bool maintainState = true,
    Duration transitionDuration = const Duration(milliseconds: 450),
  }) : super(
          settings: settings,
          pageBuilder: (BuildContext context, _, __) {
            return builder(context);
          },
          transitionDuration: transitionDuration,
          maintainState: maintainState,
        );
}

class FadePageRoute<T> extends PageRouteBuilder<T> {
  FadePageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings = const RouteSettings(),
    bool maintainState = true,
    Duration transitionDuration = const Duration(milliseconds: 450),
  }) : super(
          settings: settings,
          pageBuilder: (BuildContext context, _, __) => builder(context),
          transitionDuration: transitionDuration,
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          maintainState: maintainState,
          opaque: false,
        );
}
