// import 'dart:async';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import 'utility/ensure_visible_when_focused.dart';
import 'network/inf.pb.dart';

import 'widgets/image_uploader.dart';

// https://leonid.shevtsov.me/post/demystifying-s3-browser-upload/
// https://github.com/gjersvik/awsdart // Prepare a signature on the server
// Simple HTTP POST on the client

// https://flutter.rocks/2017/10/17/validating-forms-in-flutter/
// https://github.com/flutter/flutter/issues/11500
// https://stackoverflow.com/questions/49207145/flutter-keyboard-over-textformfield

// https://www.didierboelens.com/2018/04/hint-4-ensure-a-textfield-or-textformfield-is-visible-in-the-viewport-when-has-the-focus/
// https://github.com/flutter/flutter/issues/10826
// SingleChildScrollView instead of ListView

/*
    unselectedWidgetColor ??= isDark ? Colors.white70 : Colors.black54;
    disabledColor ??= isDark ? Colors.white30 : Colors.black26;
    buttonColor ??= isDark ? primarySwatch[600] : Colors.grey[300];
*/

typedef void CreateOfferCallback(NetReqCreateOffer req);

class OfferCreate extends StatefulWidget {
  const OfferCreate({
    Key key,
    @required this.onCreateOffer,
    this.onUploadImage,
  }) : super(key: key);

  final CreateOfferCallback onCreateOffer;
  final Future<NetUploadImageRes> Function(FileImage fileImage) onUploadImage;

  @override
  _OfferCreateState createState() => new _OfferCreateState();
}

class _OfferCreateState extends State<OfferCreate> {
  final _formKey = new GlobalKey<FormState>();

  String _imageKey;
  String _title;
  String _description;
  String _deliverables;
  String _reward;

  TextEditingController _imageKeyController;
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _deliverablesController;
  TextEditingController _rewardController;

  final FocusNode _titleNode = new FocusNode();
  final FocusNode _descriptionNode = new FocusNode();
  final FocusNode _deliverablesNode = new FocusNode();
  final FocusNode _rewardNode = new FocusNode();

  void _submitPressed() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      _imageKey = _imageKeyController.text;
      form.save();
      // Upload image
      // Handle callback
      // ...
    }
  }

  bool _validFormData() {
    // return _image != null;
    return _imageKeyController.text != null && _imageKeyController.text.length > 0;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Make an offer"),
      ),
      body: new ListView(
        padding: new EdgeInsets.all(8.0),
        children: [
          new ImageUploader(
            uploadKey: _imageKeyController,
            onUploadImage: widget.onUploadImage,
          ),
          new Form(
            key: _formKey,
            child: new Column(
              children: [
                new EnsureVisibleWhenFocused(
                  focusNode: _titleNode,
                  child: new TextFormField(
                    focusNode: _titleNode,
                    controller: _titleController,
                    maxLines: 1,
                    decoration: new InputDecoration(labelText: 'Title'),
                    validator: (val) =>
                        val.trim().isEmpty ? 'Missing title' : null,
                    onSaved: (val) => _title = val,
                  ),
                ),
                new EnsureVisibleWhenFocused(
                  focusNode: _descriptionNode,
                  child: new TextFormField(
                    focusNode: _descriptionNode,
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: new InputDecoration(labelText: 'Description'),
                    validator: (val) => val.trim().length < 20
                        ? 'Description must be longer'
                        : null,
                    onSaved: (val) => _description = val,
                  ),
                ),
                new EnsureVisibleWhenFocused(
                  focusNode: _deliverablesNode,
                  child: new TextFormField(
                    focusNode: _deliverablesNode,
                    controller: _deliverablesController,
                    maxLines: 2,
                    decoration: new InputDecoration(labelText: 'Deliverables'),
                    validator: (val) => val.trim().length < 4
                        ? 'Deliverables must be filled in'
                        : null,
                    onSaved: (val) => _deliverables = val,
                  ),
                ),
                new EnsureVisibleWhenFocused(
                  focusNode: _rewardNode,
                  child: new TextFormField(
                    focusNode: _rewardNode,
                    controller: _rewardController,
                    maxLines: 2,
                    decoration: new InputDecoration(labelText: 'Reward'),
                    validator: (val) => val.trim().length < 4
                        ? 'Reward must be filled in'
                        : null,
                    onSaved: (val) => _reward = val,
                  ),
                ),
              ]
              //    .map<Widget>((v) => new Container(
              //        padding: new EdgeInsets.only(bottom: 8.0), child: v))
              //    .toList(),
            ),
          )
        ]
            .map<Widget>((v) =>
                new Container(padding: new EdgeInsets.all(8.0), child: v))
            .toList()
              ..addAll([])
              ..addAll([
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    new RaisedButton(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Text("Make offer".toUpperCase()),
                        ],
                      ),
                      onPressed: _validFormData() ? _submitPressed : null,
                    )
                  ],
                )
              ].map<Widget>((v) =>
                  new Container(padding: new EdgeInsets.all(8.0), child: v))),
      ),
    );
  }
}
