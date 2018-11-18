/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';

import 'package:inf_common/inf_common.dart';

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
          new Text("Debug account",
              style: Theme.of(context).textTheme.display2),
          new Divider(),
          new Text("State", style: Theme.of(context).textTheme.display1),
          new Text("${account.state}"),
          new Divider(),
          new Text("Summary", style: Theme.of(context).textTheme.display1),
          new Text("${account.summary}"),
          account.summary.avatarThumbnailUrl == null ||
                  account.summary.avatarThumbnailUrl.isEmpty
              ? null
              : new Image(
                  image: new NetworkImage(account.summary.avatarThumbnailUrl)),
          new Divider(),
          new Text("Detail", style: Theme.of(context).textTheme.display1),
          new Text("${account.detail}"),
          account.detail.avatarCoverUrl == null ||
                  account.detail.avatarCoverUrl.isEmpty
              ? null
              : new Image(
                  image: new NetworkImage(account.detail.avatarCoverUrl)),
        ]..removeWhere((widget) => widget == null),
      ),
    );
  }
}

/* end of file */
