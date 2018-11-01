import 'package:flutter/material.dart';

class OnboardingPageInfluencer extends StatefulWidget {
  @override
  OnboardingPageInfluencerState createState() {
    return new OnboardingPageInfluencerState();
  }
}

class OnboardingPageInfluencerState extends State<OnboardingPageInfluencer> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Center(child: Text('Influencer Onboarding'),),
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
