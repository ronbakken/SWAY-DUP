import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
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
      builder: (BuildContext context) => AddBusinessOfferPage(userType: userType),
    );
  }

  final AccountType userType;

  @override
  _AddBusinessOfferPageState createState() => _AddBusinessOfferPageState();
}

class _AddBusinessOfferPageState extends PageState<AddBusinessOfferPage> {
  final _offer = ValueNotifier<BusinessOffer>(null);
  final _wizardKey = GlobalKey<MultiPageWizardState>();

  @override
  void initState() {
    super.initState();
    _offer.value = BusinessOffer(id: 0);
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
            offer: _offer,
          ),
          AddOfferStep2(
            offer: _offer,
          ),
          OfferPage(
            color: Colors.yellow,
            offer: _offer,
          ),
          OfferPage(
            color: Colors.cyan,
            offer: _offer,
          ),
          OfferPage(
            color: Colors.amber,
            offer: _offer,
          ),
        ],
      ),
    );
  }
}

class OfferPage extends StatelessWidget {
  const OfferPage({
    Key key,
    this.color,
    this.offer,
    this.next,
  }) : super(key: key);

  final Color color;
  final ValueNotifier<BusinessOffer> offer;
  final VoidCallback next;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: offer, 
      builder: (BuildContext context, Widget child) {
        return Container(
          color: Colors.blue,
          child: RaisedButton(
            onPressed: () {
              offer.value = offer.value.copyWith(
                id: offer.value.id + 1,
              );
              MultiPageWizard.of(context).nextPage();
            },
            child: Text('${offer.value.id}'),
          ),
        );
      },
    );
  }
}
