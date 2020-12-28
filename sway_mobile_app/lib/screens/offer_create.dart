/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

// import 'dart:async';
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:sway_mobile_app/utility/ensure_visible_when_focused.dart';
import 'package:inf_common/inf_common.dart';

import 'package:sway_mobile_app/widgets/image_uploader.dart';

import 'package:sway_mobile_app/widgets/network_status.dart';

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
    @required this.config,
    @required this.onCreateOffer,
    this.onUploadImage,
  }) : super(key: key);

  final ConfigData config;
  final Future<DataOffer> Function(NetCreateOffer createOffer) onCreateOffer;
  final Future<NetUploadSigned> Function(File file) onUploadImage;

  @override
  _OfferCreateState createState() => _OfferCreateState();
}

class _OfferCreateState extends State<OfferCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Random random = Random();

  String _imageKey;
  String _title;
  String _description;
  String _deliverables;
  String _reward;

  final TextEditingController _imageKeyController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deliverablesController = TextEditingController();
  final TextEditingController _rewardController = TextEditingController();

  final FocusNode _titleNode = FocusNode();
  final FocusNode _descriptionNode = FocusNode();
  final FocusNode _deliverablesNode = FocusNode();
  final FocusNode _rewardNode = FocusNode();

  bool _waiting = false;

  void _submitPressed(BuildContext context) async {
    final form = _formKey.currentState;
    if (form.validate()) {
      _imageKey = _imageKeyController.text;
      if (_imageKeyController.text.isNotEmpty) {
        form.save();
        final NetCreateOffer createOffer = NetCreateOffer();
        createOffer.offer = DataOffer();
        createOffer.offer.title = _title;
        createOffer.offer.coverKeys.add(_imageKey);
        createOffer.offer.description = _description;
        createOffer.offer.terms = DataTerms();
        createOffer.offer.terms.deliverablesDescription = _deliverables;
        createOffer.offer.terms.rewardItemOrServiceDescription = _reward;
        for (int i = 2; i < random.nextInt(8); ++i) {
          createOffer.offer.categories
              .add(random.nextInt(widget.config.categories.length - 1) + 1);
        }
        for (int i = 1; i < random.nextInt(3); ++i) {
          createOffer.offer.terms.deliverableSocialPlatforms
              .add(random.nextInt(4 - 1) + 1);
        }
        for (int i = 1; i < random.nextInt(3); ++i) {
          createOffer.offer.terms.deliverableContentFormats
              .add(random.nextInt(widget.config.contentFormats.length - 1) + 1);
        }
        createOffer.offer.terms.rewardCashValue =
            (random.nextInt(200) + 1) * 1000;
        createOffer.offer.terms.rewardItemOrServiceValue =
            (random.nextInt(20) + 1) * 1000;
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
        Scaffold.of(context).showSnackBar(SnackBar(
            content:
                Text("At least one photo is required to make a new offer.")));
      }
    }
  }

  /*bool _validFormData() {
    // return _image != null;
    return _imageKeyController.text != null && _imageKeyController.text.length > 0;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Make an offer"),
        ),
        bottomSheet: NetworkStatus.buildOptional(context),
        body: Builder(builder: (context) {
          return ListView(padding: EdgeInsets.all(16.0), children: [
            ImageUploader(
              uploadKey: _imageKeyController,
              onUploadImage: widget.onUploadImage,
            ),
            SizedBox(
              height: 8.0,
            ),
            Form(
              key: _formKey,
              child: Column(children: [
                EnsureVisibleWhenFocused(
                  focusNode: _titleNode,
                  child: TextFormField(
                    focusNode: _titleNode,
                    controller: _titleController,
                    maxLines: 1,
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (val) =>
                        val.trim().isEmpty ? 'Missing title' : null,
                    onSaved: (val) => setState(() {
                      _title = val;
                    }),
                  ),
                ),
                EnsureVisibleWhenFocused(
                  focusNode: _descriptionNode,
                  child: TextFormField(
                    focusNode: _descriptionNode,
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (val) => val.trim().length < 20
                        ? 'Description must be longer'
                        : null,
                    onSaved: (val) => setState(() {
                      _description = val;
                    }),
                  ),
                ),
                EnsureVisibleWhenFocused(
                  focusNode: _deliverablesNode,
                  child: TextFormField(
                    focusNode: _deliverablesNode,
                    controller: _deliverablesController,
                    maxLines: 2,
                    decoration: InputDecoration(labelText: 'Deliverables'),
                    validator: (val) => val.trim().length < 4
                        ? 'Deliverables must be filled in'
                        : null,
                    onSaved: (val) => setState(() {
                      _deliverables = val;
                    }),
                  ),
                ),
                EnsureVisibleWhenFocused(
                  focusNode: _rewardNode,
                  child: TextFormField(
                    focusNode: _rewardNode,
                    controller: _rewardController,
                    maxLines: 2,
                    decoration: InputDecoration(labelText: 'Reward'),
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
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Make offer".toUpperCase()),
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
