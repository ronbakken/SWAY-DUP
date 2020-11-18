import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart' show Ticker;

class CustomAnimatedCurves extends StatelessWidget {
  const CustomAnimatedCurves({
    Key key,
    this.height = 200.0,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return AnimatedCurves(
      colors: const [Colors.black12, Color(0x0AFFFFFF)],
      durations: const [Duration(seconds: 25), Duration(seconds: 60)],
      waveAmplitudes: const [30.0, 30.0],
      waveFrequencies: const [1.33, 1.8],
      heightFractions: const [0.30, 0.20],
      size: Size(double.infinity, height),
    );
  }
}

class AnimatedCurves extends StatelessWidget {
  AnimatedCurves({
    @required this.colors,
    @required this.durations,
    @required this.waveAmplitudes,
    @required this.waveFrequencies,
    @required this.heightFractions,
    @required this.size,
    this.backgroundColor,
  });

  final List<Color> colors;
  final List<Duration> durations;
  final List<double> waveAmplitudes;
  final List<double> waveFrequencies;
  final List<double> heightFractions;
  final Size size;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: size.width,
      height: size.height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: List.generate(durations.length, (int index) {
          return SizedBox.fromSize(
            size: size,
            child: AnimatedCurve(
              color: colors[index],
              duration: durations[index],
              heightFraction: heightFractions[index],
              waveFrequency: waveFrequencies[index],
              waveAmplitude: waveAmplitudes[index],
            ),
          );
        }),
      ),
    );
  }
}

class AnimatedCurve extends LeafRenderObjectWidget {
  AnimatedCurve({
    Key key,
    this.color,
    this.duration,
    this.waveAmplitude,
    this.waveFrequency,
    this.heightFraction,
  }) : super(key: key);

  final Color color;
  final Duration duration;
  final double waveAmplitude;
  final double waveFrequency;
  final double heightFraction;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderAnimatedCurves(widget: this);
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderAnimatedCurves renderObject) {
    renderObject..widget = this;
  }
}

class _RenderAnimatedCurves extends RenderProxyBox {
  _RenderAnimatedCurves({
    AnimatedCurve widget,
  }) : _widget = widget;

  final Paint _paint = Paint();

  AnimatedCurve _widget;
  Ticker _ticker;
  double _time = 0.0;

  AnimatedCurve get widget => _widget;

  set widget(AnimatedCurve value) {
    if (_widget != value) {
      return;
    }
    _widget = value;
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _ticker = Ticker(_onTick, debugLabel: 'RenderAnimatedCurves');
    _ticker.start();
  }

  @override
  void detach() {
    _ticker.dispose();
    _ticker = null;
    super.detach();
  }

  void _onTick(Duration animationDuration) {
    double duration = widget.duration.inMicroseconds.toDouble();
    _time =
        ((animationDuration.inMicroseconds.toDouble() % duration) / duration);
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Canvas canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    double viewCenterY = size.height * widget.heightFraction;
    double value = 360.0 *
        Curves.easeInOut.transform(((_time - 0.5) * 2.0).abs()).clamp(0.0, 1.0);

    final path = Path();
    final amplitude = (-0.8 * widget.waveAmplitude);
    final phase = value * 2.0 + 30.0;

    path.reset();
    path.moveTo(0.0,
        viewCenterY + amplitude * _sinY(size, phase, widget.waveFrequency, -1));
    for (int i = 1; i < size.width + 1; i++) {
      path.lineTo(
          i.toDouble(),
          viewCenterY +
              amplitude * _sinY(size, phase, widget.waveFrequency, i));
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();

    _paint.color = widget.color;
    _paint.style = PaintingStyle.fill;

    canvas.drawPath(path, _paint);

    canvas.restore();
  }

  double _sinY(Size size, double startRadius, double waveFrequency,
      int currentPosition) {
    return math.sin((math.pi / size.width) * waveFrequency * (currentPosition) +
        startRadius * 2 * math.pi / 360.0);
  }
}
