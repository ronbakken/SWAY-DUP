import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';

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
