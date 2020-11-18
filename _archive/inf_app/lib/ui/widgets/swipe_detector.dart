import 'package:flutter/material.dart';

class SwipeDetector extends StatefulWidget {
  const SwipeDetector({
    Key key,
    this.onSwipeUp,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeDown,
    this.slopAmount = 0,
    @required this.child,
  }) : super(key: key);

  final VoidCallback onSwipeUp;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeDown;
  final double slopAmount;
  final Widget child;

  @override
  _SwipeDetectorState createState() => _SwipeDetectorState();
}

class _SwipeDetectorState extends State<SwipeDetector> {
  Offset _start;
  Offset _end;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (d) => _start = _end = d.globalPosition,
      onPanUpdate: (d) => _end = d.globalPosition,
      onPanEnd: (d) {
        final dx = _end.dx - _start.dx;
        final dy = _end.dy - _start.dy;
        if (dx > widget.slopAmount && widget.onSwipeRight != null) {
          widget.onSwipeRight();
        } else if (dx < -widget.slopAmount && widget.onSwipeLeft != null) {
          widget.onSwipeLeft();
        }
        if (dy > widget.slopAmount && widget.onSwipeDown != null) {
          widget.onSwipeDown();
        } else if (dy < -widget.slopAmount && widget.onSwipeUp != null) {
          widget.onSwipeUp();
        }
      },
      child: widget.child,
    );
  }
}
