import 'package:flutter/material.dart';
import 'package:inf/profile/profile_avatar.dart';
import 'package:inf/widgets/blurred_network_image.dart';

import '../network/config_manager.dart';
import '../widgets/follower_tray.dart';
import '../widgets/edit_button.dart';
import '../protobuf/inf_protobuf.dart';

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
            child: new Padding(
              padding: const EdgeInsets.all(32.0),
              child: new ProfileAvatar(size: 156.0, account: account),
            ),
          ),
          new Text(
            account.summary.name,
            style: Theme.of(context).textTheme.headline,
            textAlign: TextAlign.center,
          ),
          new Text(
            account.summary.location,
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center,
          ),
          new FollowerTray(
            oAuthProviders: ConfigManager.of(context).oauthProviders.all,
            socialMedia: account.detail.socialMedia,
          ),
          new Text(
            account.summary.description,
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
