import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class NegotiationActionButtons extends StatelessWidget {
  const NegotiationActionButtons({
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
    return Column(
      children: <Widget>[
        InfStadiumButton(
          text: "ACCEPT OFFER",
          color: AppTheme.black12,
          borderColor: AppTheme.blue,
          onPressed: onAccept,
        ),
        verticalMargin16,
        InfStadiumButton(
          text: "COUNTER OFFER",
          color: AppTheme.charcoalGrey,
          onPressed: onCounter,
        ),
        verticalMargin16,
        InfStadiumButton(
          text: "REJECT OFFER",
          color: AppTheme.black12,
          borderColor: AppTheme.red,
          onPressed: onCounter,
        ),
      ],
    );
  }
}