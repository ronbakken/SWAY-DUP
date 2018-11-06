import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';

class AppTheme {
  static const grey = const Color(0xFF232326);
  static const blue = const Color(0xFF073764);
  static const red = const Color(0xFFDC7274);

  static ThemeData themeTopLevel() {
    return ThemeData(
      brightness: Brightness.dark,
      backgroundColor: AppTheme.grey,
      primaryColor: AppTheme.blue,
      fontFamily: Fonts.fontMavenPro,
    );
  }
}
