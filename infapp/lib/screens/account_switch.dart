/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';
import 'package:inf/network_generic/multi_account_client.dart';
import 'package:inf/widgets/profile_avatar.dart';

class AccountSwitch extends StatelessWidget {
  const AccountSwitch({
    Key key,
    @required this.environment,
    @required this.accounts,
    @required this.onSwitchAccount,
    @required this.onAddAccount,
  }) : super(key: key);

  final String environment;
  final Iterable<LocalAccountData> accounts;
  final Function(LocalAccountData localAccount) onSwitchAccount;
  final Function() onAddAccount;

  @override
  Widget build(BuildContext context) {
    List<Widget> accountButtons = new List<Widget>();

    for (LocalAccountData localAccount in accounts.toList()
      ..sort((a, b) {
        int c = a.environment.compareTo(b.environment);
        if (c != 0)
          return c;
        else
          return a.localId.compareTo(b.localId);
      })) {
      // Zero account id should not be displayed.
      // When using addAccount, if there's a 0 account id, that one will be used.
      if (localAccount.accountId != 0) {
        accountButtons.add(new RaisedButton(
          child: new Column(
            children: [
              // Domain is like the release channel.
              // Accounts from different environments only occur on development devices, or for the QA team, and MUST have some special marker.
              new Text("Domain: " +
                  localAccount.environment.toString() +
                  (environment == localAccount.environment
                      ? " (current)"
                      : " (other)")),
              new Text("Local Id: " + localAccount.localId.toString()),
              new Text("Session Id: " + localAccount.sessionId.toString()),
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
