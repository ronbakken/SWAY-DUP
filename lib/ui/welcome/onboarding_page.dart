import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/sign_up/sign_up_page.dart';
import 'package:inf/ui/widgets/inf_page_indicator.dart';
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
  PageController pageController = new PageController();
  
  @override
  Widget build(BuildContext context) {
    List<Widget> pages;
    String title;
    switch (widget.userType) {
      case UserType.influcencer:
        pages = _buildInfluencerPages(context);
        title = 'Onboarding Influencer';
        break;
      case UserType.business:
        pages = _buildBusinessPages(context);
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
            child: PageView(controller: pageController, children: pages),
          ),
          SafeArea(child: InfPageIndicator(pageController: pageController, count: 3,)),
          SizedBox(height: 10.0,)
        ],
      ),
    );
  }
}

List<Widget> _buildInfluencerPages(BuildContext context) {
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

List<Widget> _buildBusinessPages(BuildContext context) {
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
          onPressed: () async =>
              await Navigator.of(context).pushReplacement(SignUpPage.route(userType: UserType.influcencer)),
          child: Text('SignUp'),
        ),
        FlatButton(
          onPressed: () async {
            await backend.get<AuthenticationService>().loginAnonymous(UserType.influcencer);
            await Navigator.of(context).pushAndRemoveUntil(
              MainPage.route(UserType.business),
              (route) => false,
            );
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
