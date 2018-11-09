import 'dart:async';

import 'package:flutter/material.dart';
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
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.only(top: 40.0),
      child: Material(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            fit: StackFit.passthrough,
            children: [
              CurvedBox(
                color: AppTheme.blue,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: InfAssetImage(AppLogo.infLogo, width: 96.0),
                ),
              ),
              Positioned(
                left: 20.0,
                top: 32.0,
                child: InkResponse(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back, size: 28.0),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 32.0),
            child: Column(
              children: [
                Text(widget.userType == UserType.influcencer
                    ? 'You are now an influencer!'
                    : 'You are now an business!'),
                SizedBox(height: 10.0),
                Text('Which social media account would you like to continue with?'),
                SizedBox(height: 16.0),
                buildLoginButton(
                  leading: AppLogo.instagram,
                  text: 'INSTAGRAM',
                  onPressed: () => backend.get<AuthenticationService>().loginWithInstagram(widget.userType),
                ),
                SizedBox(height: 16.0),
                buildLoginButton(
                  leading: AppLogo.facebook,
                  text: 'FACEBOOK',
                  onPressed: () => backend.get<AuthenticationService>().loginWithFacebook(widget.userType),
                ),
                SizedBox(height: 16.0),
                buildLoginButton(
                  leading: AppLogo.twitter,
                  text: 'TWITTER',
                  onPressed: () => backend.get<AuthenticationService>().loginWithTwitter(widget.userType),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget buildLoginButton({AppAsset leading, String text, VoidCallback onPressed}) {
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
}
