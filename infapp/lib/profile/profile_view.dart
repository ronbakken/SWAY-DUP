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
    @required this.account,
    this.onEditPressed,
  }) : super(key: key);

  final DataAccount account;
  final Function() onEditPressed;

  @override
  Widget build(BuildContext context) {
    assert(ConfigManager.of(context) != null);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text((onEditPressed != null)
            ? "Your profile"
            : account.summary.name.isNotEmpty
                ? (account.summary.name + "'s profile")
                : "Profile"),
        actions: (onEditPressed != null)
            ? <Widget>[
                new EditButton(onEditPressed: onEditPressed),
              ]
            : null,
      ),
      body: new Column(
        children: <Widget>[
          new Center(
              child: new ProfilePicture(
                  imageUrl: account.detail.avatarCoverUrl.isNotEmpty
                      ? account.detail.avatarCoverUrl
                      : account.summary.avatarThumbnailUrl)),
          new Center(
            child: new Text(
              account.summary.name,
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          new Center(
            child: new Text(
              account.summary.location,
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          new FollowerTray(
            oAuthProviders: ConfigManager.of(context).oauthProviders.all,
            socialMedia: account.detail.socialMedia,
          ),
          new Center(
            child: new Text(
              account.summary.description,
              style: Theme.of(context).textTheme.body1,
            ),
          ),
        ],
      ),
    );
  }
}
