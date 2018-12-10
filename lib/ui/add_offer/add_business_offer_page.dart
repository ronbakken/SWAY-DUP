import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/add_offer/add_offer_step_1.dart';
import 'package:inf/ui/add_offer/add_offer_step_2.dart';
import 'package:inf/ui/widgets/multipage_wizard.dart';
import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';

class AddBusinessOfferPage extends PageWidget {
  AddBusinessOfferPage({Key key, this.userType}) : super(key: key);

  static Route<dynamic> route(AccountType userType) {
    return FadePageRoute(
      builder: (BuildContext context) =>
          AddBusinessOfferPage(userType: userType),
    );
  }

  final AccountType userType;

  @override
  _AddBusinessOfferPageState createState() => _AddBusinessOfferPageState();
}

class _AddBusinessOfferPageState extends PageState<AddBusinessOfferPage> {
  OfferBuilder _offerBuilder;
  final _wizardKey = GlobalKey<MultiPageWizardState>();

  @override
  void initState() {
    super.initState();
    _offerBuilder = backend.get<OfferManager>().getOfferBuilder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkGrey,
      appBar: AppBar(
        backgroundColor: AppTheme.darkGrey,
        centerTitle: true,
        title: Text('MAKE AN OFFER'),
      ),
      body: MultiPageWizard(
        key: _wizardKey,
        pages: [
          AddOfferStep1(
            offerBuilder: _offerBuilder,
          ),
          AddOfferStep2(
            offerBuilder: _offerBuilder,
          ),
          OfferPage(),
          OfferPage(),
          OfferPage(),
        ],
      ),
    );
  }
}

class OfferPage extends StatelessWidget {
  const OfferPage({
    Key key,
    this.color,
    this.offerBuilder,
    this.next,
  }) : super(key: key);

  final Color color;
  final OfferBuilder offerBuilder;
  final VoidCallback next;

  @override
  Widget build(BuildContext context) {
        return Container(
          color: Colors.blue,
          child: RaisedButton(
            onPressed: () {
              MultiPageWizard.of(context).nextPage();
            },
          ),
        );
  }
}
