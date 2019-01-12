/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

/*

API Provider
================

Provides access to an instance of a ApiClient.

Provides the ApiClient with some data from the UI context.

*/

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inf/network_generic/api_account.dart';
import 'package:inf/network_generic/api_client.dart';

import 'package:inf/network_inheritable/cross_account_navigation.dart';
import 'package:inf/network_generic/multi_account_store.dart';
import 'package:inf/network_inheritable/config_provider.dart';
import 'package:inf/network_generic/api.dart';
import 'package:inf_common/inf_common.dart';

export 'package:inf/network_generic/api.dart';

class ApiProvider extends StatelessWidget {
  const ApiProvider({
    Key key,
    this.child,
    this.multiAccountStore,
  }) : super(key: key);

  final Widget child;
  final MultiAccountStore multiAccountStore;

  static Api of(BuildContext context) {
    final _InheritedNetworkProvider inherited =
        context.inheritFromWidgetOfExactType(_InheritedNetworkProvider);
    return inherited != null ? inherited.networkInterface : null;
  }

  @override
  Widget build(BuildContext context) {
    final String ks = key.toString();
    final ConfigData config = ConfigProvider.of(context);
    assert(config != null);
    return _NetworkProviderStateful(
      key: (key != null && ks.isNotEmpty) ? Key('$ks.Stateful') : null,
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
  _NetworkProviderState createState() => _NetworkProviderState();
}

class _NetworkProviderState extends State<_NetworkProviderStateful>
    with WidgetsBindingObserver {
  // see ApiClient

  int _changed = 0;

  StreamSubscription<LocalAccountData> _onSwitchAccountSubscription;
  StreamSubscription<CrossNavigationRequest> _onNavigationRequestSubscription;

  ApiClient apiClient;

  // A notification from the server was pushed, which may switch to account
  void _onNavigationRequest(CrossNavigationRequest request) {
    CrossAccountNavigation.of(context).navigate(
        request.domain, request.accountId, request.target, request.id);
  }

  // An account switch was requested and the network must now switch accounts
  void _onMultiSwitchAccount(LocalAccountData localAccount) {
    apiClient.processSwitchAccount(localAccount);
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
    apiClient = ApiClient();
    apiClient.onChanged = _onChanged;
    apiClient.initialize();
    apiClient.updateDependencies(widget.config, widget.multiAccountStore);

    WidgetsBinding.instance.addObserver(this);

    _onSwitchAccountSubscription =
        widget.multiAccountStore.onSwitchAccount.listen(_onMultiSwitchAccount);

    _onNavigationRequestSubscription =
        apiClient.onNavigationRequest.listen(_onNavigationRequest);

    apiClient.start();
  }

  @override
  void reassemble() {
    super.reassemble();
    // Developer reload
    apiClient.accountReassemble();
  }

  @override
  void dispose() {
    _onSwitchAccountSubscription.cancel();
    _onSwitchAccountSubscription = null;
    _onNavigationRequestSubscription.cancel();
    _onNavigationRequestSubscription = null;
    WidgetsBinding.instance.removeObserver(this);
    apiClient.dispose();
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
    apiClient.updateDependencies(widget.config, widget.multiAccountStore);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    apiClient.setApplicationForeground(
        state == AppLifecycleState.resumed ||
            state == AppLifecycleState.inactive);
  }

  @override
  Widget build(BuildContext context) {
    final String ks = widget.key.toString();
    return _InheritedNetworkProvider(
      key:
          (widget.key != null && ks.isNotEmpty) ? Key(ks + '.Inherited') : null,
      networkInterface: apiClient,
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

  final Api networkInterface; // ApiClient remains!
  final int changed;

  @override
  bool updateShouldNotify(_InheritedNetworkProvider old) {
    return changed != old.changed;
  }
}

/* end of file */
