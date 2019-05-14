import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/proposal.dart';
import 'package:inf/ui/widgets/inf_bottom_button.dart';
import 'package:inf/ui/widgets/inf_bottom_sheet.dart';
import 'package:inf/ui/widgets/inf_text_form_field.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class NegotiationSheet extends StatefulWidget {
  static Route<Proposal> route({
    Proposal existingProposal,
    @required String confirmButtonTitle,
  }) {
    return InfBottomSheet.route<Proposal>(
      title: 'Negotiate',
      child: NegotiationSheet(
        existingProposal: existingProposal,
        confirmButtonTitle: confirmButtonTitle,
      ),
    );
  }

  NegotiationSheet({
    Key key,
    Proposal existingProposal,
    @required this.confirmButtonTitle,
  })  : _proposalBuilder =
            existingProposal != null ? ProposalBuilder.fromProposal(existingProposal) : ProposalBuilder(),
        super(key: key);

  final String confirmButtonTitle;

  final ProposalBuilder _proposalBuilder;

  @override
  _NegotiationSheetState createState() => _NegotiationSheetState();
}

class _NegotiationSheetState extends State<NegotiationSheet> {
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      child: Form(
        key: _form,
        child: Column(
          children: <Widget>[
            verticalMargin16,
            InfTextFormField(
              decoration: const InputDecoration(labelText: 'DELIVERABLE DESCRIPTION'),
              initialValue: widget._proposalBuilder.deliverableDescription,
              onSaved: (s) => widget._proposalBuilder.deliverableDescription = s,
              maxLines: null,
              validator: validateDeliverableDescription,
              keyboardType: TextInputType.multiline,
            ),
            verticalMargin16,
            InfTextFormField.money(
              labelText: 'CASH REWARD VALUE',
              initialValue: widget._proposalBuilder.cashValue,
              onSaved: (m) => widget._proposalBuilder.cashValue = m,
            ),
            verticalMargin16,
            InfTextFormField(
              decoration: const InputDecoration(labelText: 'ITEMS OR SERVICE DESCRIPTION'),
              initialValue: widget._proposalBuilder.serviceDescription,
              onSaved: (s) => widget._proposalBuilder.serviceDescription = s,
              validator: validateServiceDescription,
              keyboardType: TextInputType.text,
            ),
            verticalMargin16,
            InfTextFormField.money(
              labelText: 'ITEMS OR SERVICE VALUE',
              initialValue: widget._proposalBuilder.serviceValue,
              onSaved: (m) => widget._proposalBuilder.serviceValue = m,
            ),
            InfBottomButton(
              color: Colors.white,
              text: widget.confirmButtonTitle,
              onPressed: onSave,
            ),
          ],
        ),
      ),
    );
  }

  String requireIfValueIsNotEmpty(
    String currentValue, {
    @required Money bindingValue,
    String errorMessage,
  }) {
    if (currentValue.isEmpty && bindingValue != null && bindingValue.toDouble() > 0) {
      return errorMessage;
    }

    return null;
  }

  String validateDeliverableDescription(String currentValue) {
    return requireIfValueIsNotEmpty(
      currentValue,
      bindingValue: widget._proposalBuilder.cashValue,
      errorMessage: "Please provide a deliverable description.",
    );
  }

  String validateServiceDescription(String currentValue) {
    return requireIfValueIsNotEmpty(
      currentValue,
      bindingValue: widget._proposalBuilder.serviceValue,
      errorMessage: "Please provide an items or service description.",
    );
  }

  void onSave() async {
    _form.currentState.save();

    if (!_form.currentState.validate()) {
      return;
    }

    Navigator.of(context).pop<Proposal>(widget._proposalBuilder.build());
  }
}
