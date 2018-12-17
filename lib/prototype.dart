/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';

import 'package:inf/developer_menu.dart';
import 'package:inf/navigation_bindings/app_switch.dart';
import 'package:inf/network_generic/multi_account_store.dart';
import 'package:inf/network_inheritable/network_provider.dart';
import 'package:inf/network_inheritable/network_stack.dart';
import 'package:inf_common/inf_common.dart';
import 'package:inf/utility/rebuild_tracker.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

class Prototype extends StatefulWidget {
  const Prototype(
      {Key key, @required this.startupConfig, @required this.multiAccountStore})
      : super(key: key);

  final ConfigData startupConfig;
  final MultiAccountStore multiAccountStore;

  @override
  _PrototypeState createState() => _PrototypeState();
}

class _PrototypeState extends State<Prototype> {
  // Set this to fals to bypass the developer menu on launch
  bool developerMenu = false;

  void enterDeveloperMenu([bool state = true]) {
    setState(() {
      developerMenu = state;
    });
  }

  @override
  void reassemble() {
    super.reassemble();

    // Enable this line to return to development mode upon code refresh
    // developerMenu = true;
  }

  Widget _buildMaterialApp(BuildContext context) {
    // Dark switch
    /*
    // Switch theme based on account type
    // ApiClient network = NetworkProvider.of(context);
    bool dark = network.account.accountType == AccountType.business ||
        network.account.accountId == 0;
    */
    bool dark = true;
    // Custom slate green theme
    // Set base colors
    ThemeData theme = dark
        // Dark theme
        ? ThemeData(
            brightness: Brightness.dark, // This makes things dark!
            primarySwatch:
                Colors.blueGrey, // This is just defaults, no need to change!
            disabledColor: Colors.white12, // Dark fix
            primaryColorBrightness: Brightness.dark,
            accentColorBrightness: Brightness.dark,
          )
        // Light theme
        : ThemeData(
            primarySwatch: Colors.blueGrey,
          );
    if (dark) {
      // Adjust colors
      theme = theme.copyWith(
        // Generate these values on https://material.io/color/!
        primaryColor: Color.fromARGB(0xff, 0x53, 0x66, 0x59),
        primaryColorLight: Color.fromARGB(0xff, 0x80, 0x94, 0x86),
        primaryColorDark: Color.lerp(Color.fromARGB(0xff, 0x2a, 0x3c, 0x30),
            Color.fromARGB(0xff, 0x80, 0x94, 0x86), 0.125),
        buttonColor: Color.fromARGB(0xff, 0x53, 0x66, 0x59),
        // Double the value of primaryColor // Generate A200 on http://mcg.mbitson.com/!
        accentColor: Color.fromARGB(0xff, 0xa8, 0xcd, 0xb3), // 52FF88,
        // Grayscale of primaryColor
        unselectedWidgetColor: Color.fromARGB(0xff, 0x5D, 0x5D, 0x5D),
      );
    } else {
      theme = theme.copyWith(
        // Generate these values on https://material.io/color/!
        primaryColor: Color.fromARGB(0xff, 0x53, 0x66, 0x59),
        primaryColorLight: Color.fromARGB(0xff, 0x80, 0x94, 0x86),
        primaryColorDark: Color.fromARGB(0xff, 0x2a, 0x3c, 0x30),
      );
    }
    /*
    // Custom sharp green theme
    // Set base colors
    ThemeData theme = dark
        // Dark theme
        ? new ThemeData(
            brightness: Brightness.dark, // This makes things dark!
            primarySwatch:
                Colors.blueGrey, // This is just defaults, no need to change!
            disabledColor: Colors.white12, // Dark fix
            primaryColorBrightness: Brightness.dark,
            accentColorBrightness: Brightness.dark,
          )
        // Light theme
        : new ThemeData(
            primarySwatch: Colors.blueGrey,
          );
    if (dark) {
      // Adjust colors
      theme = theme.copyWith(
        // Generate these values on https://material.io/color/!
        primaryColor: new Color.fromARGB(0xff, 0x0d, 0x82, 0x6a),
        primaryColorLight: new Color.fromARGB(0xff, 0x4e, 0xb2, 0x98),
        primaryColorDark: Color.lerp(new Color.fromARGB(0xff, 0x00, 0x54, 0x3f),
            new Color.fromARGB(0xff, 0x80, 0x94, 0x86), 0.125),
        buttonColor: new Color.fromARGB(0xff, 0x0d, 0x82, 0x6a),
        // Double the value of primaryColor // Generate A200 on http://mcg.mbitson.com/!
        accentColor: new Color.fromARGB(0xff, 0x52, 0xff, 0xc5), // 52FF88,
        // Grayscale of primaryColor
        unselectedWidgetColor: new Color.fromARGB(0xff, 0x5D, 0x5D, 0x5D),
      );
    } else {
      theme = theme.copyWith(
        // Generate these values on https://material.io/color/!
        primaryColor: new Color.fromARGB(0xff, 0x53, 0x66, 0x59),
        primaryColorLight: new Color.fromARGB(0xff, 0x80, 0x94, 0x86),
        primaryColorDark: new Color.fromARGB(0xff, 0x2a, 0x3c, 0x30),
      );
    }
    */
    // Plain blue theme
    /*
    ThemeData theme = dark
        // Dark theme
        ? new ThemeData(
            brightness: Brightness.dark, // This makes things dark!
            primarySwatch: Colors.blue,
            primaryColor: Colors.blue,
            disabledColor: Colors.white12, // Dark fix
            primaryColorBrightness: Brightness.dark,
            accentColorBrightness: Brightness.dark,
          )
        // Light theme
        : new ThemeData(
            primarySwatch: Colors.blue,
          );
    */
    // Adjust widget themes
    theme = theme.copyWith(
      buttonTheme: theme.buttonTheme.copyWith(
        shape: const StadiumBorder(),
      ),
    );
    // Use final theme
    // theme = AppTheme.themeTopLevel();
    theme = ThemeData(
      brightness: Brightness.dark, // This makes things dark!
      primarySwatch:
          Colors.blueGrey, // This is just defaults, no need to change!
      disabledColor: Colors.white12, // Dark fix
      primaryColorBrightness: Brightness.dark,
      accentColorBrightness: Brightness.dark,
      fontFamily: AppFonts.mavenPro,
    );
    ApiClient network = NetworkProvider.of(context);
    theme = theme.copyWith(
      primaryColor: AppTheme.blue, // AppTheme.blackTwo,
      backgroundColor: AppTheme.darkGrey,
      scaffoldBackgroundColor: AppTheme.darkGrey,
      accentColor: network.account.accountType == AccountType.influencer
          ? AppTheme.lighterBlue
          : AppTheme
              .red, // const Color.fromARGB(255, 100, 206, 255) : const Color.fromARGB(255, 206, 255, 100), // const Color.fromARGB(255, 206, 100, 255), //
      buttonTheme: theme.buttonTheme.copyWith(
        buttonColor: Colors.white,
        textTheme: ButtonTextTheme.primary,
      ),
    );
    return MaterialApp(
      title: 'INF Marketplace',
      // debugShowMaterialGrid: true,
      theme: theme,
      home: !developerMenu
          ? Builder(
              builder: (BuildContext context) {
                return RebuildTracker(
                  message: 'Full app rebuild triggered (3)',
                  child: AppSwitch(),
                );
              },
            )
          : Builder(
              builder: (BuildContext context) {
                return RebuildTracker(
                  message: 'Full app rebuild triggered (3)',
                  child: DeveloperMenu(
                    onExitDevelopmentMode: () {
                      enterDeveloperMenu(false);
                    },
                  ),
                );
              },
            ),
      builder: _supportTransparentNavOnAndroid,
    );
  }

  Widget _supportTransparentNavOnAndroid(BuildContext context, Widget child) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final mediaQuery = MediaQueryData.fromWindow(ui.window);
      final bottomInset = mediaQuery.viewInsets.bottom;
      // Nexus 5X = 2.625  text = 1.0
      // iPhone XR = 2.0 text = 1.0
      return MediaQuery(
        data: mediaQuery.copyWith(
          padding: mediaQuery.padding.copyWith(
            bottom: (bottomInset < 64.0 ? bottomInset : 0.0),
          ),
          viewInsets: mediaQuery.viewInsets.copyWith(
            bottom: (bottomInset < 64.0 ? 0.0 : bottomInset),
          ),
          //textScaleFactor: mediaQuery.devicePixelRatio
          //devicePixelRatio: 2.0,
        ),
        child: child,
      );
    } else {
      return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NetworkStack(
      startupConfig: widget.startupConfig,
      multiAccountStore: widget.multiAccountStore,
      child: RebuildTracker(
        message: 'Full app rebuild triggered (1)',
        child: Builder(builder: (BuildContext context) {
          return RebuildTracker(
            message: "Full app rebuild triggered (2)",
            child: _buildMaterialApp(context),
          );
        }),
      ),
    );
  }
}

/* end of file */
