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
    @required String confirmButtonTitle,
    Proposal existingProposal,
  }) {
    return InfBottomSheet.route<Proposal>(
      title: 'Negotiate',
      child: NegotiationSheet(
        confirmButtonTitle: confirmButtonTitle,
        existingProposal: existingProposal,
      ),
    );
  }

  const NegotiationSheet({
    Key key,
    @required this.confirmButtonTitle,
    this.existingProposal,
  }) : super(key: key);

  final String confirmButtonTitle;
  final Proposal existingProposal;

  @override
  _NegotiationSheetState createState() => _NegotiationSheetState();
}

class _NegotiationSheetState extends State<NegotiationSheet> {
  final _form = GlobalKey<FormState>();

  ProposalBuilder _proposalBuilder;

  @override
  void initState() {
    super.initState();
    if (widget.existingProposal != null) {
      _proposalBuilder = ProposalBuilder.fromProposal(widget.existingProposal);
    } else {
      _proposalBuilder = ProposalBuilder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 16.0),
      child: Form(
        key: _form,
        child: Column(
          children: <Widget>[
            verticalMargin16,
            InfTextFormField(
              decoration: const InputDecoration(labelText: 'DELIVERABLE DESCRIPTION'),
              initialValue: _proposalBuilder.deliverableDescription,
              onSaved: (s) => _proposalBuilder.deliverableDescription = s,
              maxLines: null,
              validator: _validateDeliverableDescription,
              keyboardType: TextInputType.multiline,
            ),
            verticalMargin16,
            InfTextFormField.money(
              labelText: 'CASH REWARD VALUE',
              initialValue: _proposalBuilder.cashValue,
              onSaved: (m) => _proposalBuilder.cashValue = m,
            ),
            verticalMargin16,
            InfTextFormField(
              decoration: const InputDecoration(labelText: 'ITEMS OR SERVICE DESCRIPTION'),
              initialValue: _proposalBuilder.serviceDescription,
              onSaved: (s) => _proposalBuilder.serviceDescription = s,
              validator: _validateServiceDescription,
              keyboardType: TextInputType.text,
            ),
            verticalMargin16,
            InfTextFormField.money(
              labelText: 'ITEMS OR SERVICE VALUE',
              initialValue: _proposalBuilder.serviceValue,
              onSaved: (m) => _proposalBuilder.serviceValue = m,
            ),
            InfBottomButton(
              color: Colors.white,
              text: widget.confirmButtonTitle,
              onPressed: _onSave,
            ),
          ],
        ),
      ),
    );
  }

  String _validateDeliverableDescription(String currentValue) {
    return _requireIfValueIsNotEmpty(
      currentValue,
      bindingValue: _proposalBuilder.cashValue,
      errorMessage: 'Please provide a deliverable description.',
    );
  }

  String _validateServiceDescription(String currentValue) {
    return _requireIfValueIsNotEmpty(
      currentValue,
      bindingValue: _proposalBuilder.serviceValue,
      errorMessage: 'Please provide an items or service description.',
    );
  }

  String _requireIfValueIsNotEmpty(
    String currentValue, {
    @required Money bindingValue,
    String errorMessage,
  }) {
    if (currentValue.isEmpty && bindingValue != null && bindingValue.toDouble() > 0) {
      return errorMessage;
    }

    return null;
  }

  void _onSave() {
    _form.currentState.save();
    if (_form.currentState.validate()) {
      Navigator.of(context).pop<Proposal>(_proposalBuilder.build());
    }
  }
}
