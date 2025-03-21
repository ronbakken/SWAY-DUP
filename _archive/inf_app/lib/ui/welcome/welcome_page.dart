import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/sign_up/activation_success_page.dart';
import 'package:inf/ui/sign_up/send_signup_login_email_view.dart';
import 'package:inf/ui/welcome/onboarding_page.dart';
import 'package:inf/ui/widgets/connection_builder.dart';
import 'package:inf/ui/widgets/dialogs.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_bottom_sheet.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:inf/ui/widgets/widget_utils.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rx_command/rx_command_listener.dart';
import 'package:uni_links/uni_links.dart';

class WelcomeRoute extends FadePageRoute {
  WelcomeRoute()
      : super(
          builder: (BuildContext context) => WelcomePage(),
          transitionDuration: const Duration(milliseconds: 750),
        );
}

class WelcomePage extends PageWidget {
  static Route<dynamic> route() => WelcomeRoute();

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends PageState<WelcomePage> {
  Stream<List<String>> imageUrlStream;
  StreamSubscription deepLinkSubscription;
  RxCommandListener<LoginToken, bool> loginCommandListener;
  LoginToken loginToken;

  @override
  void initState() {
    super.initState();
    imageUrlStream = backend<ConfigService>().welcomePageProfileImages;

    // Listen for deep link calls with a login-token
    deepLinkSubscription = getUriLinksStream().listen(onDeepLinkCall);
  }

  void onDeepLinkCall(Uri uri) async {
    // FIXME: this should test for path as well as query parameter
    //print('Deeplink URI $uri');
    if (uri.queryParameters.containsKey('token')) {
      // setup listener for success of the login attempt with the token
      loginCommandListener?.dispose();
      loginCommandListener = RxCommandListener(
        backend<UserManager>().logInUserCommand,
        onValue: (success) {
          if (success) {
            loginCommandListener?.dispose();
            deepLinkSubscription?.cancel();

            // did we get a link from a new user subscription?
            if (loginToken.accountState == UserDto_Status.waitingForActivation) {
              Navigator.of(context).popUntil((route) => route is WelcomeRoute);
              Navigator.of(context).push(ActivationSuccessPage.route(loginToken.userType));
            } else {
              Navigator.of(context).pushAndRemoveUntil(MainPage.route(), (route) => false);
            }
          } else {
            showMessageDialog(
              context,
              'Login problem',
              'Sorry the link you used seems not to be valid. Please use the latest link you got or please signup again',
            );
          }
        },
        onError: (error) {
          backend<ErrorReporter>().logException(error);
          showMessageDialog(
            context,
            'Login problem',
            'Sorry the link you used seems not to be valid. Please signup again ${error.toString()}',
          );
        },
      );
      print(uri.queryParameters['token']);

      try {
        loginToken = LoginToken.fromJwt(uri.queryParameters['token']);

        backend<UserManager>().logInUserCommand(loginToken);
      } catch (error) {
        unawaited(backend<ErrorReporter>().logException(error));
        showMessageDialog(
          context,
          'Login problem',
          'Sorry the link you used seems not to be valid. Please signup again',
        );
      }
    }
  }

  @override
  void dispose() {
    loginCommandListener?.dispose();
    deepLinkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectionBuilder(
      builder: (BuildContext context, NetworkConnectionState connectionState, Widget child) {
        final secondaryAnimation = Tween<double>(begin: 1.0, end: 0.0)
            .animate(CurvedAnimation(parent: ModalRoute.of(context).secondaryAnimation, curve: Curves.fastOutSlowIn));
        return Material(
          color: theme.backgroundColor,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              StreamBuilder<List<String>>(
                stream: imageUrlStream,
                builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                  return snapshot.hasData ? _WelcomeWall(data: snapshot.data) : emptyWidget;
                },
              ),
              /*FadeTransition(
                opacity: secondaryAnimation,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.only(top: 36.0),
                    alignment: Alignment.topRight,
                    child: _WelcomeHelpPopOut(
                      content: Text('This is help content'),
                    ),
                  ),
                ),
              ),*/
              FadeTransition(
                opacity: secondaryAnimation,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(54.0, 0.0, 54.0, 24.0),
                    child: Column(
                      children: <Widget>[
                        const Expanded(
                          child: Center(
                            child: InfAssetImage(AppLogo.swayLogoText),
                          ),
                        ),
                        verticalMargin12,
                        InfStadiumButton(
                          text: 'I AM AN INFLUENCER',
                          color: AppTheme.blue,
                          onPressed: () =>
                              Navigator.of(context).push(OnBoardingPage.route(userType: UserType.influencer)),
                        ),
                        verticalMargin12,
                        InfStadiumButton(
                          text: 'I NEED AN INFLUENCER',
                          color: AppTheme.red,
                          onPressed: () =>
                              Navigator.of(context).push(OnBoardingPage.route(userType: UserType.business)),
                        ),
                        verticalMargin12,
                        InfStadiumButton(
                          textSpan: const TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: 'Already got an account? '),
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () => Navigator.of(context).push(
                                InfBottomSheet.route(
                                  title: 'Welcome to INF',
                                  child: const SendSignupLoginEmailView(
                                    newUser: false,
                                    userType: UserType.unknownType,
                                  ),
                                ),
                              ),
                          color: Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WelcomeHelpPopOut extends StatefulWidget {
  final Widget content;

  const _WelcomeHelpPopOut({
    Key key,
    @required this.content,
  }) : super(key: key);

  @override
  _WelcomeHelpPopOutState createState() => _WelcomeHelpPopOutState();
}

class _WelcomeHelpPopOutState extends State<_WelcomeHelpPopOut> with SingleTickerProviderStateMixin {
  final _buttonKey = GlobalKey();
  AnimationController _controller;
  Animation<Offset> _animation;

  bool _opened = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 450), vsync: this);
    _animation = const AlwaysStoppedAnimation<Offset>(Offset.zero);
    // FIXME: remove this post frame callback and work out size a better way
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final childSize = _buttonKey.currentState.context.size;
      setState(() {
        final inset = childSize.height + 16.0;
        _animation = Tween<Offset>(
          begin: Offset(childSize.width - inset, 0.0),
          end: Offset(inset, 0.0),
        ).animate(_controller);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHelpPressed() {
    if (_opened) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _opened = !_opened;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget child) {
        return Transform.translate(
          offset: _animation.value,
          child: child,
        );
      },
      child: RawMaterialButton(
        key: _buttonKey,
        fillColor: AppTheme.blue,
        padding: EdgeInsets.zero,
        onPressed: _onHelpPressed,
        shape: const StadiumBorder(),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 36.0, 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const InfAssetImage(AppIcons.help, width: 36.0),
              horizontalMargin12,
              widget.content,
              horizontalMargin36,
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeWall extends StatefulWidget {
  const _WelcomeWall({
    Key key,
    @required this.data,
  }) : super(key: key);

  final List<String> data;

  @override
  _WelcomeWallState createState() => _WelcomeWallState();
}

class _WelcomeWallState extends State<_WelcomeWall> {
  double _opacity = 0.0;
  bool _first = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_first) {
      Iterable<Future> loadingImages = widget.data.map<Future>((url) => precacheImage(NetworkImage(url), context));
      Future.wait(loadingImages).then((_) {
        if (mounted) {
          setState(() => _opacity = 0.25);
        }
      });
      _first = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1.25; // zoom level
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        RepaintBoundary(
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(seconds: 3),
            curve: Curves.decelerate,
            child: OverflowBox(
              minWidth: size.width,
              maxWidth: size.width,
              minHeight: size.height,
              maxHeight: size.height,
              child: _WelcomeWallBackground(
                speed: 24.0,
                children: <Widget>[
                  for (final url in widget.data) _buildWallTile(url),
                ],
              ),
            ),
          ),
        ),
        const RepaintBoundary(
          child: FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.5,
            child: Opacity(
              opacity: 0.5,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      const Color(0x00000000),
                      const Color(0xCC000000),
                      const Color(0xFF000000),
                    ],
                    stops: <double>[
                      0.5,
                      0.70,
                      0.85,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWallTile(String url) {
    return AnimatedSwitcher(
      transitionBuilder: _tileTransitionBuilder,
      duration: const Duration(seconds: 1),
      child: SizedBox.expand(
        key: ValueKey<String>(url),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.network(url, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  static Widget _tileTransitionBuilder(Widget child, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.scale(
            scale: animation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _WelcomeWallBackground extends MultiChildRenderObjectWidget {
  _WelcomeWallBackground({
    Key key,
    List<Widget> children,
    this.speed = 24.0,
  }) : super(key: key, children: children);

  final double speed;

  @override
  _RenderWallBackground createRenderObject(BuildContext context) {
    return _RenderWallBackground(speed: speed);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderWallBackground renderObject) {
    renderObject..speed = speed;
  }
}

class _WallParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderWallBackground extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _WallParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _WallParentData> {
  double _speed;

  Ticker _ticker;
  double _dy = 0.0;
  Duration _lastDuration = Duration.zero;

  _RenderWallBackground({
    @required double speed,
  }) : _speed = speed;

  set speed(double value) {
    if (_speed != value) {
      _speed = value;
      markNeedsPaint();
    }
  }

  @override
  bool get alwaysNeedsCompositing => true;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _WallParentData) child.parentData = _WallParentData();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _ticker = Ticker(_onTick, debugLabel: 'WallBackgroundTicker');
    _ticker.start();
  }

  @override
  void detach() {
    _ticker.dispose();
    _ticker = null;
    super.detach();
  }

  @override
  void performLayout() {
    List<RenderBox> children = getChildrenAsList();

    final childWidthConstraint = constraints.maxWidth / 5.0;
    final childConstraints = BoxConstraints(
      minWidth: childWidthConstraint,
      maxWidth: childWidthConstraint,
      minHeight: childWidthConstraint * 1.4,
      maxHeight: childWidthConstraint * 1.4,
    );

    for (int i = 0; i < children.length; i++) {
      final child = children[i];
      child.layout(childConstraints, parentUsesSize: true);
    }

    Size childSize = firstChild.size;
    for (int i = 0, x = 0; i < children.length - 2; i += 3, x++) {
      final inset = math.exp(x) * 3;
      _childParentData(children[i + 0]).offset = Offset(x * childSize.width, inset + 0 * childSize.height);
      _childParentData(children[i + 1]).offset = Offset(x * childSize.width, inset + 1 * childSize.height);
      _childParentData(children[i + 2]).offset = Offset(x * childSize.width, inset + 2 * childSize.height);
    }

    size = constraints.biggest;
  }

  _WallParentData _childParentData(RenderBox child) => child.parentData;

  void _onTick(Duration duration) {
    final delta = ((duration.inMicroseconds - _lastDuration.inMicroseconds) / Duration.microsecondsPerSecond);
    _dy += _speed * delta;
    _lastDuration = duration;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final segmentHeight = firstChild.size.height * 3;
    final _top = (segmentHeight * 0.5) + (_dy % (segmentHeight * 2.0));
    for (int i = 0; i < (2 * size.height / segmentHeight).ceil(); i++) {
      context.pushLayer(OffsetLayer(offset: Offset(0.0, -_top + (segmentHeight * i))), defaultPaint, offset);
    }
  }

  @override
  bool hitTestChildren(HitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
