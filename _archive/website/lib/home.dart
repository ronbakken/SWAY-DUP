import 'dart:html';
import 'dart:math' as math;

import 'package:flutter_web/cupertino.dart';
import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';
import 'package:inf_website/model.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3, radians;

const appStoreUrl = 'https://itunes.apple.com/gb/app/inf-marketplace-llc/id1464036694?mt=8';
const playStoreUrl = 'https://play.google.com/store/apps/details?id=com.swaymarketplace.app.dev';


class HomePage extends StatelessWidget {
  static Route<dynamic> route(List<CarouselModel> carouselItems, {RouteSettings settings}) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        return HomePage(carouselItems: carouselItems);
      },
    );
  }

  const HomePage({
    Key key,
    @required this.carouselItems,
  }) : super(key: key);

  final List<CarouselModel> carouselItems;

  @override
  Widget build(BuildContext context) {
    final phoneAlignment = Alignment.center; //const Alignment(0.125, 0.1);
    return Material(
      child: OverflowBox(
        minWidth: 340,
        minHeight: 220,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _Background(),
            _Carousel(
              models: carouselItems,
              front: false,
              alignment: phoneAlignment,
            ),
            Align(
              alignment: phoneAlignment,
              child: _Phone(),
            ),
            Align(
              alignment: const Alignment(-0.7, 0.8),
              child: SizedBox(
                width: 340.0,
                child: _HomeContent(),
              ),
            ),
            _Carousel(
              models: carouselItems,
              front: true,
              alignment: phoneAlignment,
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: FractionallySizedBox(
                widthFactor: 0.5,
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 24.0),
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        spacing: 32.0,
                        runSpacing: 12.0,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => window.open(appStoreUrl, 'about:blank'),
                            child: Image.asset('download_apple.png', height: 64.0),
                          ),
                          GestureDetector(
                            onTap: () => window.open(playStoreUrl, 'about:blank'),
                            child: Image.asset('download_google.png', height: 64.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed('/privacy'),
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Text('  ∣  '),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed('/terms'),
                          child: Text(
                            'Terms of Service',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text('Copyright © INF Marketplace LLC 2019. All rights reserved.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Carousel extends StatefulWidget {
  const _Carousel({
    Key key,
    @required this.models,
    @required this.front,
    this.alignment = Alignment.center,
  }) : super(key: key);

  final List<CarouselModel> models;
  final bool front;
  final Alignment alignment;

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<_Carousel> {
  final _duration = ValueNotifier<Duration>(Duration.zero);
  Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_onTick, debugLabel: 'carousel');
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    _duration.value = elapsed;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Flow(
        delegate: _CarouselFlow(
          duration: _duration,
          front: widget.front,
          alignment: widget.alignment,
        ),
        children: widget.models.map((item) {
          return _CarouselItem(model: item);
        }).toList(),
      ),
    );
  }
}

class _CarouselFlow extends FlowDelegate {
  _CarouselFlow({
    @required this.duration,
    @required this.front,
    @required this.alignment,
  }) : super(repaint: duration);

  final ValueNotifier<Duration> duration;
  final bool front;
  final Alignment alignment;

  @override
  void paintChildren(FlowPaintingContext context) {
    final tilt = 87.0;
    final size = context.size;
    final aligned = alignment.alongSize(size);
    final count = context.childCount;
    for (int index = 0; index < count; index++) {
      final result = Matrix4.identity();
      result.translate(aligned.dx, aligned.dy);
      result.multiply(Matrix4.identity()..rotateX(radians(tilt)));

      double time = duration.value.inMicroseconds / Duration.microsecondsPerSecond;
      double angle = ((360.0 * (time / 40)) + (index * (360.0 / count))) % 360;

      final x = math.sin(radians(angle)) * size.width * 0.35 - 24;
      final y = math.cos(radians(angle)) * size.height - 24;
      final pos = result.transform3(Vector3(x, y, 1.0));
      final scale = ((pos.z + 2000) * 0.0005).clamp(0.5, 1.25);

      result.multiply(Matrix4.identity()..translate(x, y));
      result.multiply(Matrix4.diagonal3Values(scale, scale, scale));
      result.multiply(Matrix4.identity()..rotateX(radians(-tilt)));

      if (angle < 90 || angle > 270) {
        if (front) context.paintChild(index, transform: result);
      } else {
        if (!front) context.paintChild(index, transform: result);
      }
    }
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return constraints; // BoxConstraints(maxWidth: 48.0, maxHeight: 48.0);
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) => false;
}

class _CarouselItem extends StatelessWidget {
  const _CarouselItem({
    Key key,
    @required this.model,
  }) : super(key: key);

  final CarouselModel model;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = MediaQuery.of(context).size.aspectRatio.clamp(0.5, 1.0);
    final size = 48.0 * ratio;
    return Stack(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.6),
            border: Border.all(color: Colors.white, width: 1.8),
            borderRadius: BorderRadius.circular(6.0 * ratio),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0 * ratio),
          child: Image.asset(
            'icons/${model.asset}.png',
            semanticLabel: model.name,
          ),
        ),
        Positioned(
          top: size,
          left: size / 2.0 - 0.5,
          width: 1.0,
          child: Container(
            width: 1.0,
            height: 96.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.white,
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          widthFactor: 0.96,
          child: Image.asset('logo.png', width: 240),
        ),
        const SizedBox(height: 12.0),
        Text(
          'Find and be found',
          style: theme.textTheme.headline.copyWith(
            fontSize: 32.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          'We have created a new way for businesses and '
          'content creators to interact and do business.',
          style: TextStyle(
            fontSize: 16.0,
            height: 1.8,
          ),
        )
      ],
    );
  }
}

class _Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset('background.jpg', fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Colors.transparent,
                Colors.black.withOpacity(0.6),
                Colors.black,
              ],
              stops: <double>[
                0.5,
                0.75,
                1.0,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Phone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 2.0 / 1.0,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 210,
              height: 434,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(28.0),
                backgroundBlendMode: BlendMode.modulate,
              ),
            ),
            RepaintBoundary(
              child: Image.asset(
                'phone.png',
                width: 220,
                height: 440,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
