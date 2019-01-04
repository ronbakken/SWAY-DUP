import 'package:flutter/material.dart';

class InfLoader extends StatefulWidget {
  static OverlayEntry currentLoader;

  const InfLoader({Key key, this.percentageCompletion}) : super(key: key);

  static void show(BuildContext context) {
    currentLoader = new OverlayEntry(
        builder: (context) => Stack(
              children: <Widget>[
                Container(
                  color: Color(0x99ffffff),
                ),
                Center(
                  child: InfLoader(),
                ),
              ],
            ));
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
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
