import 'package:flutter/material.dart';

class InfStadiumButton extends StatelessWidget {
  final String text;
  final TextSpan textSpan;
  final Color color;
  final VoidCallback onPressed;
  final double height;

  const InfStadiumButton({
    Key key,
    this.text,
    this.textSpan,
    this.color,
    this.onPressed,
    this.height = 44.0,
  })  : assert(text != null || textSpan != null, 'text or textSpan required.'),
        super(key: key);

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
        child: Text.rich(
          textSpan ?? TextSpan(text: text),
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
