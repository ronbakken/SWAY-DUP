import 'dart:math' as math;
import 'package:flutter/material.dart';

const degrees2Radians = (math.pi / 180.0);

class ExpandTransition extends StatelessWidget {
  const ExpandTransition({
    Key key,
    @required this.distance,
    @required this.startAngle,
    @required this.tickAngle,
    @required this.children,
  })  : assert(distance != null),
        assert(startAngle != null, tickAngle != null),
        assert(children != null),
        super(key: key);

  final Animation<double> distance;
  final double startAngle;
  final double tickAngle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: _ExpandTransitionDelegate(this),
      children: children,
    );
  }
}

class _ExpandTransitionDelegate extends FlowDelegate {
  final ExpandTransition widget;

  _ExpandTransitionDelegate(this.widget) : super(repaint: widget.distance);

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) => constraints.loosen();

  @override
  void paintChildren(FlowPaintingContext context) {
    for (int index = 0; index < context.childCount; index++) {
      final childSize = context.getChildSize(index);
      final childBounds = Size(context.size.width - childSize.width, context.size.height - childSize.height);
      final origin = Alignment.bottomCenter.alongSize(childBounds);
      final headingRadians = (widget.startAngle + (index * widget.tickAngle)) * degrees2Radians;
      final position = Matrix4.translationValues(
        origin.dx + ((childBounds.width * 0.5) * widget.distance.value) * math.cos(headingRadians),
        origin.dy + (childBounds.height * widget.distance.value) * math.sin(headingRadians),
        0.0,
      );
      context.paintChild(index, transform: position);
    }
  }

  @override
  bool shouldRepaint(_ExpandTransitionDelegate old) => widget != old.widget;
}
