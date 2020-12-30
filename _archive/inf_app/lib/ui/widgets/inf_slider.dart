import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';

class InfSlider extends StatelessWidget {
  const InfSlider({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
  }) : super(key: key);

  final double value;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChangeEnd;
  final double min;
  final double max;
  final int divisions;
  final String label;

  @override
  Widget build(BuildContext context) {
    SliderThemeData sliderTheme = SliderTheme.of(context);
    return SliderTheme(
      data: sliderTheme.copyWith(
        trackHeight: 8.0,
        trackShape: const _InfRoundedSliderTrackShape(),
        activeTrackColor: AppTheme.tabIndicator,
        inactiveTrackColor: AppTheme.buttonHalo,
        thumbColor: AppTheme.listViewAndMenuBackground,
        disabledThumbColor: AppTheme.toggleBackground,
        thumbShape: const _InfRoundSliderThumbShape(radius: 14.0),
      ),
      child: Slider(
        value: value,
        onChanged: onChanged,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
        min: min,
        max: max,
        divisions: divisions,
        label: label,
      ),
    );
  }
}

class _InfRoundedSliderTrackShape extends SliderTrackShape {
  const _InfRoundedSliderTrackShape();

  @override
  Rect getPreferredRect({
    RenderBox parentBox,
    Offset offset = Offset.zero,
    SliderThemeData sliderTheme,
    bool isEnabled,
    bool isDiscrete,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    assert(trackHeight >= 0);
    assert(parentBox.size.height >= trackHeight);
    return Rect.fromLTWH(
        offset.dx, offset.dy + (parentBox.size.height - trackHeight) / 2, parentBox.size.width, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    Animation<double> enableAnimation,
    TextDirection textDirection,
    Offset thumbCenter,
    bool isDiscrete,
    bool isEnabled,
  }) {
    if (sliderTheme.trackHeight == 0) {
      return;
    }

    // Assign the track segment paints, which are left: active, right: inactive,
    // but reversed for right to left text.
    final ColorTween activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );
    final ColorTween inactiveTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: sliderTheme.inactiveTrackColor,
    );
    final Paint activePaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation);
    final Paint inactivePaint = Paint()..color = inactiveTrackColorTween.evaluate(enableAnimation);
    Paint leftTrackPaint;
    Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    double horizontalAdjustment = 0.0;
    if (!isEnabled) {
      final double disabledThumbRadius = sliderTheme.thumbShape.getPreferredSize(false, isDiscrete).width / 2.0;
      horizontalAdjustment = disabledThumbRadius;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final Radius radius = Radius.circular(trackRect.shortestSide / 2.0);
    final RRect leftTrackSegment = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        trackRect.left,
        trackRect.top,
        thumbCenter.dx - horizontalAdjustment,
        trackRect.bottom,
      ),
      radius,
    );
    final RRect rightTrackSegment = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        thumbCenter.dx + horizontalAdjustment,
        trackRect.top,
        trackRect.right,
        trackRect.bottom,
      ),
      radius,
    );
    context.canvas.drawRRect(leftTrackSegment, leftTrackPaint);
    context.canvas.drawRRect(rightTrackSegment, rightTrackPaint);
  }
}

class _InfRoundSliderThumbShape extends SliderComponentShape {
  const _InfRoundSliderThumbShape({
    this.radius = 6.0,
  });

  final double radius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.fromRadius(radius);

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation,
      Animation<double> enableAnimation,
      bool isDiscrete,
      TextPainter labelPainter,
      RenderBox parentBox,
      Size sizeWithOverflow,
      SliderThemeData sliderTheme,
      TextDirection textDirection,
      double textScaleFactor,
      double value}) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = sliderTheme.thumbColor;
    context.canvas.drawCircle(center, radius, paint);
    paint
      ..style = PaintingStyle.stroke
      ..color = sliderTheme.disabledThumbColor;
    context.canvas.drawCircle(center, radius, paint);
  }
}
