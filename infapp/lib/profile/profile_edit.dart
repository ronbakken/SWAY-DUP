import 'dart:async';

import 'package:flutter/material.dart';

import '../network/inf.pb.dart';
import 'profile_view.dart';
import '../page_transition.dart';
import '../widgets/image_uploader.dart';

class ProfileEdit extends StatefulWidget {
  ProfileEdit({
    Key key,
    @required this.account,
    this.onUploadImage,
    this.onSubmitPressed,
  }) : super(key: key);

  final DataAccount account;
  final Future<NetUploadImageRes> Function(FileImage fileImage) onUploadImage;
  final Function(NetReqSetProfile setProfile) onSubmitPressed;

  @override
  _ProfileEditState createState() => new _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  // GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextEditingController _avatarController;
  TextEditingController _nameController;
  TextEditingController _locationController;
  TextEditingController _descriptionController;

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
      NetReqSetProfile setProfile = new NetReqSetProfile();
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
        title: new Text("Edit Profile"),
      ),
      body: new ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          new ImageUploader(
            initialUrl: widget.account.detail.avatarCoverUrl,
            uploadKey: _avatarController,
            onUploadImage: widget.onUploadImage,
          ),
          new TextField(
            controller: _nameController,
            decoration: new InputDecoration(labelText: 'Name'),
          ),
          new Container(
            padding: const EdgeInsets.all(12.0),
          ),
          new TextField(
            controller: _locationController,
            decoration: new InputDecoration(labelText: 'Location'),
          ),
          new Container(
            padding: const EdgeInsets.all(12.0),
          ),
          new TextField(
            controller: _descriptionController,
            decoration: new InputDecoration(labelText: 'Description'),
          ),
          new Container(
            padding: const EdgeInsets.all(12.0),
          ),
          new RaisedButton(
            child: new Text("Submit".toUpperCase()),
            onPressed: (widget.onSubmitPressed != null) ? _submitPressed : null,
          ),
        ],
      ),
    );
  }
}
