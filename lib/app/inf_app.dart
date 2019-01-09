import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/welcome/startup_page.dart';

class InfApp extends StatefulWidget {
  @override
  InfAppState createState() => InfAppState();
}

class InfAppState extends State<InfApp> with WidgetsBindingObserver {

  SystemService _systemService;

  @override
  void initState() {
    super.initState();
    _systemService = backend.get<SystemService>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(ui.AppLifecycleState state) {
    if(state == AppLifecycleState.paused) {
      _systemService.setLifecycleState(LifecycleState.paused);
    }
    else if (state == AppLifecycleState.resumed) {
      _systemService.setLifecycleState(LifecycleState.resumed);
    }
    else{
      print(state);
    }    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //debugShowMaterialGrid: true,
      title: 'INF',
      theme: AppTheme.themeTopLevel(),
      home: StartupPage(),
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
}
