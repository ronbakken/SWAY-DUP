import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/proposal.dart';
import 'package:inf/ui/widgets/inf_bottom_button.dart';
import 'package:inf/ui/widgets/inf_bottom_sheet.dart';
import 'package:inf/ui/widgets/inf_text_form_field.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class RejectOfferSheet extends StatelessWidget {
  static Route<ProposalResponse> route({
    String otherParty,
  }) {
    return InfBottomSheet.route<ProposalResponse>(
      title: 'Negotiate',
      child: RejectOfferSheet(
        otherParty: otherParty,
      ),
    );
  }

  RejectOfferSheet({
    Key key,
    this.otherParty,
  }) : super(key: key);

  final String otherParty;

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Let ${otherParty ?? "them"} know the reason for the rejection."),
            verticalMargin16,
            InfTextFormField(
              onSaved: (s) => Navigator.of(context).pop<ProposalResponse>(ProposalResponse.reject(message: s)),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            InfBottomButton(
              color: AppTheme.red,
              text: "REJECT",
              onPressed: onConfirm,
            ),
          ],
        ),
      ),
    );
  }

  void onConfirm() async {
    if (!_form.currentState.validate()) return;

    _form.currentState.save();
  }
}
