import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/inf_business_row.dart';

class EventView extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;

  const EventView({
    Key key,
    @required this.title,
    this.subtitle,
    @required this.icon,
    this.iconColor = Colors.white,
    this.iconBackgroundColor = AppTheme.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: InfBusinessRow(
        leading: icon != null
            ? Icon(
                icon,
                color: iconColor,
              )
            : null,
        leadingBackgroundColor: iconBackgroundColor,
        // TODO: Add icon background.
        title: title,
        subtitle: subtitle,
      ),
    );
  }
}
