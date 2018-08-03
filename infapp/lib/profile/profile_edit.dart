import 'package:flutter/material.dart';

class ProfileEdit extends StatefulWidget 
{
  
  @override
  _ProfileEditState createState() => new _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit>
{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Edit Profile'),
      ),
      body: new ListView( 
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[

        ],
      ),
    );
  }
}
