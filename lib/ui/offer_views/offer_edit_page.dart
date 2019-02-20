import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/animated_curves.dart';
import 'package:inf/ui/widgets/category_selector_view.dart';
import 'package:inf/ui/widgets/column_separator.dart';
import 'package:inf/ui/widgets/deliverable_selector.dart';
import 'package:inf/ui/widgets/help_button.dart';
import 'package:inf/ui/widgets/image_selector.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_date_picker.dart';
import 'package:inf/ui/widgets/inf_page_scroll_view.dart';
import 'package:inf/ui/widgets/inf_radio_button.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/inf_text_form_field.dart';
import 'package:inf/ui/widgets/inf_time_picker.dart';
import 'package:inf/ui/widgets/location_selector_page.dart';
import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:inf/ui/widgets/social_platform_selector.dart';
import 'package:inf_api_client/inf_api_client.dart';

class OfferEditPage extends PageWidget {
  static Route<dynamic> route(BusinessOffer offer) {
    return FadePageRoute(
      builder: (BuildContext context) => OfferEditPage(offer: offer),
    );
  }

  OfferEditPage({Key key, this.offer}) : super(key: key);

  final BusinessOffer offer;

  @override
  OfferEditPageState createState() => OfferEditPageState();
}

class OfferEditPageState extends PageState<OfferEditPage> {
  final pageController = PageController();

  OfferBuilder offerBuilder;

  @override
  void initState() {
    super.initState();
    offerBuilder = OfferBuilder.fromOffer(widget.offer);
  }

