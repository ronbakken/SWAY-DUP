import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:sway_mobile_app/app/assets.dart';
import 'package:sway_mobile_app/app/theme.dart';
// import 'package:sway_mobile_app/ui/welcome/onboarding_page.dart';
import 'package:sway_mobile_app/ui/widgets/inf_asset_image.dart';
import 'package:sway_mobile_app/ui/widgets/inf_stadium_button.dart';

// Prototype: onboarding_selection.dart

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    Key key,
    @required this.onInfluencer,
    @required this.onBusiness,
    this.onExistingAccount,
    @required this.welcomeImageUrls,
  }) : super(key: key);

  final Function() onInfluencer;
  final Function() onBusiness;
  final Function() onExistingAccount;
  final List<String> welcomeImageUrls;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Animation<double> secondaryAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
            parent: ModalRoute.of(context).secondaryAnimation,
            curve: Curves.fastOutSlowIn));
    return Material(
      color: theme.backgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _WelcomeWall(data: widget.welcomeImageUrls),
          /*
          FadeTransition(
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
          ),
          */
          FadeTransition(
            opacity: secondaryAnimation,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(54.0, 0.0, 54.0, 48.0),
                child: Column(
                  children: <Widget>[
                    const Expanded(
                      child: Center(
                        child: InfAssetImage(
                          AppLogo.infLogoWithShadow,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    InfStadiumButton(
                      text: 'I am an influencer'.toUpperCase(),
                      color: const Color.fromARGB(
                          255, 100, 206, 255), // AppTheme.blue,
                      onPressed: widget.onInfluencer,
                      /*() => Navigator.of(context).push<void>(
                          OnBoardingPage.route(
                              userType: AccountType.influencer)),*/
                    ),
                    const SizedBox(height: 12.0),
                    InfStadiumButton(
                      text: 'I need an influencer'.toUpperCase(),
                      color: AppTheme.red,
                      onPressed: widget.onBusiness,
                      /*() => Navigator.of(context).push<void>(
                          OnBoardingPage.route(userType: AccountType.business)),*/
                    ),
                    widget.onExistingAccount != null
                        ? const SizedBox(height: 12.0)
                        : const SizedBox(),
                    // TODO: This should be a generic fake BACK < button or ACCOUNTS icon in the top-left or top-right
                    // This feature switches to the list of already logged in accounts
                    widget.onExistingAccount != null
                        ? FlatButton(
                            child: const Text('Go to existing account'),
                            onPressed: widget.onExistingAccount,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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

class _WelcomeHelpPopOutState extends State<_WelcomeHelpPopOut>
    with SingleTickerProviderStateMixin {
  final GlobalKey _buttonKey = GlobalKey();
  AnimationController _controller;
  Animation<Offset> _animation;

  bool _opened = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    _animation = const AlwaysStoppedAnimation<Offset>(Offset.zero);
    // FIXME: remove this post frame callback and work out size a better way
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Size childSize = _buttonKey.currentState.context.size;
      setState(() {
        final double inset = childSize.height + 16.0;
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
              const InfAssetImage(
                AppIcons.help,
                width: 36.0,
              ),
              const SizedBox(width: 12.0),
              widget.content,
              const SizedBox(width: 36.0),
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
      final Iterable<Future<void>> loadingImages = widget.data
          .map<Future<void>>(
              (String url) => precacheImage(NetworkImage(url), context));
      Future.wait<void>(loadingImages).then((_) {
        if (mounted) {
          setState(() => _opacity = 0.5);
        }
      });
      _first = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size * 1.25; // zoom level
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(seconds: 3),
      curve: Curves.decelerate,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Opacity(
            opacity: 0.5,
            child: OverflowBox(
              minWidth: size.width,
              maxWidth: size.width,
              minHeight: size.height,
              maxHeight: size.height,
              child: _WelcomeWallBackground(
                speed: 24.0,
                children: widget.data
                    .map<Widget>((String url) => _buildWallTile(url))
                    .toList(growable: false),
              ),
            ),
          ),
          const FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.5,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0x00000000),
                    Color(0xCC000000),
                    Color(0xFF000000),
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
        ],
      ),
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

  static Widget _tileTransitionBuilder(
      Widget child, Animation<double> animation) {
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
  void updateRenderObject(
      BuildContext context, _RenderWallBackground renderObject) {
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
    if (child.parentData is! _WallParentData)
      child.parentData = _WallParentData();
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
    final List<RenderBox> children = getChildrenAsList();

    final double childWidthConstraint = constraints.maxWidth / 5.0;
    final BoxConstraints childConstraints = BoxConstraints(
      minWidth: childWidthConstraint,
      maxWidth: childWidthConstraint,
      minHeight: childWidthConstraint * 1.4,
      maxHeight: childWidthConstraint * 1.4,
    );

    for (int i = 0; i < children.length; i++) {
      final RenderBox child = children[i];
      child.layout(childConstraints, parentUsesSize: true);
    }

    final Size childSize = firstChild.size;
    for (int i = 0, x = 0; i < children.length - 2; i += 3, x++) {
      final double inset = math.exp(x) * 3;
      _childParentData(children[i + 0]).offset =
          Offset(x * childSize.width, inset + 0 * childSize.height);
      _childParentData(children[i + 1]).offset =
          Offset(x * childSize.width, inset + 1 * childSize.height);
      _childParentData(children[i + 2]).offset =
          Offset(x * childSize.width, inset + 2 * childSize.height);
    }

    size = constraints.biggest;
  }

  _WallParentData _childParentData(RenderBox child) => child.parentData;

  void _onTick(Duration duration) {
    final double delta =
        (duration.inMicroseconds - _lastDuration.inMicroseconds) /
            Duration.microsecondsPerSecond;
    _dy += _speed * delta;
    _lastDuration = duration;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final double segmentHeight = firstChild.size.height * 3;
    final double _top = (segmentHeight * 0.5) + (_dy % (segmentHeight * 2.0));
    for (int i = 0; i < (2 * size.height / segmentHeight).ceil(); i++) {
      context.pushLayer(
          OffsetLayer(offset: Offset(0.0, -_top + (segmentHeight * i))),
          defaultPaint,
          offset);
    }
  }

  @override
  bool hitTestChildren(HitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
