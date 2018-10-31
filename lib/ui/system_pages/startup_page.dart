import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/backend/managers/app_manager_.dart';
import 'package:inf/backend/managers/user_manager_.dart';
import 'package:inf/backend/services/auth_service.dart';
import 'package:inf/ui/business/main_page/business_main_page.dart';
import 'package:inf/ui/influencer/main_page/inf_main_page.dart';
import 'package:inf/ui/welcome/welcome_page.dart';
import 'package:permission_handler/permission_handler.dart';

//*********************************************************
/// <summary>
/// This widget is the root of your application.
/// </summary>
//*********************************************************
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
        backend<UserManager>().logInStateChanged.listen((loginResult) async {
      if (loginResult.state == AuthenticationState.success) {
        if (backend<UserManager>().currentUser.userType == AppMode.influcencer) {
          nextPage = InfMainPage();
        } else {
          nextPage = BusinessMainPage();
        }
      } else {  
        nextPage = WelcomePage();
      }

      // TODO hide Spinner
      await Navigator.pushReplacement<void, void>(
          context,
          PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) {
                return nextPage;
              },
              transitionsBuilder:
                  (___, Animation<double> animation, ____, Widget child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              }));
    });
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
    if (_locationPermissionStatus == null)
      return Container(
        color: Colors.white,
      );

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
  }
}
