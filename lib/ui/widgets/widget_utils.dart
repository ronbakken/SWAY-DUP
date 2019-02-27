import 'package:flutter/material.dart';

List<T> nonNullChildren<T>(List<T> children) {
  return children.where((v) => v != null).toList(growable: false);
}

typedef IfWidgetBuilder = Widget Function();

Widget ifWidget(bool condition, {
  @required Widget then,
  Widget orElse,
}) {
  return (condition ? then : orElse);
}
