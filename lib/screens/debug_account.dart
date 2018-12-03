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
          new Text("Account", style: Theme.of(context).textTheme.display1),
          new Text("$account"),
          new Divider(),
          new Text("Avatar", style: Theme.of(context).textTheme.display1),
          account.avatarUrl == null || account.avatarUrl.isEmpty
              ? null
              : new Image(image: new NetworkImage(account.avatarUrl)),
          new Divider(),
          new Text("Covers", style: Theme.of(context).textTheme.display1),
        ]
          ..removeWhere((widget) => widget == null)
          ..addAll(account.coverUrls
              .map((coverUrl) => new Image(image: new NetworkImage(coverUrl)))),
      ),
    );
  }
}

/* end of file */
