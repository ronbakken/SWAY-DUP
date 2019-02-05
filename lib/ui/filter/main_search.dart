import 'dart:ui' show window;

import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/filter/filter_panel.dart';
import 'package:inf/ui/main/page_mode.dart';
import 'package:inf_api_client/inf_api_client.dart';

void main() => runApp(FilterMenuApp());

class FilterMenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.themeTopLevel(),
      builder: _supportTransparentNavOnAndroid,
      home: Material(
        color: Colors.black,
        child: FilterMenuPage(),
      ),
    );
  }

  Widget _supportTransparentNavOnAndroid(BuildContext context, Widget child) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final mediaQuery = MediaQueryData.fromWindow(window);
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

class FilterMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Placeholder(),
        BottomNavPanel(
          userType: UserType.influencer,
          initialValue: MainPageMode.browse,
          onBottomNavChanged: (MainPageMode value) {},
        ),
      ],
    );
  }
}
