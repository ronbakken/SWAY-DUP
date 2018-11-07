import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/offers/offer_liste_tile.dart';

class BrowseView extends StatefulWidget {
  @override
  _BrowseViewState createState() => _BrowseViewState();
}

class _BrowseViewState extends State<BrowseView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BusinessOffer>>(
        stream: backend.get<NetWorkService>().getBusinessOffers(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.active) {
            // TODO
            return Center(child: Text('Here has to be an waiting spinner'));
          }
          if (!snapShot.hasData) {
            // TODO
            return Center(child: Text('Here has to be an Error message'));
          }

          final offers = snapShot.data;
          return ListView.builder(
            itemCount: offers.length,
            itemBuilder: (context, index) => OfferListTile(offer:  offers[index]),
          );
        });
  }

}


