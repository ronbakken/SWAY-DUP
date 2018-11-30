import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/sign_up/sign_up_page.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_page_indicator.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/onboarding_pager.dart';
import 'package:inf/ui/widgets/routes.dart';

const _kOnBoardingAssets = const <AppAsset>[
  AppImages.onBoarding1,
  AppImages.onBoarding2,
  AppImages.onBoarding3,
];

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
  final PageController pageController = PageController();
  List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = <Widget>[
      OnBoardingCard(
        index: 0,
        title: 'THE INFLUENCERS MARKETPLACE',
        content: 'We have created a new way for businesses and content creators to interact and do business.',
        onNextPressed: () => _onNextPressed(0),
      ),
      OnBoardingCard(
        index: 1,
        title: 'THE INFLUENCERS MARKETPLACE',
        content: 'We have created a new way for businesses and content creators to interact and do business.',
        onNextPressed: () => _onNextPressed(1),
      ),
      OnBoardingCard(
        index: 2,
        title: 'YOU ARE ALL SET!',
        content: 'You can now create an account with INF to get started straighta way, or if you fancy taking a look around, you can jump straight in.',
        onNextPressed: () => _onNextPressed(2),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.darkGrey.withOpacity(0.5),
      child: RepaintBoundary(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: OnBoardingPager(
                  controller: pageController,
                  padding: const EdgeInsets.fromLTRB(24.0, 48.0, 24.0, 0.0),
                  radius: Radius.circular(8.0),
                  inset: 8.0,
                  children: pages,
                ),
              ),
              AnimatedBuilder(
                animation: pageController,
                builder: (BuildContext context, Widget child) {
                  double opacity = 0.0;
                  if ((pageController.page ?? 0.0) >= pages.length - 2) {
                    opacity = 1.0 - (pages.length - 1 - pageController.page);
                  }
                  return IgnorePointer(
                    ignoring: opacity < 1.0,
                    child: Opacity(
                      opacity: opacity,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    child: Text('SKIP FOR NOW'),
                    onPressed: _onSkipPressed,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 48.0),
                child: InfPageIndicator(
                  controller: pageController,
                  itemCount: pages.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onNextPressed(int pageIndex) {
    if (pageIndex == pages.length - 1) {
      Navigator.of(context)
        ..pop()
        ..push(SignUpPage.route(userType: widget.userType));
    } else {
      pageController.animateToPage(pageIndex + 1,
          duration: const Duration(milliseconds: 450), curve: Curves.fastOutSlowIn);
      ModalRoute.of(context).addLocalHistoryEntry(LocalHistoryEntry(
        onRemove: () => pageController.animateToPage(pageIndex,
            duration: const Duration(milliseconds: 450), curve: Curves.fastOutSlowIn),
      ));
    }
  }

  Future<void> _onSkipPressed() async {
    await backend.get<AuthenticationService>().loginAnonymous(AccountType.influencer);
    return Navigator.of(context).pushAndRemoveUntil(MainPage.route(AccountType.business), (route) => false);
  }
}

class OnBoardingCard extends StatelessWidget {
  const OnBoardingCard({
    Key key,
    this.index,
    this.title,
    this.content,
    this.onNextPressed,
  }) : super(key: key);

  final int index;
  final String title;
  final String content;
  final VoidCallback onNextPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.darkGrey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: CurvedBoxClip(
              bottom: true,
              child: InfAssetImage(_kOnBoardingAssets[index], fit: BoxFit.cover),
            ),
          ),
          Expanded(
            flex: 1,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                InfAssetImage(
                  AppImages.mockCurves, // FIXME:
                  alignment: Alignment.bottomCenter,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Spacer(flex: 1),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        content,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          height: 1.25,
                        ),
                      ),
                      Spacer(flex: 2),
                      InfStadiumButton(
                        color: Colors.white,
                        text: 'NEXT',
                        onPressed: onNextPressed,
                      ),
                      SizedBox(height: 24.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
