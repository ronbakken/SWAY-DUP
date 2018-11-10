import 'dart:math' show pi;

import 'package:flutter/material.dart';

class CurvedBox extends StatelessWidget {
  const CurvedBox({
    Key key,
    this.curveFactor = 1.0,
    this.color,
    this.top = false,
    this.bottom = true,
    @required this.child,
  })  : assert(curveFactor != null),
        super(key: key);

  final double curveFactor;
  final Color color;
  final Widget child;
  final bool top;
  final bool bottom;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CurvedBoxPainter(
        color: color ?? Theme.of(context).primaryColor,
        curveFactor: curveFactor,
        bottom: bottom,
        top: top
      ),
      child: child,
    );
  }
}

class _CurvedBoxPainter extends CustomPainter {
  _CurvedBoxPainter({@required this.color, this.curveFactor = 1.0, this.top, this.bottom});

  final Color color;
  final double curveFactor;
  final bool top;
  final bool bottom;

  @override
  void paint(Canvas canvas, Size size) {
    final curve = size.height * curveFactor;
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    if (top && ! bottom) {
      canvas.drawArc(
          Rect.fromLTRB(-curve , 0, size.width + curve, 2* size.height), pi, 2*pi, true, Paint()..color = color);
    }
    else if (bottom && ! top) {
      canvas.drawArc(
          Rect.fromLTRB(-curve, -size.height, size.width + curve, size.height), 0.0, pi, true, Paint()..color = color);
    }
    else 
    {
      canvas.drawArc(
          Rect.fromLTRB(-curve* 0.5, 0, size.width + curve *0.5, size.height), 0.0, 2* pi, true, Paint()..color = color);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CurvedBoxPainter oldDelegate) => oldDelegate.curveFactor != curveFactor;
}
