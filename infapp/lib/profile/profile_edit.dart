import 'dart:async';

import 'package:flutter/material.dart';

import '../protobuf/inf_protobuf.dart';
import 'profile_view.dart';
import '../page_transition.dart';
import '../widgets/image_uploader.dart';

import '../widgets/network_status.dart';

// TODO: Warn when unsaved changes

class ProfileEdit extends StatefulWidget {
  ProfileEdit({
    Key key,
    @required this.account,
    this.onUploadImage,
    this.onSubmitPressed,
  }) : super(key: key);

  final DataAccount account;
  final Future<NetUploadImageRes> Function(FileImage fileImage) onUploadImage;
  final Function(NetProfileModify setProfile) onSubmitPressed;

  @override
  _ProfileEditState createState() => new _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  // GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextEditingController _avatarController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _locationController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();

  @override
  void initState() {
    // Initialize the Parent
    super.initState();
    _nameController.text = widget.account.summary.name;
    _locationController.text = widget.account.summary.location;
    _descriptionController.text = widget.account.summary.description;
  }

  void _submitPressed() {
    /* 
    string name = 1;
    string description = 2;
    string avatarKey = 4;
    
    string url = 6;
    
    repeated CategoryId categories = 12;
    
    double latitude = 14;
    double longitude = 15;
    */

    if (widget.onSubmitPressed != null) {
      NetProfileModify setProfile = new NetProfileModify();
      setProfile.avatarKey = _avatarController.text;
      setProfile.name = _nameController.text;
      setProfile.description = _descriptionController.text;
      widget.onSubmitPressed(setProfile);
    }

    // _location need lat long from map selection
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Modify your profile"),
      ),
      bottomSheet: NetworkStatus.buildOptional(context),
      body: new ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          new ImageUploader(
            initialUrl: widget.account.detail.avatarCoverUrl,
            uploadKey: _avatarController,
            onUploadImage: widget.onUploadImage,
          ),
          new SizedBox(
            height: 8.0,
          ),
          new TextField(
            controller: _nameController,
            decoration: new InputDecoration(labelText: 'Name'),
          ),
          new TextField(
            controller: _locationController,
            decoration: new InputDecoration(labelText: 'Location'),
          ),
          new TextField(
            controller: _descriptionController,
            decoration: new InputDecoration(labelText: 'Description'),
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
                    new Text("Save your profile".toUpperCase()),
                  ],
                ),
                onPressed:
                    (widget.onSubmitPressed != null) ? _submitPressed : null,
              )
            ],
          ),
        ],
      ),
    );
  }
}
