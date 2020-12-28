/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Kenneth Amiel Santos <kennethamiel.santos@gmail.com>
*/

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:inf_common/inf_common.dart';
import 'package:sway_mobile_app/widgets/image_uploader.dart';

import 'package:sway_mobile_app/widgets/network_status.dart';

// TODO: Warn when unsaved changes

class ProfileEdit extends StatefulWidget {
  ProfileEdit({
    Key key,
    @required this.account,
    this.onUploadImage,
    this.onSubmitPressed,
  }) : super(key: key);

  final DataAccount account;
  final Future<NetUploadSigned> Function(File file) onUploadImage;
  final Function(dynamic setProfile) onSubmitPressed;

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  // GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextEditingController _avatarController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    // Initialize the Parent
    super.initState();
    _nameController.text = widget.account.name;
    _locationController.text = widget.account.location;
    _descriptionController.text = widget.account.description;
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
      // TODO
      /*dynamic setProfile = new NetProfileModify();
      setProfile.avatarKey = _avatarController.text;
      setProfile.name = _nameController.text;
      setProfile.description = _descriptionController.text;
      widget.onSubmitPressed(setProfile);*/
    }

    // _location need lat long from map selection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modify your profile"),
      ),
      bottomSheet: NetworkStatus.buildOptional(context),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ImageUploader(
            initialUrl: widget.account.avatarUrl,
            uploadKey: _avatarController,
            onUploadImage: widget.onUploadImage,
          ),
          SizedBox(
            height: 8.0,
          ),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(labelText: 'Location'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
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
                    Text("Save your profile".toUpperCase()),
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

/* end of file */
