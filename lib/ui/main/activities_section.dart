import 'package:flutter/material.dart';

class MainActivitiesSection extends StatefulWidget {
  const MainActivitiesSection({
    Key key,
    this.padding = EdgeInsets.zero,
  })  : assert(padding != null),
        super(key: key);

  final EdgeInsetsGeometry padding;

  @override
  _MainActivitiesSectionState createState() => _MainActivitiesSectionState();
}

class _MainActivitiesSectionState extends State<MainActivitiesSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: widget.padding,
      child: Text('ACTIVITIES'),
    );
  }
}
