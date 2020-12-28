/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

/*

Network Stack
=============

This base widget includes all the classes necessary for managing the network.

Flutter-specific:
- config_downloader.dart: Configuration loaded from APK or network as part of flutter state.
- cross_account_selection.dart: Account selection as part of flutter state.

Mobile-specific:
- cross_account_store.dart: Stores the collection of known accounts in SharedPreferences.

Generic:
- network_...

*/

import 'package:flutter/widgets.dart';
import 'package:sway_mobile_app/network_inheritable/cross_account_navigation.dart';
import 'package:sway_mobile_app/network_inheritable/multi_account_selection.dart';
import 'package:sway_mobile_app/network_inheritable/config_provider.dart';
import 'package:sway_mobile_app/network_generic/multi_account_store.dart';
import 'package:sway_mobile_app/network_inheritable/api_provider.dart';
import 'package:sway_common/inf_common.dart';

class NetworkStack extends StatelessWidget {
  final Widget child;
  final MultiAccountStore multiAccountStore;
  final ConfigData startupConfig;

  const NetworkStack(
      {Key key,
      this.child,
      @required this.multiAccountStore,
      @required this.startupConfig})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiAccountSelection(
      key: const Key('CrossAccountSelection'),
      client: multiAccountStore,
      child: ConfigProvider(
        key: const Key('ConfigProvider'),
        startupConfig: startupConfig,
        child: CrossAccountNavigation(
          key: const Key('CrossAccountNavigation'),
          child: ApiProvider(
            key: const Key('NetworkProvider'),
            multiAccountStore: multiAccountStore,
            child: child,
          ),
        ),
      ),
    );
  }
}

/* end of file */
