import 'package:flutter/material.dart';

import 'follower_count.dart';
import '../network/inf.pb.dart';


class FollowerTray extends StatelessWidget
{ 
  FollowerTray({
    Key key, 
    this.oAuthProviders,
    }) :super (key: key);

  final List<ConfigOAuthProvider> oAuthProviders;

  @override
  Widget build(BuildContext context){

    List<FollowerWidget> followerWidgets = new List<FollowerWidget>();
    
    for (int i = 1; i < oAuthProviders.length; i++) {
      if(oAuthProviders[i].enabled) {
        followerWidgets.add(new FollowerWidget(oAuthProvider: oAuthProviders[i]));
      }
    }

    return new Row(
			mainAxisAlignment: MainAxisAlignment.center,
			children: followerWidgets,
		);
  }
}
