import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/money.dart';
import 'package:inf/ui/widgets/animated_curves.dart';
import 'package:inf/ui/widgets/column_separator.dart';
import 'package:inf/ui/widgets/dialogs.dart';
import 'package:inf/ui/widgets/help_button.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_bottom_button.dart';
import 'package:inf/ui/widgets/inf_icon.dart';
import 'package:inf/ui/widgets/inf_location_field.dart';
import 'package:inf/ui/widgets/inf_page_scroll_view.dart';
import 'package:inf/ui/widgets/inf_text_form_field.dart';
import 'package:inf/ui/widgets/location_selector_page.dart';
import 'package:inf/ui/widgets/multipage_wizard.dart';
import 'package:inf_api_client/inf_api_client.dart';

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
        Align(
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
                  SizedBox(
                    height: 16.0,
                  ),
                  InfTextFormField(
                    decoration: InputDecoration(
                      labelText: 'CASH REWARD VALUE',
                      icon: Text('\$'),
                    ),
                    initialValue:
                        widget.offerBuilder.cashValue != null ? widget.offerBuilder.cashValue.toString(0) : '',
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    onSaved: (s) => widget.offerBuilder.cashValue = Money.tryParse(s),
//                    validator: (s) => s.isEmpty ? 'You have so provide value' : null,
                    keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                    onHelpPressed: () {},
                  ),
                  SizedBox(height: 32.0),
                  InfTextFormField(
                    decoration: InputDecoration(
                      labelText: 'REWARD ITEM OR SERVICE DESCRIPTION',
                    ),
                    initialValue: widget.offerBuilder.rewardDescription,
                    onSaved: (s) => widget.offerBuilder.rewardDescription = s,
//                    validator: (s) => s.isEmpty ? 'You have so provide value' : null,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(height: 32.0),
                  InfTextFormField(
                    decoration: InputDecoration(
                      labelText: 'ITEM OR SERVICE VALUE',
                      icon: Text('\$'),
                    ),
                    initialValue:
                        widget.offerBuilder.barterValue != null ? widget.offerBuilder.barterValue.toString(0) : '',
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    onSaved: (s) => widget.offerBuilder.barterValue = Money.tryParse(s),
//                    validator: (s) => s.isEmpty ? 'You have so provide value' : null,
                    keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                  ),
                  SizedBox(height: 16),
                  InfTextFormField(
                    decoration: InputDecoration(
                      labelText: 'MINIMUM FOLLOWERS',
                    ),
                    initialValue: widget.offerBuilder.minFollowers?.toString(),
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    onSaved: (s) => widget.offerBuilder.minFollowers = int.tryParse(s),
                    keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                    onHelpPressed: () {},
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CHOOSE LOCATION',
                        textAlign: TextAlign.left,
                        style: AppTheme.formFieldLabelStyle,
                      ),
                      HelpButton(
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
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

      if (widget.offerBuilder.cashValue != null) {
        if (widget.offerBuilder.barterValue != null) {
          widget.offerBuilder.rewardType = RewardDto_Type.barterAndCash;
        } else {
          widget.offerBuilder.rewardType = RewardDto_Type.cash;
        }
      } else if (widget.offerBuilder.barterValue != null){
        widget.offerBuilder.rewardType = RewardDto_Type.barter;
      }

      if (widget.offerBuilder.rewardType ==null)
      {
         if (!await showQueryDialog(context, 'No reward?', 'Are you sure that you don\'t want to set a reward?\n Even if you provide a reward item or service you have to enter a value for it.'))
         {
           return;
         }
      }

      if (widget.offerBuilder.rewardType == RewardDto_Type.barter && widget.offerBuilder.rewardDescription.isEmpty)
      {
        await showMessageDialog(context, 'We need a bit more...', 'Please provide a description of your reward item or service');
        return;
      }

      if (widget.offerBuilder.location == null)
      {
        await showMessageDialog(context, 'We need a bit more...', 'Please provide a location for the offer');
        return;
      }

      

      super.nextPage();
    } else {
      await showMessageDialog(context, 'We need a bit more...', 'Please fill out all fields');
    }
  }
}
