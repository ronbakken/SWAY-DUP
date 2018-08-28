/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// https://pub.dartlang.org/packages/image_picker
import 'package:image_picker/image_picker.dart';

import '../network/inf.pb.dart';
import '../utility/progress_dialog.dart';

// Image uploader
class ImageUploader extends StatefulWidget {
  const ImageUploader(
      {Key key, this.initialUrl, @required this.uploadKey, this.onUploadImage})
      : super(key: key);

  // The key of the uploaded image, this value may be sent to the server
  final String initialUrl;
  final TextEditingController uploadKey;
  final Future<NetUploadImageRes> Function(FileImage fileImage) onUploadImage;

  @override
  _ImageUploaderState createState() => new _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  String _imageUrl;
  FileImage _image;

  Future<void> uploadImage() async {
    if (widget.onUploadImage != null) {
      NetUploadImageRes res = await widget.onUploadImage(_image);
      if (!mounted) return;
      widget.uploadKey.text = res.uploadKey;
      setState(() {
        _imageUrl = res.coverUrl;
      });
    } else {
      Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text("Upload not implemented here")));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (_image != null) {
      if (_imageUrl != null) {
        image = new FadeInImage(
            fit: BoxFit.cover,
            placeholder: _image,
            image: new NetworkImage(_imageUrl));
      } else {
        image = new Image(
          fit: BoxFit.cover,
          image: _image,
        );
      }
    } else if (widget.initialUrl != null) {
      image = new FadeInImage.assetNetwork(
          fit: BoxFit.cover,
          placeholder: 'assets/placeholder_photo_select.png',
          image: widget.initialUrl);
    } else {
      image = new Image(
        fit: BoxFit.cover,
        image: new AssetImage('assets/placeholder_photo_select.png'),
      );
    }
    return new Column(
      children: <Widget>[
        new AspectRatio(
          aspectRatio: 16.0 / 9.0,
          child: new ClipRRect(
            borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
            child: image,
          ),
        ),
        new SizedBox(
          height: 8.0,
        ),
        new RaisedButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
              topLeft: new Radius.circular(4.0),
              topRight: new Radius.circular(4.0),
              bottomLeft: new Radius.circular(16.0),
              bottomRight: new Radius.circular(16.0),
            ),
          ),
          color: _image == null
              ? Theme.of(context).buttonColor
              : Theme.of(context).unselectedWidgetColor,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Icon(Icons.photo),
              new Text("Select Photo".toUpperCase()),
              new Icon(_image == null ? Icons.folder_open : Icons.check),
            ],
          ),
          onPressed: () async {
            File image =
                await ImagePicker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              setState(() {
                // _imageFile = image;
                _image = new FileImage(image);
                _imageUrl = null;
              });
              bool success = false;
              var progressDialog = showProgressDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return new Dialog(
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          new Container(
                              padding: new EdgeInsets.all(24.0),
                              child: new CircularProgressIndicator()),
                          new Text("Uploading image..."),
                        ],
                      ),
                    );
                  });
              try {
                await uploadImage();
                success = true;
              } catch (error, stack) {
                print("[INF] Exception uploading image': $error\n$stack");
              }
              closeProgressDialog(progressDialog);
              if (!success) {
                setState(() {
                  _image = null;
                  _imageUrl = null;
                });
                await showDialog<Null>(
                  context: this.context,
                  builder: (BuildContext context) {
                    return new AlertDialog(
                      title: new Text('Image Upload Failed'),
                      content: new SingleChildScrollView(
                        child: new ListBody(
                          children: <Widget>[
                            new Text('An error has occured.'),
                            new Text('Please try again later.'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [new Text('Ok'.toUpperCase())],
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            }
          },
        ),
      ],
    );
  }
}

/* end of file */
