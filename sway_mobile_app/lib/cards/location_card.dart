/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Kenneth Amiel Santos <kennethamiel.santos@gmail.com>
*/

import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    Key key,
    this.onCardTapped,
    this.locationName,
    this.addressName,
  }) : super(key: key);

  final Function(String searchQuery) onCardTapped;
  final String locationName;
  final String addressName;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          onCardTapped(locationName);

          // TODO: save longitude and latitude

          // TODO: go back to map
        },
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(locationName),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(addressName),
            ),
          ],
        ),
      ),
    );
  }
}

/* end of file */
