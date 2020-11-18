import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class ImagePreviewScreen extends StatefulWidget {
  static Route<dynamic> route(ImageReference imageReference, {String tag}) {
    return FadePageRoute(builder: (BuildContext context) {
      return ImagePreviewScreen(
        imageReference: imageReference,
        tag: tag,
      );
    });
  }

  const ImagePreviewScreen({
    Key key,
    @required this.imageReference,
    this.tag,
  }) : super(key: key);

  final ImageReference imageReference;
  final String tag;

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> with SingleTickerProviderStateMixin {
  final _matrix = ValueNotifier<Matrix4>(Matrix4.identity());
  AnimationController _scaleController;
  Matrix4 _startMatrix = Matrix4.identity();
  Offset _startOrigin = Offset.zero;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this);
    _scaleController.addListener(() {
      final scale = _scaleController.value;
      _matrix.value = _startMatrix.copyInto(Matrix4.identity())..splatDiagonal(scale);
      //_matrix.value = _startMatrix * (Matrix4.identity()..scale(scale, scale));
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onScaleStart(ScaleStartDetails details) {
    _scaleController.stop();
    _startMatrix = _matrix.value;
    _startOrigin = details.focalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final origin = (context.findRenderObject() as RenderBox).globalToLocal(details.focalPoint - _startOrigin);
    final inverse = Matrix4.identity()..copyInverse(_startMatrix);
    final transformed = inverse.transform3(Vector3(origin.dx, origin.dy, 1.0));
    _matrix.value = _startMatrix *
        (Matrix4.identity()
          ..translate(transformed.x, transformed.y)
          ..scale(details.scale, details.scale)
          ..rotateZ(details.rotation));
  }

  void _onScaleEnd(ScaleEndDetails details) {
    /*
    final scale = _matrix.value.getMaxScaleOnAxis();
    if (scale < 0.7) {
      _startMatrix = _matrix.value;
      _scaleController.value = scale;
      _scaleController.animateTo(1.0, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            onScaleEnd: _onScaleEnd,
            child: ValueListenableBuilder<Matrix4>(
              valueListenable: _matrix,
              builder: (BuildContext context, Matrix4 value, Widget child) {
                return Transform(
                  transform: value,
                  alignment: Alignment.center,
                  child: child,
                );
              },
              child: Builder(
                builder: (BuildContext context) {
                  final image = Image.network(widget.imageReference.imageUrl);
                  if (widget.tag != null) {
                    return Hero(
                      tag: widget.tag,
                      child: image,
                    );
                  } else {
                    return image;
                  }
                },
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            child: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              actions: <Widget>[
                IconButton(
                  onPressed: _resetPosition,
                  icon: Icon(Icons.my_location),
                  tooltip: 'Reset Position',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _resetPosition() {
    _matrix.value = Matrix4.identity();
  }
}
