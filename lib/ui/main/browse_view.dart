import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';

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
            itemBuilder: (context, index) => buildOfferCard(context, offers[index]),
          );
        });
  }

  Widget buildOfferCard(BuildContext context, BusinessOffer offer) {
    return Container(
      color: Colors.blue,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
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
    );
  }
}
