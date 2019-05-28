import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/messaging/attachments/image_preview_screen.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class ImageAttachment extends StatefulWidget {
  const ImageAttachment({
    Key key,
    @required this.imageReference,
  }) : super(key: key);

  final ImageReference imageReference;

  @override
  _ImageAttachmentState createState() => _ImageAttachmentState();
}

class _ImageAttachmentState extends State<ImageAttachment> {
  ImageStream _imageStream;
  bool _isListeningToStream = false;
  ImageProvider _provider;
  ImageInfo _imageInfo;

  @override
  void initState() {
    super.initState();
    _provider = NetworkImage(widget.imageReference.lowResUrl);
  }

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
  void reassemble() {
    super.reassemble();
    _resolveImage(); // in case the image cache was flushed
  }

  void _resolveImage() {
    final ImageStream newStream = _provider.resolve(
      createLocalImageConfiguration(context),
    );
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
        _imageInfo = imageInfo;
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
    return AnimatedSwitcher(
      duration: kThemeChangeDuration,
      child: (_imageInfo != null)
          ? LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final fitted = applyBoxFit(
                  BoxFit.contain,
                  Size(
                    _imageInfo.image.width.toDouble(),
                    _imageInfo.image.height.toDouble(),
                  ),
                  constraints.biggest,
                );
                return SizedBox.fromSize(
                  size: fitted.destination,
                  child: Hero(
                    tag: 'attachment-${widget.imageReference.imageUrl}',
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: _onTapThumbnail,
                        child: Ink.image(
                          image: _provider,
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                padding: const EdgeInsets.all(32.0),
                color: AppTheme.black12,
                child: loadingWidget,
              ),
            ),
    );
  }

  void _onTapThumbnail() {
    Navigator.of(context).push(ImagePreviewScreen.route(
      widget.imageReference,
      tag: 'attachment-${widget.imageReference.imageUrl}',
    ));
  }
}
