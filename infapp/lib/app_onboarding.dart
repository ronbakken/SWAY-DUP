/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'network/inf.pb.dart';
import 'network/config_manager.dart';
import 'network/network_manager.dart';

import 'widgets/oauth_scaffold.dart';
import 'onboarding_selection.dart';
import 'onboarding_social.dart';

// Onboarding sequence
class AppOnboarding extends StatelessWidget {
  void navigateToOAuth(BuildContext context, int oauthProvider) {
    Navigator.push( // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      context,
      new MaterialPageRoute(
        builder: (context) {
          ConfigData config = ConfigManager.of(context);
          NetworkInterface network = NetworkManager.of(context);
          assert(config != null);
          assert(network != null);
          return new OAuthScaffold(
            onOAuthGetParams: () { return network.getOAuthUrls(oauthProvider); },
            onOAuthCallbackResult: (String callbackQuery) { return network.connectOAuth(oauthProvider, callbackQuery); },
            whitelistHosts: config.oauthProviders.all[oauthProvider].whitelistHosts,
          );
        },
      ),
    );
  }

  void navigateToSocial(BuildContext context) {
    Navigator.push( // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      context,
      new MaterialPageRoute(
        builder: (context) {
          ConfigData config = ConfigManager.of(context);
          NetworkInterface network = NetworkManager.of(context);
          bool canSignUp = network.account.detail.socialMedia.any((DataSocialMedia data) => (data.connected && !data.expired));
          assert(config != null);
          assert(network != null);
          return new OnboardingSocial(
            accountType: network.account.state.accountType,
            oauthProviders: config.oauthProviders.all,
            oauthState: network.account.detail.socialMedia,
            onOAuthSelected: (network.connected == NetworkConnectionState.Ready) ? (int oauthProvider) { navigateToOAuth(context, oauthProvider); } : null,
            onSignUp: canSignUp ? () { /*Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Todo")));*/ } : null,
          );
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    NetworkInterface network = NetworkManager.of(context);
    assert(network != null);
    return new OnboardingSelection(
      onInfluencer: network.connected == NetworkConnectionState.Ready ? () { network.setAccountType(AccountType.AT_INFLUENCER); navigateToSocial(context); } : null,
      onBusiness: network.connected == NetworkConnectionState.Ready ? () { network.setAccountType(AccountType.AT_BUSINESS); navigateToSocial(context); } : null,
    );
  }
}

/* end of file */
