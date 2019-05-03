import 'package:flutter/material.dart';

abstract class InfImageProvider {
  String get lowResUrl;

  String get imageUrl;
}

class InfImage extends StatefulWidget {
  InfImage({
    Key key,
    @required String lowResUrl,
    @required String imageUrl,
    double lowResScale = 1.0,
    double imageUrlScale = 1.0,
    this.duration = const Duration(milliseconds: 450),
    this.width,
    this.height,
    this.color,
    this.colorBlendMode,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.inkChild,
  })  : placeholder = NetworkImage(lowResUrl, scale: lowResScale),
        image = NetworkImage(imageUrl, scale: imageUrlScale),
        super(key: key);

  factory InfImage.fromProvider(
    InfImageProvider provider, {
    Key key,
    double lowResScale = 1.0,
    double imageUrlScale = 1.0,
    Duration duration = const Duration(milliseconds: 450),
    double width,
    double height,
    Color color,
    BlendMode colorBlendMode,
    BoxFit fit = BoxFit.cover,
    Alignment alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    bool matchTextDirection = false,
    Widget inkChild,
  }) {
    return InfImage(
      key: key,
      lowResUrl: provider.lowResUrl,
      imageUrl: provider.imageUrl,
      lowResScale: lowResScale,
      imageUrlScale: imageUrlScale,
      duration: duration,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      inkChild: inkChild,
    );
  }

  final ImageProvider placeholder;
  final ImageProvider image;
  final Duration duration;
  final double width;
  final double height;
  final Color color;
  final BlendMode colorBlendMode;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final bool matchTextDirection;
  final Widget inkChild;

  @override
  _InfImageState createState() => _InfImageState();
}

class _InfImageState extends State<InfImage> {
  ImageStream _imageStream;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
  }

  @override
  void didUpdateWidget(InfImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resolveImage();
  }

  @override
  void reassemble() {
    super.reassemble();
    _resolveImage();
  }

  void _resolveImage() {
    final ImageConfiguration config = createLocalImageConfiguration(context,
        size: widget.width != null && widget.height != null ? Size(widget.width, widget.height) : null);
    final ImageStream oldImageStream = _imageStream;
    _imageStream = widget.image.resolve(config);
    if (_imageStream.key != oldImageStream?.key) {
      oldImageStream?.removeListener(_handleImageChanged);
      _imageStream.addListener(_handleImageChanged);
    }
  }

  void _handleImageChanged(ImageInfo imageInfo, bool synchronousCall) {
    if (mounted) {
      setState(() => _loaded = (imageInfo != null));
    }
  }

  @override
  void dispose() {
    _imageStream?.removeListener(_handleImageChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider provider;
    if (_loaded) {
      provider = widget.image;
    } else {
      provider = widget.placeholder;
    }
    return AnimatedSwitcher(
      duration: widget.duration,
      switchInCurve: Curves.decelerate,
      switchOutCurve: Curves.easeInOut.flipped,
      layoutBuilder: fitLayoutBuilder,
      child: (widget.inkChild != null)
          ? Ink.image(
              key: ValueKey<ImageProvider>(provider),
              image: provider,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              alignment: widget.alignment,
              repeat: widget.repeat,
              matchTextDirection: widget.matchTextDirection,
              child: widget.inkChild,
            )
          : Image(
              key: ValueKey<ImageProvider>(provider),
              image: provider,
              width: widget.width,
              height: widget.height,
              color: widget.color,
              colorBlendMode: widget.colorBlendMode,
              fit: widget.fit,
              alignment: widget.alignment,
              repeat: widget.repeat,
              matchTextDirection: widget.matchTextDirection,
            ),
    );
  }

  static Widget fitLayoutBuilder(Widget currentChild, List<Widget> previousChildren) {
    List<Widget> children = previousChildren;
    if (currentChild != null) children = children.toList()..add(currentChild);
    return Stack(
      fit: StackFit.passthrough,
      children: children,
      alignment: Alignment.center,
    );
  }
}
