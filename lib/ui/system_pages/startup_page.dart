import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/sign_up/check_email_popup.dart';
import 'package:inf/ui/system_pages/no_connection_page.dart';
import 'package:inf/ui/welcome/welcome_page.dart';
import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:inf/backend/backend.dart';

class StartupPage extends PageWidget {
  static Route<dynamic> route() {
    return FadePageRoute(
      builder: (BuildContext context) => StartupPage(),
    );
  }

  @override
  _StartupPageState createState() => _StartupPageState();
}

class _StartupPageState extends PageState<StartupPage> {
  StreamSubscription _loginCommandSubscription;
  StreamSubscription _loginCommandErrorSubscription;
//  PermissionStatus _locationPermissionStatus;

  @override
  void initState() {
    super.initState();
    var loginCommand = backend.get<UserManager>().logInUserCommand;

    _loginCommandSubscription = loginCommand.listen((loginSuccess) {
      Route nextPage;
      if (loginSuccess) {
        nextPage = MainPage.route();
      } else {
        nextPage = WelcomePage.route();
      }
      Navigator.of(context).pushReplacement(nextPage);
    });

    _loginCommandErrorSubscription = loginCommand.thrownExceptions.listen((error) async {
      if (error is GrpcError || error is SocketException) {
        await Navigator.of(context).push(NoConnectionPage.route());
        loginCommand.execute();
      } else {
        await backend.get<ErrorReporter>().logException(error);
      }
    });

    initBackend().catchError((error) async {
      await Navigator.of(context).push(NoConnectionPage.route());
      await initBackend();
    }).then((_) {
      loginCommand.execute();
    });
  }

  @override
  void dispose() {
    _loginCommandSubscription?.cancel();
    _loginCommandErrorSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.backgroundColor,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Check is we got permissions for the location service and if it is turned on
  void checkPermissionStatus() {
    // PermissionHandler().checkPermissionStatus(PermissionGroup.location).then((status) async {
    //   if (status == PermissionStatus.granted) {
    //     waitForLoginState();
    //   } else {
    //     /// if we have no permission for location we ask for it
    //     await PermissionHandler().requestPermissions([PermissionGroup.location]);
    //     status = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
    //     if (status == PermissionStatus.granted) {
    //       waitForLoginState();
    //     } else {
    //       /// if we still haven't got permission we update the screen with the last permission state
    //       setState(() {
    //         _locationPermissionStatus = status;
    //       });
    //     }
    //   }
    // });
  }

  // Widget displayPermissionStatus() {
  //   if (_locationPermissionStatus == PermissionStatus.denied ||
  //       _locationPermissionStatus == PermissionStatus.restricted) {
  //     return Material(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Text(
  //             'It seems you have denied this App the permission to access your current location.'
  //                 'INF needs this permission to do its job. Please grant the permission to continue.',
  //             textAlign: TextAlign.center,
  //           ),
  //           SizedBox(height: 40.0),
  //           RaisedButton(
  //             child: Center(
  //                 child: Text(
  //               'Grant Permission',
  //             )),
  //             onPressed: () => PermissionHandler().openAppSettings(),
  //           ),
  //           SizedBox(height: 30.0),
  //           RaisedButton(
  //             child: Center(
  //                 child: Text('Retry'),
  //             ),
  //             onPressed: () => checkPermissionStatus(),
  //           )
  //         ],
  //       ),
  //     );
  //   }
  //   if (_locationPermissionStatus == PermissionStatus.disabled) {
  //     return Material(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Text(
  //             'It seems you have disabled your location service '
  //                 'INF needs to know your location. Please enable it to continue.',
  //             textAlign: TextAlign.center,
  //           ),
  //           SizedBox(height: 40.0),
  //           RaisedButton(
  //             child: Center(
  //               child: Text('Retry'),
  //             ),
  //             onPressed: () => checkPermissionStatus(),
  //           )
  //         ],
  //       ),
  //     );
  //   }
  //   return null;
  // }
}
