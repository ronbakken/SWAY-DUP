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

import 'onboarding_selection.dart';
import 'onboarding_social.dart';

// Onboarding sequence
class AppOnboarding extends StatelessWidget {
  void navigateToOAuth(BuildContext context) {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) {
          ConfigData config = ConfigManager.of(context);
          NetworkInterface network = NetworkManager.of(context);
          assert(config != null);
          assert(network != null);
          return new OnboardingSocial(
            accountType: AccountType.AT_BUSINESS,
            oauthProviders: config.oauthProviders.all,
            oauthState: network.socialMedia,
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
      onInfluencer: network.connected == NetworkConnectionState.Ready ? () { network.setAccountType(AccountType.AT_INFLUENCER); navigateToOAuth(context); } : null,
      onBusiness: network.connected == NetworkConnectionState.Ready ? () { network.setAccountType(AccountType.AT_BUSINESS); navigateToOAuth(context); } : null,
    );
  }
}

/* end of file */
