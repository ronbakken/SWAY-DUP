import 'package:flutter/material.dart';

class DarkContainer extends StatelessWidget {
  const DarkContainer({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new Material(
      elevation: 4.0,
      color: Theme.of(context).primaryColorDark,
      child: new Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).primaryTextTheme,
          iconTheme: Theme.of(context).primaryIconTheme,
        ),
        child: child,
      ),
    );
  }
}