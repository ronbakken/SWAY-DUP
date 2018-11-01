import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/welcome/onboarding_business.dart';
import 'package:inf/ui/welcome/onboarding_inf.dart';
import 'package:inf/ui/widgets/navigation_functions.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                onPressed: () async {
                  await backend.get<AuthenticationService>().setUserType(UserType.influcencer);
                  await replacePage(context, OnboardingPageInfluencer());
                },
                child: Text('Influencer'),
              ),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(
                onPressed: () async {
                  await backend.get<AuthenticationService>().setUserType(UserType.business);
                  await replacePage(context, OnboardingPageBusiness());
                },
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
  }
}
