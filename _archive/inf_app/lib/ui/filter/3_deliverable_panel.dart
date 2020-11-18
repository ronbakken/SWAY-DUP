import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf/ui/filter/filter_confirmation.dart';
import 'package:inf/ui/filter/filter_panel.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FilterConfirmButton.of(context).delegate = FilterConfirmButtonDelegate(AppIcons.tick, _onConfirmed);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final filter = FilterPanel.of(context).value;

    if (filter is UserFilter) {
      _selection.clear();

      if (filter.channels != null) {
        final idSet = filter.channels.map((channel) => channel.id).toSet();

        for (var socialNetworkProvider in backend<ConfigService>().socialNetworkProviders) {
          if (idSet.contains(socialNetworkProvider.id)) {
            _selection.toggle(socialNetworkProvider);
          }
        }
      }
    } else if (filter is OfferFilter) {
      _selection.clear();

      if (filter.deliverableSocialMediaNetworkIds != null) {
        final idSet = filter.deliverableSocialMediaNetworkIds.toSet();

        for (var socialNetworkProvider in backend<ConfigService>().socialNetworkProviders) {
          if (idSet.contains(socialNetworkProvider.id)) {
            _selection.toggle(socialNetworkProvider);
          }
        }
      }
    }

    _selection.addListener(_onSelectionChanged);
  }

  void _onSelectionChanged() {
    final filter = FilterPanel.of(context);
    final value = filter.value;
    final selectedIds = _selection.toList();

    if (value is UserFilter) {
      if (selectedIds.isEmpty) {
        filter.value = value.copyWithout(
          channels: true,
        );
      } else {
        filter.value = value.copyWith(
          channels: selectedIds,
        );
      }
    } else if (value is OfferFilter) {
      if (selectedIds.isEmpty) {
        filter.value = value.copyWithout(
          deliverableSocialMediaNetworkIds: true,
        );
      } else {
        filter.value = value.copyWith(
          deliverableSocialMediaNetworkIds: selectedIds.map((s) => s.id).toList(),
        );
      }
    }
  }

  @override
  void dispose() {
    _selection.removeListener(_onSelectionChanged);
    super.dispose();
  }

  void _onConfirmed() {
    widget.closePanel();
  }

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
