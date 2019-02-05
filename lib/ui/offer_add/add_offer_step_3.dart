import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/animated_curves.dart';
import 'package:inf/ui/widgets/help_button.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_input_decorator.dart';
import 'package:inf/ui/widgets/inf_page_scroll_view.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/inf_text_form_field.dart';
import 'package:inf/ui/widgets/location_selector_page.dart';

import 'package:inf/ui/widgets/multipage_wizard.dart';

class AddOfferStep3 extends StatefulWidget {
  const AddOfferStep3({
    Key key,
    this.offerBuilder,
  }) : super(key: key);

  final OfferBuilder offerBuilder;

  @override
  _AddOfferStep3State createState() {
    return new _AddOfferStep3State();
  }
}

class _AddOfferStep3State extends State<AddOfferStep3> {
  final _form = GlobalKey();

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
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    onSaved: (s) => widget.offerBuilder.cashValue = int.tryParse(s),
                    validator: (s) => s.isEmpty ? 'You have so provide value' : null,
                    keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                    onHelpPressed: () {},
                  ),
                  SizedBox(height: 32.0),
                  InfTextFormField(
                    decoration: InputDecoration(
                      labelText: 'REWARD ITEM OR SERVICE DESCRIPTION',
                    ),
                    onSaved: (s) => widget.offerBuilder.rewardDescription = s,
                    validator: (s) => s.isEmpty ? 'You have so provide value' : null,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(height: 32.0),
                  InfTextFormField(
                    decoration: InputDecoration(
                      labelText: 'ITEM OR SERVICE VALUE',
                      icon: Text('\$'),
                    ),
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    onSaved: (s) => widget.offerBuilder.barterValue = int.tryParse(s),
                    validator: (s) => s.isEmpty ? 'You have so provide value' : null,
                    keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                  ),
                  Spacer(),
                  InfTextFormField(
                    decoration: InputDecoration(
                      labelText: 'MINIMUM FOLLOWERS',
                    ),
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    onSaved: (s) => widget.offerBuilder.miniFollowers = int.tryParse(s),
                    keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                    onHelpPressed: () {},
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CHOOSE LOCATION',
                        textAlign: TextAlign.left,
                        style: AppTheme.formFieldLabelStyle,
                      ),
                      HelpButton(),
                    ],
                  ),
                  SizedBox(height: 16),
                  InkWell(
                    child: Row(
                      children: [
                        InfAssetImage(
                          AppIcons.location,
                          height: 24,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text('Location'),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 24, top: 8.0),
                              child: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      Location location = await Navigator.of(context).push(LocationSelectorPage.route());
                      widget.offerBuilder.location = location;
                    },
                  ),
                  _spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
                    child: InfStadiumButton(
                      height: 56,
                      color: Colors.white,
                      text: 'NEXT',
                      onPressed: () => onNext(context),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onNext(BuildContext context) {
    FormState state = _form.currentState;
    if (true /*state.validate()*/) {
      state.save();
      MultiPageWizard.of(context).nextPage();
    }
  }

  Container _spacer() {
    return Container(
      margin: const EdgeInsets.only(top: 16.0, bottom: 32),
      height: 1,
      color: AppTheme.white30,
    );
  }
}
