import 'package:flutter/material.dart';

typedef void LocationSelectCallback(String searchQuery);

class LocationCard extends StatelessWidget {
  LocationCard({
    Key key,
    this.onCardTapped,
  }) : super(key: key);

  final LocationSelectCallback onCardTapped;

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new InkWell(
        onTap: () { 
          onCardTapped("data"); 
          
          // TODO: save longitude and latitude

          // TODO: go back to map
        },
        child: new Text("data"),
      ),
    );
  }
}
