import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/sign_up/sign_up_page.dart';
import 'package:inf/ui/widgets/inf_page_indicator.dart';
import 'package:inf/ui/widgets/routes.dart';

class OnBoardingPage extends StatefulWidget {
  final AccountType userType;

  static Route<dynamic> route({AccountType userType}) {
    return FadePageRoute(
      builder: (context) => OnBoardingPage(userType: userType),
    );
  }

  const OnBoardingPage({Key key, this.userType}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    List<Widget> pages;
    String title;
    switch (widget.userType) {
      case AccountType.influencer:
        pages = _buildInfluencerPages(context);
        title = 'Onboarding Influencer';
        break;
      case AccountType.business:
        pages = _buildBusinessPages(context);
        title = 'Onboarding business';
        break;
      default:
        assert(false, 'Never should get here');
    }
    return Center(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Material(
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(title),
                ),
                Expanded(
                  child: PageView(controller: pageController, children: pages),
                ),
                SafeArea(
                  child: InfPageIndicator(
                    controller: pageController,
                    itemCount: 3,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          ),
        ),
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
          onPressed: () => Navigator.of(context)
            ..pop()
            ..push(SignUpPage.route(userType: AccountType.influencer)),
          child: Text('Next'),
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
          onPressed: () async => await Navigator.of(context).pushReplacement(
              SignUpPage.route(userType: AccountType.influencer)),
          child: Text('SignUp'),
        ),
        FlatButton(
          onPressed: () async {
            await backend
                .get<AuthenticationService>()
                .loginAnonymous(AccountType.influencer);
            await Navigator.of(context).pushAndRemoveUntil(
              MainPage.route(AccountType.business),
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
