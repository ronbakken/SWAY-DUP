import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/messaging/event_view.dart';

class JobCompletedView extends StatelessWidget {
  final String actionTaker;

  const JobCompletedView({
    Key key,
    this.actionTaker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EventView(
      title: actionTaker != null
          ? "$actionTaker has marked the deal as COMPLETE."
          : "The deal has been marked as COMPLETE.",
      icon: Icons.check,
      iconColor: Colors.white,
      iconBackgroundColor: AppTheme.blue,
    );
  }
}
