import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';

class InfIcon extends StatelessWidget {
  const InfIcon(
    this.icon, {
    Key key,
    this.size,
    this.color,
    this.semanticLabel,
    this.textDirection,
  }) : super(key: key);

  final AppAsset icon;
  final double size;
  final Color color;
  final String semanticLabel;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    assert(this.textDirection != null || debugCheckHasDirectionality(context));

    final TextDirection textDirection = this.textDirection ?? Directionality.of(context);
    final IconThemeData iconTheme = IconTheme.of(context);
    final double iconSize = size ?? iconTheme.size;

    if (icon == null) {
      return Semantics(label: semanticLabel, child: SizedBox(width: iconSize, height: iconSize));
    }

    final double iconOpacity = iconTheme.opacity;
    Color iconColor = color ?? iconTheme.color;
    if (iconOpacity != 1.0) {
      iconColor = iconColor.withOpacity(iconColor.opacity * iconOpacity);
    }

    Widget iconWidget = InfAssetImage(
      icon,
      color: iconColor,
      width: iconSize,
      height: iconSize,
    );

    if (icon.matchTextDirection) {
      switch (textDirection) {
        case TextDirection.rtl:
          iconWidget = Transform(
            transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
            alignment: Alignment.center,
            transformHitTests: false,
            child: iconWidget,
          );
          break;
        case TextDirection.ltr:
          break;
      }
    }

    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: SizedBox(
          width: iconSize,
          height: iconSize,
          child: Center(
            child: iconWidget,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppAsset>('icon', icon, ifNull: '<empty>', showName: false));
    properties.add(DoubleProperty('size', size, defaultValue: null));
    properties.add(DiagnosticsProperty<Color>('color', color, defaultValue: null));
  }
}
