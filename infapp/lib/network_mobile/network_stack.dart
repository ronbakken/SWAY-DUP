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
- config_manager.dart: Configuration loaded from APK or network as part of flutter state.
- cross_account_selection.dart: Account selection as part of flutter state.

Mobile-specific:
- cross_account_store.dart: Stores the collection of known accounts in SharedPreferences.

Generic:
- network_...

*/

import 'package:flutter/widgets.dart';
import 'package:inf/network_mobile/config_manager.dart';
import 'package:inf/network_mobile/cross_account_selection.dart';
import 'package:inf/network_mobile/network_manager.dart';
import 'package:inf/protobuf/inf_protobuf.dart';

class NetworkStack extends StatelessWidget {
  final Widget child;
  final CrossAccountStore crossAccountStore;
  final ConfigData startupConfig;

  const NetworkStack(
      {Key key,
      this.child,
      @required this.crossAccountStore,
      @required this.startupConfig})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new CrossAccountSelection(
      key: const Key('CrossAccountSelection'),
      store: crossAccountStore,
      startupDomain: startupConfig.services.domain,
      child: new ConfigManager(
          key: const Key('ConfigManager'),
          startupConfig: startupConfig,
          child: new NetworkManager(
            key: const Key('NetworkManager'),
            child: child, // new CrossNavigationManager()
          )),
    );
  }
}

/* end of file */
