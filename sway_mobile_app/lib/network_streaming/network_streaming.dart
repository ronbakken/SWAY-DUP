/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/widgets.dart';
import 'package:sway_mobile_app/network_generic/cross_account_navigator.dart';
import 'package:sway_mobile_app/network_generic/multi_account_store.dart';
import 'package:sway_mobile_app/network_generic/api_client.dart';
import 'package:sway_mobile_app/network_mobile/config_downloader.dart';
import 'package:inf_common/inf_common.dart';

class NetworkStreaming {
  MultiAccountStore _multiAccountStore;
  ConfigDownloader _configManager;
  CrossAccountNavigator _crossAccountNavigator;
  ApiClient _networkManager;

  StreamSubscription<LocalAccountData> _onSwitchAccountSubscription;
  StreamSubscription<CrossNavigationRequest> _onNavigationRequestSubscription;

  final StreamController<void> onNetworkChanged =
      StreamController<void>.broadcast(sync: true);
  final StreamController<void> onConfigChanged =
      StreamController<void>.broadcast(sync: true);

  /// Exposes 'onAccountsChanged' (list of accounts changed)
  /// and account switching / adding functionality.
  MultiAccountClient get multiAccount {
    return _multiAccountStore;
  }

  /// Exposes listening to navigation requests coming from the server.
  /// These occur due to pushing notifications or due to external actions.
  CrossAccountNavigator get navigator {
    return _crossAccountNavigator;
  }

  /// Current config
  ConfigData get config {
    return _configManager.config;
  }

  /// Api Client
  Api get api {
    return _networkManager;
  }

  NetworkStreaming({
    @required MultiAccountStore multiAccountStore,
    @required ConfigData startupConfig,
  }) {
    _multiAccountStore = multiAccountStore;

    _configManager = ConfigDownloader(
        startupConfig: startupConfig, onChanged: _onConfigChanged);

    _crossAccountNavigator = CrossAccountNavigator();
    _crossAccountNavigator.multiAccountClient = _multiAccountStore;

    _networkManager = ApiClient();
    _networkManager.onChanged = _onNetworkChanged;
    _networkManager.initialize();
    _networkManager.updateDependencies(
        _configManager.config, _multiAccountStore);

    _onSwitchAccountSubscription =
        _multiAccountStore.onSwitchAccount.listen(_onMultiSwitchAccount);
    _onNavigationRequestSubscription =
        _networkManager.onNavigationRequest.listen(_onNavigationRequest);
  }

  void start() {
    _networkManager.start();
  }

  /// Reloads configuration. Call on developer reassemble.
  void reload() {
    _configManager.reloadConfig();
    _networkManager.accountReassemble();
  }

  void dispose() {
    _onSwitchAccountSubscription.cancel();
    _onSwitchAccountSubscription = null;
    _onNavigationRequestSubscription.cancel();
    _onNavigationRequestSubscription = null;
    // WidgetsBinding.instance.removeObserver(this);
    _networkManager.dispose();
    _crossAccountNavigator.dispose();
  }

  /// App must implement this. Call on didChangeAppLifecycleState
  void setApplicationForeground(bool foreground) {
    _networkManager.setApplicationForeground(foreground);
  }

  StreamSubscription<NavigationRequest> listenNavigation(
      Function(NavigationTarget target, Int64 id) onData) {
    if (config.services.domain != _multiAccountStore.current.domain) {
      throw Exception('Mismatching domain');
    }
    if (_networkManager.account.accountId !=
        _multiAccountStore.current.accountId) {
      throw Exception('Mismatching account id');
    }
    return _crossAccountNavigator.listen(
      config.services.domain,
      _networkManager.account.accountId,
      onData,
    );
  }

  void _onNetworkChanged() {
    onNetworkChanged.add(null);
  }

  void _onConfigChanged() {
    _networkManager.updateDependencies(
        _configManager.config, _multiAccountStore);
    onConfigChanged.add(null);
  }

  /// A notification from the server was pushed, which may switch to account
  void _onNavigationRequest(CrossNavigationRequest request) {
    _crossAccountNavigator.navigate(
        request.domain, request.accountId, request.target, request.id);
  }

  /// An account switch was requested and the network must now switch accounts
  void _onMultiSwitchAccount(LocalAccountData localAccount) {
    _networkManager.processSwitchAccount(localAccount);
  }
}

/* end of file */
