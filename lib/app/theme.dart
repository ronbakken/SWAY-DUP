import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';

class AppTheme {
  static const darkGrey = Color(0xFF232326);
  static const menuUserNameBackground = Color(0xFF1B1B1B);
  static const listViewAndMenuBackground = Color(0xFF202020);
  static const listViewItemBackground = Color(0xFF292929);
  static const buttonHalo = Color(0xFF323232);
  static const grey = Color(0xFF2c2c2f);
  static const blue = Color(0xFF073764);
  static const lightBlue = Color(0xFF0070c0);
  static const red = Color(0xFFDC7274);
  static const white30 = Color(0x66FFFFFF);
  static const blackTwo = Color(0xFF181616);
  static const black12 = Color(0x1F000000);
  static const white12 = Color(0x1FFFFFFF);
  static const toggleBackground = Color(0xFF474749);
  static const toggleInActive = Color(0xFF57697C);
  static const toggleActive = Colors.white;
  static const toggleIconActive = blue;
  static const toggleIconInActive = Colors.white;
  static const tabIndicator = blue;
  static const notificationDot = Color(0xFFDC7173);

  static ThemeData themeTopLevel() {
    return ThemeData(
        brightness: Brightness.dark,
        backgroundColor: AppTheme.darkGrey,
        scaffoldBackgroundColor: AppTheme.darkGrey,
        primaryColor: AppTheme.blue,
        fontFamily: AppFonts.mavenPro,
        // TODO define all colors
        buttonTheme: const ButtonThemeData(
            buttonColor: Colors.white, textTheme: ButtonTextTheme.primary));
  }
}
