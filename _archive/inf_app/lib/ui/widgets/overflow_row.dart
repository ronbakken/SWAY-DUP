import 'package:flutter/material.dart';

class OverflowRow extends StatelessWidget {
  final EdgeInsets padding;
  final EdgeInsets itemPadding;
  final double childrenWidth;
  final double height;
  final List<Widget> children;

  const OverflowRow({
    Key key,
    this.padding = EdgeInsets.zero,
    this.itemPadding = EdgeInsets.zero,
    @required this.childrenWidth,
    @required this.height,
    @required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          assert(constraints.hasBoundedWidth);
          double childWidth;
          // If we don't have room for the children, make sure we have always
          // have half of the last visible child on screen.
          double maxChildWidth = childrenWidth + itemPadding.horizontal;
          double maxWidth = (constraints.maxWidth - padding.horizontal);
          bool overflow = (maxChildWidth * children.length) > maxWidth;
          if(overflow){
            final maxWidthLeft = (constraints.maxWidth - padding.left);
            childWidth = maxWidthLeft / ((maxWidth ~/ maxChildWidth) + 0.5);
          }else{
            childWidth = maxWidth / children.length;
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: padding,
            itemCount: children.length,
            itemBuilder: (BuildContext context, int index) {
              /*
              FIXME: Put up with extra padding for the moment so that children are always the same size.
              EdgeInsets padding = itemPadding;
              if(overflow){
                if(index == 0) {
                  padding = itemPadding.copyWith(left: 0.0);
                }else if(index == children.length - 1){
                  padding = itemPadding.copyWith(right: 0.0);
                }
              }
              */
              return Container(
                width: childWidth,
                alignment: Alignment.center,
                padding: itemPadding,
                child: children[index],
              );
            },
          );
        },
      ),
    );
  }
}
