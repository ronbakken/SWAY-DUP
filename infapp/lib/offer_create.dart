// import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// https://pub.dartlang.org/packages/image_picker
import 'package:image_picker/image_picker.dart';

import 'utility/ensure_visible_when_focused.dart';
import 'network/inf.pb.dart';

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
  }) : super(key: key);

  final CreateOfferCallback onCreateOffer;

  @override
  _OfferCreateState createState() => new _OfferCreateState();
}

class _OfferCreateState extends State<OfferCreate> {
  final _formKey = new GlobalKey<FormState>();

  // File _imageFile;
  FileImage _image;
  String _title;
  String _description;
  String _deliverables;
  String _reward;

  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _deliverablesController;
  TextEditingController _rewardController;

  final FocusNode _titleNode = new FocusNode();
  final FocusNode _descriptionNode = new FocusNode();
  final FocusNode _deliverablesNode = new FocusNode();
  final FocusNode _rewardNode = new FocusNode();

  _submitPressed() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      // Upload image
      // Handle callback
      // ...
    }
  }

  bool _validFormData() {
    return _image != null;
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
          new Column(
            children: <Widget>[
              new AspectRatio(
                aspectRatio: 16.0 / 9.0,
                child: new ClipRRect(
                  borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
                  child: Image(
                    fit: BoxFit.cover,
                    image: _image == null
                        ? new AssetImage('assets/placeholder_photo_select.png')
                        : _image),
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
                      await ImagePicker.pickImage(source: ImageSource.askUser);
                  if (image != null) {
                    setState(() {
                      // _imageFile = image;
                      _image = new FileImage(image);
                    });
                  }
                },
              ),
            ],
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
