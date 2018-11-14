import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';

class AppTheme {
  static const darkGrey = const Color(0xFF232326);
  static const buttonHalo = const Color(0xFF323232);
  static const grey = const Color(0xFF2c2c2f);
  static const blue = const Color(0xFF073764);
  static const lightBlue = const Color(0xFF0070c0);
  static const red = const Color(0xFFDC7274);
  static const white30 = const Color(0x66FFFFFF);
  static const blackTwo = const Color(0xFF181616);
  static const black12 = const Color(0x1F000000);
  static const white12 = const Color(0x1FFFFFFF);
  static const toggleBackground = const Color(0xFF474749);
  static const toggleInActive = const Color(0xFF57697C);
  static const toggleActive = Colors.white;
  static const toggleIconActive = blue;
  static const toggleIconInActive = Colors.white;


  static ThemeData themeTopLevel() {
    return ThemeData(
      brightness: Brightness.dark,
      backgroundColor: AppTheme.darkGrey,
      scaffoldBackgroundColor: AppTheme.darkGrey,
      primaryColor: AppTheme.blue,
      fontFamily: AppFonts.mavenPro,
      // TODO define all colors
      buttonTheme: ButtonThemeData(buttonColor: Colors.white, textTheme: ButtonTextTheme.primary)
      
    );
  }
}
