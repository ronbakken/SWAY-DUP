import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';

class ColumnSeparator extends StatelessWidget {
  const ColumnSeparator({
    Key key,
    this.horizontalMargin = 24.0,
  }) : super(key: key);

  final double horizontalMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: AppTheme.white30,
      margin: EdgeInsets.only(left: horizontalMargin, right: horizontalMargin, top: 16.0, bottom: 24.0),
    );
  }
}
