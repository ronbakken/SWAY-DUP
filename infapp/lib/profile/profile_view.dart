import 'package:flutter/material.dart';

import '../network/config_manager.dart';
import 'profile_picture.dart';
import '../widgets/follower_tray.dart';
import '../widgets/edit_button.dart';
import '../network/inf.pb.dart';

// TODO: Change to a stateful Widget and Cleanup
class ProfileView extends StatelessWidget {

  // Constructor
  ProfileView({
    Key key,
    this.dataAccount,
  }) : super(key: key);
	
  final DataAccount dataAccount;

	@override
  Widget build(BuildContext context) {
    assert(ConfigManager.of(context) != null);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(dataAccount.summary.name + "'s Profile"),
        actions: <Widget>[
          new EditButton(),
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Center( child: new ProfilePicture( imageUrl: dataAccount.summary.avatarUrl)),
          new Center( child: new Text(dataAccount.summary.name, style: Theme.of(context).textTheme.headline,),),
          new Center( child: new Text(dataAccount.summary.location, style: Theme.of(context).textTheme.body2,),),
          new FollowerTray( oAuthProviders: ConfigManager.of(context).oauthProviders.all, socialMedia: dataAccount.detail.socialMedia,),
          new Center( child: new Text(dataAccount.summary.description, style: Theme.of(context).textTheme.body1,),),
        ],
      ),
    );
  }
}