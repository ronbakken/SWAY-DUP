import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// https://pub.dartlang.org/packages/image_picker
import 'package:image_picker/image_picker.dart';

// https://leonid.shevtsov.me/post/demystifying-s3-browser-upload/
// https://github.com/gjersvik/awsdart // Prepare a signature on the server
// Simple HTTP POST on the client

/*
    unselectedWidgetColor ??= isDark ? Colors.white70 : Colors.black54;
    disabledColor ??= isDark ? Colors.white30 : Colors.black26;
    buttonColor ??= isDark ? primarySwatch[600] : Colors.grey[300];
*/

class OfferCreate extends StatefulWidget {
  @override
  _OfferCreateState createState() => new _OfferCreateState();
}

class _OfferCreateState extends State<OfferCreate> {
  // File _imageFile;
  FileImage _image;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Create an offer"),
      ),
      body: new ListView(
        padding: new EdgeInsets.all(8.0),
        children: ([
          new AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: new Image(
              fit: BoxFit.cover,
              image: _image == null ? new AssetImage('assets/placeholder_photo_select.png') : _image
            ),
          ),
          new RaisedButton(
            color: _image == null ? Theme.of(context).buttonColor : Theme.of(context).unselectedWidgetColor,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Icon(Icons.photo),
                new Text("Select Photo".toUpperCase()),
                new Icon(_image == null ? Icons.folder_open : Icons.check),
              ],
            ),
            onPressed: () async {
              File image = await ImagePicker.pickImage(source: ImageSource.askUser);
              if (image != null) {
                setState(() {
                  // _imageFile = image;
                  _image = new FileImage(image);
                });
              }
            },
          ),
          new Text("I have a nice offer for you mate"),
        ]).map<Widget>((v) => new Container(
          padding: new EdgeInsets.all(8.0),
          child: v
        )).toList(),
      ),
    );
  }
}
