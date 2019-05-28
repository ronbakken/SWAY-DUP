import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

Future<Size> getImageSize(ImageProvider provider) {
  final completer = Completer<Size>();
  final stream = provider.resolve(ImageConfiguration.empty);
  ImageStreamListener listener;
  listener = ImageStreamListener((ImageInfo info, bool synchronousCall) {
    completer.complete(Size(info.image.width.toDouble(), info.image.height.toDouble()));
    stream.removeListener(listener);
  }, onError: completer.completeError);
  stream.addListener(listener);
  return completer.future;
}
