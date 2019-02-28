import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';

class WhiteBorderCircleAvatar extends StatelessWidget {
  const WhiteBorderCircleAvatar({Key key, @required this.child, this.radius = 24, this.whiteThickness = 0.7})
      : super(key: key);

  final Widget child;
  final double radius;
  final double whiteThickness;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: radius != null ? radius * 2 : null,
      height: radius != null ? radius * 2 : null,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.black12,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(4.0),
        child: Container(
          foregroundDecoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: whiteThickness),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
