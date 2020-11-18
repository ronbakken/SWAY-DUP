import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';

class WhiteBorderCircleAvatar extends StatelessWidget {
  const WhiteBorderCircleAvatar({
    Key key,
    @required this.child,
    this.radius = 24,
  }) : super(key: key);

  final Widget child;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: Center(
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.darkGrey,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4.0),
            child: Container(
              foregroundDecoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 0.7),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
