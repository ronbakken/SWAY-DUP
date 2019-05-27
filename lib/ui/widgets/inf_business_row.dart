import 'package:flutter/material.dart';
import 'package:inf/ui/widgets/white_border_circle_avatar.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class InfBusinessRow extends StatelessWidget {
  const InfBusinessRow({
    Key key,
    this.leading,
    this.leadingBackgroundColor,
    this.title,
    this.subtitle,
    this.trailing,
    this.onPressed,
  }) : super(key: key);

  final Widget leading;
  final Color leadingBackgroundColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            children: <Widget>[
              if (leading != null) ...[
                WhiteBorderCircle(
                  child: leading,
                  backgroundColor: leadingBackgroundColor,
                ),
                horizontalMargin12,
              ],
              Expanded(
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
              ),
              if (trailing != null) trailing
            ],
          ),
        ),
      ),
    );
  }
}
