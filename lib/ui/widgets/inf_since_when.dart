import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:inf/utils/date_time_helpers.dart' show sinceWhen;

class InfSinceWhen extends StatefulWidget {
  const InfSinceWhen(
    this.data, {
    Key key,
    this.style,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  }) : super(key: key);

  final DateTime data;
  final TextStyle style;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  final String semanticsLabel;

  @override
  _InfSinceWhenState createState() => _InfSinceWhenState();
}

class _InfSinceWhenState extends State<InfSinceWhen> {

  String _text;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _text = sinceWhen(widget.data).toUpperCase();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTimerTick);
  }

  void _onTimerTick(Timer timer) {
    String newText = sinceWhen(widget.data).toUpperCase();
    if(newText != _text){
      setState(() => _text = newText);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: widget.style,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      softWrap: widget.softWrap,
      overflow: widget.overflow,
      textScaleFactor: widget.textScaleFactor,
      maxLines: widget.maxLines,
      semanticsLabel: widget.semanticsLabel,
    );
  }
}
