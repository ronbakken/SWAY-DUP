/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Kenneth Amiel Santos <kennethamiel.santos@gmail.com>
*/

import 'dart:math';

import 'package:flutter/material.dart';

import 'package:sway_mobile_app/widgets/follower_count.dart';
import 'package:inf_common/inf_common.dart';

class FollowerTray extends StatelessWidget {
  FollowerTray({
    Key key,
    this.oauthProviders,
    this.socialMedia,
  }) : super(key: key);

  final List<ConfigOAuthProvider> oauthProviders;
  final Map<int, DataSocialMedia> socialMedia;

  @override
  Widget build(BuildContext context) {
    List<FollowerWidget> followerWidgets = List<FollowerWidget>();

    for (DataSocialMedia media in socialMedia.values) {
      if (media.connected) {
        followerWidgets.add(FollowerWidget(
          oAuthProvider: oauthProviders[media.providerId],
          followerCount: max(media.followersCount, media.friendsCount),
        ));
      }
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: followerWidgets,
      ),
    );
  }
}

/* end of file */
