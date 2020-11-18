import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/sign_up/send_signup_login_email_view.dart';
import 'package:inf/ui/widgets/animated_curves.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_bottom_sheet.dart';
import 'package:inf/ui/widgets/inf_page_indicator.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/onboarding_pager.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:inf/ui/widgets/widget_utils.dart';
import 'package:inf_api_client/inf_api_client.dart';

class OnBoardingPage extends StatefulWidget {
  static Route<dynamic> route({UserType userType}) {
    return FadePageRoute(
      builder: (context) => OnBoardingPage(userType: userType),
    );
  }

  const OnBoardingPage({
    Key key,
    @required this.userType,
  }) : super(key: key);

  final UserType userType;

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController pageController = PageController();
  List<Widget> pages;

  @override
  void initState() {
    super.initState();
    if (widget.userType == UserType.influencer) {
      pages = <Widget>[
        OnBoardingCard(
          index: 0,
          image: AppImages.onBoarding1,
          title: 'WHAT WE DO',
          content: 'Sway offers a simpler way for the most sought-after influencers and '
              'businesses to connect, market, and monetize.',
          onPositivePressed: () => _onNextPressed(0),
        ),
        OnBoardingCard(
          index: 1,
          image: AppImages.onBoarding2,
          title: 'THE INFLUENCERS MARKETPLACE',
          content: 'We have created a new way for businesses and content creators to '
              'interact and do business.',
          onPositivePressed: () => _onNextPressed(1),
        ),
        OnBoardingCard(
          index: 2,
          image: AppImages.onBoarding3,
          title: 'WHAT YOU GET',
          content: 'Free exchanges, paid offers, and access to exclusive events that you\'ll '
              'WANT to show your followers. Simply pull up our interactive map each day '
              'to see all the new offers available to you.',
          onPositivePressed: () => _onNextPressed(2),
        ),
      ];
    } else {
      pages = <Widget>[
        OnBoardingCard(
          index: 0,
          image: AppImages.onBoarding1,
          title: 'WHAT WE DO',
          content: 'Sway offers a simpler way for the most sought-after content creators and '
              'businesses to connect, market and monetize.',
          onPositivePressed: () => _onNextPressed(0),
        ),
        OnBoardingCard(
          index: 1,
          image: AppImages.onBoarding2,
          title: 'HOW WE DO IT',
          content: 'Using your customized preferences and branding criteria as a guide, '
              'we match you with the best influencers.',
          onPositivePressed: () => _onNextPressed(1),
        ),
        OnBoardingCard(
          index: 2,
          image: AppImages.onBoarding3,
          title: 'WHAT YOU GET',
          content: 'Sway gets you access to the leading influencers in your industry who have '
              'a loyal following of your target market.',
          onPositivePressed: () => _onNextPressed(2),
        ),
      ];
    }
    pages.add(
      OnBoardingCard(
        index: 3,
        image: AppImages.over18Warning,
        title: 'Are you 18 or older?',
        content: 'You must be 18 or older to complete transactions on Sway.\n\n'
            'If an influencer or business representative is under the age of 18, an accompanying '
            'adult must be present to approve the transaction.',
        positiveText: 'I AM 18+',
        positiveColor: AppTheme.blue,
        onPositivePressed: () => _onNextPressed(3),
        negativeText: 'I AM UNDER 18',
        negativeColor: AppTheme.toggleBackground,
        onNegativePressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSpacingVert = mediaQuery.size.shortestSide < 360.0 ? 12.0 : 48.0;
    final screenSpacingHorz = mediaQuery.size.shortestSide < 360.0 ? 12.0 : 24.0;
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
                  padding: EdgeInsets.fromLTRB(screenSpacingHorz, 16.0 + screenSpacingVert, screenSpacingHorz, 0.0),
                  radius: const Radius.circular(8.0),
                  inset: 8.0,
                  children: pages,
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: screenSpacingVert, horizontal: screenSpacingHorz),
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
      Navigator.of(context).pop();
      Navigator.of(context).push(
        InfBottomSheet.route(
          title: 'Welcome to INF',
          child: SendSignupLoginEmailView(newUser: true, userType: widget.userType),
        ),
      );
    } else {
      _gotoPage(pageIndex + 1);
    }
  }

  void _gotoPage(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 450),
      curve: Curves.fastOutSlowIn,
    );
  }
}

class OnBoardingCard extends StatelessWidget {
  const OnBoardingCard({
    Key key,
    @required this.index,
    @required this.image,
    @required this.title,
    @required this.content,
    this.positiveText = 'NEXT',
    this.positiveColor = Colors.white,
    this.onPositivePressed,
    this.negativeText,
    this.negativeColor = Colors.white,
    this.onNegativePressed,
  }) : super(key: key);

  final int index;
  final AppAsset image;
  final String title;
  final String content;

  final String positiveText;
  final Color positiveColor;
  final VoidCallback onPositivePressed;

  final String negativeText;
  final Color negativeColor;
  final VoidCallback onNegativePressed;

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
              child: InfAssetImage(image, fit: BoxFit.cover),
            ),
          ),
          Expanded(
            flex: 1,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomAnimatedCurves(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Spacer(flex: 1),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                        ),
                      ),
                      verticalMargin16,
                      Text(
                        content,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          height: 1.25,
                        ),
                      ),
                      const Spacer(flex: 2),
                      if (positiveText != null)
                        InfStadiumButton(
                          color: positiveColor,
                          text: positiveText,
                          onPressed: onPositivePressed,
                        ),
                      if (negativeText != null) ...[
                        verticalMargin8,
                        InfStadiumButton(
                          color: negativeColor,
                          text: negativeText,
                          onPressed: onNegativePressed,
                        ),
                      ],
                      verticalMargin24,
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
