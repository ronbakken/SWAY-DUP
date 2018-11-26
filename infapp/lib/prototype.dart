/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';

import 'package:inf/developer_menu.dart';
import 'package:inf/navigation_bindings/app_switch.dart';
import 'package:inf/network_generic/multi_account_store.dart';
import 'package:inf/network_inheritable/network_stack.dart';
import 'package:inf_common/inf_common.dart';
import 'package:inf/utility/rebuild_tracker.dart';

class Prototype extends StatefulWidget {
  const Prototype(
      {Key key, @required this.startupConfig, @required this.multiAccountStore})
      : super(key: key);

  final ConfigData startupConfig;
  final MultiAccountStore multiAccountStore;

  @override
  _PrototypeState createState() => new _PrototypeState();
}

class _PrototypeState extends State<Prototype> {
  // Set this to fals to bypass the developer menu on launch
  bool developerMenu = true;

  void enterDeveloperMenu([bool state = true]) {
    setState(() {
      developerMenu = state;
    });
  }

  @override
  void reassemble() {
    super.reassemble();

    // Enable this line to return to development mode upon code refresh
    developerMenu = true;
  }

  Widget _buildMaterialApp(BuildContext context) {
    // Dark switch
    /*
    // Switch theme based on account type
    // ApiClient network = NetworkProvider.of(context);
    bool dark = network.account.state.accountType == AccountType.business ||
        network.account.state.accountId == 0;
    */
    bool dark = true;
    // Custom slate green theme
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
        primaryColor: new Color.fromARGB(0xff, 0x53, 0x66, 0x59),
        primaryColorLight: new Color.fromARGB(0xff, 0x80, 0x94, 0x86),
        primaryColorDark: Color.lerp(new Color.fromARGB(0xff, 0x2a, 0x3c, 0x30),
            new Color.fromARGB(0xff, 0x80, 0x94, 0x86), 0.125),
        buttonColor: new Color.fromARGB(0xff, 0x53, 0x66, 0x59),
        // Double the value of primaryColor // Generate A200 on http://mcg.mbitson.com/!
        accentColor: new Color.fromARGB(0xff, 0xa8, 0xcd, 0xb3), // 52FF88,
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
        shape: new StadiumBorder(),
      ),
    );
    return new MaterialApp(
      title: 'INF Marketplace',
      // debugShowMaterialGrid: true,
      theme: theme,
      home: !developerMenu
          ? new Builder(
              builder: (BuildContext context) {
                return new RebuildTracker(
                  message: "Full app rebuild triggered (3)",
                  child: new AppSwitch(),
                );
              },
            )
          : new Builder(
              builder: (BuildContext context) {
                return new RebuildTracker(
                  message: "Full app rebuild triggered (3)",
                  child: new DeveloperMenu(
                    onExitDevelopmentMode: () {
                      enterDeveloperMenu(false);
                    },
                  ),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new NetworkStack(
      startupConfig: widget.startupConfig,
      multiAccountStore: widget.multiAccountStore,
      child: new RebuildTracker(
        message: "Full app rebuild triggered (1)",
        child: new Builder(builder: (BuildContext context) {
          return new RebuildTracker(
            message: "Full app rebuild triggered (2)",
            child: _buildMaterialApp(context),
          );
        }),
      ),
    );
  }
}

/* end of file */
