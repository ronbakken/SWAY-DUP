import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class InfLoader extends StatefulWidget {
  static OverlayEntry currentLoader;

  const InfLoader({Key key, this.percentageCompletion}) : super(key: key);

  static void show(BuildContext context, [Stream<double> completionPercent]) {
    // Don't push a second loader if there is already one
    if (currentLoader != null) {
      return;
    }
    currentLoader = OverlayEntry(
      builder: (context) {
        return Stack(
            children: <Widget>[
              Container(
                color: Colors.transparent,
              ),
              Center(
                child: InfLoader(
                  percentageCompletion: completionPercent,
                ),
              ),
            ],
          );
      },
    );
    Overlay.of(context).insert(currentLoader);
  }

  /// if null the loader will just display a busy state
  final Stream<double> percentageCompletion;

  static void hide() {
    currentLoader?.remove();
    currentLoader = null;
  }

  @override
  _InfLoaderState createState() => _InfLoaderState();
}

class _InfLoaderState extends State<InfLoader> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    if (widget.percentageCompletion != null) {
      return StreamBuilder<double>(
        initialData: 0.0,
        stream: widget.percentageCompletion,
        builder: (context, snapShot) {
          double completion = 0.0;
          if (snapShot.hasData) {
            completion = snapShot.data;
          }
          return Center(
            child: CircularProgressIndicator(
              value: completion,
            ),
          );
        },
      );
    } else {
      return loadingWidget;
    }
  }
}
