/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inf/network_generic/network_common.dart';
import 'package:inf/network_generic/network_manager.dart';
import 'package:inf/network_generic/network_offers_business.dart';
import 'package:inf/network_generic/network_offers_demo.dart';
import 'package:inf/network_generic/network_proposals.dart';
import 'package:inf/network_mobile/network_notifications.dart';
import 'package:wstalk/wstalk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';
import 'package:pointycastle/pointycastle.dart' as pointycastle;
import 'package:pointycastle/block/aes_fast.dart' as pointycastle;
import 'package:mime/mime.dart';
import 'package:crypto/crypto.dart';
import 'package:crypto/src/digest_sink.dart'; // Necessary for asynchronous hashing.

import 'package:inf/network_inheritable/cross_account_navigation.dart';
import 'package:inf/network_generic/network_offers.dart';
import 'package:inf/network_generic/network_profiles.dart';
import 'package:inf/network_generic/multi_account_store.dart';
import 'package:inf/network_mobile/config_manager.dart';
import 'package:inf/network_generic/network_interface.dart';
import 'package:inf/network_generic/network_internals.dart';
import 'package:inf/protobuf/inf_protobuf.dart';

export 'package:inf/network_generic/network_interface.dart';

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
    networkManager.syncConfig(widget.config);
    networkManager.syncMultiAccountStore(widget.multiAccountStore);

    WidgetsBinding.instance.addObserver(this);

    // Setup sync
    _onSwitchAccountSubscription =
        widget.multiAccountStore.onSwitchAccount.listen(_onMultiSwitchAccount);

    _onNavigationRequestSubscription = networkManager.onNavigationRequest
        .listen((CrossNavigationRequest request) {
      CrossAccountNavigation.of(context).navigate(
          request.domain, request.accountId, request.target, request.id);
    });

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
    networkManager.disposeCommon();
    networkManager.disposeNotifications();
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
    networkManager.syncConfig(widget.config);
    networkManager.syncMultiAccountStore(widget.multiAccountStore);
    networkManager.dependencyChangedCommon();
  }

  void _onMultiSwitchAccount(LocalAccountData localAccount) {
    networkManager.processSwitchAccount(localAccount);
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

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

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
