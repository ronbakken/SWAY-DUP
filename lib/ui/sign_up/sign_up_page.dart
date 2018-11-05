import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/main_page/main_page.dart';
import 'package:inf/ui/sign_up/check_email_popup.dart';
import 'package:inf/ui/system/startup_page.dart';
import 'package:inf/ui/widgets/inf_button.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'dart:developer';

class SignUpPage extends StatefulWidget {
  final UserType userType;

  const SignUpPage({Key key, this.userType}) : super(key: key);

  static Route<dynamic> route({UserType userType}) {
    return FadePageRoute(
      builder: (context) => SignUpPage(
            userType: userType,
          ),
    );
  }

  @override
  SignUpPageState createState() {
    return new SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> {
  StreamSubscription _loginStateChangedSubscription;

  @override
  void initState() {
    super.initState();
    _loginStateChangedSubscription = backend.get<UserManager>().logInStateChanged.listen((loginResult)  {
      switch (loginResult.state) {
        case AuthenticationState.waitingForActivation:
          showDialog(
              context: context,
              builder: (context) => CheckEmailPopUp(
                    userType: widget.userType,
                    email: loginResult.user.email,
                  ));
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
          SizedBox(
            height: 100.0,
          ),
          Text(widget.userType == UserType.influcencer ? 'You are now an influencer!' : 'You are now an business!'),
          SizedBox(height: 10.0),
          Text('Which social media account would you like to connect with?'),
          SizedBox(height: 40.0),
          InfButton(
              leading: Image.asset('assets/images/instagram_logo.png'),
              text: 'INSTAGRAM',
              onPressed: () => backend.get<AuthenticationService>().loginWithInstagram(widget.userType)),
          SizedBox(height: 40.0),
          InfButton(
              leading: SvgPicture.asset('assets/images/facebook_logo.svg'),
              text: 'FACEBOOK',
              onPressed: () => backend.get<AuthenticationService>().loginWithFacebook(widget.userType)),
          SizedBox(height: 40.0),
          InfButton(
              leading: SvgPicture.asset('assets/images/twitter_logo.svg'),
              text: 'TWITTER',
              onPressed: () => backend.get<AuthenticationService>().loginWithTwitter(widget.userType)),
        ],
      ),
    );
  }
}
