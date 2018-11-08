import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';

class AppTheme {
  static const darkGrey = const Color(0xFF232326);
  static const blue = const Color(0xFF073764);
  static const red = const Color(0xFFDC7274);
  static const white30 = const Color(0x66FFFFFF);
  static const blackTwo = const Color(0xFF181616);

  static ThemeData themeTopLevel() {
    return ThemeData(
      brightness: Brightness.dark,
      backgroundColor: AppTheme.darkGrey,
      scaffoldBackgroundColor: AppTheme.darkGrey,
      primaryColor: AppTheme.blue,
      fontFamily: AppFonts.mavenPro,
    );
  }
}
