/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';
import 'package:sway_mobile_app/network_generic/multi_account_client.dart';
import 'package:sway_mobile_app/widgets/profile_avatar.dart';

class AccountSwitch extends StatelessWidget {
  const AccountSwitch({
    Key key,
    @required this.domain,
    @required this.accounts,
    @required this.onSwitchAccount,
    @required this.onAddAccount,
  }) : super(key: key);

  final String domain;
  final Iterable<LocalAccountData> accounts;
  final Function(LocalAccountData localAccount) onSwitchAccount;
  final Function() onAddAccount;

  @override
  Widget build(BuildContext context) {
    List<Widget> accountButtons = List<Widget>();

    for (LocalAccountData localAccount in accounts.toList()
      ..sort((a, b) {
        int c = a.domain.compareTo(b.domain);
        if (c != 0)
          return c;
        else
          return a.localId.compareTo(b.localId);
      })) {
      // Zero account id should not be displayed.
      // When using addAccount, if there's a 0 account id, that one will be used.
      if (localAccount.accountId != 0) {
        accountButtons.add(RaisedButton(
          child: Column(
            children: [
              // Domain is like the release channel.
              // Accounts from different domains only occur on development devices, or for the QA team, and MUST have some special marker.
              Text("Domain: " +
                  localAccount.domain.toString() +
                  (domain == localAccount.domain ? " (current)" : " (other)")),
              Text("Local Id: " + localAccount.localId.toString()),
              Text("Session Id: " + localAccount.sessionId.toString()),
              Text("Account Id: " + localAccount.accountId.toString()),
              Text("Account Type: " + localAccount.accountType.toString()),
              Text("Name: " + localAccount.name.toString()),
              ProfileAvatar(
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Switch Account"),
      ),
      body: ListView(
        children: <Widget>[
          Column(children: accountButtons),
          FlatButton(
            child: Row(children: [Text('Add Account')]),
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
