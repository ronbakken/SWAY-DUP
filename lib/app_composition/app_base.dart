/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf/network_inheritable/cross_account_navigation.dart';
import 'package:inf/network_inheritable/multi_account_selection.dart';
import 'package:inf/network_inheritable/config_provider.dart';
import 'package:inf/network_inheritable/api_provider.dart';
import 'package:inf/widgets/oauth_scaffold.dart';
import 'package:inf_common/inf_common.dart';
import 'package:inf/screens/account_switch.dart';
import 'package:inf/screens/debug_account.dart';
import 'package:inf/screens/haggle_view.dart';
import 'package:inf/screens/profile_view.dart';
import 'package:inf/screens/proposal_list.dart';
import 'package:file/file.dart' as file;
import 'package:file/local.dart' as file;

abstract class AppBaseState<T extends StatefulWidget> extends State<T> {
  void navigateToSwitchAccount() {
    Navigator.push<void>(context, MaterialPageRoute<void>(builder: (context) {
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      ConfigData config = ConfigProvider.of(context);
      // ApiClient network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      MultiAccountClient selection = MultiAccountSelection.of(context);
      return AccountSwitch(
        domain: config.services.domain,
        accounts: selection.accounts,
        onAddAccount: () {
          selection.addAccount();
        },
        onSwitchAccount: (LocalAccountData localAccount) {
          selection.switchAccount(localAccount.domain, localAccount.accountId);
        },
      );
    }));
  }

  Future<void> navigateToOAuthConnect(
    BuildContext context, {
    ConfigOAuthProvider oauthProvider,
    Future<NetOAuthUrl> Function() onOAuthGetParams,
    Future<NetOAuthSecrets> Function() onOAuthGetSecrets,
    Future<NetOAuthConnection> Function(String callbackQuery)
        onOAuthCallbackResult,
  }) async {
    bool connectionAttempted = false;
    if (!connectionAttempted &&
        oauthProvider.providerId == OAuthProviderIds.facebook.value) {
      // Attempt to use Facebook plugin
      connectionAttempted = false;
    }
    if (!connectionAttempted &&
        oauthProvider.providerId == OAuthProviderIds.twitter.value) {
      // Attempt to use Twitter plugin
      connectionAttempted = false;
    }
    if (!connectionAttempted) {
      // Attempt to use generic OAuth
      await Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
            return OAuthScaffold(
              onOAuthGetParams: onOAuthGetParams,
              onOAuthCallbackResult: onOAuthCallbackResult,
              whitelistHosts: oauthProvider.whitelistHosts,
            );
          },
        ),
      );
    }
  }
}

/* end of file */
