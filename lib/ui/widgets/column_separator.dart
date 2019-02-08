import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';

class ColumnSeparator extends StatelessWidget {
  final double horizontalMargin;

  const ColumnSeparator({Key key, this.horizontalMargin = 24}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(height: 1,
    color: AppTheme.white30,
    margin: EdgeInsets.only(left: horizontalMargin, right:horizontalMargin,top: 16.0,bottom: 24.0),
    
      
    );
  }
}