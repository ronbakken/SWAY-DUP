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
  String text = "";

  void a() {
    setState(() {
      coordinatesToAddress(14.541530587952687, 121.01074919533015);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(text)),
      body: new Column(
        children: <Widget>[
          new Text(text),
          new FlatButton(
            child: new Text("Geocode"),
            onPressed: a,
          ),
        ],
      ),
    );
  }
}
