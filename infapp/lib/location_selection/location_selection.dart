import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

typedef void SearchCallback(String searchQuery);
typedef void ConfirmLocationCallback(LatLng locationCoordinates);

/// Location Selection Screen that will save 
/// the user profile's location. It is a stateful Widget
/// because we want to constantly display the pinpoint
/// location name from the map.
class LocationSelectionScreen extends StatefulWidget
{
  LocationSelectionScreen({
    Key key,
    this.onSearchPressed,
    this.onConfirmPressed,
  }) : super (key: key);

  // Callback when the search button is pressed
  final SearchCallback onSearchPressed;

  // Callback when the user confirms the location
  final ConfirmLocationCallback onConfirmPressed;

  @override
  _LocationSelectionState createState() => new _LocationSelectionState();
}


class _LocationSelectionState extends State<LocationSelectionScreen>
{
  // Confirm Button to save the pointer location
  FloatingActionButton confirmButton;

  // Pointer Marker to pin point the target location

  // Search Bar to search the location
  TextField searchField;
  TextEditingController _searchFieldController;

  // Search Button to find the desired location
  IconButton searchButton;

  // The map that will be displayed on the screen
  FlutterMap flutterMap;

  @override
  void initState() {
    // Initialize the Parent
    super.initState();

    // Initialize Confirm Button
    confirmButton = new FloatingActionButton(
      onPressed: () {
        widget.onConfirmPressed(flutterMap.options.center);
      },
      backgroundColor: Colors.green,
      child: new Icon(Icons.check),
    );

    // Initializer Marker
    
    // Initialize Search Bar
    _searchFieldController = new TextEditingController();
    searchField = new TextField(
      controller: _searchFieldController,
    );

    // Initialize Search Button
    Icon searchIcon = new Icon(Icons.search);
    searchButton = new IconButton(
      icon: searchIcon,
      onPressed: () {
        widget.onSearchPressed(_searchFieldController.text);
      }
    );

    // Initialize Map
    flutterMap = new FlutterMap(
      options: new MapOptions(
        center: new LatLng(0.0, 0.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      appBar: _buildSearchBar(),
      floatingActionButton: confirmButton,
    );
  }
  
  // Appbar that will be a search bar
  AppBar _buildSearchBar() 
  {
    return new AppBar(
      title: searchField,
      actions: <Widget>[ searchButton ],
    );
  }
}