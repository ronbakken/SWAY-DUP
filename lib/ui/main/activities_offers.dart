
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/main/offer_list_tile.dart';
import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/offers/offer_details_page.dart';
import 'package:inf/ui/widgets/notification_marker.dart';
import 'package:inf_common/inf_common.dart';

class ActivitiesOffers extends StatefulWidget {
  final String name;
  final List<Int64> offers;
  final DataOffer Function(BuildContext cibtext, Int64 offerId) getOffer;
  final ConfigData config;

  final void Function(Int64 offerId) onOfferPressed;

  const ActivitiesOffers({
    @required this.name,
    Key key,
    @required this.offers,
    @required this.getOffer,
    @required this.config,
    @required this.onOfferPressed,
  }) : super(key: key);

  @override
  _ActivitiesOffersState createState() => _ActivitiesOffersState();
}

class _ActivitiesOffersState extends State<ActivitiesOffers> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _tileBuilder(BuildContext context, int index) {
    final Int64 offerId = widget.offers[index];
    final DataOffer offer = widget.getOffer(context, offerId);
    final String tag = '${widget.name}-${offer.offerId}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: OfferListTile(
        key: Key(tag),
        config: widget.config,
        backGroundColor: AppTheme.listViewItemBackground,
        offer: offer,
        onPressed: widget.onOfferPressed == null
            ? null
            : () {
                widget.onOfferPressed(offerId);
              },
        heroTag: tag,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.0, 8, 16.0, 0.0),
      itemCount: widget.offers.length,
      itemBuilder: _tileBuilder,
    );
  }
}
