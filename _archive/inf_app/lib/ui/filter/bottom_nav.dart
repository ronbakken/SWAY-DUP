import 'package:flutter/material.dart';
import 'package:inf/ui/filter/filter_panel.dart';
import 'package:inf/ui/filter/main_nav_panel.dart';
import 'package:inf/ui/main/page_mode.dart';
import 'package:inf/ui/offer_add/add_business_offer_page.dart';
import 'package:inf/ui/widgets/swipe_detector.dart';
import 'package:inf/utils/animation_choreographer.dart';
import 'package:inf_api_client/inf_api_client.dart';

const kBottomNavHeight = 84.0;

class BottomNavPanel extends StatefulWidget {
  const BottomNavPanel({
    Key key,
    @required this.userType,
    @required this.initialValue,
    @required this.onBottomNavChanged,
  }) : super(key: key);

  final UserType userType;
  final MainPageMode initialValue;
  final ValueChanged<MainPageMode> onBottomNavChanged;

  @override
  BottomNavPanelState createState() => BottomNavPanelState();
}

class BottomNavPanelState extends State<BottomNavPanel> with SingleTickerProviderStateMixin {
  LocalHistoryEntry _panelHistoryEntry;
  AnimationController _controller;
  Animation<Offset> _panel1;
  Animation<Offset> _panel2;

  double height1;
  double height2;

  FocusNode _bottomNavFocus;

  MainPageMode _pageMode;

  @override
  void initState() {
    super.initState();

    _pageMode = widget.initialValue;

    _controller = AnimationController(duration: const Duration(milliseconds: 350), vsync: this);

    _panel1 = Tween<Offset>(begin: const Offset(0.0, 0.0), end: const Offset(0.0, 1.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _panel2 = Tween<Offset>(begin: const Offset(0.0, 1.0), end: const Offset(0.0, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _bottomNavFocus = FocusNode();
  }

  @override
  void dispose() {
    _bottomNavFocus.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        SlideTransition(
          position: _panel1,
          child: Container(
            height: mediaQuery.padding.bottom + kBottomNavHeight + 12.0,
            child: MainNavPanel(
              userType: widget.userType,
              initialValue: widget.initialValue,
              onFabPressed: _onFabPressed,
              onBottomNavChanged: (mode) {
                _pageMode = mode;
                widget.onBottomNavChanged(mode);
              },
            ),
          ),
        ),
        AnimationChoreographer(
          animation: _controller,
          child: SlideTransition(
            position: _panel2,
            child: SwipeDetector(
              onSwipeDown: _hideSearchPanel,
              slopAmount: 24.0,
              child: FilterPanel(
                closePanel: _hideSearchPanel,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onFabPressed() {
    if (widget.userType == UserType.influencer || _pageMode == MainPageMode.browse) {
      _showSearchPanel();
    } else {
      Navigator.of(context).push(AddBusinessOfferPage.route(widget.userType));
    }
  }

  void _showSearchPanel() {
    _controller.forward();
    _panelHistoryEntry = LocalHistoryEntry(onRemove: () {
      _panelHistoryEntry = null;
      _hideSearchPanel();
    });
    ModalRoute.of(context).addLocalHistoryEntry(_panelHistoryEntry);
    FocusScope.of(context).requestFocus(_bottomNavFocus);
  }

  void _hideSearchPanel() {
    if (_panelHistoryEntry != null) {
      ModalRoute.of(context).removeLocalHistoryEntry(_panelHistoryEntry);
    }
    FocusScope.of(context).requestFocus(_bottomNavFocus);
    _controller.reverse();
  }
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

class BottomNavBackgroundClipper extends CustomClipper<Path> {
  BottomNavBackgroundClipper({
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

class BottomNavBackgroundPainter extends CustomPainter {
  BottomNavBackgroundPainter({
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
