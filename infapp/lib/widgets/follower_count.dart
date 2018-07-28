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
    }) :super (key: key);

  // The Social media where to get the followers from
  // TODO: Refactor
  final ConfigOAuthProvider oAuthProvider;

  @override
  Widget build(BuildContext context){
    return new Container(
      padding: const EdgeInsets.all(10.0),
      child: new Column(
        children: <Widget>[
          // Icon
          // TODO: Changeable Icon
          new Icon(
            new IconData(
              this.oAuthProvider.fontAwesomeBrand, 
              fontFamily: 'FontAwesomeBrands', 
              fontPackage: 'font_awesome_flutter'
            )
          ),

          // Number of Followers
          // TODO: Updateable value
          new Text("10"),
        ],
      ),
    );
  }
}
