import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'dart:math';

class MultiPageWizard extends StatefulWidget {
  final List<Widget> pages;

  const MultiPageWizard({
    Key key,
    @required this.pages,
  }) : super(key: key);

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WizzardPageIndicator(_controller),
        Expanded(
            child: TabBarView(
          children: widget.pages,
          controller: _controller,
        ))
      ],
    );
  }

  void nextPage() {
    _controller.animateTo(_controller.index + 1);
  }
}

class _WizzardPageIndicator extends StatelessWidget {
  final TabController controller;


  _WizzardPageIndicator(this.controller);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      color: Colors.green,
      child: Stack(
        children: [
          Container(
            color: Colors.red,
          ),
          ClipPath(
            child: Container(
              color: AppTheme.darkGrey,
            ),
            clipper: _IndicatorClipper(
              count: controller.length,
              indicatorWidthPercent: 0.7,
              radiusPadding: 4,
              linepadding: 4.0,
              controller: controller,
            ),
          ),
          ClipPath(
              child: Container(
                color: Colors.blue,
              ),
              clipper: _IndicatorClipper(
                count: controller.length,
                indicatorWidthPercent: 0.7,
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
    double horizontalPadding = (size.width -indicatorWidth) /2;

    double segmentSize = indicatorWidth / (count - 1);

    double circleRadius = segmentSize * 0.5 / 2;

    double delta = (indicatorWidth - 2 * circleRadius) / (count -1);
    double y = size.height / 2.0;
    double barThickness = circleRadius * 0.6;

    final contentPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    Path circlesPath = Path();

    for (int i = 0; i < count; i++) {
      circlesPath
        ..addOval(Rect.fromCircle(
            center: Offset(horizontalPadding + circleRadius + i * delta , y), radius: circleRadius - radiusPadding));
    }
    circlesPath.addRect(Rect.fromLTWH(horizontalPadding + circleRadius, y - (barThickness - linepadding * 2) / 2,
        indicatorWidth - circleRadius * 2, barThickness - linepadding * 2));
    var path = Path.combine(PathOperation.difference, contentPath, circlesPath);
    
    double barMaskStart = (controller != null) ? (controller.index +1) * delta + (delta *controller.offset) : indicatorWidth;
    
    path = Path.combine(
        PathOperation.union,
        path,
        Path()
          ..addRect(Rect.fromLTRB(horizontalPadding + barMaskStart , 0, size.width -horizontalPadding,
              size.height)));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
