/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:inf/protobuf/inf_protobuf.dart';
import 'package:inf/network_generic/multi_account_client.dart';

import 'package:inf/utility/ensure_visible_when_focused.dart';
import 'package:inf/widgets/blurred_network_image.dart';

import 'package:inf/widgets/profile_avatar.dart';
import 'package:inf/widgets/carousel_app_bar.dart';
import 'package:inf/widgets/dark_container.dart';

class AccountSwitch extends StatelessWidget {
  const AccountSwitch({
    Key key,
    @required this.accounts,
    @required this.onSwitchAccount,
    @required this.onAddAccount,
  }) : super(key: key);

  final Iterable<LocalAccountData> accounts;
  final Function(LocalAccountData localAccount) onSwitchAccount;
  final Function() onAddAccount;

  @override
  Widget build(BuildContext context) {
    List<Widget> accountButtons = new List<Widget>();

    for (LocalAccountData localAccount in accounts) {
      accountButtons.add(new RaisedButton(
        child: new Column(
          children: [
            new Text("Domain: " + localAccount.domain.toString()),
            new Text("Local Id: " + localAccount.localId.toString()),
            new Text("Device Id: " + localAccount.deviceId.toString()),
            new Text("Account Id: " + localAccount.accountId.toString()),
            new Text("Account Type: " + localAccount.accountType.toString()),
            new Text("Name: " + localAccount.name.toString()),
            new ProfileAvatar(
              localAccount: localAccount,
              size: 56.0,
            )
          ],
        ),
        onPressed: () {
          Navigator.pop(context);
          onSwitchAccount(localAccount);
        },
      ));
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Switch Account"),
      ),
      body: new ListView(
        children: <Widget>[
          new Column(children: accountButtons),
          new FlatButton(
            child: new Row(children: [new Text('Add Account')]),
            onPressed: () {
              Navigator.pop(context);
              onAddAccount();
            },
          ),
        ],
      ),
    );
  }
}

/* end of file */
