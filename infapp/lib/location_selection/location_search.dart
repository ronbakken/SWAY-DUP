import 'package:flutter/material.dart';

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
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: searchField,
        actions: <Widget>[ cancelButton ],
      ),
    );
  }
}
