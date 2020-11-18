import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';

class InfDivider extends StatelessWidget {
  const InfDivider({
    this.height = 1,
    this.verticalPadding = 0,
  });

  final double verticalPadding;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Divider(height: height, color: AppTheme.white30),
    );
  }
}
