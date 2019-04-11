import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';

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
    return InfAssetImage(
      AppAsset.raw(data, matchTextDirection: matchTextDirection),
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      color: color,
      colorBlendMode: colorBlendMode,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
    );
  }
}
