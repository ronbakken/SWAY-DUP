import 'package:flutter/material.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/welcome/onboarding_business.dart';
import 'package:inf/ui/welcome/onboarding_inf.dart';
import 'package:inf/ui/widgets/routes.dart';

class OnBoardingPage extends StatefulWidget {
  final UserType userType;

  static Route<dynamic> route({UserType userType}) {
    return FadePageRoute(
      builder: (context) => OnBoardingPage(
            userType: userType,
          ),
    );
  }

  const OnBoardingPage({Key key, this.userType}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> pages;
    String title;
    switch (widget.userType) {
      case UserType.influcencer:
        pages = buildInfluencerPages(context);
        title = 'Onboarding Influencer';
        break;
      case UserType.business:
        pages = buildBusinessPages(context);
        title = 'Onboarding business';
        break;
      default:
        assert(false, 'Never should get here');
    }
    return Material(
      child: Column(
        children: <Widget>[
          Center(
            child: Text(title),
          ),
          Expanded(
            child: PageView(children: pages),
          ),
        ],
      ),
    );
  }
}
