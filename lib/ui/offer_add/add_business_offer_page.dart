import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/offer_add/add_offer_step_1.dart';
import 'package:inf/ui/offer_add/add_offer_step_2.dart';
import 'package:inf/ui/offer_add/add_offer_step_3.dart';
import 'package:inf/ui/offer_add/add_offer_step_4.dart';
import 'package:inf/ui/widgets/multipage_wizard.dart';
import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:inf_api_client/inf_api_client.dart';

class AddBusinessOfferPage extends PageWidget {
  AddBusinessOfferPage({Key key, this.userType}) : super(key: key);

  static Route<dynamic> route(UserType userType) {
    return FadePageRoute(
      builder: (BuildContext context) => AddBusinessOfferPage(userType: userType),
    );
  }

  final UserType userType;

  @override
  _AddBusinessOfferPageState createState() => _AddBusinessOfferPageState();
}

class _AddBusinessOfferPageState extends PageState<AddBusinessOfferPage> {
  OfferBuilder _offerBuilder;

  @override
  void initState() {
    super.initState();
    _offerBuilder = backend.get<OfferManager>().createOfferBuilder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: AppTheme.darkGrey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppTheme.darkGrey,
        centerTitle: true,
        title: Text('MAKE AN OFFER'),
      ),
      body: MultiPageWizard(
        indicatorBackgroundColor: AppTheme.blue,
        indicatorColor: AppTheme.lightBlue,
        pageCount: 4,
        pageBuilder: (BuildContext context, Key key, int index) {
          switch(index) {
            case 0: return AddOfferStep1(key: key, offerBuilder: _offerBuilder);
            case 1: return AddOfferStep2(key: key, offerBuilder: _offerBuilder);
            case 2: return AddOfferStep3(key: key, offerBuilder: _offerBuilder);
            case 3: return AddOfferStep4(key: key, offerBuilder: _offerBuilder);
          }
          throw StateError('Invalid page index: $index');
        },
      ),
    );
  }
}
