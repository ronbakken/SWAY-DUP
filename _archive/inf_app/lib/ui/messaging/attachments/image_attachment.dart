import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/messaging/attachments/image_preview_screen.dart';
import 'package:inf/utils/image_utils.dart';
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
  ImageProvider _provider;
  Size _imageSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
  }

  @override
  void reassemble() {
    super.reassemble();
    _resolveImage(); // in case the image cache was flushed
  }

  Future<void> _resolveImage() async {
    _provider = NetworkImage(widget.imageReference.lowResUrl);
    final imageSize = await getImageSize(_provider);
    if (mounted) {
      setState(() {
        _imageSize = imageSize;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: kThemeChangeDuration,
      child: (_imageSize != null)
          ? LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final fitted = applyBoxFit(
                  BoxFit.contain,
                  _imageSize,
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
