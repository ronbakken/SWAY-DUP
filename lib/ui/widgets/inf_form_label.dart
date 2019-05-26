import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';

class InfFormLabel extends StatelessWidget {
  const InfFormLabel(this.data, {this.style});

  final String data;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      data.toUpperCase(),
      style: AppTheme.formFieldLabelStyle.merge(style),
    );
  }
}
