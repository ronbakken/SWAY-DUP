import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
// import 'package:inf/ui/welcome/onboarding_page.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';

// Prototype: onboarding_selection.dart

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    Key key,
    @required this.onInfluencer,
    @required this.onBusiness,
    @required this.welcomeImageUrls,
  }) : super(key: key);

  final Function() onInfluencer;
  final Function() onBusiness;
  final List<String> welcomeImageUrls;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
        return Material(
          color: theme.backgroundColor,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _WelcomeWall(welcomeImageUrls: widget.welcomeImageUrls),
              FractionallySizedBox(
                alignment: Alignment.bottomCenter,
                heightFactor: 0.5,
                child: DecoratedBox(
                  decoration: BoxDecoration(
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
                        0.75,
                        0.97,
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(top: 36.0),
                  alignment: Alignment.topRight,
                  child: _WelcomeHelpPopOut(
                    content: Text('This is help content'),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(54.0, 0.0, 54.0, 48.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: InfAssetImage(
                            AppLogo.infLogoWithShadow,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      _WelcomeButton(
                        text: 'I AM AN INFLUENCER',
                        color: AppTheme.blue,
                        onPressed: widget.onInfluencer/*() => Navigator.of(context).push(
                            OnBoardingPage.route(
                                userType: AccountType.influencer))*/,
                      ),
                      SizedBox(height: 12.0),
                      _WelcomeButton(
                        text: 'I NEED AN INFLUENCER',
                        color: AppTheme.red,
                        onPressed: widget.onBusiness/*() => Navigator.of(context).push(
                            OnBoardingPage.route(userType: AccountType.business))*/,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
  }
}

class _WelcomeButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _WelcomeButton({
    Key key,
    @required this.text,
    @required this.color,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: this.color,
      shape: const StadiumBorder(),
      onPressed: this.onPressed,
      child: Container(
        alignment: Alignment.center,
        height: 44.0,
        child: Text(
          this.text,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
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
  final _buttonKey = GlobalKey();
  AnimationController _controller;
  Animation<Offset> _animation;

  bool _opened = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 450), vsync: this);
    _animation = AlwaysStoppedAnimation<Offset>(Offset.zero);
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
              InfAssetImage(
                AppIcons.help,
                width: 36.0,
              ),
              SizedBox(width: 12.0),
              widget.content,
              SizedBox(width: 36.0),
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
    @required this.welcomeImageUrls,
  }) : super(key: key);

  final List<String> welcomeImageUrls;

  @override
  _WelcomeWallState createState() => _WelcomeWallState();
}

class _WelcomeWallState extends State<_WelcomeWall> {
  static const double kOpacity = 0.5;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1.25; // zoom level
    return AnimatedOpacity(
      duration: Duration(seconds: 3),
      curve: Curves.decelerate,
      opacity: kOpacity,
      child: OverflowBox(
        minWidth: size.width,
        maxWidth: size.width,
        minHeight: size.height,
        maxHeight: size.height,
        child: _WelcomeWallBackground(
          speed: 24.0,
          children: widget.welcomeImageUrls
              .map<Widget>((url) => _buildWallTile(url))
              .toList(growable: false),
        ),
      ),
    );
  }

  Widget _buildWallTile(String url) {
    return AnimatedSwitcher(
      transitionBuilder: _tileTransitionBuilder,
      duration: Duration(seconds: 1),
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
    final delta = ((duration.inMicroseconds - _lastDuration.inMicroseconds) /
        Duration.microsecondsPerSecond);
    _dy += _speed * delta;
    _lastDuration = duration;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final segmentHeight = firstChild.size.height * 3;
    final _top = (segmentHeight * 0.5) + (_dy % (segmentHeight * 2.0));
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
