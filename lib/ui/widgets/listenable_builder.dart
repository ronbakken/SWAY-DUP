import 'package:flutter/material.dart';

class ListenableBuilder extends StatelessWidget {
  const ListenableBuilder({
    Key key,
    @required this.listenable,
    @required this.builder,
    this.child,
  }) : super(key: key);

  final Listenable listenable;
  final TransitionBuilder builder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: listenable,
      builder: builder,
      child: child,
    );
  }
}
