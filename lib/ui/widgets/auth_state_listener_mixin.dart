import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';

import 'package:inf/ui/system_pages/startup_page.dart';

mixin AuthStateMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription _loginStateChangedSubscription;

  @override
  void initState() {
    super.initState();
    _loginStateChangedSubscription =
        backend.get<UserManager>().logInStateChanged.listen(onAuthStateChanged);
  }

  void onAuthStateChanged(AuthenticationResult authResult) {
    switch (authResult.state) {
      case AuthenticationState.notLoggedIn:
        Navigator.of(context)
            .pushAndRemoveUntil(StartupPage.route(), (route) => false);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _loginStateChangedSubscription.cancel();
    super.dispose();
  }
}
