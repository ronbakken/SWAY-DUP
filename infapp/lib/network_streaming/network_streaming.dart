/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/widgets.dart';
import 'package:inf/network_generic/cross_account_navigator.dart';
import 'package:inf/network_generic/multi_account_store.dart';
import 'package:inf/network_generic/network_manager.dart';
import 'package:inf/network_mobile/config_manager.dart';
import 'package:inf_common/inf_common.dart';

class NetworkStreaming {
  MultiAccountStore _multiAccountStore;
  ConfigManager _configManager;
  CrossAccountNavigator _crossAccountNavigator;
  NetworkManager _networkManager;

  StreamSubscription<LocalAccountData> _onSwitchAccountSubscription;
  StreamSubscription<CrossNavigationRequest> _onNavigationRequestSubscription;

  Function() onNetworkChanged = () {};
  Function() onConfigChanged = () {};

  /// Exposes 'onAccountsChanged' (list of accounts changed)
  /// and account switching / adding functionality.
  MultiAccountClient get multiAccountClient {
    return _multiAccountStore;
  }

  /// Exposes listening to navigation requests
  CrossAccountNavigator get crossAccountNavigator {
    return _crossAccountNavigator;
  }

  /// Current config
  ConfigData get config {
    return _configManager.config;
  }

  /// Network manager
  NetworkManager get networkManager {
    return _networkManager;
  }

  NetworkStreaming({
    @required MultiAccountStore multiAccountStore,
    @required ConfigData startupConfig,
  }) {
    _multiAccountStore = multiAccountStore;

    _configManager = new ConfigManager(
        startupConfig: startupConfig, onChanged: _onConfigChanged);

    _crossAccountNavigator = new CrossAccountNavigator();
    _crossAccountNavigator.multiAccountClient = _multiAccountStore;

    _networkManager = new NetworkManager();
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
    _networkManager.reassembleCommon();
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
    if (config.services.environment != _multiAccountStore.current.environment) {
      throw new Exception("Mismatching environment");
    }
    if (_networkManager.account.state.accountId !=
        _multiAccountStore.current.accountId) {
      throw new Exception("Mismatching account id");
    }
    return _crossAccountNavigator.listen(
      config.services.environment,
      _networkManager.account.state.accountId,
      onData,
    );
  }

  void _onNetworkChanged() {
    onNetworkChanged();
  }

  void _onConfigChanged() {
    _networkManager.updateDependencies(
        _configManager.config, _multiAccountStore);
    onConfigChanged();
  }

  /// A notification from the server was pushed, which may switch to account
  void _onNavigationRequest(CrossNavigationRequest request) {
    _crossAccountNavigator.navigate(
        request.environment, request.accountId, request.target, request.id);
  }

  /// An account switch was requested and the network must now switch accounts
  void _onMultiSwitchAccount(LocalAccountData localAccount) {
    _networkManager.processSwitchAccount(localAccount);
  }
}

/* end of file */
