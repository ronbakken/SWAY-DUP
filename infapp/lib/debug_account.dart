import 'package:flutter/material.dart';

import 'network/inf.pb.dart';

class DebugAccount extends StatelessWidget {

  final DataAccount account;
  
  DebugAccount({
    Key key,
    this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new ListView(
        children: [
          new Text("Debug account", style: Theme.of(context).textTheme.display2),
          new Divider(),
          new Text("State", style: Theme.of(context).textTheme.display1),
          new Text("deviceId: ${account.state.deviceId}"),
          new Text("accountId: ${account.state.accountId}"),
          new Text("accountType: ${account.state.accountType}"),
          new Text("globalAccountState: ${account.state.globalAccountState}"),
          new Text("globalAccountStateReason: ${account.state.globalAccountStateReason}"),
          new Text("notificationFlags: ${account.state.notificationFlags}"),
          new Divider(),
          new Text("Summary", style: Theme.of(context).textTheme.display1),
          new Text("name: ${account.summary.name}"),
          new Text("description: ${account.summary.description}"),
          new Text("location: ${account.summary.location}"),
          new Text("avatarUrl: ${account.summary.avatarUrl}"),
          new Divider(),
          new Text("Detail", style: Theme.of(context).textTheme.display1),
        ]..addAll(account.detail.coverUrls.map((coverUrl) => new Text("coverUrls: $coverUrl")))
        ..addAll(account.detail.categories.map((categoryId) {
          return new Text("categories: TODO");
        }))
        ..addAll(account.detail.socialMedia.map((socialMedia) {
          return new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new Divider(),
              new Text("socialMedia.connected: ${socialMedia.connected}"),
              new Text("socialMedia.expired: ${socialMedia.expired}"),
              new Text("socialMedia.screenName: ${socialMedia.screenName}"),
              new Text("socialMedia.displayName: ${socialMedia.displayName}"),
              new Text("socialMedia.avatarUrl: ${socialMedia.avatarUrl}"),
              new Text("socialMedia.profileUrl: ${socialMedia.profileUrl}"),
              new Text("socialMedia.description: ${socialMedia.description}"),
              new Text("socialMedia.location: ${socialMedia.location}"),
              new Text("socialMedia.url: ${socialMedia.url}"),
              new Text("socialMedia.email: ${socialMedia.email}"),
              new Text("socialMedia.friendsCount: ${socialMedia.friendsCount}"),
              new Text("socialMedia.followersCount: ${socialMedia.followersCount}"),
              new Text("socialMedia.followingCount: ${socialMedia.followingCount}"),
              new Text("socialMedia.postsCount: ${socialMedia.postsCount}"),
              new Text("socialMedia.verified: ${socialMedia.verified}"),
            ],
          );
        })),
      ),
    );
  }

}