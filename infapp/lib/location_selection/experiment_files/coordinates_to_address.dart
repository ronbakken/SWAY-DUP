import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CoordinatesToAddress extends StatefulWidget {
  @override
  _CoordinatesToAddressState createState() => _CoordinatesToAddressState();
}

class _CoordinatesToAddressState extends State<CoordinatesToAddress> {
  Geolocator _geolocator = new Geolocator();
  TextEditingController _coordinatesTextController = new TextEditingController();
  String _placemark = "";

  void _onLookupAddressPressed() async {
    List<String> coords = _coordinatesTextController.text.split(',');
    double latitude = double.parse(coords[0]);
    double longitude = double.parse(coords[1]);

    List<Placemark> placemarks =
        await _geolocator.placemarkFromCoordinates(latitude, longitude);

    if (placemarks != null && placemarks.length >= 1) {
      Placemark position = placemarks[0];
      setState(() {
        _placemark = position.thoroughfare + ", " + position.locality;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new TextField(
          decoration: new InputDecoration(hintText: "latitude,longitude"),
          controller: _coordinatesTextController,
        ),
        new RaisedButton(
          child: new Text('Look up...'),
          onPressed: () {
            _onLookupAddressPressed();
          },
        ),
        new Text(_placemark),
      ],
    );
  }
}
