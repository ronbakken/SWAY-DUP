import 'package:flutter/material.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf/ui/widgets/listenable_builder.dart';
import 'package:inf/ui/widgets/social_platform_selector.dart';
import 'package:inf/utils/selection_set.dart';

class DeliverableFilterPanel extends StatefulWidget {
  DeliverableFilterPanel({
    Key key,
    this.padding = EdgeInsets.zero,
    this.closePanel,
  })  : assert(padding != null),
        super(key: key);

  final EdgeInsets padding;
  final VoidCallback closePanel;

  @override
  _DeliverableFilterPanelState createState() => _DeliverableFilterPanelState();
}

class _DeliverableFilterPanelState extends State<DeliverableFilterPanel> {
  final _selection = SelectionSet<SocialNetworkProvider>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _selection,
      builder: (BuildContext context, Widget child) {
        return SocialNetworkRow(
          selectedPlatforms: _selection,
          onProviderPressed: _selection.toggle,
          height: double.infinity,
          childrenWidth: 56.0,
          padding: const EdgeInsets.symmetric(horizontal: 24.0) + widget.padding,
        );
      },
    );
  }
}
