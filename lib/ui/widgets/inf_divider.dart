import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';

class InfDivider extends StatelessWidget {
  const InfDivider({this.height = 1});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Divider(height: height, color: AppTheme.white30);
  }
}
