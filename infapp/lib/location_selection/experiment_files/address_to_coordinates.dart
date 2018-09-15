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

  void _onLookupCoordinatesPressed() async {
    List<Placemark> placemarks =
        await _geolocator.placemarkFromAddress(_addressTextController.text);

    if (placemarks != null && placemarks.length >= 1) {
      Placemark pos = placemarks[0];
      setState(() {
        coords.latitude = pos.position.latitude;
        coords.longitude = pos.position.longitude;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}
