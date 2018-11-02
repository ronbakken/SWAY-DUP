import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';

import 'package:inf/ui/system/startup_page.dart';

mixin AuthStateListenerMixin<T extends StatefulWidget> on State<T> {
  
  StreamSubscription _loginStateChangedSubscription;

  @override
  void initState() {
    super.initState();
    _loginStateChangedSubscription = backend
        .get<UserManager>()
        .logInStateChanged
        .listen((loginResult) async {
      switch (loginResult.state) {
        case AuthenticationState.notLoggedIn:
          await Navigator.of(context).pushReplacement(StartupPage.route());
          break;
        default:
      }
    });
  }

  @override 
  void dispose() {
    _loginStateChangedSubscription.cancel();
    super.dispose();
  }
}