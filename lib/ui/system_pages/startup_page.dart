import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/sign_up/check_email_popup.dart';
import 'package:inf/ui/system_pages/no_network_page.dart';
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
  StreamSubscription loginStateChangedSubscription;
//  PermissionStatus _locationPermissionStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await initBackend();
      } on GrpcError   {
        await Navigator.of(context).push(NoNetworkPage.route());
        await initBackend();
      }
      on AppMustUpdateException {
        
      }
      on SocketException {
        // TODO How do we deal with this?
      }
      waitForLoginState();
    });
  }

  void waitForLoginState() {
    loginStateChangedSubscription = backend.get<UserManager>().logInStateChanged.listen(
      (loginResult) {
        Route nextPage;
        switch (loginResult.state) {

          /// This is in case that the user has not activated his account
          /// but has closed the App
          case AuthenticationState.waitingForActivation:
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CheckEmailPopUp(
                  userType: loginResult.user.userType,
                  email: loginResult.user.email,
                );
              },
            );
            nextPage = MainPage.route(loginResult.user.userType);
            break;

          case AuthenticationState.success:
            nextPage = MainPage.route(loginResult.user.userType);
            break;

          default:
            nextPage = WelcomePage.route();
        }

        Navigator.of(context).pushReplacement(nextPage);
      },
    );
  }

  @override
  void dispose() {
    loginStateChangedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.backgroundColor,
      /*child: Center(
        child: Image.asset(Images.assetSplashLogo),
      ),*/
    );
  }

  /// Check is we got permissions for the location service and if it is turned on
  void checkPermissionStatus() {
    waitForLoginState();

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
