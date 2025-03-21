import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';

class AppTheme {
  static const darkGrey = const Color(0xFF232326);
  static const darkGrey2 = const Color(0xFF262628);
  static const menuUserNameBackground = const Color(0xFF1B1B1B);
  static const listViewAndMenuBackground = const Color(0xFF202020);
  static const listViewItemBackground = const Color(0xFF292929);
  static const buttonHalo = const Color(0xFF323232);
  static const grey = const Color(0xFF2c2c2f);
  static const blue = const Color(0xFF073764);
  static const lightBlue = const Color(0xFF0070c0);
  static const red = const Color(0xFFDC7274);
  static const white20 = const Color(0x33FFFFFF);
  static const white30 = const Color(0x66FFFFFF);
  static const white50 = const Color(0x80FFFFFF);
  static const blackTwo = const Color(0xFF181616);
  static const black12 = const Color(0x1F000000);
  static const black50 = const Color(0x80000000);
  static const white12 = const Color(0x1FFFFFFF);
  static const charcoalGrey = const Color(0xFF3D3D41);
  static const toggleBackground = const Color(0xFF474749);
  static const toggleInActive = const Color(0xFF57697C);
  static const toggleActive = Colors.white;
  static const toggleIconActive = blue;
  static const toggleIconInActive = Colors.white;
  static const tabIndicator = const Color(0xFF0274B3);
  static const tabIndicatorInactive = const Color(0xFF4D4D4E);
  static const notificationDot = const Color(0xFFDC7173);

  static const radioButtonBgUnselected = const Color(0xFF4C4C4D);
  static const radioButtonBgSelected = blue;

  static const formFieldLabelStyle = const TextStyle(
    color: white50,
    fontSize: 16.0,
  );

  static ThemeData themeTopLevel() {
    final textTheme = const TextTheme(
      title: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
      ),
    );
    var theme = ThemeData(
      brightness: Brightness.dark,
      backgroundColor: AppTheme.darkGrey,
      scaffoldBackgroundColor: AppTheme.darkGrey,
      primaryColor: AppTheme.blue,
      accentColor: Colors.lightBlue,
      fontFamily: AppFonts.mavenPro,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      cursorColor: AppTheme.lightBlue,
      textSelectionHandleColor: AppTheme.lightBlue,
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.white,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      accentTextTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: formFieldLabelStyle,
      ),
    );
    return theme;
  }
}
