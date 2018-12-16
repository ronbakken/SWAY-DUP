import 'package:flutter/material.dart';

class InfStadiumButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  final double height;

  const InfStadiumButton({
    Key key,
    @required this.text,
    @required this.color,
    @required this.onPressed,
    this.height = 44.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: color,
      shape: const StadiumBorder(),
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: height,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
