import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/help_button.dart';
import 'package:inf/ui/widgets/listenable_builder.dart';
import 'package:inf/ui/widgets/overflow_row.dart';
import 'package:inf/ui/widgets/social_network_toggle_button.dart';
import 'package:inf/ui/widgets/widget_utils.dart';
import 'package:inf/utils/selection_set.dart';

class SocialPlatformSelector extends StatelessWidget {
  const SocialPlatformSelector({
    Key key,
    @required this.channels,
    this.padding = EdgeInsets.zero,
    this.label,
  }) : super(key: key);

  final SelectionSet<SocialNetworkProvider> channels;
  final EdgeInsets padding;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  textAlign: TextAlign.left,
                  style: AppTheme.formFieldLabelStyle,
                ),
                const Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: HelpButton(),
                ),
              ],
            ),
          ),
        ListenableBuilder(
          listenable: channels,
          builder: (BuildContext context, Widget child) {
            return SocialNetworkRow(
              selectedPlatforms: channels,
              onProviderPressed: channels.toggle,
            );
          },
        ),
      ],
    );
  }
}

class SocialNetworkRow extends StatelessWidget {
  const SocialNetworkRow({
    Key key,
    @required this.selectedPlatforms,
    this.onProviderPressed,
    this.height = 96.0,
    this.childrenWidth = 48.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0),
  })  : assert(padding != null),
        super(key: key);

  final double height;
  final double childrenWidth;
  final EdgeInsets padding;
  final SelectionSet<SocialNetworkProvider> selectedPlatforms;
  final ValueChanged<SocialNetworkProvider> onProviderPressed;

  @override
  Widget build(BuildContext context) {
    final socialNetworkProviders = backend<ConfigService>().socialNetworkProviders;
    return OverflowRow(
      padding: padding,
      itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: height,
      childrenWidth: this.childrenWidth,
      children: mapChildren(socialNetworkProviders, (provider) {
        return SocialNetworkToggleButton(
          onTap: onProviderPressed != null ? () => onProviderPressed(provider) : null,
          isSelected: selectedPlatforms.contains(provider),
          provider: provider,
        );
      }),
    );
  }
}
