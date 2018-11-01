import 'package:flutter/material.dart';

class InfluencerOnboardingPage extends StatefulWidget {
  @override
  InfluencerOnboardingPageState createState() {
    return new InfluencerOnboardingPageState();
  }
}

class InfluencerOnboardingPageState extends State<InfluencerOnboardingPage> {
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
