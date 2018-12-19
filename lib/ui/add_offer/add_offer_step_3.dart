import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/help_button.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
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
  ValueNotifier<Category> activeTopLevelCategory =
      ValueNotifier<Category>(null);

  GlobalKey form = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: constraints.copyWith(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
                maxHeight: double.infinity,
              ),
              child: IntrinsicHeight(
                child: Stack(
                    fit: StackFit.passthrough,
                    alignment: Alignment.bottomCenter,
                    children: [
                      InfAssetImage(
                        AppImages.mockCurves, // FIXME:
                        alignment: Alignment.bottomCenter,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 24, right: 24, top: 32),
                        child: Form(
                          key: form,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 16.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'CASH REWARD VALUE',
                                    textAlign: TextAlign.left,
                                    style: AppTheme.textStyleformfieldLabel,
                                  ),
                                  HelpButton(),
                                ],
                              ),
                              TextFormField(
                                decoration: InputDecoration(icon: Text('\$')),
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                onSaved: (s) => widget
                                    .offerBuilder.cashValue = int.tryParse(s),
                                validator: (s) => s.isEmpty
                                    ? 'You have so provide value'
                                    : null,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: false, signed: false),
                              ),
                              SizedBox(height: 32.0),
                              Text(
                                'REWARD ITEM OR SERVICE DESCRIPTION',
                                textAlign: TextAlign.left,
                                style: AppTheme.textStyleformfieldLabel,
                              ),
                              TextFormField(
                                decoration: InputDecoration(prefixText: '\$ '),
                                onSaved: (s) => widget
                                    .offerBuilder.rewardDescription = s,
                                validator: (s) => s.isEmpty
                                    ? 'You have so provide value'
                                    : null,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                              ),
                              SizedBox(height: 32.0),
                              Text(
                                'ITEM OR SERVICE VALUE',
                                textAlign: TextAlign.left,
                                style: AppTheme.textStyleformfieldLabel,
                              ),
                              TextFormField(
                                decoration: InputDecoration(icon: Text('\$')),
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                onSaved: (s) => widget
                                    .offerBuilder.barterValue = int.tryParse(s),
                                validator: (s) => s.isEmpty
                                    ? 'You have so provide value'
                                    : null,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: false, signed: false),
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'MINIMUM FOLLOWERS',
                                    textAlign: TextAlign.left,
                                    style: AppTheme.textStyleformfieldLabel,
                                  ),
                                  HelpButton(),
                                ],
                              ),
                              TextFormField(
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                onSaved: (s) => widget
                                    .offerBuilder.miniFollowers = int.tryParse(s),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: false, signed: false),
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'CHOOSE LOCATION',
                                    textAlign: TextAlign.left,
                                    style: AppTheme.textStyleformfieldLabel,
                                  ),
                                  HelpButton(),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              InkWell(
                                child: Row(
                                  children: [
                                    InfAssetImage(
                                      AppIcons.location,
                                      height: 32,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text('Location'),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 24, top: 8.0),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0, vertical: 32.0),
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
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }

  void onNext(BuildContext context) {
    FormState state = form.currentState;
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
