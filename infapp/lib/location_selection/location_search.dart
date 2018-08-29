import 'package:flutter/material.dart';

import 'location_card.dart';

class LocationSearchScreen extends StatefulWidget {
  LocationSearchScreen({
    Key key,
    this.searchQuery,
  }) : super(key: key);

  final String searchQuery;

  @override
  _LocationSearchPageState createState() => new _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchScreen> {

   // Search Field 
  TextField searchField;
  TextEditingController _searchFieldController;

  // Cancel Button 
  IconButton cancelButton;

  // function called when the cancel button is pressed
  void _resetSearchField()
  {
    setState(() {
       _searchFieldController.text = "";
      }

      // TODO: clear search cards
    );
  }

  // Function called when a location card is tapped
  void _selectLocation(String item) 
  {
    setState(() {
       _searchFieldController.text = item;
      }
    );
  }

  @override
  void initState() {
    // Initialize the Parent
    super.initState();

    // Initialize Search Field
    _searchFieldController = new TextEditingController(text: widget.searchQuery);
    searchField = new TextField(
      controller: _searchFieldController,
    );

    // Initialize Cancel Button
    Icon cancelIcon = new Icon(Icons.cancel);
    cancelButton = new IconButton(
      icon: cancelIcon,
      onPressed: _resetSearchField,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: searchField,
        actions: <Widget>[ cancelButton ],
      ),
      body: new ListView.builder(
        itemCount: 10,
        itemBuilder: (context,  index) {
          return new LocationCard(
            onCardTapped: _selectLocation,
            locationName: "Location $index",
            addressName: "Adress $index"

          );
        },
      ),

    );
  }
}
