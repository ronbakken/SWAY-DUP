/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:flutter/widgets.dart';
import 'package:sway_mobile_app/network_inheritable/config_provider.dart';

import 'package:sway_common/inf_common.dart';
import 'package:sway_mobile_app/network_inheritable/api_provider.dart';
import 'package:sway_mobile_app/screens_loading/loading_network.dart';
import 'package:sway_mobile_app/app_composition/app_onboarding.dart';
import 'package:sway_mobile_app/app_composition/app_business.dart';
import 'package:sway_mobile_app/app_composition/app_influencer.dart';
import 'package:sway_mobile_app/screens/debug_account.dart';

// Switches between app home depending on the network state
class AppSwitch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppSwitchState();
  }
}

class _AppSwitchState extends State<AppSwitch> {
  String _domain;
  Int64 _accountId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String domain = ConfigProvider.of(context).services.domain;
    final Int64 accountId = ApiProvider.of(context).account.accountId;
    if (domain != _domain || accountId != _accountId) {
      _domain = domain;
      _accountId = accountId;
      try {
        Navigator.of(context)
            .popUntil(ModalRoute.withName(Navigator.defaultRouteName));
      } catch (error, stackTrace) {
        print('$error\n$stackTrace');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Api network = ApiProvider.of(context);
    assert(network != null);
    if (network.account.sessionId == 0) {
      return LoadingNetwork();
    }
    if (network.account.accountId == 0) {
      return const AppOnboarding();
    }
    if (network.account.accountType == AccountType.influencer) {
      return const AppInfluencer();
    }
    if (network.account.accountType == AccountType.business) {
      return const AppBusiness();
    }
    return DebugAccount(account: network.account);
    // throw new Exception("Invalid account state");
  }
}

/* end of file */
