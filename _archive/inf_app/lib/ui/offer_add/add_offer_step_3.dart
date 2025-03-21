import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/money.dart';
import 'package:inf/ui/widgets/animated_curves.dart';
import 'package:inf/ui/widgets/dialogs.dart';
import 'package:inf/ui/widgets/help_button.dart';
import 'package:inf/ui/widgets/inf_bottom_button.dart';
import 'package:inf/ui/widgets/inf_location_field.dart';
import 'package:inf/ui/widgets/inf_page_scroll_view.dart';
import 'package:inf/ui/widgets/inf_text_form_field.dart';
import 'package:inf/ui/widgets/multipage_wizard.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class AddOfferStep3 extends MultiPageWizardPageWidget {
  const AddOfferStep3({
    Key key,
    this.offerBuilder,
  }) : super(key: key);

  final OfferBuilder offerBuilder;

  @override
  _AddOfferStep3State createState() => _AddOfferStep3State();
}

class _AddOfferStep3State extends MultiPageWizardPageState<AddOfferStep3> {
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const Align(
          alignment: Alignment.bottomCenter,
          child: CustomAnimatedCurves(),
        ),
        InfPageScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  verticalMargin16,
                  InfTextFormField(
                    decoration: const InputDecoration(
                      labelText: 'CASH REWARD VALUE',
                      icon: Text('\$'),
                    ),
                    initialValue:
                        widget.offerBuilder.cashValue != null ? widget.offerBuilder.cashValue.toString(0) : '',
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    onSaved: (s) => widget.offerBuilder.cashValue = Money.tryParse(s),
//                    validator: (s) => s.isEmpty ? 'You have so provide value' : null,
                    keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                    onHelpPressed: () {},
                  ),
                  verticalMargin32,
                  InfTextFormField(
                    decoration: const InputDecoration(
                      labelText: 'REWARD ITEM OR SERVICE DESCRIPTION',
                    ),
                    initialValue: widget.offerBuilder.serviceDescription,
                    onSaved: (s) => widget.offerBuilder.serviceDescription = s,
//                    validator: (s) => s.isEmpty ? 'You have so provide value' : null,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                  verticalMargin32,
                  InfTextFormField(
                    decoration: const InputDecoration(
                      labelText: 'ITEM OR SERVICE VALUE',
                      icon: Text('\$'),
                    ),
                    initialValue:
                        widget.offerBuilder.serviceValue != null ? widget.offerBuilder.serviceValue.toString(0) : '',
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    onSaved: (s) => widget.offerBuilder.serviceValue = Money.tryParse(s),
//                    validator: (s) => s.isEmpty ? 'You have so provide value' : null,
                    keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                  ),
                  verticalMargin16,
                  InfTextFormField(
                    decoration: const InputDecoration(
                      labelText: 'MINIMUM FOLLOWERS',
                    ),
                    initialValue: widget.offerBuilder.minFollowers?.toString(),
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    onSaved: (s) => widget.offerBuilder.minFollowers = int.tryParse(s),
                    keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                    onHelpPressed: () {},
                  ),
                  verticalMargin16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'CHOOSE LOCATION',
                        textAlign: TextAlign.left,
                        style: AppTheme.formFieldLabelStyle,
                      ),
                      HelpButton(
                        onTap: () {},
                      ),
                    ],
                  ),
                  verticalMargin16,
                  InfLocationField(
                    location: widget.offerBuilder.location,
                    onChanged: (location) => setState(() => widget.offerBuilder.location = location),
                  ),
                ],
              ),
            ),
          ), // InfBottomButton
          bottom: InfBottomButton(
            color: Colors.white,
            text: 'NEXT',
            onPressed: nextPage,
          ),
        ),
      ],
    );
  }

  @override
  void onPrevPage() {
    print('onPrevPage 3');
    _form.currentState.save();
  }

  @override
  void nextPage() async {
    if (_form.currentState.validate()) {
      _form.currentState.save();

      if (widget.offerBuilder.cashValue == null && widget.offerBuilder.serviceValue == null) {
        final response = await showQueryDialog(
          context,
          'No reward?',
          'Are you sure that you don\'t want to set a reward?\n'
              'Even if you provide a reward item or service you have to enter a value for it.',
        );
        if (response == false) {
          return;
        }
      }

      if (widget.offerBuilder.serviceValue == null && widget.offerBuilder.serviceDescription.isEmpty) {
        showMessageDialog(
          context,
          'We need a bit more...',
          'Please provide a description of your reward item or service',
        );
        return;
      }

      if (widget.offerBuilder.location == null) {
        showMessageDialog(
          context,
          'We need a bit more...',
          'Please provide a location for the offer',
        );
        return;
      }

      super.nextPage();
    } else {
      showMessageDialog(
        context,
        'We need a bit more...',
        'Please fill out all fields',
      );
    }
  }
}
