import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InfMemoryImage extends StatelessWidget {
  const InfMemoryImage(
    this.data, {
    Key key,
    this.matchTextDirection = false,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.color,
    this.colorBlendMode = BlendMode.srcIn,
    this.allowDrawingOutsideViewBox = false,
  }) : super(key: key);

  final Uint8List data;
  final bool matchTextDirection;
  final double width;
  final double height;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final Color color;
  final BlendMode colorBlendMode;
  final bool allowDrawingOutsideViewBox;

  @override
  Widget build(BuildContext context) {
    if (data == null || data.isEmpty) {
      return const Icon(Icons.close);
    }
    if (isVector(data)) {
      return SvgPicture.memory(
        data,
        matchTextDirection: matchTextDirection,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        color: color,
        colorBlendMode: colorBlendMode,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      );
    } else {
      return Image.memory(
        data,
        matchTextDirection: matchTextDirection,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        color: color,
        colorBlendMode: colorBlendMode,
      );
    }
  }

  bool isVector(Uint8List data) {
    final header = <int>[0x3C, 0x73, 0x76, 0x67];
    for (int i = 0; i < header.length; i++) {
      if (data[i] != header[i]) {
        return false;
      }
    }
    return true;
  }
}
