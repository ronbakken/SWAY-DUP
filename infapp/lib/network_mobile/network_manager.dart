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

// TODO: Reassemble should re-merge all protobuf

class NetworkManager extends StatelessWidget {
  const NetworkManager({
    Key key,
    this.child,
    this.multiAccountStore,
  }) : super(key: key);

  final Widget child;
  final MultiAccountStore multiAccountStore;

  static NetworkInterface of(BuildContext context) {
    final _InheritedNetworkManager inherited =
        context.inheritFromWidgetOfExactType(_InheritedNetworkManager);
    return inherited != null ? inherited.networkInterface : null;
  }

  @override
  Widget build(BuildContext context) {
    String ks = key.toString();
    ConfigData config = ConfigManager.of(context);
    assert(config != null);
    return new _NetworkManagerStateful(
      key: (key != null && ks.length > 0) ? new Key('$ks.Stateful') : null,
      networkManager: this,
      child: child,
      config: config,
      multiAccountStore: multiAccountStore,
    );
  }
}

class _NetworkManagerStateful extends StatefulWidget {
  const _NetworkManagerStateful({
    Key key,
    this.networkManager,
    this.child,
    this.config,
    this.multiAccountStore,
  }) : super(key: key);

  final NetworkManager networkManager;
  final Widget child;
  final ConfigData config;
  final MultiAccountStore multiAccountStore;

  @override
  _NetworkManagerState createState() => new _NetworkManagerState();
}

class _NetworkManagerState extends State<_NetworkManagerStateful>
    with
        WidgetsBindingObserver,
        NetworkProfiles,
        NetworkOffers,
        NetworkOffersBusiness,
        NetworkOffersDemo,
        NetworkProposals,
        NetworkCommon,
        NetworkNotifications
    implements NetworkInterface, NetworkInternals {
  // see NetworkInterface

  int _changed = 0;

  void onProfileChanged(ChangeAction action, Int64 id) {
    setState(() {
      ++_changed;
    });
  }

  void onOfferChanged(ChangeAction action, Int64 id) {
    setState(() {
      ++_changed;
    });
  }

  void onOffersBusinessChanged(ChangeAction action, Int64 id) {
    setState(() {
      ++_changed;
    });
  }

  void onOffersDemoChanged(ChangeAction action, Int64 id) {
    setState(() {
      ++_changed;
    });
  }

  void onProposalChanged(ChangeAction action, Int64 id) {
    setState(() {
      ++_changed;
    });
  }

  void onProposalChatChanged(ChangeAction action, DataApplicantChat chat) {
    setState(() {
      ++_changed;
    });
  }

  void onCommonChanged() {
    setState(() {
      ++_changed;
    });
  }

  StreamSubscription<LocalAccountData> _onSwitchAccountSubscription;
  StreamSubscription<CrossNavigationRequest> _onNavigationRequestSubscription;

  @override
  void initState() {
    super.initState();

    // Initialize base dependencies
    commonInitBase();
    syncConfig(widget.config);
    syncMultiAccountStore(widget.multiAccountStore);

    // Setup sync
    _onSwitchAccountSubscription =
        widget.multiAccountStore.onSwitchAccount.listen(_onMultiSwitchAccount);

    // Initialize notifications
    initNotifications();
    _onNavigationRequestSubscription =
        onNavigationRequest.listen((CrossNavigationRequest request) {
      CrossAccountNavigation.of(context).navigate(
          request.domain, request.accountId, request.target, request.id);
    });

    WidgetsBinding.instance.addObserver(this);

    // Start the network
    commonInitReady();
  }

  @override
  void reassemble() {
    super.reassemble();
    // Developer reload
    reassembleCommon();
  }

  @override
  void dispose() {
    _onSwitchAccountSubscription.cancel();
    _onSwitchAccountSubscription = null;
    WidgetsBinding.instance.removeObserver(this);
    disposeCommon();
    disposeNotifications();
    super.dispose();
  }

  @override
  void didUpdateWidget(_NetworkManagerStateful oldWidget) {
    // Called before build(), may change/update any state here without calling setState()
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // Called before build(), may change/update any state here without calling setState()
    super.didChangeDependencies();
    syncConfig(widget.config);
    syncMultiAccountStore(widget.multiAccountStore);
    dependencyChangedCommon();
  }

  void _onMultiSwitchAccount(LocalAccountData localAccount) {
    processSwitchAccount(localAccount);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setApplicationForeground(state == AppLifecycleState.resumed ||
        state == AppLifecycleState.inactive);
  }

  @override
  Widget build(BuildContext context) {
    String ks = widget.key.toString();
    return new _InheritedNetworkManager(
      key: (widget.key != null && ks.length > 0)
          ? new Key(ks + '.Inherited')
          : null,
      networkInterface: this,
      changed: _changed,
      child: widget.child,
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

class _InheritedNetworkManager extends InheritedWidget {
  const _InheritedNetworkManager({
    Key key,
    @required this.networkInterface,
    @required this.changed,
    @required Widget child,
  }) : super(key: key, child: child);

  final NetworkInterface networkInterface; // NetworkInterface remains!
  final int changed;

  @override
  bool updateShouldNotify(_InheritedNetworkManager old) {
    return this.changed != old.changed;
  }
}

/* end of file */
