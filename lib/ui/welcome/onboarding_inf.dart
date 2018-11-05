import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/main_page/main_page.dart';
import 'package:inf/ui/sign_up/sign_up_page.dart';

List<Widget> buildInfluencerPages(BuildContext context) {
  Widget page1(BuildContext context) {
    return Center(child: Text('Page1'));
  }

  Widget page2(BuildContext context) {
    return Center(child: Text('Page2'));
  }

  Widget page3(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(child: Text('Page3')),
        FlatButton(
          onPressed: () => Navigator.of(context).pushReplacement(SignUpPage.route(userType: UserType.influcencer)),
          child: Text('SignUp'),
        ),
        FlatButton(
          onPressed: () async {
            await backend.get<AuthenticationService>().loginAnonymous(UserType.influcencer);
            await Navigator.of(context).pushAndRemoveUntil(MainPage.route(UserType.influcencer), (route) => false);
          },
          child: Text('Skip for now'),
        ),
      ],
    );
  }

  return <Widget>[
    page1(context),
    page2(context),
    page3(context),
  ];
}
