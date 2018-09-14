import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:geolocator/geolocator.dart';

typedef void SearchCallback(String searchQuery);
typedef void ConfirmLocationCallback(String location);

/// Location Selection Screen that will save
/// the user profile's location. It is a stateful Widget
/// because we want to constantly display the pinpoint
/// location name from the map.
class LocationSelectionScreen extends StatefulWidget {
  LocationSelectionScreen({
    Key key,
    this.onSearchPressed,
    this.onConfirmPressed,
  }) : super(key: key);

  // Callback when the search button is pressed
  final SearchCallback onSearchPressed;

  // Callback when the user confirms the location
  final ConfirmLocationCallback onConfirmPressed;

  @override
  _LocationSelectionState createState() => new _LocationSelectionState();
}

class _LocationSelectionState extends State<LocationSelectionScreen> {
  // Confirm Button to save the pointer location
  FloatingActionButton confirmButton;

  // Pointer Marker to pin point the target location
  Center centeredMarker;

  // Search Bar to search the location
  AppBar searchBar;
  TextField searchField;
  TextEditingController _searchFieldController;

  // Search Button to find the desired location
  IconButton searchButton;

  // The map that will be displayed on the screen
  MapController _flutterMapController;
  FlutterMap flutterMap;
  Stack mapBody;

  // Geolocation for getting position name on map
  Geolocator _geolocator;

  // Current selected placemark
  Placemark _selectedPlacemark;

  @override
  void initState() {
    // Initialize the Parent
    super.initState();

    // Initialize Confirm Button
    confirmButton = new FloatingActionButton(
      onPressed: () {
        _updateSelectedPlacemark();
        _searchFieldController.text = _selectedPlacemark.thoroughfare;
        widget.onConfirmPressed(_selectedPlacemark.thoroughfare);
      },
      backgroundColor: Colors.green,
      child: new Icon(Icons.check),
    );

    // Initializer Marker
    centeredMarker = new Center(
      child: new Icon(Icons.location_on),
    );

    // Initialize Search Bar
    _searchFieldController = new TextEditingController();
    searchField = new TextField(
      controller: _searchFieldController,
      decoration: new InputDecoration(
        hintText: "Select a Location...",
      ),
    );

    // Initialize Search Button
    Icon searchIcon = new Icon(Icons.search);
    searchButton = new IconButton(
      icon: searchIcon,
      onPressed: () {
        widget.onSearchPressed(_searchFieldController.text);
      }
    );

    // Initialize Appbar
    searchBar = new AppBar(
      title: searchField,
      actions: <Widget>[searchButton],
    );

    // Initialize Map
    // TODO: Make marker stay on the center
    _flutterMapController = new MapController();
    flutterMap = new FlutterMap(
      options: new MapOptions(
        center: new LatLng(14.541530587952687, 121.01074919533015),
      ),
      mapController: _flutterMapController,
      layers: <LayerOptions>[
        new TileLayerOptions(
          backgroundColor: new Color.fromARGB(0xFF, 0x1C, 0x1C, 0x1C),
          placeholderImage: new MemoryImage(kTransparentImage),
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken':
                'pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqazRwN3h4ODBjM2QzcHA2N2ZzbHoyYm0ifQ.vpwrdXRoCU-nBm-E1KNKdA',
            'id': 'mapbox.dark',
          },
        ),
      ],
    );

    // Initialize Scaffold's Body
    mapBody = new Stack(
      children: <Widget>[
        flutterMap,
        centeredMarker,
      ],
    );

    // Initialize Geolocator
    _geolocator = new Geolocator();
  }

  // Updates the currently selected location
  Future _updateSelectedPlacemark() async
  {
    // Get the list of placemarks from the center
    List<Placemark> placemarks = 
      await _geolocator.placemarkFromCoordinates(_flutterMapController.center.latitude, _flutterMapController.center.longitude);

    // Update the selected placemark
    _selectedPlacemark = placemarks[0];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: searchBar,
      body: mapBody,
      floatingActionButton: confirmButton,
    );
  }
}
