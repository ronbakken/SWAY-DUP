/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/widgets.dart';

import 'package:inf/protobuf/inf_protobuf.dart';
import 'package:inf/network_mobile/network_manager.dart';
import 'package:inf/screens/loading_network.dart';
import 'package:inf/navigation_bindings/app_onboarding.dart';
import 'package:inf/navigation_bindings/app_business.dart';
import 'package:inf/navigation_bindings/app_influencer.dart';
import 'package:inf/screens/debug_account.dart';

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
