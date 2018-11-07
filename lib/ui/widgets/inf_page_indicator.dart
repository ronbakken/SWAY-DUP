import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

class InfPageIndicator extends StatelessWidget {
  const InfPageIndicator({
    Key key,
    @required this.pageController, this.count,

  }) : super(key: key);

  final PageController pageController;
  final int count;

  @override
  Widget build(BuildContext context,) {
    return PageIndicator(space: 10.0,
      size: 15.0,
      scale: 0.8,
      controller: pageController,
      count: count,
      layout: PageIndicatorLayout.SCALE,
    );
  }
}
