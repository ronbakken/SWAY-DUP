import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/sign_up/check_email_popup.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';

import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';

class SignUpPage extends PageWidget {
  static Route<dynamic> route({UserType userType}) {
    return FadePageRoute(
      builder: (BuildContext context) => SignUpPage(userType: userType),
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
          Navigator.of(context).pushAndRemoveUntil(MainPage.route(widget.userType), (route) => false);
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
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 100.0),
          Text(widget.userType == UserType.influcencer ? 'You are now an influencer!' : 'You are now an business!'),
          SizedBox(height: 10.0),
          Text('Which social media account would you like to connect with?'),
          SizedBox(height: 40.0),
          buildLoginButton(
            leading: InfAssetImage(AppLogo.instagram),
            text: 'INSTAGRAM',
            onPressed: () => backend.get<AuthenticationService>().loginWithInstagram(widget.userType),
          ),
          SizedBox(height: 40.0),
          buildLoginButton(
            leading: InfAssetImage(
              AppLogo.facebook,
            ),
            text: 'FACEBOOK',
            onPressed: () => backend.get<AuthenticationService>().loginWithFacebook(widget.userType),
          ),
          SizedBox(height: 40.0),
          buildLoginButton(
            leading: InfAssetImage(AppLogo.twitter),
            text: 'TWITTER',
            onPressed: () => backend.get<AuthenticationService>().loginWithTwitter(widget.userType),
          ),
        ],
      ),
    );
  }

  Widget buildLoginButton({Widget leading, String text, VoidCallback onPressed}) {
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
        Positioned(left: 20.0, child: leading),
      ],
    );
  }
}
