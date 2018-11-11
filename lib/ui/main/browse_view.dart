import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/offers/offer_details_page.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
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
    return Material(
      color: AppTheme.grey,
      elevation: 2.0,
      borderRadius: BorderRadius.circular(5.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: InkResponse(
          onTap: () => Navigator.of(context).push(OfferDetailsPage.route(offer)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: InfImage(
                        lowRes: offer.thumbnailLowRes,
                        imageUrl: offer.thumbnailUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(offer.title, textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
                        SizedBox(width: 10.0),
                        InfAssetImage(AppLogo.getDeliverableChannel(offer.deliverables[0].channel,), width: 20.0,)
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Text(offer.description, style: TextStyle(color: AppTheme.white30)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
