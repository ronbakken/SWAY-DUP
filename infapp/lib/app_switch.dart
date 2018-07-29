/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/widgets.dart';

import 'network/inf.pb.dart';
import 'network/network_manager.dart';
import 'loading_network.dart';

// Switches between app home depending on the network state
class AppSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NetworkInterface network = NetworkManager.of(context);
    assert(network != null);
    if (network.accountState.deviceId == 0) {
      return new LoadingNetwork();
    }
    if (network.accountState.accountId == 0) {
      return new Text("Onboarding");
    }
    if (network.accountState.accountType == AccountType.AT_INFLUENCER) {
      return new Text("Influencer");
    }
    if (network.accountState.accountType == AccountType.AT_BUSINESS) {
      return new Text("Business");
    }
    throw new Exception("Invalid account state");
  }
}

/* end of file */
