import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/main/page_mode.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/notification_marker.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rxdart/rxdart.dart';

class MainBottomNav extends StatefulWidget {
  const MainBottomNav({
    Key key,
    @required this.userType,
    @required this.initialValue,
    @required this.height,
    @required this.onBottomNavChanged,
    this.onFABPressed,
  })  : assert(height != null),
        super(key: key);

  final MainPageMode initialValue;
  final double height;
  final ValueChanged<MainPageMode> onBottomNavChanged;
  final VoidCallback onFABPressed;
  final UserType userType;

  @override
  _MainBottomNavState createState() => _MainBottomNavState();
}

class _MainBottomNavState extends State<MainBottomNav> {
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
    final buttonSize = widget.height * 0.85;
    final topInset = widget.height * 0.25;

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
        stream: Observable.just(0), // TODO backend.get<OfferManager>().newOfferMessages,
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

    final buttons = <Widget>[];
    Widget fabIcon;

    if (widget.userType == UserType.influencer) {
      buttons.addAll([browseButton, activitiesButton]);
      fabIcon = Icon(Icons.search);
    } else {
      buttons.addAll([activitiesButton, browseButton]);
      if (_selected == MainPageMode.activities) {
        fabIcon = Icon(Icons.add);
      } else {
        fabIcon = Icon(Icons.search);
      }
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          ClipPath(
            clipper: _BottomNavBackgroundClipper(
              inset: Offset(0.0, 4.0),
            ),
            child: CustomPaint(
              painter: _BottomNavBackgroundPainter(
                fillColor: AppTheme.darkGrey,
                strokeColor: AppTheme.white12,
                inset: Offset(0.0, 4.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: topInset),
                child: Container(
                  margin: EdgeInsets.only(bottom: mediaQuery.padding.bottom),
                  height: widget.height,
                  child: Row(
                    children: buttons,
                  ),
                ),
              ),
            ),
          ),
          RawMaterialButton(
            fillColor: AppTheme.lightBlue,
            shape: const CircleBorder(
              side: BorderSide(color: AppTheme.buttonHalo, width: 2.0),
            ),
            constraints: BoxConstraints.tightFor(
              width: buttonSize,
              height: buttonSize,
            ),
            onPressed: widget.onFABPressed,
            child: fabIcon,
          ),
        ],
      ),
    );
  }
}

class _BottomNavBackgroundClipper extends CustomClipper<Path> {
  _BottomNavBackgroundClipper({
    this.inset = Offset.zero,
    this.radius = 16.0,
  });

  final Offset inset;
  final double radius;

  @override
  Path getClip(Size size) {
    return _createBottomNavPath(true, inset, size, radius);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true; // TODO: optimize
}

class _BottomNavBackgroundPainter extends CustomPainter {
  _BottomNavBackgroundPainter({
    @required Color fillColor,
    @required Color strokeColor,
    this.inset = Offset.zero,
    double strokeWidth = 1.0,
    this.radius = 16.0,
  })  : fillPaint = Paint()
          ..color = fillColor
          ..style = PaintingStyle.fill,
        strokePaint = Paint()
          ..color = strokeColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

  final Paint fillPaint;
  final Paint strokePaint;
  final Offset inset;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(_createBottomNavPath(true, inset, size, radius), fillPaint);
    canvas.drawPath(_createBottomNavPath(false, inset, size, radius), strokePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true; // TODO: optimize
}

Path _createBottomNavPath(bool fill, Offset inset, Size size, double radius) {
  Path path = Path();
  path.moveTo(inset.dx, inset.dy);
  path.relativeArcToPoint(
    Offset(radius, radius),
    radius: Radius.circular(radius),
    clockwise: false,
  );
  path.relativeLineTo(size.width - (radius * 2.0) - inset.dx, 0.0);
  path.relativeArcToPoint(
    Offset(radius, -radius),
    radius: Radius.circular(radius),
    clockwise: false,
  );
  if (!fill) {
    return path;
  }
  path.relativeLineTo(0.0, size.height - inset.dy);
  path.relativeLineTo(-size.width - inset.dx, 0.0);
  path.close();
  return path;
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
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppTheme.black12,
                shape: BoxShape.circle,
              ),
              child: SizedBox.expand(),
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
                widget.notificationCount > 0 ? new NotificationMarker() : SizedBox(),
                InfAssetImage(widget.mode.icon, width: 24.0),
                SizedBox(height: 4.0),
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
