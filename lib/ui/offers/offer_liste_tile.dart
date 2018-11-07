import 'package:flutter/material.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/offers/offer_details_page.dart';

class OfferListTile extends StatelessWidget {
  final BusinessOffer offer;
  OfferListTile({
    Key key,
    this.offer
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO
    return Container(
      color: Colors.blue,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      child: InkResponse(
              onTap: () => Navigator.of(context).push(OfferDetailsPage.route(offer)),
              child: Row(
          children: <Widget>[
            Image.network(
              offer.thumbnailUrl,
              width: 100.0,
            ),
            SizedBox(width: 10.0,),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(offer.title),
                SizedBox(height: 10.0),
                Text(offer.description),
              ],
            ))
          ],
        ),
      ),
    );
  }
}