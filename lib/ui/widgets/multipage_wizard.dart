import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:pedantic/pedantic.dart';

/// Returned widget's must use the given key
typedef MultiPageWizardBuilder = Widget Function(BuildContext context, Key key, int index);

class MultiPageWizard extends StatefulWidget {
  const MultiPageWizard({
    Key key,
    @required this.pageCount,
    @required this.pageBuilder,
    this.indicatorColor = AppTheme.red,
    this.indicatorBackgroundColor = AppTheme.lightBlue,
  }) : super(key: key);

  final int pageCount;
  final MultiPageWizardBuilder pageBuilder;
  final Color indicatorColor;
  final Color indicatorBackgroundColor;

  @override
  MultiPageWizardState createState() => MultiPageWizardState();

  static MultiPageWizardState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<MultiPageWizardState>());
  }
}

class MultiPageWizardState extends State<MultiPageWizard> {
  PageController _controller;
  List<GlobalKey<MultiPageWizardPageState>> _pageKeys;
  MultiPageWizardPageState _currentPage;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _pageKeys = List.generate(widget.pageCount, (_) => GlobalKey());
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
                  pageCount: widget.pageCount,
                  color: widget.indicatorColor,
                ),
                size: const Size(double.infinity, kTextTabBarHeight),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _controller,
              onPageChanged: (int page) => _currentPage = _pageKeys[page].currentState,
              itemCount: widget.pageCount,
              itemBuilder: (BuildContext context, int index) {
                Widget child = widget.pageBuilder(context, _pageKeys[index], index);
                assert(child.key == _pageKeys[index], 'Child must use given key');
                return child;
              },
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
      _currentPage?.onPrevPage();
      unawaited(_controller.previousPage(duration: kThemeAnimationDuration, curve: Curves.fastOutSlowIn));
      return false;
    }
    return true;
  }

  void nextPage() {
    if (_controller.page.round() + 1 < widget.pageCount) {
      _controller.nextPage(duration: kThemeAnimationDuration, curve: Curves.fastOutSlowIn);
    }
  }
}

abstract class MultiPageWizardPageWidget extends StatefulWidget {
  const MultiPageWizardPageWidget({
    Key key,
  }) : super(key: key);

  @override
  MultiPageWizardPageState createState();
}

abstract class MultiPageWizardPageState<T extends MultiPageWizardPageWidget> extends State<T> {
  MultiPageWizardState _wizard;

  MultiPageWizardState get wizard => _wizard;

  @override
  void initState() {
    super.initState();
    _wizard = MultiPageWizard.of(context);
  }

  void onPrevPage() {
    //
  }

  void nextPage() {
    _wizard.nextPage();
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

    for (int i = 0; i < controller.page.round(); i++) {
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
