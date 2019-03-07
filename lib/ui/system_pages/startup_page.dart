import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/sign_up/activation_success_page.dart';
import 'package:inf/ui/system_pages/no_connection_page.dart';
import 'package:inf/ui/welcome/welcome_page.dart';
import 'package:inf/ui/widgets/dialogs.dart';
import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rx_command/rx_command.dart';
import 'package:uni_links/uni_links.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

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
  RxCommandListener<LoginToken, bool> _loginCommandListener;

  // in case we are started from an login link the token goes here
  LoginToken _loginToken;

  @override
  void initState() {
    super.initState();
    var loginCommand = backend<UserManager>().logInUserCommand;

    _loginCommandListener = RxCommandListener<LoginToken, bool>(
      loginCommand,
      onValue: (loginSuccess) {
        Route nextPage;
        if (loginSuccess) {
          // we got started with an login token with a new user we jump to a different startup page
          if ((_loginToken != null) && _loginToken.accountState == UserDto_Status.waitingForActivation) {
            Navigator.of(context).pushReplacement(WelcomeRoute());
            Navigator.of(context).push(ActivationSuccessPage.route(_loginToken.userType));
            return;
          } else {
            nextPage = MainPage.route();
          }
        } else {
          // No login success
          nextPage = WelcomeRoute();
        }
        _firebaseMessaging.requestNotificationPermissions();
        _firebaseMessaging.getToken().then((token) {
          print('Push Token: $token');
        });
        _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
          print('Push Received: $message');
        });
        Navigator.of(context).pushReplacement(nextPage);
      },
      onError: (error) async {
        if (error is SocketException) {
          // Wait till we have a connection again
          await Navigator.of(context).push(NoConnectionPage.route());
          loginCommand.execute(_loginToken);
        } else if (error is GrpcError) {
          if (_loginToken != null) {
            await showMessageDialog(context, 'Login problem',
                'Sorry the link you used seems not to be valid. Please use the latest link you got or signup again');
          }
          unawaited(Navigator.of(context).pushReplacement(WelcomeRoute()));
        } else {
          await backend<ErrorReporter>().logException(error);
        }
      },
    );

    initBackend().catchError((error) async {
      await Navigator.of(context).push(NoConnectionPage.route());
      await initBackend();
    }).then((_) async {
      Uri initialUri = await getInitialUri();
      //   await showMessageDialog(
      // context, 'Debug', initialUri.toString());
      if (initialUri != null && initialUri.queryParameters.containsKey('token')) {
        {
          try {
            _loginToken = LoginToken.fromJwt(initialUri.queryParameters['token']);
          } catch (ex) {
            await showMessageDialog(
                context, 'Login problem', 'Sorry the link you used seems not to be valid. Please signup again');
          }
        }
      }

      // if _loginToken == null this will try to login with a stored
      // refresh-token
      loginCommand.execute(_loginToken);
    });
  }

  @override
  void dispose() {
    _loginCommandListener?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.backgroundColor,
      child: const Center(
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
