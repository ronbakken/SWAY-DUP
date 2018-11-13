import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';

class InfToggle<T> extends StatelessWidget {
  final T leftState;
  final T rightState;
  final T currentState;
  final Widget left;
  final Widget right;

  const InfToggle({
    Key key,
    this.currentState,
    this.leftState,
    this.rightState,
    this.left,
    this.right,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const StadiumBorder(),
      color: AppTheme.toggleBackground,
      child: SizedBox(
        width: 64,
        height: 32,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 26,
                decoration: BoxDecoration(
                  color: AppTheme.darkGrey,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: left,
                ),
              ),
              Container(
                width: 26,
                decoration: BoxDecoration(
                  color: AppTheme.grey,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
