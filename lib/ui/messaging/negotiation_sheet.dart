import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  const NegotiationSheet({
    Key key,
    this.existingProposal,
    @required this.confirmButtonTitle,
  }) : super(key: key);

  final Proposal existingProposal;
  final String confirmButtonTitle;

  @override
  _NegotiationSheetState createState() => _NegotiationSheetState();
}

class _NegotiationSheetState extends State<NegotiationSheet> {
  Proposal newProposal;

  @override
  void initState() {
    super.initState();
    newProposal = widget.existingProposal /* ?? Proposal()*/; // FIXME: How to construct.
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      child: Column(
        children: <Widget>[
          verticalMargin16,
          InfTextFormField(
            decoration: const InputDecoration(labelText: 'DELIVERABLE DESCRIPTION'),
            initialValue:
                'Lorem excepteur laborum aute incididunt quis sit. Sunt laboris est qui sunt eiusmod ipsum labore exercitation incididunt dolore officia.',
            onSaved: (val) => newProposal, // FIXME: How to mutate / generate new one.
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
          verticalMargin16,
          InfTextFormField(
            decoration: const InputDecoration(
              labelText: 'CASH REWARD VALUE',
              // FIXME: Should change to
              //   icon: Text('\$'),
              // for consistency?
              icon: Text('\$'),
            ),
            initialValue: '1000',
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            onSaved: (val) => newProposal, // FIXME: How to mutate / generate new one.
            keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
          ),
          verticalMargin16,
          InfTextFormField(
            decoration: const InputDecoration(labelText: 'ITEMS OR SERVICE DESCRIPTION'),
            initialValue: 'Ea esse ea consectetur Lorem ea dolor elit eu.',
            onSaved: (val) => newProposal, // FIXME: How to mutate / generate new one.
            keyboardType: TextInputType.text,
          ),
          verticalMargin16,
          InfTextFormField(
            decoration: const InputDecoration(
              labelText: 'ITEMS OR SERVICE VALUE',
              // FIXME: Should change to
              //   icon: Text('\$'),
              // for consistency?
              prefix: Text('\$', style: TextStyle(color: Colors.white)),
            ),
            initialValue: '100',
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            onSaved: (val) => newProposal, // FIXME: How to mutate / generate new one.
            keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
          ),
          InfBottomButton(
            color: Colors.white,
            text: widget.confirmButtonTitle,
            onPressed: () => Navigator.of(context).pop<Proposal>(newProposal),
          ),
        ],
      ),
    );
  }
}
