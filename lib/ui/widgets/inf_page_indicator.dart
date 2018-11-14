import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';

// TODO: Clean up and fix

class InfPageIndicator extends StatelessWidget {
  const InfPageIndicator({
    Key key,
    @required this.controller,
    @required this.itemCount,
    this.size = 8.0,
    this.spacing = 12.0,
  }) : super(key: key);

  final PageController controller;
  final int itemCount;
  final double size;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      willChange: true,
      painter: _PageViewIndicatorPainter(
        controller: controller,
        callback: _paintWarm,
      ),
      size: Size(itemCount * size + (itemCount - 1) * spacing, size),
    );
  }

  void _paintWarm(Canvas canvas, Size canvasSize) {
    final page = controller.page ?? 0.0;
    final index = page.floor();

    double radius = size / 2;

    Paint dotPaint = Paint();

    dotPaint.color = Colors.white54;

    for (int i = 0; i < itemCount; i++) {
      canvas.drawCircle(Offset(i * (size + spacing) + radius, radius), radius, dotPaint);
    }

    dotPaint.color = Colors.white;

    double progress = page - index;
    double distance = size + spacing;
    double start = index * (size + spacing);

    if (progress > 0.5) {
      double left = index * distance + distance * (progress - 0.5) * 2;
      double right = start + size + distance;
      canvas.drawRRect(RRect.fromLTRBR(left, 0.0, right, size, Radius.circular(radius)), dotPaint);
    } else {
      double right = start + size + distance * progress * 2;
      canvas.drawRRect(RRect.fromLTRBR(start, 0.0, right, size, Radius.circular(radius)), dotPaint);
    }
  }
}

typedef PageViewPaintCallback = void Function(Canvas canvas, Size size);

class _PageViewIndicatorPainter extends CustomPainter {
  _PageViewIndicatorPainter({
    @required this.controller,
    @required this.callback,
  }) : super(repaint: controller);

  final PageController controller;
  final PageViewPaintCallback callback;

  @override
  void paint(Canvas canvas, Size size) => callback(canvas, size);

  @override
  bool shouldRepaint(_PageViewIndicatorPainter old) => (old.controller != controller);
}
