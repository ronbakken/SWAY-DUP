import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/welcome/onboarding_business.dart';
import 'package:inf/ui/welcome/onboarding_inf.dart';
import 'package:inf/ui/welcome/onboarding_page.dart';
import 'package:inf/ui/widgets/connection_builder.dart';
import 'package:inf/ui/widgets/routes.dart';

class WelcomePage extends StatelessWidget {

	static Route<dynamic> route() {
		return FadePageRoute(
			builder: (context) =>
				WelcomePage(
				),
		);
	}



  @override
  Widget build(BuildContext context) {
    return ConnectionBuilder(builder: (contex, connectionState) {
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
                    await backend
                        .get<AuthenticationService>()
                        .setUserType(UserType.influcencer);
                    await Navigator.of(context).push(OnboardingPage.route(userType: UserType.influcencer));
                  },
                  child: Text('Influencer'),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  onPressed: () async {
                    await backend
                        .get<AuthenticationService>()
                        .setUserType(UserType.business);
                    await Navigator.of(context).push(OnboardingPage.route(userType: UserType.business));
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
    });
  }
}
