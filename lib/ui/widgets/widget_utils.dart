import 'package:flutter/material.dart';

List<T> mapChildren<E, T>(Iterable<E> data, T fn(E e)) {
  return data.map(fn).toList(growable: false);
}

List<T> nonNullChildren<T>(List<T> children) {
  return children.where((v) => v != null).toList(growable: false);
}

typedef IfWidgetBuilder = Widget Function();

Widget ifWidget(
  bool condition, {
  @required Widget then,
  Widget orElse,
}) {
  return (condition ? then : orElse);
}

const Widget emptyWidget = SizedBox();

const Widget verticalMargin4 = const SizedBox(height: 4.0);
const Widget verticalMargin8 = const SizedBox(height: 8.0);
const Widget verticalMargin12 = const SizedBox(height: 12.0);
const Widget verticalMargin16 = const SizedBox(height: 16.0);
const Widget verticalMargin24 = const SizedBox(height: 24.0);
const Widget verticalMargin32 = const SizedBox(height: 32.0);
const Widget verticalMargin36 = const SizedBox(height: 36.0);

const Widget horizontalMargin4 = const SizedBox(width: 4.0);
const Widget horizontalMargin8 = const SizedBox(width: 8.0);
const Widget horizontalMargin12 = const SizedBox(width: 12.0);
const Widget horizontalMargin16 = const SizedBox(width: 16.0);
const Widget horizontalMargin24 = const SizedBox(width: 24.0);
const Widget horizontalMargin32 = const SizedBox(width: 32.0);
const Widget horizontalMargin36 = const SizedBox(width: 36.0);
