import 'dart:math' show pi;

import 'package:flutter/material.dart';

class CurvedBox extends StatelessWidget {
  const CurvedBox({
    Key key,
    this.curveFactor = 1.0,
    this.color,
    @required this.child,
  })  : assert(curveFactor != null),
        super(key: key);

  final double curveFactor;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CurvedBoxPainter(
        color: color ?? Theme.of(context).primaryColor,
        curveFactor: curveFactor,
      ),
      child: child,
    );
  }
}

class _CurvedBoxPainter extends CustomPainter {
  _CurvedBoxPainter({
    @required this.color,
    this.curveFactor = 1.0,
  });

  final Color color;
  final double curveFactor;

  @override
  void paint(Canvas canvas, Size size) {
    final curve = size.height * curveFactor;
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.drawArc(
        Rect.fromLTRB(-curve, -size.height, size.width + curve, size.height), 0.0, pi, true, Paint()..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CurvedBoxPainter oldDelegate) => oldDelegate.curveFactor != curveFactor;
}
