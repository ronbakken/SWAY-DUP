import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf/ui/offers/offer_post_tile.dart';
import 'package:inf_common/inf_common.dart';

class BrowseListView extends StatelessWidget {
  final ConfigData config;
  final List<Int64> offers;
  final DataOffer Function(BuildContext context, Int64 offerId) getOffer;
  final void Function(Int64 offerId) onOfferPressed;

  const BrowseListView({
    Key key,
    @required this.config,
    @required this.offers,
    @required this.getOffer,
    @required this.onOfferPressed,
  }) : super(key: key);

  Widget _buildOfferTile(BuildContext context, int index) {
    final Int64 offerId = offers[index];
    final DataOffer offer = getOffer(context, offerId);
    final String tag = 'browse-offer-list-$offerId';
    return Padding(
      key: Key(tag),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: OfferPostTile(
        config: config,
        offer: offer,
        onPressed: () {
          onOfferPressed(offerId);
        },
        heroTag: tag,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return Stack(
      children: <Widget>[
        ListView.builder(
          padding: EdgeInsets.fromLTRB(
              16.0, mediaQuery.padding.top + 54.0, 16.0, 8.0),
          itemCount: offers.length,
          itemBuilder: _buildOfferTile,
        ),
        SafeArea(
          child: Container(
            height: 48.0,
            alignment: Alignment.center,
            child: Text('${offers.length} OFFERS NEAR YOU'),
          ),
        ),
      ],
    );
  }
}
