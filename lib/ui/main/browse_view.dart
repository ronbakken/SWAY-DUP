import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/offers/offer_details_page.dart';
import 'package:inf/ui/widgets/inf_image.dart';

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
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          itemCount: offers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: _OfferListTile(
                offer: offers[index],
              ),
            );
          },
        );
      },
    );
  }
}

class _OfferListTile extends StatelessWidget {
  final BusinessOffer offer;

  _OfferListTile({
    Key key,
    this.offer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: InkResponse(
        onTap: () => Navigator.of(context).push(OfferDetailsPage.route(offer)),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: InfImage(
                lowRes: offer.thumbnailLowRes,
                imageUrl: offer.thumbnailUrl,
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(offer.title),
                  SizedBox(height: 10.0),
                  Text(offer.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
