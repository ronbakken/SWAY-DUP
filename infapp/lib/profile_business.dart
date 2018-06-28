import 'package:flutter/material.dart';
import 'follower_count.dart';

class BusinessProfileView extends StatelessWidget {

  BusinessProfileView({
    Key key,
    this.self,
  }) : super(key: key);

  final bool self;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Business Profile View'),
        actions: <Widget>[ self ? 
        new IconButton(
          icon: new Icon(Icons.edit),
          onPressed: () { print("Edit Profile"); },
          ) 
        : new Container() ],
      ),
    );
  }
}

