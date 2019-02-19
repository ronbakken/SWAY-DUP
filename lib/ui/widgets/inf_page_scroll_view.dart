import 'package:flutter/material.dart';

class InfPageScrollView extends StatefulWidget {
  const InfPageScrollView({
    Key key,
    this.top,
    this.bottom,
    this.child,
  }) : super(key: key);

  final Widget top;
  final PreferredSizeWidget bottom;
  final Widget child;

  @override
  _InfPageScrollViewState createState() => _InfPageScrollViewState();
}

class _InfPageScrollViewState extends State<InfPageScrollView> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double scrollViewBottomInset = mediaQuery.padding.bottom;

        Widget top;
        if (widget.top != null) {
          top = Align(
            alignment: Alignment.topCenter,
            child: Material(
              type: MaterialType.transparency,
              child: widget.top,
            ),
          );
        } else {
          top = SizedBox();
        }

        Widget bottom;
        if (widget.bottom != null) {
          bottom = Align(
            alignment: Alignment.bottomCenter,
            child: widget.bottom,
          );
          scrollViewBottomInset += widget.bottom.preferredSize.height;
        } else {
          bottom = SizedBox();
        }

        return Padding(
          padding: mediaQuery.viewInsets,
          child: Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              Positioned.fill(
                bottom: scrollViewBottomInset,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: constraints.copyWith(
                      minWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight,
                      maxHeight: double.infinity,
                    ),
                    child: IntrinsicHeight(
                      child: widget.child,
                    ),
                  ),
                ),
              ),
              bottom,
              top,
            ],
          ),
        );
      },
    );
  }
}
