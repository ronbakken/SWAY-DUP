/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';

import 'package:sway_common/inf_common.dart';

class DebugAccount extends StatelessWidget {
  final DataAccount account;

  DebugAccount({
    Key key,
    this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView(
        children: [
          Text("Debug account", style: Theme.of(context).textTheme.display2),
          Divider(),
          Text("Account", style: Theme.of(context).textTheme.display1),
          Text("$account"),
          Divider(),
          Text("Avatar", style: Theme.of(context).textTheme.display1),
          account.avatarUrl == null || account.avatarUrl.isEmpty
              ? null
              : Image(image: NetworkImage(account.avatarUrl)),
          Divider(),
          Text("Covers", style: Theme.of(context).textTheme.display1),
        ]
          ..removeWhere((widget) => widget == null)
          ..addAll(account.coverUrls
              .map((coverUrl) => Image(image: NetworkImage(coverUrl)))),
      ),
    );
  }
}

/* end of file */
