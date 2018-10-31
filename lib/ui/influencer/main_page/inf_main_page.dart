import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inf/backend/managers/user_manager_.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/auth_service.dart';

class InfMainPage extends StatefulWidget {
  @override
  _InfMainPageState createState() => _InfMainPageState();
}

class _InfMainPageState extends State<InfMainPage> {
  StreamSubscription loginStateChangedSubscription;

  @override
  void initState() {
    loginStateChangedSubscription = backend
        .get<UserManager>()
        .logInStateChanged
        .listen((loginResult) async {
      switch (loginResult.state) {
        case AuthenticationState.notLoggedIn:
          replacePage(StartupPage());
          break;
        default:
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
