import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/welcome/onboarding_business.dart';
import 'package:inf/ui/welcome/onboarding_inf.dart';
import 'package:inf/ui/welcome/onboarding_page.dart';
import 'package:inf/ui/widgets/connection_builder.dart';
import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';

class WelcomePage extends PageWidget {
  static Route<dynamic> route() {
    return FadePageRoute(
      builder: (BuildContext context) => WelcomePage(),
    );
  }

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends PageState<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return ConnectionBuilder(
      builder: (BuildContext context, NetworkConnectionState connectionState) {
        return Material(
          child: Stack(
            children: <Widget>[
              Placeholder(),
              Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text('Welcome'),
                    ),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.of(context).push(OnBoardingPage.route(userType: UserType.influcencer)),
                    child: Text('Influencer'),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  FlatButton(
                    onPressed: () => Navigator.of(context).push(OnBoardingPage.route(userType: UserType.business)),
                    child: Text('Business'),
                  ),
                  SizedBox(
                    height: 50.0,
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
