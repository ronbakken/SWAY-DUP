import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/ui/widgets/inf_icon.dart';

// Minimum logical pixel size of the IconButton.
// See: <https://material.io/guidelines/layout/metrics-keylines.html#metrics-keylines-touch-target-size>

const double kMinButtonSize = 48.0;

class InfIconButton extends StatelessWidget {
  const InfIconButton(
      {Key key,
      this.iconSize = 24.0,
      this.padding = const EdgeInsets.all(8.0),
      this.alignment = Alignment.center,
      @required this.icon,
      this.child,
      this.color,
      this.highlightColor,
      this.splashColor,
      this.disabledColor,
      @required this.onPressed,
      this.tooltip})
      : assert(iconSize != null),
        assert(padding != null),
        assert(alignment != null),
        assert(icon != null || child != null),
        super(key: key);

  final double iconSize;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final AppAsset icon;
  final Widget child;
  final Color color;
  final Color splashColor;
  final Color highlightColor;
  final Color disabledColor;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    Color currentColor;
    if (onPressed != null) {
      currentColor = color;
    } else {
      currentColor = disabledColor ?? Theme.of(context).disabledColor;
    }

    Widget result = Semantics(
      button: true,
      enabled: onPressed != null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: kMinButtonSize,
          minHeight: kMinButtonSize,
        ),
        child: Padding(
          padding: padding,
          child: SizedBox(
            height: iconSize,
            width: iconSize,
            child: Align(
              alignment: alignment,
              child: IconTheme.merge(
                data: IconThemeData(size: iconSize, color: currentColor),
                child: child ?? InfIcon(icon),
              ),
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      result = Tooltip(message: tooltip, child: result);
    }

    return InkResponse(
      onTap: onPressed,
      child: result,
      highlightColor: highlightColor ?? Theme.of(context).highlightColor,
      splashColor: splashColor ?? Theme.of(context).splashColor,
      radius: math.max(
        Material.defaultSplashRadius,
        (iconSize + math.min(padding.horizontal, padding.vertical)) * 0.7,
        // x 0.5 for diameter -> radius and + 40% overflow derived from other Material apps.
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppAsset>('icon', icon, showName: false));
    properties.add(DiagnosticsProperty<Widget>('child', child, showName: false));
    properties.add(ObjectFlagProperty<VoidCallback>('onPressed', onPressed, ifNull: 'disabled'));
    properties.add(StringProperty('tooltip', tooltip, defaultValue: null, quoted: false));
  }
}
