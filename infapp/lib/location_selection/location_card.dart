import 'package:flutter/material.dart';

typedef void LocationSelectCallback(String searchQuery);

class LocationCard extends StatelessWidget {
  LocationCard({
    Key key,
    this.onCardTapped,
    this.locationName,
    this.addressName,
  }) : super(key: key);

  final LocationSelectCallback onCardTapped;
  final String locationName;
  final String addressName;

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new InkWell(
        onTap: () { 
          onCardTapped(this.locationName); 
          
          // TODO: save longitude and latitude

          // TODO: go back to map
        },
        child: new Column(
          children: <Widget> [
            new Container(
              padding: const EdgeInsets.all(8.0),
              child: new Text(this.locationName),
            ),
            new Container(
              padding: const EdgeInsets.all(8.0),
              child: new Text(this.addressName),
            ),
          ],
        ),
      ),
    );
  }
}