  GlobalKey form = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Offer',
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: CustomAnimatedCurves(),
        ),
        InfPageScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ImageSelector(
                imageReferences: offerBuilder.images,
                imageAspecRatio: 4 / 3,
                onImageChanged: (images) => offerBuilder.images = images,
              ),
              Expanded(
                child: Form(
                  key: form,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
                        child: InfTextFormField(
                          initialValue: offerBuilder.title,
                          decoration: const InputDecoration(labelText: 'TITLE'),
                          onSaved: (s) => offerBuilder.title = s,
                          validator: (s) => s.isEmpty ? 'You have so provide a title' : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
                        child: InfTextFormField(
                          initialValue: offerBuilder.description,
                          decoration: const InputDecoration(
                            labelText: 'DESCRIPTION',
                          ),
                          onSaved: (s) => offerBuilder.description = s,
                          validator: (s) => s.isEmpty ? 'You have so provide a description' : null,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                      CategorySelectorView(
                        selectedCategories: offerBuilder.categories,
                        label: 'PLEASE SELECT CATEGORIES',
                        padding: const EdgeInsets.only(
                          top: 32.0,
                          bottom: 24.0,
                          left: 24,
                        ),
                      ),
                      SocialPlatformSelector(
                        label: 'SOCIAL PLATFORM',
                        channels: offerBuilder.channels,
                        padding: const EdgeInsets.only(
                          bottom: 16.0,
                          left: 24,
                        ),
                      ),
                      ColumnSeparator(),
                      Padding(
                        padding: const EdgeInsets.only(left: 24, bottom: 16),
                        child: DeliverySelector(
                          padding: const EdgeInsets.only(right: 24),
                          label: 'CONTENT TYPE',
                          deliverableTypes: offerBuilder.deliverableTypes,
                        ),
                      ),
                      ColumnSeparator(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InfTextFormField(
                              initialValue: offerBuilder.deliverableDescription,
                              decoration: const InputDecoration(labelText: 'DELIVERABLE DESCRIPTION'),
                              onSaved: (s) => offerBuilder.deliverableDescription = s,
                              validator: (s) => s.isEmpty ? 'You have so provide a description' : null,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                            ),
                            SizedBox(height: 32.0),
                            InfTextFormField(
                              decoration: InputDecoration(
                                labelText: 'CASH REWARD VALUE',
                                icon: Text('\$'),
                              ),
                              initialValue: offerBuilder.cashValue.toString(),
                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                              onSaved: (s) => offerBuilder.cashValue = Decimal.tryParse(s),
                              validator: (s) => s.isEmpty ? 'You have so provide value' : null,
                              keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                              onHelpPressed: () {},
                            ),
                            SizedBox(height: 32.0),
                            InfTextFormField(
                              decoration: InputDecoration(
                                labelText: 'REWARD ITEM OR SERVICE DESCRIPTION',
                              ),
                              initialValue: offerBuilder.rewardDescription.toString(),
                              onSaved: (s) => offerBuilder.rewardDescription = s,
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
                              initialValue: offerBuilder.barterValue.toString(),
                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                              onSaved: (s) => offerBuilder.barterValue = Decimal.tryParse(s),
                              validator: (s) => s.isEmpty ? 'You have so provide value' : null,
                              keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                            ),
                            SizedBox(height: 32.0),
                            InfTextFormField(
                              decoration: InputDecoration(
                                labelText: 'MINIMUM FOLLOWERS',
                              ),
                              initialValue: offerBuilder.minFollowers?.toString() ?? '',
                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                              onSaved: (s) => offerBuilder.minFollowers = int.tryParse(s),
                              keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                              onHelpPressed: () {},
                            ),
                            SizedBox(height: 32.0),
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
                                  Text(offerBuilder.location.name ?? ''),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Icon(Icons.search),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                Location location = await Navigator.of(context).push(LocationSelectorPage.route());
                                offerBuilder.location = location;
                              },
                            ),
                            ColumnSeparator(
                              horizontalMargin: 0,
                            ),
                            Table(
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 24, bottom: 16.0),
                                        child: InfDatePicker(
                                          decoration: InputDecoration(
                                            labelText: 'OFFER START DATE',
                                          ),
                                          initialValue: offerBuilder.startDate,
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now().add(Duration(days: 90)),
                                          validator: (date) => date == null ? 'You have to provide a date' : null,
                                          onSaved: (date) => offerBuilder.startDate,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 16.0),
                                        child: InfTimePicker(
                                          decoration: InputDecoration(
                                            labelText: 'OFFER START TIME',
                                          ),
                                          initialValue: offerBuilder.startTime,
                                          validator: (time) => time == null ? 'You have to provide a time' : null,
                                          onSaved: (time) => offerBuilder.startTime,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 24, bottom: 16.0),
                                        child: InfDatePicker(
                                          decoration: InputDecoration(
                                            labelText: 'OFFER END DATE',
                                          ),
                                          initialValue: offerBuilder.endDate,
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now().add(Duration(days: 90)),
                                          validator: (date) => date == null ? 'You have to provide a date' : null,
                                          onSaved: (date) => offerBuilder.endDate,
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 16.0),
                                        child: InfTimePicker(
                                          decoration: InputDecoration(
                                            labelText: 'OFFER END TIME',
                                          ),
                                          initialValue: offerBuilder.endTime,
                                          validator: (time) => time == null ? 'You have to provide a time' : null,
                                          onSaved: (time) => offerBuilder.endTime,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 32.0),
                            InfTextFormField(
                              decoration: const InputDecoration(labelText: 'AMOUNT AVAILABLE'),
                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                              onSaved: (s) => offerBuilder.numberOffered = int.tryParse(s),
                              validator: (s) => s.isEmpty ? 'You have so provide value' : null,
                              keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                              initialValue:
                                  offerBuilder.numberOffered != null ? offerBuilder.numberOffered.toString() : '',
                            ),
                            Row(
                              children: [
                                Align(
                                  widthFactor: 0.4,
                                  child: Checkbox(
                                    value: offerBuilder.unlimitedAvailable,
                                    onChanged: (val) => setState(() => offerBuilder.unlimitedAvailable = val),
                                    activeColor: AppTheme.lightBlue,
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Expanded(child: Text('There is no limit')),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'How do you like to deal with proposals?',
                              style: TextStyle(fontSize: 18.0, color: Colors.white),
                            ),
                            SizedBox(height: 16.0),
                            InfRadioButton<OfferDto_AcceptancePolicy>(
                              value: OfferDto_AcceptancePolicy.manualReview,
                              groupValue: offerBuilder.acceptancePolicy,
                              label: 'MANUALLY REVIEW PROPOSALS',
                              onChanged: (val) => setState(() => offerBuilder.acceptancePolicy = val),
                            ),
                            SizedBox(height: 8.0),
                            InfRadioButton<OfferDto_AcceptancePolicy>(
                              value: OfferDto_AcceptancePolicy.automaticAcceptMatching,
                              groupValue: offerBuilder.acceptancePolicy,
                              label: 'ACCEPT MATCHING PROPOSALS',
                              onChanged: (val) => setState(() => offerBuilder.acceptancePolicy = val),
                            ),
                            SizedBox(height: 8.0),
                            InfRadioButton<OfferDto_AcceptancePolicy>(
                              value: OfferDto_AcceptancePolicy.allowNegotiation,
                              groupValue: offerBuilder.acceptancePolicy,
                              label: 'ALLOW NEGOTIATION',
                              onChanged: (val) => setState(() => offerBuilder.acceptancePolicy = val),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
                child: InfStadiumButton(
                  height: 56,
                  color: Colors.white,
                  text: 'Udate Offer',
                  onPressed: () => _onUpdateOffer,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _onUpdateOffer() {}
}
