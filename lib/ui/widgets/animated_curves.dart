import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(AnimApp());

class AnimApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Material(
        child: Center(
          child: WaveyLines(
            child: SizedBox(
              width: 200.0,
              height: 200.0,
            ),
          ),
        ),
      ),
    );
  }
}

class WaveyLines extends SingleChildRenderObjectWidget {
  WaveyLines({
    Key key,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderWaveyLines();
  }
}

class _RenderWaveyLines extends RenderProxyBox {
  Ticker _ticker;
  double _time = 0.0;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _ticker = Ticker(_onTick, debugLabel: 'RenderWaveyLines');
    _ticker.start();
  }

  @override
  void detach() {
    _ticker.dispose();
    _ticker = null;
    super.detach();
  }

  void _onTick(Duration duration) {
    _time = duration.inMicroseconds / Duration.microsecondsPerSecond;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Canvas canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    _paintWaves(canvas, size);
    canvas.restore();

    super.paint(context, offset);
  }

  final red = Paint()..color = Colors.red;
  final yellow = Paint()..color = Colors.yellow.withOpacity(0.5);
  final green = Paint()..color = Colors.green;
  final cyan = Paint()..color = Colors.cyan;

  void _paintWaves(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, red);

    final fWidth = size.width;
    final fHeight = size.height;
    final hWidth = size.width / 2.0;
    final hHeight = size.height / 2.0;

    final wWidth = (fWidth * 1.25) / 3;
    final wave = Path();
    wave.moveTo(-(fWidth * (0.125 + (math.sin(_time) * 0.125))), hHeight);
    for (int i = 0; i < 3; i++) {
      double y1 = (math.sin(_time) * 0.3);
      double y2 = (math.sin(-_time) * 0.3);
      final control1 =
          Offset(wWidth * (0.5 + (math.sin(_time) * 0.125)), fHeight * y1);
      final control2 =
          Offset(wWidth * (0.5 + (math.sin(_time) * 0.125)), fHeight * y2);
      wave.relativeCubicTo(
          control1.dx, control1.dy, control2.dx, control2.dy, wWidth, 0.0);
      //canvas.drawCircle(control1, 3.0, cyan);
      //canvas.drawCircle(control2, 3.0, green);
    }

    wave.lineTo(size.width, size.height);
    wave.lineTo(0.0, size.height);
    wave.close();

    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.drawPath(wave, yellow);
    canvas.restore();
  }
}
