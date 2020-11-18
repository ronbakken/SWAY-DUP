import 'package:flutter/material.dart';

class AnimationChoreographer extends InheritedWidget {
  AnimationChoreographer({
    Key key,
    @required this.animation,
    Widget child,
  })  : assert(animation != null),
        super(key: key, child: child);

  final Animation animation;

  static Animation<T> of<T>(BuildContext context) {
    final element = context.ancestorInheritedElementForWidgetOfExactType(AnimationChoreographer);
    return (element?.widget as AnimationChoreographer)?.animation;
  }

  @override
  bool updateShouldNotify(AnimationChoreographer oldWidget) {
    return animation != oldWidget.animation;
  }
}
