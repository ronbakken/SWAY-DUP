import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LookupCoordinatesWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LookupCoordinatesState();
}

class _LookupCoordinatesState extends State<LookupCoordinatesWidget> {
  Geolocator _geolocator = new Geolocator();
  TextEditingController _coordinatesTextController = new TextEditingController();
  String _placemark = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold();
  }
}
