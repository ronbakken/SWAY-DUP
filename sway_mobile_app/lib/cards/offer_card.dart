/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';
import 'package:sway_common/inf_common.dart';

class OfferCard extends StatelessWidget {
  final DataOffer businessOffer;
  final bool inner;
  final Function() onPressed;

  const OfferCard({
    Key key,
    this.businessOffer,
    this.onPressed,
    this.inner = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget child = ListTile(
      isThreeLine: true,
      leading: CircleAvatar(
        backgroundImage: businessOffer.thumbnailUrl.isNotEmpty
            ? NetworkImage(businessOffer.thumbnailUrl)
            : null,
        /* child: new Text('$index'), */
        backgroundColor: Colors
            .primaries[businessOffer.title.hashCode % Colors.primaries.length]
            .shade300,
      ),
      title: Text(businessOffer.title),
      subtitle: Text(businessOffer.description),
      onTap: onPressed,
    );
    return inner
        ? child
        : Card(
            //child: new InkWell(
            // onTap: () => print("tapped"),
            child: child,
            //),
          );
  }
}

/* end of file */
