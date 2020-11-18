import 'package:flutter/material.dart';

class InfStadiumButton extends StatelessWidget {
  const InfStadiumButton({
    Key key,
    this.text,
    this.textSpan,
    this.icon,
    this.color,
    this.borderColor,
    this.textColor,
    this.onPressed,
    this.height = 44.0,
  })  : assert(text != null || textSpan != null, 'text or textSpan required.'),
        super(key: key);

  final String text;
  final TextSpan textSpan;
  final Widget icon;
  final Color color;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: this.color,
      elevation: this.color != Colors.transparent ? 2.0 : 0.0,
      highlightElevation: this.color != Colors.transparent ? 8.0 : 0.0,
      shape: StadiumBorder(
        side: borderColor != null ? BorderSide(color: borderColor, width: 2.0) : BorderSide.none,
      ),
      onPressed: this.onPressed,
      child: Container(
        alignment: Alignment.center,
        height: height,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            if (this.icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: this.icon,
              ),
            Expanded(
              child: Text.rich(
                textSpan ?? TextSpan(text: text, style: TextStyle(color: textColor)),
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
