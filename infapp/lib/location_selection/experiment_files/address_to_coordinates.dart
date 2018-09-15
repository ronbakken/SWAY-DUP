import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class AddressToCoordinates extends StatefulWidget {
  @override
  _AddressToCoordinatesState createState() => _AddressToCoordinatesState();
}

class _AddressToCoordinatesState extends State<AddressToCoordinates> {
  Geolocator _geolocator = new Geolocator();
  TextEditingController _addressTextController = new TextEditingController();

   LatLng coords = new LatLng(0.00, 0.00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}
