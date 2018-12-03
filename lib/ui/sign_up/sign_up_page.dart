import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pedantic/pedantic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/sign_up/check_email_popup.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';

import 'package:inf/ui/widgets/page_widget.dart';

class SignUpPage extends PageWidget {
  static Route<dynamic> route({AccountType userType, double topPadding = 32}) {
    return PageRouteBuilder(
      pageBuilder: (BuildContext context, _, __) {
        return SignUpPage(
          userType: userType,
          topPadding: topPadding,
        );
      },
      transitionsBuilder:
          (BuildContext context, Animation<double> animation, _, Widget child) {
        final slide = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
            .animate(animation);
        return SlideTransition(
          position: slide,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 650),
      opaque: false,
    );
  }

  const SignUpPage({Key key, this.userType, this.topPadding = 32.0})
      : super(key: key);

  final AccountType userType;
  final double topPadding;

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends PageState<SignUpPage> {
  StreamSubscription _loginStateChangedSubscription;

  @override
  void initState() {
    super.initState();

    /// OBserve login state
    _loginStateChangedSubscription =
        backend.get<UserManager>().logInStateChanged.listen((loginResult) {
      switch (loginResult.state) {
        case AuthenticationState.waitingForActivation:
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CheckEmailPopUp(
                userType: widget.userType,
                email: loginResult.user.email,
              );
            },
          );
          break;
        case AuthenticationState.success:
          Navigator.of(context).pushAndRemoveUntil(
              MainPage.route(widget.userType), (route) => false);
          break;
        default:
      }
    });
  }

  @override
  void dispose() {
    _loginStateChangedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQuery.padding.top + widget.topPadding,
        left: 0.0,
        right: 0.0,
      ),
      child: Material(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: constraints.copyWith(
                      minWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight,
                      maxHeight: double.infinity,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 96.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 16.0),
                            child: _DynamicSocialNetworkButtons(
                                userType: widget.userType),
                          ),
                          Spacer(),
                          CurvedBox(
                            curveFactor: 0.8,
                            color: Colors.black,
                            top: true,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(48.0, 32.0, 48.0,
                                  16.0 + mediaQuery.padding.bottom),
                              child: Text.rich(
                                TextSpan(
                                  style: TextStyle(height: 1.2),
                                  children: [
                                    // TODO set correct ULRS
                                    TextSpan(
                                        text:
                                            'By Signing up, you agree with our\n'),
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: const TextStyle(
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () =>
                                            _launchURL('https://flutter.io'),
                                    ),
                                    TextSpan(text: '  and  '),
                                    TextSpan(
                                      text: 'Privacy',
                                      style: const TextStyle(
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () =>
                                            _launchURL('https://flutter.io'),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 96.0,
                  child: CurvedBox(
                    curveFactor: 0.9,
                    color: AppTheme.blue,
                    bottom: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: InfAssetImage(AppLogo.infLogo, width: 96.0),
                    ),
                  ),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkResponse(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Icon(Icons.arrow_back, size: 24.0),
                        ),
                      ),
                      InkResponse(
                        onTap: () async {
                          await backend
                              .get<AuthenticationService>()
                              .loginAnonymous(widget.userType);
                          final nav = Navigator.of(context)..pop();
                          unawaited(
                              nav.push(MainPage.route(widget.userType)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Skip',
                                textScaleFactor: 1.3,
                              ),
                              Align(
                                widthFactor: 0.85,
                                heightFactor: 0.9,
                                alignment: Alignment.topRight,
                                child: Icon(Icons.chevron_right, size: 28.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class _DynamicSocialNetworkButtons extends StatelessWidget {
  const _DynamicSocialNetworkButtons({Key key, @required this.userType})
      : super(key: key);

  final AccountType userType;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SocialNetworkProvider>>(
        future: backend
            .get<AuthenticationService>()
            .getAvailableSocialNetworkProviders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // TODO error message
            return Text("Error while retrieving SocialNetWorks");
          }
          if (!snapshot.hasData) {
            //TODO Show Spinner
            return Text("Loading");
          }

          List<Widget> buttonList = <Widget>[]..add(
              Padding(
                padding: const EdgeInsets.only(
                    left: 40.0, right: 40, top: 10.0, bottom: 32.0),
                child: Text(
                  'Which social media account would you like to continue with?',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.1),
                ),
              ),
            );
          for (var network in snapshot.data) {
            if (network.canAuthorizeUser) {
              buttonList.add(
                _buildLoginButton(
                  leading: network.isVectorLogo
                      ? SvgPicture.memory(network.logoData)
                      : Image.memory(network.logoData),
                  text: network.name,
                  onPressed: () => backend
                      .get<AuthenticationService>()
                      .loginWithSocialNetWork(context, userType, network),
                ),
              );
            }
            buttonList.add(SizedBox(height: 16.0));
          }
          buttonList.addAll([
            SizedBox(height: 16.0),
            _buildLoginButton(
              leading: InfAssetImage(AppLogo.email),
              text: 'EMAIL',
              onPressed: () {
                // TODO: implement email login
              },
            ),
          ]);

          return Column(
            children: buttonList,
          );
        });
  }

  Widget _buildLoginButton(
      {Widget leading, String text, VoidCallback onPressed}) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        RaisedButton(
          onPressed: onPressed,
          shape: const StadiumBorder(),
          child: Container(
            alignment: Alignment.center,
            height: 44.0,
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
        Positioned(
          left: 20.0,
          child: leading,
          width: 24.0,
        ),
      ],
    );
  }
}
