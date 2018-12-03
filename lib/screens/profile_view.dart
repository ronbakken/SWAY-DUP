/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Kenneth Amiel Santos <kennethamiel.santos@gmail.com>
*/

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inf/widgets/profile_avatar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:inf/widgets/follower_tray.dart';
import 'package:inf/widgets/edit_button.dart';
import 'package:inf_common/inf_common.dart';

// TODO: Change to a stateful Widget and Cleanup
class ProfileView extends StatelessWidget {
  // Constructor
  ProfileView({
    Key key,
    @required this.account,
    @required this.oauthProviders,
    this.onEditPressed,
  }) : super(key: key);

  final DataAccount account;
  final List<ConfigOAuthProvider> oauthProviders;
  final Function() onEditPressed;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool portrait = (MediaQuery.of(context).size.height >
        MediaQuery.of(context).size.width);
    List<Widget> accountAvatar = <Widget>[
      Center(
        child: Padding(
          padding: portrait
              ? const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 24.0)
              : const EdgeInsets.fromLTRB(
                  24.0, 8.0, 24.0, kToolbarHeight + 8.0),
          child: ProfileAvatar(size: 160.0, account: account),
        ),
      ),
    ];
    List<Widget> accountInfo = <Widget>[
      Text(
        account.name,
        style: theme.textTheme.headline,
        textAlign: TextAlign.center,
      ),
      Text(
        account.location,
        style: theme.textTheme.caption,
        textAlign: TextAlign.center,
      ),
      FollowerTray(
        oauthProviders: oauthProviders,
        socialMedia: account.socialMedia,
      ),
      account.website.isEmpty
          ? null
          : RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: account.website,
                    // style: new TextStyle(color: Colors.blue),
                    style: theme.textTheme.button
                        .copyWith(color: theme.accentColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch(account.website);
                      },
                  ),
                ],
              ),
            ),
      account.website.isEmpty ? null : SizedBox(height: 20.0),
      Text(
        account.description,
        style: theme.textTheme.body1,
        textAlign: TextAlign.center,
      ),
    ].where((w) => w != null).toList();

    return Scaffold(
      // backgroundColor: theme.primaryColorDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,

        /*title: new Text((onEditPressed != null)
            ? "Your profile"
            : account.name.isNotEmpty
                ? (account.name + "'s profile")
                : "Profile"),*/
        actions: (onEditPressed != null)
            ? <Widget>[
                EditButton(onEditPressed: onEditPressed),
              ]
            : null,
      ),
      body: (MediaQuery.of(context).size.height >
              MediaQuery.of(context).size.width)
          ? Column(
              children: accountAvatar + accountInfo,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: accountAvatar +
                  <Widget>[
                    Column(
                      children: accountInfo,
                    ),
                    SizedBox(width: 24.0),
                  ],
            ),
    );
  }
}

/* end of file */
