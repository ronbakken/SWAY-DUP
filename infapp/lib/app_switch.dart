/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/widgets.dart';

import 'network/inf.pb.dart';
import 'network/network_manager.dart';
import 'loading_network.dart';
import 'app_onboarding.dart';
import 'app_business.dart';
import 'app_influencer.dart';
import 'debug_account.dart';

// Switches between app home depending on the network state
class AppSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NetworkInterface network = NetworkManager.of(context);
    assert(network != null);
    if (network.account.state.deviceId == 0) {
      return new LoadingNetwork();
    }
    if (network.account.state.accountId == 0) {
      return new AppOnboarding();
    }
    if (network.account.state.accountType == AccountType.AT_INFLUENCER) {
      return new AppInfluencer();
    }
    if (network.account.state.accountType == AccountType.AT_BUSINESS) {
      return new AppBusiness();
    }
    return new DebugAccount(account: network.account);
    // throw new Exception("Invalid account state");
  }
}

/* end of file */
