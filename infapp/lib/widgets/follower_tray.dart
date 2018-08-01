import 'package:flutter/material.dart';

import 'follower_count.dart';
import '../network/inf.pb.dart';


class FollowerTray extends StatelessWidget
{ 
  FollowerTray({
    Key key, 
    this.oAuthProviders,
    this.socialMedia,
    }) :super (key: key);

  final List<ConfigOAuthProvider> oAuthProviders;
  final List<DataSocialMedia> socialMedia;

  @override
  Widget build(BuildContext context){

    List<FollowerWidget> followerWidgets = new List<FollowerWidget>();
    
    for (int i = 1; i < socialMedia.length; i++) {
      if(socialMedia[i].connected) {
        followerWidgets.add(
          new FollowerWidget(
            oAuthProvider: oAuthProviders[i], 
            followerCount: socialMedia[i].followersCount,
          )
        );
      }
    }

    return new Row(
			mainAxisAlignment: MainAxisAlignment.center,
			children: followerWidgets,
		);
  }
}
