/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:flutter/material.dart';

import 'network/inf.pb.dart';

// TODO: This will have the infinite scroll mechanism

class BusinessOfferList extends StatelessWidget {
  final List<DataBusinessOffer> businessOffers;

  const BusinessOfferList({Key key, this.businessOffers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      // key: _refreshIndicatorKey,
      onRefresh: () async { return await new Future.delayed(new Duration(seconds: 2)); },
      child: businessOffers == null ? new Text("Please wait...") : 
        businessOffers.length == 0 ? new Text("No offers") : ListView.builder(
        padding: kMaterialListPadding,
        itemCount: businessOffers.length,
        itemBuilder: (BuildContext context, int index) {
          DataBusinessOffer data = businessOffers[index];
          return new ListTile(
            isThreeLine: true,
            leading: new CircleAvatar(
              backgroundImage: data.avatarUrl.length > 0 ? new NetworkImage(data.avatarUrl) : null,
              /* child: new Text('$index'), */
              backgroundColor: Colors.primaries[data.title.hashCode % Colors.primaries.length].shade300,
            ),
            title: new Text(data.title),
            subtitle: const Text('Even more additional list item information appears on line three.'),
            onTap: () { },
          );
        },
      ),
    );
  }
}

/* end of file */
