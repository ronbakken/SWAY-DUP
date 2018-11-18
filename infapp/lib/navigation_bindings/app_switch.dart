/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:flutter/widgets.dart';
import 'package:inf/network_mobile/config_manager.dart';

import 'package:inf_common/inf_common.dart';
import 'package:inf/network_inheritable/network_provider.dart';
import 'package:inf/screens_loading/loading_network.dart';
import 'package:inf/navigation_bindings/app_onboarding.dart';
import 'package:inf/navigation_bindings/app_business.dart';
import 'package:inf/navigation_bindings/app_influencer.dart';
import 'package:inf/screens/debug_account.dart';

// Switches between app home depending on the network state
class AppSwitch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AppSwitchState();
  }
}

class _AppSwitchState extends State<AppSwitch> {
  String _environment;
  Int64 _accountId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String environment = ConfigManager.of(context).services.environment;
    Int64 accountId = NetworkProvider.of(context).account.state.accountId;
    if (environment != _environment || accountId != _accountId) {
      _environment = environment;
      _accountId = accountId;
      Navigator.of(context)
          .popUntil(ModalRoute.withName(Navigator.defaultRouteName));
    }
  }

  @override
  Widget build(BuildContext context) {
    NetworkInterface network = NetworkProvider.of(context);
    assert(network != null);
    if (network.account.state.sessionId == 0) {
      return new LoadingNetwork();
    }
    if (network.account.state.accountId == 0) {
      return new AppOnboarding();
    }
    if (network.account.state.accountType == AccountType.influencer) {
      return new AppInfluencer();
    }
    if (network.account.state.accountType == AccountType.business) {
      return new AppBusiness();
    }
    return new DebugAccount(account: network.account);
    // throw new Exception("Invalid account state");
  }
}

/* end of file */
