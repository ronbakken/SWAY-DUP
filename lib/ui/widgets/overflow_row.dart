import 'package:flutter/material.dart';

class OverFlowRow extends StatelessWidget {
  final List<Widget> children;
  final double height;
  final double spacing;
  final double minChildrenWidth;

  const OverFlowRow({
    Key key,
    @required this.children,
    @required this.height,
    this.spacing = 0.0,
    @required this.minChildrenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double segmentSpace;
          int numberOfItemsToDisplay =
              (constraints.maxWidth / ((minChildrenWidth + spacing))).round();

          segmentSpace = constraints.maxWidth / (numberOfItemsToDisplay);

          var listItems = <Widget>[];
          for (var item in children) {
            listItems.add(Container(
                margin: EdgeInsets.only(right: spacing / 2, left: spacing / 2),
                width: segmentSpace,
                child: item));
          }

          return ListView(
            scrollDirection: Axis.horizontal,
            children: listItems,
          );
        },
      ),
    );
  }
}
