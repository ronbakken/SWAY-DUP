import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

/// Location Selection Screen that will find 
/// the influencer profile's location.
class LocationInfluencerScreen extends StatefulWidget
{
  LocationInfluencerScreen({
    Key key,
  }) : super (key: key);

  VoidCallback onSearch;
  VoidCallback onConfirm;
  
  @override
  _LocationInfluencerState createState() => new _LocationInfluencerState();
}


class _LocationInfluencerState extends State<LocationInfluencerScreen>
{
  FloatingActionButton confirmButton;
  Marker marker;
  TextField search;
  TextEditingController _searchController;
  IconButton searchButton;
  MapController _mapController;
  FlutterMap map;

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold();
  }
}