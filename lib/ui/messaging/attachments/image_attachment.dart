import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/routes.dart';

class ImageAttachment extends StatelessWidget {
  const ImageAttachment({
    Key key,
    @required this.imageReference,
  }) : super(key: key);

  final ImageReference imageReference;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.network(imageReference.lowResUrl),
        // FIXME: image onTap to open ImagePreviewScreen
      ],
    );
  }
}

class ImagePreviewScreen extends StatelessWidget {
  static Route<dynamic> route(ImageReference imageReference) {
    return FadePageRoute(builder: (BuildContext context) {
      return ImagePreviewScreen(
        imageReference: imageReference,
      );
    });
  }

  const ImagePreviewScreen({
    Key key,
    @required this.imageReference,
  }) : super(key: key);

  final ImageReference imageReference;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          Image.network(imageReference.imageUrl),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            child: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
