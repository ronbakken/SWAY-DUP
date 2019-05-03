import 'package:flutter/material.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/social_network_provider.dart';

import 'inf_asset_image.dart';

class SocialNetworkToggleButton extends StatelessWidget {
  final SocialNetworkProvider provider;
  final VoidCallback onTap;
  final bool isSelected;

  const SocialNetworkToggleButton({
    Key key,
    @required this.provider,
    @required this.onTap,
    @required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration logoDecoration;
    if (provider.hasLogoBackgroundImage) {
      logoDecoration = BoxDecoration(
        image: DecorationImage(
          image: provider.logoBackgroundImage,
          fit: BoxFit.fill,
        ),
      );
    } else {
      logoDecoration = BoxDecoration(
        color: provider.logoBackgroundColor,
      );
    }
    BoxDecoration foregroundDecoration;
    if (isSelected) {
      foregroundDecoration = const BoxDecoration(color: Colors.transparent);
    } else {
      foregroundDecoration = const BoxDecoration(color: Colors.black54);
    }
    return AspectRatio(
      aspectRatio: 1.0,
      child: Center(
        child: Material(
          type: MaterialType.transparency,
          clipBehavior: Clip.antiAlias,
          shape: const CircleBorder(),
          child: AnimatedContainer(
            duration: kThemeAnimationDuration,
            foregroundDecoration: foregroundDecoration,
            child: InkResponse(
              onTap: onTap,
              child: Ink(
                decoration: logoDecoration,
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.6,
                    heightFactor: 0.6,
                    child: InfAssetImage(
                      provider.logoRawAssetMonochrome,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
