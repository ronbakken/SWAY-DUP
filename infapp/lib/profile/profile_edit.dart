import 'package:flutter/material.dart';

import '../network/inf.pb.dart';
import 'profile_view.dart';
import '../page_transition.dart';

class ProfileEdit extends StatefulWidget 
{
  ProfileEdit({
    Key key,
    this.dataAccount,
  }) : super(key: key);

  final DataAccount dataAccount;

  @override
  _ProfileEditState createState() => new _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit>
{
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _name;
  String _location;
  String _description;

  TextEditingController _nameController;
  TextEditingController _locationController;
  TextEditingController _descriptionController;

   @override
  void initState() {
    // Initialize the Parent
    super.initState();

  }

  void _submitPressed()
   {
    widget.dataAccount.summary.name = _name;
    widget.dataAccount.summary.location = _location;
    widget.dataAccount.summary.description = _description;

    transitionPage(context, new ProfileView( dataAccount: widget.dataAccount,));
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
          new TextField(
            controller: _nameController,
            decoration: new InputDecoration(labelText: 'Name'),
            onChanged: (value) { _name = value; },
          ),
          new Container(padding: const EdgeInsets.all(12.0),),
          new TextField(
            controller: _locationController,
            decoration: new InputDecoration(labelText: 'Location'),
            onChanged: (value) { _location = value; },
          ),
          new Container(padding: const EdgeInsets.all(12.0),),
          new TextField(
            controller: _descriptionController,
            decoration: new InputDecoration(labelText: 'Description'),
            onChanged: (value) { _description = value; },
          ),
          new Container(padding: const EdgeInsets.all(12.0),),
          new RaisedButton(
            child: new Text("SUBMIT"),
            onPressed: _submitPressed,
          ),
        ],
      ),
    );
  }
}
