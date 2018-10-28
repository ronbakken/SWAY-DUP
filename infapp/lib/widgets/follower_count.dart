/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Kenneth Amiel Santos <kennethamiel.santos@gmail.com>
*/

import 'package:flutter/material.dart';

import 'package:inf/protobuf/inf_protobuf.dart';

/// This widget will take in a specific authenticated Social Media
/// Account and display the social media's Brand Icon along with
/// the account user's number of followers
class FollowerWidget extends StatelessWidget {
  FollowerWidget({
    Key key,
    this.oAuthProvider,
    this.followerCount = 0,
  }) : super(key: key);

  // The Social media where to get the followers from
  final ConfigOAuthProvider oAuthProvider;
  final int followerCount;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return new Container(
      padding: const EdgeInsets.all(8.0),
      child: new Column(
        children: <Widget>[
          // Icon
          new Icon(new IconData(this.oAuthProvider.fontAwesomeBrand,
              fontFamily: 'FontAwesomeBrands',
              fontPackage: 'font_awesome_flutter')),
          new SizedBox(height: 4.0),
          // Number of Followers
          new Text(followerCount.toString(), style: theme.textTheme.body2),
        ],
      ),
    );
  }
}

/* end of file */
