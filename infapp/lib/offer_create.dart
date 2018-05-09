import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OfferCreate extends StatefulWidget {
  @override
  _OfferCreateState createState() => new _OfferCreateState();
}

class _OfferCreateState extends State<OfferCreate> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Create Offer"),
      ),
      body: new Text("Ok"),
    );
  }
}
