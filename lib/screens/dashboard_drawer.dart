/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:inf/widgets/blurred_network_image.dart';

import 'package:inf_common/inf_common.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({
    Key key,
    @required this.account,
    @required this.onNavigateProfile,
    @required this.onNavigateHistory,
    @required this.onNavigateSwitchAccount,
    @required this.onNavigateDebugAccount,
  }) : super(key: key);

  final DataAccount account;

  final Function() onNavigateProfile;
  final Function() onNavigateHistory;
  final Function() onNavigateSwitchAccount;
  final Function() onNavigateDebugAccount;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Material(
                  elevation: 4.0, // Match AppBar
                  color: Theme.of(context).primaryColor,
                  child: Stack(children: <Widget>[
                    Positioned.fill(
                      child: BlurredNetworkImage(
                        url: account.avatarUrl,
                        blurredUrl: account.blurredAvatarUrl,
                        placeholderAsset: 'assets/placeholder_photo.png',
                      ),
                    ),
                    SafeArea(
                        // child: new Text("Hello world"),
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                                margin:
                                    const EdgeInsets.fromLTRB(56.0, 16.0, 16.0, 16.0),
                                child: Text(
                                  account.name,
                                  style:
                                      Theme.of(context).primaryTextTheme.title,
                                ))))
                  ]))),
          FlatButton(
            child: Row(children: <Widget>[
              Container(
                margin: const EdgeInsets.all(16.0),
                child: const Icon(Icons.account_circle),
              ),
              const Text('Profile')
            ]),
            onPressed: (onNavigateProfile != null)
                ? () {
                    Navigator.pop(context);
                    onNavigateProfile();
                  }
                : null,
          ),
          FlatButton(
            child: Row(children: <Widget>[
              Container(
                margin: const EdgeInsets.all(16.0),
                child: const Icon(Icons.history),
              ),
              const Text('History')
            ]),
            onPressed: (onNavigateHistory != null)
                ? () {
                    Navigator.pop(context);
                    onNavigateHistory();
                  }
                : null,
          ),
          FlatButton(
            child: Row(children: <Widget>[
              Container(
                margin: const EdgeInsets.all(16.0),
                child: const Icon(Icons.supervisor_account),
              ),
              const Text('Switch User')
            ]),
            onPressed: (onNavigateSwitchAccount != null)
                ? () {
                    Navigator.pop(context);
                    onNavigateSwitchAccount();
                  }
                : null,
          ),
          (account.globalAccountState.value >= GlobalAccountState.debug.value)
              ? FlatButton(
                  child: Row(children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(16.0),
                      child: const Icon(Icons.account_box),
                    ),
                    const Text('Debug Account')
                  ]),
                  onPressed: (onNavigateDebugAccount != null)
                      ? () {
                          Navigator.pop(context);
                          onNavigateDebugAccount();
                        }
                      : null,
                )
              : null,
        ].where((Widget w) => w != null).toList(),
      ),
    );
  }
}
/* end of file */
