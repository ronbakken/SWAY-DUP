import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';

class InfFormLabel extends StatelessWidget {
  final String data;

  InfFormLabel(this.data);

  @override
  Widget build(BuildContext context) {
    return Text(data.toUpperCase(), style: AppTheme.formFieldLabelStyle);
  }
}
