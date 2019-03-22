import 'package:flutter/material.dart';
import 'package:inf/ui/widgets/white_border_circle_avatar.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class InfBusinessRow extends StatelessWidget {
  const InfBusinessRow({
    Key key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
  }) : super(key: key);

  final Widget leading;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    if (leading != null) {
      children.addAll(<Widget>[
        WhiteBorderCircleAvatar(
          child: leading,
        ),
        horizontalMargin12,
      ]);
    }

    children.add(Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title ?? ''),
          Text(
            subtitle ?? '',
            style: const TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
    ));

    if(trailing != null){
      children.add(trailing);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      color: Colors.black,
      child: Row(
        children: children,
      ),
    );
  }
}
