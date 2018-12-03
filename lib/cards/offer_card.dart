/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';
import 'package:inf_common/inf_common.dart';

class OfferCard extends StatelessWidget {
  final DataOffer businessOffer;
  final bool inner;
  final Function() onPressed;

  OfferCard({
    Key key,
    this.businessOffer,
    this.onPressed,
    this.inner = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = new ListTile(
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
    );
    return inner
        ? child
        : new Card(
            //child: new InkWell(
            // onTap: () => print("tapped"),
            child: child,
            //),
          );
  }
}

/* end of file */
