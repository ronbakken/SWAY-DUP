import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class ConversationNegotiationButtons extends StatelessWidget {
  const ConversationNegotiationButtons({
    Key key,
    @required this.onAccept,
    @required this.onCounter,
    @required this.onReject,
  }) : super(key: key);

  final VoidCallback onAccept;
  final VoidCallback onCounter;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        children: <Widget>[
          InfStadiumButton(
            text: 'ACCEPT PROPOSAL',
            color: AppTheme.black12,
            borderColor: AppTheme.blue,
            onPressed: onAccept,
          ),
          verticalMargin16,
          InfStadiumButton(
            text: 'COUNTER OFFER',
            color: AppTheme.black12,
            borderColor: AppTheme.grey,
            onPressed: onCounter,
          ),
          verticalMargin16,
          InfStadiumButton(
            text: 'REJECT PROPOSAL',
            color: AppTheme.black12,
            borderColor: AppTheme.red,
            onPressed: onReject,
          ),
        ],
      ),
    );
  }
}
