import 'package:flutter/material.dart';
import 'package:inf/ui/welcome/onboarding_page.dart';

class OnboardingPageBusiness extends StatefulWidget {
  @override
  OnboardingPageBusinessState createState() {
    return new OnboardingPageBusinessState();
  }
}

class OnboardingPageBusinessState extends State<OnboardingPageBusiness> {
  @override
  Widget build(BuildContext context) {
    return OnboardingPage(title: 'Onboarding Business',
      pages: <Widget>[
                page1(context),
                page2(context),
                page3(context),
              ],
    );
  }

  Widget page1(BuildContext context) {
    return Center(child: Text('Page1'));
  }

  Widget page2(BuildContext context) {
    return Center(child: Text('Page2'));
  }

  Widget page3(BuildContext context) {
    return Center(child: Text('Page3'));
  }
}
