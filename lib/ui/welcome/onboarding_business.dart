import 'package:flutter/material.dart';

class OnboardingPageBusiness extends StatefulWidget {
  @override
  OnboardingPageBusinessState createState() {
    return new OnboardingPageBusinessState();
  }
}

class OnboardingPageBusinessState extends State<OnboardingPageBusiness> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Center(child: Text('Business Onboarding'),),
          Expanded(
            child: PageView(
              children: <Widget>[
                page1(context),
                page2(context),
                page3(context),
              ],
            ),
          ),
        ],
      ),
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
