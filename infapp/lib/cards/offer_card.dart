/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';
import '../network/inf.pb.dart';

class OfferCard extends StatelessWidget {
  final DataBusinessOffer businessOffer;
  final Function() onPressed;

  OfferCard({
    Key key,
    this.businessOffer,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Card(
      //child: new InkWell(
      // onTap: () => print("tapped"),
      child: new ListTile(
        isThreeLine: true,
        leading: new CircleAvatar(
          backgroundImage: businessOffer.thumbnailUrl.length > 0
              ? new NetworkImage(businessOffer.thumbnailUrl)
              : null,
          /* child: new Text('$index'), */
          backgroundColor: Colors
              .primaries[businessOffer.title.hashCode % Colors.primaries.length]
              .shade300,
        ),
        title: new Text(businessOffer.title),
        subtitle: new Text(businessOffer.description),
        onTap: onPressed,
      ),
      //),
    );
  }
}

/* end of file */
