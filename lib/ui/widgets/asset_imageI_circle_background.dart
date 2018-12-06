import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';

class AssetImageCircleBackgroundButton extends StatelessWidget {
  final double radius;
  final Color backgroundColor;
  final AppAsset asset;
  final VoidCallback onTap;

  const AssetImageCircleBackgroundButton(
      {Key key, @required this.radius, @required this.backgroundColor, @required this.asset, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
        child: InfAssetImage(asset),
      ),
    );
  }
}
