import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/main/page_mode.dart';
import 'package:inf/ui/filter/bottom_nav.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_icon.dart';
import 'package:inf/ui/widgets/notification_marker.dart';
import 'package:inf/ui/widgets/widget_utils.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rxdart/rxdart.dart';

class MainNavPanel extends StatefulWidget {
  const MainNavPanel({
    Key key,
    @required this.userType,
    @required this.initialValue,
    @required this.onBottomNavChanged,
    this.onFabPressed,
  })  : super(key: key);

  final UserType userType;
  final MainPageMode initialValue;
  final ValueChanged<MainPageMode> onBottomNavChanged;
  final VoidCallback onFabPressed;

  @override
  _MainNavPanelState createState() => _MainNavPanelState();
}

class _MainNavPanelState extends State<MainNavPanel> {
  MainPageMode _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  void _onBottomNavButton(MainPageMode value) {
    setState(() => _selected = value);
    widget.onBottomNavChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final browseButton = Expanded(
      child: _BottomNavButton(
        selected: _selected,
        mode: MainPageMode.browse,
        onPressed: _onBottomNavButton,
      ),
    );

    final activitiesButton = Expanded(
      child: StreamBuilder<int>(
        initialData: 0,
        stream: Observable.just(0), // TODO backend<OfferManager>().newOfferMessages,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var notificationCount = snapshot.hasData ? snapshot.data : 0;
          return _BottomNavButton(
            selected: _selected,
            mode: MainPageMode.activities,
            onPressed: _onBottomNavButton,
            notificationCount: notificationCount,
          );
        },
      ),
    );

    Widget fabIcon;
    Widget firstButton;
    Widget secondButton;

    if (widget.userType == UserType.influencer) {
      firstButton = browseButton;
      secondButton = activitiesButton;
      fabIcon = const InfIcon(AppIcons.search, key: ObjectKey(AppIcons.search));
    } else {
      firstButton = activitiesButton;
      secondButton = browseButton;
      if (_selected == MainPageMode.activities) {
        fabIcon = const InfIcon(AppIcons.add, key: ObjectKey(AppIcons.add));
      } else {
        fabIcon = const InfIcon(AppIcons.search, key: ObjectKey(AppIcons.search));
      }
    }

    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: BottomNavBackgroundClipper(
            inset: const Offset(0.0, 4.0),
          ),
          child: CustomPaint(
            painter: BottomNavBackgroundPainter(
              fillColor: AppTheme.darkGrey,
              strokeColor: AppTheme.white12,
              inset: const Offset(0.0, 4.0),
            ),
            child: Container(
              //margin: const EdgeInsets.only(top: 12.0),
              padding: EdgeInsets.only(
                top: 16.0,
                bottom: mediaQuery.padding.bottom,
              ),
              child: Row(
                children: <Widget>[
                  firstButton,
                  secondButton,
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: RaisedButton(
            onPressed: widget.onFabPressed,
            color: AppTheme.lightBlue,
            shape: const CircleBorder(
              side: BorderSide(color: AppTheme.buttonHalo, width: 2.0),
            ),
            child: Container(
              width: 64.0,
              height: 64.0,
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: fabIcon,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomNavButton extends StatefulWidget {
  const _BottomNavButton({
    Key key,
    @required this.selected,
    @required this.mode,
    @required this.onPressed,
    this.notificationCount = 0,
  }) : super(key: key);

  final MainPageMode selected;
  final MainPageMode mode;
  final ValueChanged<MainPageMode> onPressed;
  final int notificationCount;

  @override
  _BottomNavButtonState createState() => _BottomNavButtonState();
}

class _BottomNavButtonState extends State<_BottomNavButton> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 350), vsync: this);
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
    _animate();
  }

  @override
  void didUpdateWidget(_BottomNavButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      _animate();
    }
  }

  void _animate() {
    if (widget.selected == widget.mode) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[
        FadeTransition(
          opacity: _controller,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.translationValues(0.0, -8.0, 0.0) * Matrix4.diagonal3Values(1.5, 1.5, 1.0),
            child: const DecoratedBox(
              decoration: const BoxDecoration(
                color: AppTheme.black12,
                shape: BoxShape.circle,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        FlatButton(
          onPressed: () => widget.onPressed(widget.mode),
          shape: const Border(),
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(widget.notificationCount > 0)
                  NotificationMarker(),
                InfAssetImage(widget.mode.icon, width: 24.0),
                verticalMargin4,
                Text(
                  widget.mode.text,
                  style: const TextStyle(
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
