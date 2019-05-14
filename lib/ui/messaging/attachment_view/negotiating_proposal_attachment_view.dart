import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_divider.dart';
import 'package:inf/ui/widgets/inf_form_label.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class NegotiatingProposalAttachmentView extends StatelessWidget {
  final Proposal previousProposal;
  final Proposal newProposal;

  const NegotiatingProposalAttachmentView({
    @required this.previousProposal,
    @required this.newProposal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _Comparison(
          title: 'DELIVERABLE DESCRIPTION',
          previousValue: previousProposal.deliverableDescription,
          newValue: newProposal.deliverableDescription,
        ),
        const InfDivider(verticalPadding: 9),
        _Comparison(
          title: 'CASH REWARD VALUE',
          previousValue: previousProposal.cashValue?.toStringWithCurrencySymbol(0),
          newValue: newProposal.cashValue?.toStringWithCurrencySymbol(0),
        ),
        const InfDivider(verticalPadding: 9),
        _Comparison(
          title: 'ITEMS OR SERVICE DESCRIPTION',
          previousValue: previousProposal.serviceDescription,
          newValue: newProposal.serviceDescription,
        ),
        const InfDivider(verticalPadding: 9),
        _Comparison(
          title: 'ITEMS OR SERVICE VALUE',
          previousValue: previousProposal.serviceValue?.toStringWithCurrencySymbol(0),
          newValue: newProposal.serviceValue?.toStringWithCurrencySymbol(0),
        ),
      ],
    );
  }
}

class _Comparison extends StatelessWidget {
  _Comparison({
    @required this.title,
    @required this.previousValue,
    @required this.newValue,
  });

  final String title;
  final String previousValue;
  final String newValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InfFormLabel(title),
        verticalMargin8,
        if (newValue != null) Text(newValue),
        if (newValue == null)
          const Text(
            'No value provided.',
            style: TextStyle(color: AppTheme.white50, fontStyle: FontStyle.italic),
          ),
        verticalMargin8,
        if (previousValue != newValue) buildOriginalBlock(previousValue),
      ],
    );
  }

  Widget buildOriginalBlock(String text) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: AppTheme.grey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Original",
                style: TextStyle(color: AppTheme.white30),
              ),
              verticalMargin8,
              if (text != null) Text(text),
              if (text == null)
                const Text(
                  'No value provided.',
                  style: TextStyle(color: AppTheme.white50, fontStyle: FontStyle.italic),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
