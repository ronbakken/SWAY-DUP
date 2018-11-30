import 'package:flutter/material.dart';

class InfStadiumButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const InfStadiumButton({
    Key key,
    @required this.text,
    @required this.color,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: this.color,
      shape: const StadiumBorder(),
      onPressed: this.onPressed,
      child: Container(
        alignment: Alignment.center,
        height: 44.0,
        child: Text(
          this.text,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
