import 'package:flutter/material.dart';

import '../network/inf.pb.dart';

/// This widget will take in a specific authenticated Social Media
/// Account and display the social media's Brand Icon along with
/// the account user's number of followers
class FollowerWidget extends StatelessWidget
{ 
  FollowerWidget({
    Key key, 
    this.oAuthProvider,
    this.followerCount = 10,
    }) :super (key: key);

  // The Social media where to get the followers from
  final ConfigOAuthProvider oAuthProvider;
  final int followerCount;

  @override
  Widget build(BuildContext context){
    return new Container(
      padding: const EdgeInsets.all(10.0),
      child: new Column(
        children: <Widget>[
          // Icon
          new Icon(
            new IconData(
              this.oAuthProvider.fontAwesomeBrand, 
              fontFamily: 'FontAwesomeBrands', 
              fontPackage: 'font_awesome_flutter'
            )
          ),

          // Number of Followers
          new Text(followerCount.toString()),
        ],
      ),
    );
  }
}

