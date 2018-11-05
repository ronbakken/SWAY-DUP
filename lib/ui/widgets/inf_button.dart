import 'package:flutter/material.dart';

class InfButton extends StatelessWidget {
  final Widget leading;
  final String text;
  final VoidCallback onPressed;

  const InfButton({Key key, this.leading, this.text, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        // TODO set correct theme
        disabledColor: Colors.grey,
        color: Colors.blueAccent,
        onPressed: onPressed,
        child: Row(
          children: <Widget>[
            Expanded(
              child: leading != null
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: leading,
                    )
                  : SizedBox(),
            ),
            Expanded(flex: 2,child: Center(child: Text(text))),
            Expanded(
              child: SizedBox(),
            )
          ],
        ));
  }
}
