import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/system/startup_page.dart';
import 'package:inf/ui/widgets/navigation_functions.dart';

class MainPageBusiness extends StatefulWidget {
  @override
  _MainPageBusinessState createState() => _MainPageBusinessState();
}

class _MainPageBusinessState extends State<MainPageBusiness> {

  StreamSubscription loginStateChangedSubscription;

  @override
  void initState() {
    loginStateChangedSubscription = backend
        .get<UserManager>()
        .logInStateChanged
        .listen((loginResult) async {
      switch (loginResult.state) {
        case AuthenticationState.notLoggedIn:
          await replacePage(context, StartupPage());
          break;
        default:
      }
    });

    super.initState();
  }

  @override 
  void dispose() {
      loginStateChangedSubscription.cancel();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Business MainPage'),);
  }
}