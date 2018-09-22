import 'dart:async';

import 'package:flutter/material.dart';
import 'reverse_geocoding.dart';

class GeocodingTestPage extends StatefulWidget {
  GeocodingTestPage({
    Key key,
  }) : super(key: key);

  @override
  _GeocodingTestPageState createState() => new _GeocodingTestPageState();
}

class _GeocodingTestPageState extends State<GeocodingTestPage> {
  String address = "";
  TextEditingController latController = new TextEditingController();
  TextEditingController longController = new TextEditingController();

  void convert(double lat, double long) async {
    address = await coordinatesToAddress(lat, long);
  }

  void a(double lat, double long) {
    setState(() {
      convert(lat, long);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Geocode Test")),
      body: new Column(
        children: <Widget>[
          new TextField(
            controller: latController,
            decoration: new InputDecoration(
              hintText: "Latitude",
            ),
          ),
          new TextField(
            controller: longController,
            decoration: new InputDecoration(
              hintText: "Longitude",
            ),
          ),
          new Text(address),
          new FlatButton(
            child: new Text("Reverse Geocode"),
            onPressed: () {
              //a(double.parse(latController.text), double.parse(longController.text));
            },
          ),
        ],
      ),
    );
  }
}
