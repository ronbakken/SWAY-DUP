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
import 'package:sway_mobile_app/network_inheritable/api_provider.dart';

import 'package:sway_common/inf_common.dart';
import 'package:sway_mobile_app/widgets/progress_dialog.dart';
import 'package:logging/logging.dart';

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
  final Future<NetUploadSigned> Function(File file) onUploadImage;

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  String _imageUrl;
  FileImage _image;

  Future<void> uploadImage() async {
    if (widget.onUploadImage != null) {
      final NetUploadSigned res = await widget.onUploadImage(_image.file);
      if (!mounted) {
        return;
      }
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
    // NetworkProvider.of(context)
    //     .pushKeepAlive(); // Temporary workaround to keep the connection open in the background
    try {
      image = await ImagePicker.pickImage(source: source);
    } finally {
      // NetworkProvider.of(context)
      //     .popKeepAlive(); // Temporary workaround to keep the connection open in the background
    }
    if (image != null) {
      setState(() {
        // _imageFile = image;
        _image = FileImage(image);
        _imageUrl = null;
      });
      try {
        await wrapProgressAndError<void>(
          context: context,
          progressBuilder:
              genericProgressBuilder(message: 'Uploading image...'),
          errorBuilder: genericMessageBuilder(title: 'Image Upload Failed'),
          task: () async {
            await uploadImage();
          },
        );
      } catch (error, _) {
        setState(() {
          _image = null;
          _imageUrl = null;
        });
        rethrow;
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
