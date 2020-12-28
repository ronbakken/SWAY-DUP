import 'package:flutter/material.dart';
import 'package:sway_mobile_app/app/theme.dart';

class NotificationMarker extends StatelessWidget {
  const NotificationMarker({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0),
      width: 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: AppTheme.notificationDot,
        shape: BoxShape.circle,
      ),
    );
  }
}
