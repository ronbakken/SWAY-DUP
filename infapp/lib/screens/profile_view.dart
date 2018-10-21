/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Kenneth Amiel Santos <kennethamiel.santos@gmail.com>
*/

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inf/widgets/profile_avatar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:inf/network_mobile/config_manager.dart';
import 'package:inf/widgets/follower_tray.dart';
import 'package:inf/widgets/edit_button.dart';
import 'package:inf/protobuf/inf_protobuf.dart';

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
    ThemeData theme = Theme.of(context);
    bool portrait = (MediaQuery.of(context).size.height >
        MediaQuery.of(context).size.width);
    List<Widget> accountAvatar = <Widget>[
      new Center(
        child: new Padding(
          padding: portrait
              ? const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 24.0)
              : const EdgeInsets.fromLTRB(
                  24.0, 8.0, 24.0, kToolbarHeight + 8.0),
          child: new ProfileAvatar(size: 160.0, account: account),
        ),
      ),
    ];
    List<Widget> accountInfo = <Widget>[
      new Text(
        account.summary.name,
        style: theme.textTheme.headline,
        textAlign: TextAlign.center,
      ),
      new Text(
        account.summary.location,
        style: theme.textTheme.caption,
        textAlign: TextAlign.center,
      ),
      new FollowerTray(
        oAuthProviders: ConfigManager.of(context).oauthProviders.all,
        socialMedia: account.detail.socialMedia,
      ),
      account.detail.url.isEmpty
          ? null
          : new RichText(
              text: new TextSpan(
                children: [
                  new TextSpan(
                    text: account.detail.url,
                    // style: new TextStyle(color: Colors.blue),
                    style: theme.textTheme.button
                        .copyWith(color: theme.accentColor),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch(account.detail.url);
                      },
                  ),
                ],
              ),
            ),
      account.detail.url.isEmpty ? null : new SizedBox(height: 20.0),
      new Text(
        account.summary.description,
        style: theme.textTheme.body1,
        textAlign: TextAlign.center,
      ),
    ].where((w) => w != null).toList();

    return new Scaffold(
      // backgroundColor: theme.primaryColorDark,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,

        /*title: new Text((onEditPressed != null)
            ? "Your profile"
            : account.summary.name.isNotEmpty
                ? (account.summary.name + "'s profile")
                : "Profile"),*/
        actions: (onEditPressed != null)
            ? <Widget>[
                new EditButton(onEditPressed: onEditPressed),
              ]
            : null,
      ),
      body: (MediaQuery.of(context).size.height >
              MediaQuery.of(context).size.width)
          ? new Column(
              children: accountAvatar + accountInfo,
            )
          : new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: accountAvatar +
                  <Widget>[
                    new Column(
                      children: accountInfo,
                    ),
                    new SizedBox(width: 24.0),
                  ],
            ),
    );
  }
}

/* end of file */
