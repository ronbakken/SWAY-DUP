import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/system/startup_page.dart';
import 'package:inf/ui/widgets/navigation_functions.dart';

class BusinessMainPage extends StatefulWidget {
  @override
  _BusinessMainPageState createState() => _BusinessMainPageState();
}

class _BusinessMainPageState extends State<BusinessMainPage> {

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
  Widget build(BuildContext context) {
    return Center(child: Text('Business MainPage'),);
  }
}