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
    this.semanticLabel,
    this.excludeFromSemantics = false,
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
    String semanticLabel,
    bool excludeFromSemantics = false,
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
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
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
  final String semanticLabel;
  final bool excludeFromSemantics;
  final Widget inkChild;

  @override
  _InfImageState createState() => _InfImageState();
}

class _InfImageState extends State<InfImage> {
  ImageStream _imageStream;
  bool _isListeningToStream = false;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
    if (TickerMode.of(context)) {
      _listenToStream();
    } else {
      _stopListeningToStream();
    }
  }

  @override
  void didUpdateWidget(InfImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      _resolveImage();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    _resolveImage(); // in case the image cache was flushed
  }

  void _resolveImage() {
    final ImageStream newStream = widget.image.resolve(createLocalImageConfiguration(
      context,
      size: widget.width != null && widget.height != null ? Size(widget.width, widget.height) : null,
    ));
    assert(newStream != null);
    _updateSourceStream(newStream);
  }

  // Update _imageStream to newStream, and moves the stream listener
  // registration from the old stream to the new stream (if a listener was
  // registered).
  void _updateSourceStream(ImageStream newStream) {
    if (_imageStream?.key == newStream?.key) return;

    if (_isListeningToStream) _imageStream.removeListener(_handleImageChanged);

    _imageStream = newStream;
    if (_isListeningToStream) _imageStream.addListener(_handleImageChanged);
  }

  void _listenToStream() {
    if (_isListeningToStream) return;
    _imageStream.addListener(_handleImageChanged);
    _isListeningToStream = true;
  }

  void _stopListeningToStream() {
    if (!_isListeningToStream) return;
    _imageStream.removeListener(_handleImageChanged);
    _isListeningToStream = false;
  }

  void _handleImageChanged(ImageInfo imageInfo, bool synchronousCall) {
    if (mounted) {
      setState(() {
        _loaded = (imageInfo != null);
      });
    }
  }

  @override
  void dispose() {
    assert(_imageStream != null);
    _stopListeningToStream();
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
              semanticLabel: widget.semanticLabel,
              excludeFromSemantics: widget.excludeFromSemantics,
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
