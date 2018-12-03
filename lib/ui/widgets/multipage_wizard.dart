import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'dart:math';

class MultiPageWizard extends StatefulWidget {
  final List<Widget> pages;
  final Color indicatorColor;
  final Color indicatorForegroundColor;

  const MultiPageWizard(
      {Key key,
      @required this.pages,
      this.indicatorColor = AppTheme.red,
      this.indicatorForegroundColor = AppTheme.lightBlue})
      : super(key: key);

  @override
  MultiPageWizardState createState() => MultiPageWizardState();

  static MultiPageWizardState of(BuildContext context) {
    return context.ancestorStateOfType(TypeMatcher<MultiPageWizardState>());
  }
}

class MultiPageWizardState extends State<MultiPageWizard> with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: widget.pages.length, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // if we arent on the first tab, a tap on the backbutton doesn't pop the page but moves
        // to the previous tab
        if (_controller.index > 0) {
          _controller.index--;
          return false;
        }
        return true;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _WizzardPageIndicator(controller: _controller, indicatorColor: widget.indicatorColor, indicatorForegroundColor: widget.indicatorForegroundColor,),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: widget.pages,
              controller: _controller,
            ),
          )
        ],
      ),
    );
  }

  void nextPage() {
    if (_controller.index < _controller.length - 1) {
      _controller.animateTo(_controller.index + 1);
    }
  }
}

class _WizzardPageIndicator extends StatelessWidget {
  final TabController controller;
  final Color indicatorColor;
  final Color indicatorForegroundColor;

  _WizzardPageIndicator({
    @required this.controller,
    @required this.indicatorColor,
    @required this.indicatorForegroundColor,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
      child: Stack(
        children: [
          Container(
            color: indicatorColor,
          ),
          ClipPath(
            child: Container(
              color: AppTheme.darkGrey,
            ),
            clipper: _IndicatorClipper(
              count: controller.length,
              indicatorWidthPercent: 0.6,
              radiusPadding: 4,
              linepadding: 3.0,
              controller: controller,
            ),
          ),
          ClipPath(
              child: Container(
                color: indicatorForegroundColor,
              ),
              clipper: _IndicatorClipper(
                count: controller.length,
                indicatorWidthPercent: 0.6,
              )),   
        ],
      ),
    );
  }
}

class _IndicatorClipper extends CustomClipper<Path> {
  final int count;
  final double indicatorWidthPercent;
  final double linepadding;
  final double radiusPadding;
  final TabController controller;

  _IndicatorClipper({
    this.count,
    this.indicatorWidthPercent = 1.0,
    this.linepadding = 0,
    this.radiusPadding = 0,
    this.controller,
  }) : super(reclip: controller?.animation);

  @override
  Path getClip(Size size) {
    double indicatorWidth = size.width * indicatorWidthPercent;
    double horizontalPadding = (size.width - indicatorWidth) / 2;

    double segmentSize = indicatorWidth / (count - 1);

    double circleRadius = segmentSize * 0.5 / 2;

    double delta = (indicatorWidth - 2 * circleRadius) / (count - 1);
    double y = size.height / 2.0;
    double barThickness = circleRadius * 0.6;

    final contentPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    Path circlesPath = Path();

    for (int i = 0; i < count; i++) {
      circlesPath
        ..addOval(Rect.fromCircle(
            center: Offset(horizontalPadding + circleRadius + i * delta, y), radius: circleRadius - radiusPadding));
    }
    circlesPath.addRect(Rect.fromLTWH(horizontalPadding + circleRadius, y - (barThickness - linepadding * 2) / 2,
        indicatorWidth - circleRadius * 2, barThickness - linepadding * 2));
    var path = Path.combine(PathOperation.difference, contentPath, circlesPath);

    double barMaskStart =
        (controller != null) ? (controller.index + 1) * delta + (delta * controller.offset) : indicatorWidth;

    path = Path.combine(
        PathOperation.union,
        path,
        Path()
          ..addRect(Rect.fromLTRB(horizontalPadding + barMaskStart, 0, size.width - horizontalPadding, size.height)));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
