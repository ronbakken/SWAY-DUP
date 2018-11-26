/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Kenneth Amiel Santos <kennethamiel.santos@gmail.com>
*/

import 'dart:math';

import 'package:flutter/material.dart';

import 'package:inf/widgets/follower_count.dart';
import 'package:inf_common/inf_common.dart';

class FollowerTray extends StatelessWidget {
  FollowerTray({
    Key key,
    this.oauthProviders,
    this.socialMedia,
  }) : super(key: key);

  final List<ConfigOAuthProvider> oauthProviders;
  final List<DataSocialMedia> socialMedia;

  @override
  Widget build(BuildContext context) {
    List<FollowerWidget> followerWidgets = new List<FollowerWidget>();

    for (int i = 1; i < socialMedia.length; i++) {
      if (socialMedia[i].connected) {
        followerWidgets.add(new FollowerWidget(
          oAuthProvider: oauthProviders[i],
          followerCount:
              max(socialMedia[i].followersCount, socialMedia[i].friendsCount),
        ));
      }
    }

    return new Container(
      padding: const EdgeInsets.all(16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: followerWidgets,
      ),
    );
  }
}

/* end of file */
