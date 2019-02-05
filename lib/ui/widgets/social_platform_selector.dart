import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/help_button.dart';
import 'package:inf/ui/widgets/overflow_row.dart';
import 'package:inf/ui/widgets/social_network_toggle_button.dart';
import 'package:inf/utils/selection_set.dart';

class SocialPlatformSelector extends StatefulWidget {
  final SelectionSet<SocialNetworkProvider> channels;
  final EdgeInsets padding;
  final String label;

  const SocialPlatformSelector({
    Key key,
    @required this.channels,
    this.padding = EdgeInsets.zero,
    this.label,
  }) : super(key: key);

  @override
  SocialPlatformSelectorState createState() => SocialPlatformSelectorState();
}

class SocialPlatformSelectorState extends State<SocialPlatformSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: widget.padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                textAlign: TextAlign.left,
                style: AppTheme.formFieldLabelStyle,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: HelpButton(),
              ),
            ],
          ),
        ),
        buildSocialPlatformRow(),
      ],
    );
  }

  Widget buildSocialPlatformRow() {
    return OverflowRow(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 96.0,
      childrenWidth: 48.0,
      children: backend.get<ConfigService>().socialNetworkProviders.map((provider) {
        return SocialNetworkToggleButton(
          onTap: () => setState(() => widget.channels.toggle(provider)),
          isSelected: widget.channels.contains(provider),
          provider: provider,
        );
      }).toList(growable: false),
    );
  }
}
