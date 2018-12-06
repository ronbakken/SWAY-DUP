import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';

import 'package:pedantic/pedantic.dart';

class MultiPageWizard extends StatefulWidget {
  final List<Widget> pages;
  final Color indicatorColor;
  final Color indicatorBackgroundColor;

  const MultiPageWizard({
    Key key,
    @required this.pages,
    this.indicatorColor = AppTheme.red,
    this.indicatorBackgroundColor = AppTheme.lightBlue,
  }) : super(key: key);

  @override
  MultiPageWizardState createState() => MultiPageWizardState();

  static MultiPageWizardState of(BuildContext context) {
    return context.ancestorStateOfType(TypeMatcher<MultiPageWizardState>());
  }
}

class MultiPageWizardState extends State<MultiPageWizard> {
  PageController _controller;
  int _pageCount;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _pageCount = widget.pages.length;
  }

  @override
  void didUpdateWidget(MultiPageWizard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _pageCount = widget.pages.length;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => prevPage(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: widget.indicatorBackgroundColor,
            child: FractionallySizedBox(
              widthFactor: 0.6,
              child: CustomPaint(
                painter: _WizardPageIndicatorPainter(
                  controller: _controller,
                  pageCount: _pageCount,
                  color: widget.indicatorColor,
                ),
                size: Size(double.infinity, 56.0),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              children: widget.pages,
              controller: _controller,
            ),
          )
        ],
      ),
    );
  }

  bool prevPage() {
    // if we aren't on the first tab, a tap on the back button doesn't pop the page but moves
    // to the previous tab
    if (_controller.page > 0) {
      unawaited(_controller.previousPage(duration: kThemeAnimationDuration, curve: Curves.fastOutSlowIn));
      return false;
    }
    return true;
  }

  void nextPage() {
    if (_controller.page.round() + 1 < _pageCount) {
      _controller.nextPage(duration: kThemeAnimationDuration, curve: Curves.fastOutSlowIn);
    }
  }
}

class _WizardPageIndicatorPainter extends CustomPainter {
  _WizardPageIndicatorPainter({
    @required this.controller,
    @required this.pageCount,
    @required this.color,
  }) : super(repaint: controller);

  final PageController controller;
  final int pageCount;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final count = pageCount;
    final circleRadius = (size.width / count) * 0.5 / 2;
    final segmentSize = (size.width - ((size.width / count) - circleRadius * 2)) / (count - 1);

    final centerLeft = size.centerLeft(Offset(circleRadius, 0.0));
    final barThickness = circleRadius * 0.5;

    Path path = Path();
    for (int i = 0; i < count; i++) {
      path.addOval(Rect.fromCircle(
        center: centerLeft + Offset(i * segmentSize, 0.0),
        radius: circleRadius,
      ));
    }

    path = Path.combine(
      PathOperation.union,
      path,
      Path()
        ..addRect(
          Rect.fromLTRB(circleRadius, centerLeft.dy - barThickness * 0.5, size.width - circleRadius,
              centerLeft.dy + barThickness * 0.5),
        ),
    );

    double delta = (size.width - 2 * circleRadius) / (count - 1);
    double indicatorWidth = (controller != null) ? delta * (controller.page + 1) : size.width;

    canvas.drawPath(path, Paint()..color = AppTheme.darkGrey);

    canvas.save();
    canvas.clipRect(Offset.zero & Size(indicatorWidth - circleRadius, size.height));
    canvas.drawPath(path, Paint()..color = color);
    canvas.restore();

    final check = Icons.check;
    final painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: String.fromCharCode(check.codePoint),
        style: TextStyle(
          inherit: false,
          color: Colors.white,
          fontSize: circleRadius * 1.3,
          fontFamily: check.fontFamily,
          package: check.fontPackage,
        ),
      ),
    );
    painter.layout();

    for(int i = 0; i < controller.page.round(); i++){
      painter.paint(canvas, centerLeft + Offset(i * segmentSize, 0.0) - painter.size.center(Offset.zero));
    }

    Paint paintBorder = Paint()
      ..strokeWidth = barThickness * 0.4
      ..style = PaintingStyle.stroke
      ..color = AppTheme.darkGrey;
    canvas.drawPath(path, paintBorder);
  }

  @override
  bool shouldRepaint(_WizardPageIndicatorPainter oldDelegate) => true;
}
