import 'dart:async';


import 'package:flutter/material.dart';

Future showMessageDialog(BuildContext context, String title, String message,
    [String buttonText = 'OK']) async {
  await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(title),
          content: Text(message),
          actions: <Widget>[
            new FlatButton(
              child: new Text(buttonText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

Future<bool> showQueryDialog(BuildContext context, String title, String message,
    {String trueText = 'Yes',String falseText = 'Cancel'}) async {
  return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(title),
          content: Text(message),
          actions: <Widget>[
            new FlatButton(
              child: new Text(trueText),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            new FlatButton(
              child: new Text(falseText),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      });
}


