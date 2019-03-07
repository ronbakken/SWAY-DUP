import 'package:flutter/material.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class InfStadiumButton extends StatelessWidget {
  const InfStadiumButton({
    Key key,
    this.text,
    this.textSpan,
    this.icon,
    this.color,
    this.onPressed,
    this.height = 44.0,
  })
    : assert(text != null || textSpan != null, 'text or textSpan required.'),
      super(key: key);

  final String text;
  final TextSpan textSpan;
  final Widget icon;
  final Color color;
  final VoidCallback onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: this.color,
      elevation: this.color != Colors.transparent ? 2.0 : 0.0,
      highlightElevation: this.color != Colors.transparent ? 8.0 : 0.0,
      shape: const StadiumBorder(),
      onPressed: this.onPressed,
      child: Container(
        alignment: Alignment.center,
        height: height,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            this.icon != null ? Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: this.icon,
            ) : emptyWidget,
            Text.rich(
              textSpan ?? TextSpan(text: text),
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
