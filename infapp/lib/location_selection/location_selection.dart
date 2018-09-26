import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:geolocator/geolocator.dart';
import 'experiment_files/lookup_address.dart';
import 'experiment_files/reverse_geocoding.dart';
import 'dart:async';

typedef Future<String> SearchCallback(String searchQuery);
typedef void ConfirmLocationCallback(String location);

/// Location Selection Screen that will save
/// the user profile's location. It is a stateful Widget
/// because we want to constantly display the pinpoint
/// location name from the map.
class LocationSelectionScreen extends StatefulWidget {
  LocationSelectionScreen({
    Key key,
    this.onSearch,
    this.onConfirmPressed,
  }) : super(key: key);

  // Callback when the user is typing in the search bar
  final SearchCallback onSearch;

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

  // The map that will be displayed on the screen
  MapController _flutterMapController;
  FlutterMap flutterMap;
  Stack mapBody;

  // Geolocation for getting position name on map
  Geolocator _geolocator;
  Position _initialLocation;

  // Current selected placemark
  String _placeMarkAddress;

  // Navigate to search page when user types
  void _onQueryChanged(String query) async {
    // Get result from search page
    // returns blank string if user presses back button on the search page
    // returns the place name if user selectsa search item
    _searchFieldController.text = await widget.onSearch(query);

    // If user picks a location, center that location
    if (_searchFieldController.text != '') {
      // Get the coordinates
      LatLng coordinates = await getCoordinates(_searchFieldController.text);

      // then move to that location
      _flutterMapController.move(coordinates, 15.0);
    }
  }

  // Updates center whenever mapos dragged
  void _onMapDragged(MapPosition position) async {
    _searchFieldController.text = await coordinatesToAddress(
        position.center.latitude, position.center.longitude);
  }

  // get current location
  void _getInitialPosition() async {
    _initialLocation = await _geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    // Initialize the Parent
    super.initState();

    // Initialize Confirm Button
    confirmButton = new FloatingActionButton(
      onPressed: () {
        widget.onConfirmPressed(_placeMarkAddress);
        print(_flutterMapController.zoom);
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
      onChanged: (query) {
        _onQueryChanged(query);
      },
    );

    // Initialize Appbar
    searchBar = new AppBar(
      title: searchField,
    );

    // Initialize Geolocator
    _geolocator = new Geolocator();
    _getInitialPosition();

    // Initialize Map
    _flutterMapController = new MapController();
    flutterMap = new FlutterMap(
      options: new MapOptions(
          center: new LatLng(14.541530587952687, 121.01074919533015),
          onPositionChanged: _onMapDragged), // TODO: Fix (Call only when user stops dragging)
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
