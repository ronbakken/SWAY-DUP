import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/sign_up/check_email_popup.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';

import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';

class SignUpPage extends PageWidget {
  static Route<dynamic> route({UserType userType}) {
    return PageRouteBuilder(
      pageBuilder: (BuildContext context, _, __) {
        return SignUpPage(userType: userType);
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, _, Widget child) {
        final slide = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero).animate(animation);
        return SlideTransition(
          position: slide,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 650),
      opaque: false,
    );
  }

  const SignUpPage({
    Key key,
    this.userType,
  }) : super(key: key);

  final UserType userType;

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends PageState<SignUpPage> {
  StreamSubscription _loginStateChangedSubscription;

  @override
  void initState() {
    super.initState();
    _loginStateChangedSubscription = backend.get<UserManager>().logInStateChanged.listen((loginResult) {
      switch (loginResult.state) {
        case AuthenticationState.waitingForActivation:
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CheckEmailPopUp(
                userType: widget.userType,
                email: loginResult.user.email,
              );
            },
          );
          break;
        case AuthenticationState.success:
          Navigator.of(context).pushAndRemoveUntil(
            MainPage.route(widget.userType),
            (route) => false,
          );
          break;
        default:
      }
    });
  }

  @override
  void dispose() {
    _loginStateChangedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQuery.padding.top + 32.0,
        left: 0.0,
        right: 0.0,
      ),
      child: Material(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: constraints.copyWith(
                      minWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight,
                      maxHeight: double.infinity,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 96.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                            child: Column(
                              children: [
                                // Text(
                                //   widget.userType == UserType.influcencer
                                //       ? 'You will continue as an influencer!'
                                //       : 'You will continue as a business!',
                                //   style: TextStyle(fontSize: 18.5),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 40.0, right: 40, top: 10.0, bottom: 32.0),
                                  child: Text(
                                    'Which social media account would you like to continue with?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(height: 1.1),
                                  ),
                                ),
                                _buildLoginButton(
                                  leading: AppLogo.instagram,
                                  text: 'INSTAGRAM',
                                  onPressed: () =>
                                      backend.get<AuthenticationService>().loginWithInstagram(widget.userType),
                                ),
                                SizedBox(height: 16.0),
                                _buildLoginButton(
                                  leading: AppLogo.facebook,
                                  text: 'FACEBOOK',
                                  onPressed: () =>
                                      backend.get<AuthenticationService>().loginWithFacebook(widget.userType),
                                ),
                                SizedBox(height: 16.0),
                                _buildLoginButton(
                                  leading: AppLogo.twitter,
                                  text: 'TWITTER',
                                  onPressed: () =>
                                      backend.get<AuthenticationService>().loginWithTwitter(widget.userType),
                                ),
                                SizedBox(height: 16.0),
                                _buildLoginButton(
                                  leading: AppLogo.google,
                                  text: 'GOOGLE',
                                  onPressed: () =>
                                      backend.get<AuthenticationService>().loginWithGoogle(widget.userType),
                                ),
                                SizedBox(height: 32.0),
                                _buildLoginButton(
                                  leading: AppLogo.email,
                                  text: 'EMAIL',
                                  onPressed: () {
                                    // FIXME: implement email login
                                  },
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          CurvedBox(
                            curveFactor: 0.8,
                            color: Colors.black,
                            top: true,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(48.0, 32.0, 48.0, 16.0 + mediaQuery.padding.bottom),
                              child: Text.rich(
                                TextSpan(
                                  style: TextStyle(height: 1.2),
                                  children: [
                                    // TODO set correct ULRS
                                    TextSpan(text: 'By Signing up, you agree with our\n'),
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: const TextStyle(decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => _launchURL('https://flutter.io'),
                                    ),
                                    TextSpan(text: '  and  '),
                                    TextSpan(
                                      text: 'Privacy',
                                      style: const TextStyle(decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => _launchURL('https://flutter.io'),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 96.0,
                  child: CurvedBox(
                    curveFactor: 0.9,
                    color: AppTheme.blue,
                    bottom: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: InfAssetImage(AppLogo.infLogo, width: 96.0),
                    ),
                  ),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkResponse(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Icon(Icons.arrow_back, size: 24.0),
                        ),
                      ),
                      InkResponse(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('Skip', 
                                textScaleFactor: 1.3,
                              ),
                              Align(
                                widthFactor: 0.85,
                                heightFactor: 0.9,
                                alignment: Alignment.topRight,
                                child: Icon(Icons.chevron_right, size: 28.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginButton({AppAsset leading, String text, VoidCallback onPressed}) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        RaisedButton(
          onPressed: onPressed,
          shape: const StadiumBorder(),
          child: Container(
            alignment: Alignment.center,
            height: 44.0,
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
        Positioned(
          left: 20.0,
          child: InfAssetImage(leading),
          width: 24.0,
        ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
