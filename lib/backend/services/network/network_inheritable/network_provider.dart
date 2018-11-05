/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

/*

Network Provider
================

Provides access to an instance of a NetworkInterface.

Provides the NetworkInterface with some data from the UI context.

*/

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inf/backend/services/network/network_generic/network_common.dart';
import 'package:inf/backend/services/network/network_generic/network_manager.dart';

import 'package:inf/backend/services/network/network_inheritable/cross_account_navigation.dart';
import 'package:inf/backend/services/network/network_generic/multi_account_store.dart';
import 'package:inf/backend/services/network/network_mobile/config_manager.dart';
import 'package:inf/backend/services/network/network_generic/network_interface.dart';
import 'package:inf/backend/services/network/protobuf/inf_protobuf.dart';

export 'package:inf/backend/services/network/network_generic/network_interface.dart';

class NetworkProvider extends StatelessWidget {
  const NetworkProvider({
    Key key,
    this.child,
    this.multiAccountStore,
  }) : super(key: key);

  final Widget child;
  final MultiAccountStore multiAccountStore;

  static NetworkInterface of(BuildContext context) {
    final _InheritedNetworkProvider inherited =
        context.inheritFromWidgetOfExactType(_InheritedNetworkProvider);
    return inherited != null ? inherited.networkInterface : null;
  }

  @override
  Widget build(BuildContext context) {
    String ks = key.toString();
    ConfigData config = ConfigManager.of(context);
    assert(config != null);
    return new _NetworkProviderStateful(
      key: (key != null && ks.length > 0) ? new Key('$ks.Stateful') : null,
      child: child,
      config: config,
      multiAccountStore: multiAccountStore,
    );
  }
}

class _NetworkProviderStateful extends StatefulWidget {
  const _NetworkProviderStateful({
    Key key,
    this.child,
    this.config,
    this.multiAccountStore,
  }) : super(key: key);

  final Widget child;
  final ConfigData config;
  final MultiAccountStore multiAccountStore;

  @override
  _NetworkProviderState createState() => new _NetworkProviderState();
}

class _NetworkProviderState extends State<_NetworkProviderStateful>
    with WidgetsBindingObserver {
  // see NetworkInterface

  int _changed = 0;

  StreamSubscription<LocalAccountData> _onSwitchAccountSubscription;
  StreamSubscription<CrossNavigationRequest> _onNavigationRequestSubscription;

  NetworkManager networkManager;

  // A notification from the server was pushed, which may switch to account
  void _onNavigationRequest(CrossNavigationRequest request) {
    CrossAccountNavigation.of(context).navigate(
        request.domain, request.accountId, request.target, request.id);
  }

  // An account switch was requested and the network must now switch accounts
  void _onMultiSwitchAccount(LocalAccountData localAccount) {
    networkManager.processSwitchAccount(localAccount);
  }

  // Signals all dependencies using InheritedWidget to rebuild from the latest data
  void _onChanged() {
    setState(() {
      ++_changed;
    });
  }

  @override
  void initState() {
    super.initState();
    networkManager = new NetworkManager();
    networkManager.onChanged = _onChanged;
    networkManager.initialize();
    networkManager.updateDependencies(widget.config, widget.multiAccountStore);

    WidgetsBinding.instance.addObserver(this);

    _onSwitchAccountSubscription =
        widget.multiAccountStore.onSwitchAccount.listen(_onMultiSwitchAccount);

    _onNavigationRequestSubscription =
        networkManager.onNavigationRequest.listen(_onNavigationRequest);

    networkManager.start();
  }

  @override
  void reassemble() {
    super.reassemble();
    // Developer reload
    networkManager.reassembleCommon();
  }

  @override
  void dispose() {
    _onSwitchAccountSubscription.cancel();
    _onSwitchAccountSubscription = null;
    _onNavigationRequestSubscription.cancel();
    _onNavigationRequestSubscription = null;
    WidgetsBinding.instance.removeObserver(this);
    networkManager.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_NetworkProviderStateful oldWidget) {
    // Called before build(), may change/update any state here without calling setState()
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // Called before build(), may change/update any state here without calling setState()
    super.didChangeDependencies();
    networkManager.updateDependencies(widget.config, widget.multiAccountStore);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    networkManager.setApplicationForeground(
        state == AppLifecycleState.resumed ||
            state == AppLifecycleState.inactive);
  }

  @override
  Widget build(BuildContext context) {
    String ks = widget.key.toString();
    return new _InheritedNetworkProvider(
      key: (widget.key != null && ks.length > 0)
          ? new Key(ks + '.Inherited')
          : null,
      networkInterface: networkManager,
      changed: _changed,
      child: widget.child,
    );
  }
}

class _InheritedNetworkProvider extends InheritedWidget {
  const _InheritedNetworkProvider({
    Key key,
    @required this.networkInterface,
    @required this.changed,
    @required Widget child,
  }) : super(key: key, child: child);

  final NetworkInterface networkInterface; // NetworkInterface remains!
  final int changed;

  @override
  bool updateShouldNotify(_InheritedNetworkProvider old) {
    return this.changed != old.changed;
  }
}

/* end of file */
