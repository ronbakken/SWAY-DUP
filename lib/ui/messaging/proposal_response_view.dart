import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/messaging/event_view.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class ProposalResponseView extends StatelessWidget {
  final ProposalResponse response;
  final String _otherParty;

  String get otherParty => _otherParty ?? "They";

  const ProposalResponseView({
    Key key,
    @required this.response,
    String otherParty,
  })  : _otherParty = otherParty,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (response.type) {
      case ProposalResponseType.accept:
        return EventView(
          title: "Congratulations - $otherParty have agreed to your offer.",
          subtitle: response.message,
          icon: Icons.thumb_up,
          iconColor: Colors.white,
          iconBackgroundColor: AppTheme.blue,
        );
      case ProposalResponseType.counter:
        return EventView(
          title: "$otherParty have countered your offer.",
          subtitle: response.message,
          icon: Icons.subdirectory_arrow_left,
          iconColor: Colors.white,
          iconBackgroundColor: AppTheme.charcoalGrey,
        );
        break;
      case ProposalResponseType.reject:
        return EventView(
          title: "$otherParty have declined your offer.",
          subtitle: response.message,
          icon: Icons.clear,
          iconColor: Colors.white,
          iconBackgroundColor: AppTheme.red,
        );
        break;
      default:
        return emptyWidget;
    }
  }
}
