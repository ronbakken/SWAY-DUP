/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

// import 'dart:async';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:inf/utility/ensure_visible_when_focused.dart';
import 'package:inf_common/inf_common.dart';

import 'package:inf/widgets/image_uploader.dart';

import 'package:inf/widgets/network_status.dart';

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

class OfferCreate extends StatefulWidget {
  const OfferCreate({
    Key key,
    @required this.onCreateOffer,
    this.onUploadImage,
  }) : super(key: key);

  final Future<DataOffer> Function(NetCreateOffer createOffer) onCreateOffer;
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

  final TextEditingController _imageKeyController = new TextEditingController();
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _descriptionController =
      new TextEditingController();
  final TextEditingController _deliverablesController =
      new TextEditingController();
  final TextEditingController _rewardController = new TextEditingController();

  final FocusNode _titleNode = new FocusNode();
  final FocusNode _descriptionNode = new FocusNode();
  final FocusNode _deliverablesNode = new FocusNode();
  final FocusNode _rewardNode = new FocusNode();

  bool _waiting = false;

  void _submitPressed(BuildContext context) async {
    final form = _formKey.currentState;
    if (form.validate()) {
      _imageKey = _imageKeyController.text;
      if (_imageKeyController.text.isNotEmpty) {
        form.save();
        NetCreateOffer createOffer = new NetCreateOffer();
        createOffer.offer = new DataOffer();
        createOffer.offer.title = _title;
        createOffer.offer.coverKeys.add(_imageKey);
        createOffer.offer.description = _description;
        createOffer.offer.terms.deliverablesDescription = _deliverables;
        createOffer.offer.terms.rewardItemOrServiceDescription = _reward;
        // TODO
        // createOffer.location // Not yet supported
        setState(() {
          _waiting = true;
        });
        try {
          await widget.onCreateOffer(createOffer);
        } finally {
          setState(() {
            _waiting = false;
          });
        }
      } else {
        Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text(
                "At least one photo is required to make a new offer.")));
      }
    }
  }

  /*bool _validFormData() {
    // return _image != null;
    return _imageKeyController.text != null && _imageKeyController.text.length > 0;
  }*/

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Make an offer"),
        ),
        bottomSheet: NetworkStatus.buildOptional(context),
        body: new Builder(builder: (context) {
          return new ListView(padding: new EdgeInsets.all(16.0), children: [
            new ImageUploader(
              uploadKey: _imageKeyController,
              onUploadImage: widget.onUploadImage,
            ),
            new SizedBox(
              height: 8.0,
            ),
            new Form(
              key: _formKey,
              child: new Column(children: [
                new EnsureVisibleWhenFocused(
                  focusNode: _titleNode,
                  child: new TextFormField(
                    focusNode: _titleNode,
                    controller: _titleController,
                    maxLines: 1,
                    decoration: new InputDecoration(labelText: 'Title'),
                    validator: (val) =>
                        val.trim().isEmpty ? 'Missing title' : null,
                    onSaved: (val) => setState(() {
                          _title = val;
                        }),
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
                    onSaved: (val) => setState(() {
                          _description = val;
                        }),
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
                    onSaved: (val) => setState(() {
                          _deliverables = val;
                        }),
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
                    onSaved: (val) => setState(() {
                          _reward = val;
                        }),
                  ),
                ),
              ]),
            ),
            new SizedBox(
              height: 16.0,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                new RaisedButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Text("Make offer".toUpperCase()),
                    ],
                  ),
                  onPressed:
                      (/*_validFormData() &&*/ widget.onCreateOffer != null &&
                              !_waiting)
                          ? () {
                              _submitPressed(context);
                            }
                          : null,
                )
              ],
            )
          ]);
        }));
  }
}

/* end of file */
