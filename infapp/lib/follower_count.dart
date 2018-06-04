import 'package:flutter/material.dart';

/// This widget will take in a specific authenticated Social Media
/// Account and display the social media's Brand Icon along with
/// the account user's number of followers
class FollowerWidget extends StatelessWidget
{
  @override
  Widget build(BuildContext context){
    return new Container(
      padding: const EdgeInsets.all(10.0),
      child: new Column(
        children: <Widget>[
          // Icon
          new Icon(Icons.face),
          // Number of Followers
          new Text("10"),
        ],
      ),
    );
  }
}
