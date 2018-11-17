import 'dart:typed_data';

import 'package:flutter/material.dart';

class InfImage extends StatefulWidget {
  InfImage({
    Key key,
    @required Uint8List lowRes,
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
  })  : placeholder = MemoryImage(lowRes, scale: lowResScale),
        image = NetworkImage(imageUrl, scale: imageUrlScale),
        super(key: key);

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
    if (widget.image != oldWidget.image) {
      _resolveImage();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    _resolveImage();
  }

  void _resolveImage() {
    final ImageConfiguration config = createLocalImageConfiguration(context,
        size: widget.width != null && widget.height != null
            ? Size(widget.width, widget.height)
            : null);
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
      child: Image(
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

  static Widget fitLayoutBuilder(
      Widget currentChild, List<Widget> previousChildren) {
    List<Widget> children = previousChildren;
    if (currentChild != null) children = children.toList()..add(currentChild);
    return Stack(
      fit: StackFit.passthrough,
      children: children,
      alignment: Alignment.center,
    );
  }
}
