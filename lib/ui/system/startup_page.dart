import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inf/ui/main_page/main_page_business.dart';
import 'package:inf/ui/main_page/main_page_inf.dart';

import 'package:inf/ui/welcome/welcome_page.dart';
import 'package:inf/ui/widgets/navigation_functions.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';


/// This page is only visible for a short moment and should display a
/// loading symbol while the connection to the server is initialized
/// Also it checks if the Navigationservice is enabled and if not asks to enable it.
class StartupPage extends StatefulWidget {
  @override
  _StartupPageState createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  StreamSubscription loginStateChangedSubscription;
  PermissionStatus _locationPermissionStatus;

  @override
  void initState() {
    super.initState();

    checkPermissionStatus();
  }

  /// Checke is we got permissions for the location service and if it is turned on
  void checkPermissionStatus() {
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location)
        .then((status) async {
      if (status == PermissionStatus.granted) {
        waitForLoginState();
      } else {
        /// if we have no permission for loaction we ask for it
        await PermissionHandler()
            .requestPermissions([PermissionGroup.location]);
        status = await PermissionHandler()
            .checkPermissionStatus(PermissionGroup.location);
        if (status == PermissionStatus.granted) {
          waitForLoginState();
        } else {
          /// if we still haven't got permission we update the screen with the last permission state
          setState(() {
            _locationPermissionStatus = status;
          });
        }
      }
    });
  }

  void waitForLoginState() {
    // TODO show spinner
    Widget nextPage;
    loginStateChangedSubscription =
        backend<UserManager>().logInStateChanged.listen(
      (loginResult) async {
        if (loginResult.state == AuthenticationState.success) {
          if (loginResult.user.userType == UserType.influcencer) {
            nextPage = MainPageInf();
          } else {
            nextPage = MainPageBusiness();
          }
        } else {
          nextPage = WelcomePage();
        }

        // TODO hide Spinner
        await replacePage(context, nextPage);
      },
    );
  }

  //*********************************************************
  /// <summary>
  /// dispose
  /// </summary>
  //*********************************************************
  @override
  dispose() {
    loginStateChangedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_locationPermissionStatus == PermissionStatus.denied ||
        _locationPermissionStatus == PermissionStatus.restricted) {
      return Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'It seems you have denied this App the permission to access your current location.'
                  'INF needs this permission to do its job. Please grant the permission to continue.',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40.0,
            ),
            RaisedButton(
              child: Center(
                  child: Text(
                'Grant Permission',
              )),
              onPressed: () async =>
                  await PermissionHandler().openAppSettings(),
            ),
            SizedBox(
              height: 30.0,
            ),
            RaisedButton(
              child: Center(
                  child: Text(
                'Retry',
              )),
              onPressed: () => checkPermissionStatus(),
            )
          ],
        ),
      );
    }
    if (_locationPermissionStatus == PermissionStatus.disabled) {
      return Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'It seems you have disabled your location service '
                  'INF needs to know your location. Please enable it to continue.',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40.0,
            ),
            RaisedButton(
              child: Center(
                  child: Text(
                'Retry',
              )),
              onPressed: () => checkPermissionStatus(),
            )
          ],
        ),
      );
    }
    return Center(
      child: Image.asset('assets/images/splash_logo.png'),
    );
  }
}
