import 'dart:math' show pi;

import 'package:flutter/material.dart';

class CurvedBox extends StatelessWidget {
  const CurvedBox({
    Key key,
    this.curveFactor = 1.0,
    this.color,
    this.top = false,
    this.bottom = false,
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
        top: top,
      ),
      child: child,
    );
  }
}

class _CurvedBoxPainter extends CustomPainter {
  _CurvedBoxPainter(
      {@required this.color, this.curveFactor = 1.0, this.top, this.bottom});

  final Color color;
  final double curveFactor;
  final bool top;
  final bool bottom;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    final path = _createCurvedPath(curveFactor, size, top, bottom);
    canvas.drawPath(path, Paint()..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CurvedBoxPainter oldDelegate) =>
      oldDelegate.curveFactor != curveFactor;
}

class CurvedBoxClip extends StatelessWidget {
  const CurvedBoxClip({
    Key key,
    this.curveFactor = 1.0,
    this.top = false,
    this.bottom = false,
    @required this.child,
  })  : assert(curveFactor != null),
        super(key: key);

  final double curveFactor;
  final Widget child;
  final bool top;
  final bool bottom;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _CurvedBoxClipper(
        curveFactor: curveFactor,
        top: top,
        bottom: bottom,
      ),
      child: child,
    );
  }
}

class _CurvedBoxClipper extends CustomClipper<Path> {
  _CurvedBoxClipper({this.curveFactor = 1.0, this.top, this.bottom});

  final double curveFactor;
  final bool top;
  final bool bottom;

  @override
  Path getClip(Size size) {
    return _createCurvedPath(curveFactor, size, top, bottom);
  }

  @override
  bool shouldReclip(_CurvedBoxClipper oldClipper) =>
      oldClipper.curveFactor != curveFactor ||
      oldClipper.top != top ||
      oldClipper.bottom != bottom;
}

Path _createCurvedPath(double curveFactor, Size size, bool top, bool bottom) {
  final curve = size.height * curveFactor;
  if (top && !bottom) {
    // top only
    final rect = Rect.fromLTRB(-curve, 0, size.width + curve, 2 * size.height);
    return Path()..addArc(rect, pi, 2 * pi);
  } else if (bottom && !top) {
    // bottom only
    final rect =
        Rect.fromLTRB(-curve, -size.height, size.width + curve, size.height);
    return Path()..addArc(rect, 0.0, pi);
  } else {
    // both top and bottom
    final rect =
        Rect.fromLTRB(-curve * 0.5, 0, size.width + curve * 0.5, size.height);
    return Path()..addArc(rect, 0.0, 2 * pi);
  }
}
