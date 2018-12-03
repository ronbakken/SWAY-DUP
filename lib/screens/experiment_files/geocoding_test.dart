/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Kenneth Amiel Santos <kennethamiel.santos@gmail.com>
*/

import 'package:flutter/material.dart';
import 'package:inf_app/screens/experiment_files/reverse_geocoding.dart';

class GeocodingTestPage extends StatefulWidget {
  GeocodingTestPage({
    Key key,
  }) : super(key: key);

  @override
  _GeocodingTestPageState createState() => _GeocodingTestPageState();
}

class _GeocodingTestPageState extends State<GeocodingTestPage> {
  String address = "";
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(title: Text("Geocode Test")),
      body: Column(
        children: <Widget>[
          TextField(
            controller: latController,
            decoration: InputDecoration(
              hintText: "Latitude",
            ),
          ),
          TextField(
            controller: longController,
            decoration: InputDecoration(
              hintText: "Longitude",
            ),
          ),
          Text(address),
          FlatButton(
            child: Text("Reverse Geocode"),
            onPressed: () {
              //a(double.parse(latController.text), double.parse(longController.text));
            },
          ),
        ],
      ),
    );
  }
}

/* end of file */
