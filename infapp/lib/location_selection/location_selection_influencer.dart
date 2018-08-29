import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

/// Location Selection Screen that will find 
/// the influencer profile's location.
class LocationInfluencerScreen extends StatefulWidget
{
  LocationInfluencerScreen({
    Key key,
    this.onSearch,
    this.onConfirm,
  }) : super (key: key);

  // function called when the search button is pressed
  final VoidCallback onSearch;

  // function called when the confirm button is pressed
  final VoidCallback onConfirm;

  @override
  _LocationInfluencerState createState() => new _LocationInfluencerState();
}


class _LocationInfluencerState extends State<LocationInfluencerScreen>
{
  // saves the target area
  FloatingActionButton confirmButton;

  // transparent circle that selects area of location
  Marker marker;

  // used when searching something on map
  TextField search;

  // controller for search app bar
  TextEditingController _searchController;

  // search button
  IconButton searchButton;

  // used to control the map state
  MapController _mapController;

  // map to be displayed
  FlutterMap map;

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold();
  }
}