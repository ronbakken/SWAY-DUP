import 'package:flutter/material.dart';

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
