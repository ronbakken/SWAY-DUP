import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';

class NotificationMarker extends StatelessWidget {
  const NotificationMarker({
    Key key,
    this.radius = 5.0,
    this.margin,
  })  : assert(radius != null),
        super(key: key);

  final double radius;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      margin: margin,
      decoration: BoxDecoration(
        color: AppTheme.notificationDot,
        shape: BoxShape.circle,
      ),
    );
  }
}
