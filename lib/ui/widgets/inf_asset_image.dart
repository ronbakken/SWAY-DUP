import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inf/app/assets.dart';

class InfAssetImage extends StatelessWidget {
  const InfAssetImage(
    this.asset, {
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

  final AppAsset asset;
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
    switch (asset.type) {
      case AppAssetType.Vector:
        return SvgPicture.asset(
          asset.path,
          matchTextDirection: matchTextDirection,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          color: color,
          colorBlendMode: colorBlendMode,
          allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
        );
      case AppAssetType.Bitmap:
        return Image.asset(
          asset.path,
          matchTextDirection: matchTextDirection,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          color: color,
          colorBlendMode: colorBlendMode,
        );
      case AppAssetType.Raw:
        if (isSvgData(asset.data)) {
          return SvgPicture.memory(
            asset.data,
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
            asset.data,
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
    throw StateError("Invalid AppAssetType ${asset.type}");
  }

  static bool isSvgData(Uint8List data) {
    final header = <int>[0x3C, 0x73, 0x76, 0x67];
    for (int i = 0; i < header.length; i++) {
      if (data[i] != header[i]) {
        return false;
      }
    }
    return true;
  }
}
