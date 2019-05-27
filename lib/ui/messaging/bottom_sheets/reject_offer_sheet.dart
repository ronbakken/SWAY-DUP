import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_bottom_button.dart';
import 'package:inf/ui/widgets/inf_bottom_sheet.dart';
import 'package:inf/ui/widgets/inf_text_form_field.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class RejectOfferSheet extends StatefulWidget {
  static Route<String> route({User user}) {
    return InfBottomSheet.route<String>(
      title: 'Negotiate',
      child: RejectOfferSheet(
        user: user,
      ),
    );
  }

  RejectOfferSheet({
    Key key,
    this.user,
  }) : super(key: key);

  final User user;

  @override
  _RejectOfferSheetState createState() => _RejectOfferSheetState();
}

class _RejectOfferSheetState extends State<RejectOfferSheet> {
  final _form = GlobalKey<FormState>();

  String _reason;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 16.0),
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Let ${widget.user} know the reason for the rejection.'),
            verticalMargin16,
            InfTextFormField(
              onSaved: (value) => _reason = value,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            InfBottomButton(
              color: AppTheme.red,
              text: 'REJECT',
              onPressed: _onConfirm,
            ),
          ],
        ),
      ),
    );
  }

  void _onConfirm() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      Navigator.of(context).pop<String>(_reason);
    }
  }
}
