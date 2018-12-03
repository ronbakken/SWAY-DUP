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
import 'package:inf/network_inheritable/network_provider.dart';

import 'package:inf_common/inf_common.dart';
import 'package:inf/widgets/progress_dialog.dart';

// Image uploader
class ImageUploader extends StatefulWidget {
  const ImageUploader(
      {Key key,
      this.light = false,
      this.initialUrl,
      @required this.uploadKey,
      this.onUploadImage})
      : super(key: key);

  final bool light;

  // The key of the uploaded image, this value may be sent to the server
  final String initialUrl;
  final TextEditingController uploadKey;
  final Future<NetUploadImageRes> Function(FileImage fileImage) onUploadImage;

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
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
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Upload not implemented here")));
    }
  }

  Future<void> _selectImage(ImageSource source) async {
    File image;
    NetworkProvider.of(context)
        .pushKeepAlive(); // Temporary workaround to keep the connection open in the background
    try {
      image = await ImagePicker.pickImage(source: source);
    } catch (error) {
      rethrow;
    } finally {
      NetworkProvider.of(context)
          .popKeepAlive(); // Temporary workaround to keep the connection open in the background
      // TODO: Have a waiting mechanism in the uploadImage function with timeout
    }
    if (image != null) {
      setState(() {
        // _imageFile = image;
        _image = FileImage(image);
        _imageUrl = null;
      });
      bool success = false;
      final dynamic progressDialog = showProgressDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator()),
                  Text("Uploading image..."),
                ],
              ),
            );
          });
      try {
        await uploadImage();
        success = true;
      } catch (error, stackTrace) {
        print("[INF] Exception uploading image': $error\n$stackTrace");
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
            return AlertDialog(
              title: Text('Image Upload Failed'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('An error has occured.'),
                    Text('Please try again later.'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Ok'.toUpperCase())],
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
  }

  @override
  Widget build(BuildContext context) {
    Widget buttons = Row(
      children: <Widget>[
        Expanded(
            child: RaisedButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.light ? 16.0 : 4.0),
              topRight: Radius.circular(4.0),
              bottomLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(4.0),
            ),
          ),
          color: _image == null
              ? Theme.of(context).buttonColor
              : Theme.of(context).unselectedWidgetColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.photo),
              //new SizedBox(width: 8.0),
              Text("Gallery".toUpperCase()),
              // new Icon(_image == null ? Icons.folder_open : Icons.check),
            ],
          ),
          onPressed: () async {
            await _selectImage(ImageSource.gallery);
          },
        )),
        SizedBox(
          width: 8.0,
        ),
        Expanded(
            child: RaisedButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(widget.light ? 16.0 : 4.0),
              bottomLeft: Radius.circular(4.0),
              bottomRight: Radius.circular(16.0),
            ),
          ),
          color: _image == null
              ? Theme.of(context).buttonColor
              : Theme.of(context).unselectedWidgetColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // new Icon(Icons.photo),
              Text("Camera".toUpperCase()),
              //new SizedBox(width: 8.0),
              // new Icon(_image == null ? Icons.folder_open : Icons.check),
              Icon(Icons.camera),
            ],
          ),
          onPressed: () async {
            await _selectImage(ImageSource.camera);
          },
        )),
      ],
    );
    if (widget.light) {
      return buttons;
    }
    Widget image;
    if (_image != null) {
      if (_imageUrl != null) {
        image = FadeInImage(
            fit: BoxFit.cover,
            placeholder: _image,
            image: NetworkImage(_imageUrl));
      } else {
        image = Image(
          fit: BoxFit.cover,
          image: _image,
        );
      }
    } else if (widget.initialUrl != null) {
      image = FadeInImage.assetNetwork(
          fit: BoxFit.cover,
          placeholder: 'assets/placeholder_photo_select.png',
          image: widget.initialUrl);
    } else {
      image = Image(
        fit: BoxFit.cover,
        image: AssetImage('assets/placeholder_photo_select.png'),
      );
    }
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 16.0 / 9.0,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            child: image,
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        buttons,
      ],
    );
  }
}

/* end of file */
