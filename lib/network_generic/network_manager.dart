/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/api_client_demo.dart';
import 'package:inf/network_generic/api_client_offer.dart';
import 'package:inf/network_generic/network_common.dart';
import 'package:inf/network_generic/network_proposals.dart';
import 'package:inf/network_mobile/network_notifications.dart';
import 'package:inf/network_generic/change.dart';
import 'package:inf/network_generic/network_profiles.dart';
import 'package:inf/network_generic/multi_account_store.dart';
import 'package:inf/network_generic/api_client.dart';
import 'package:inf/network_generic/network_internals.dart';
import 'package:inf_common/inf_common.dart';

export 'package:inf/network_generic/api_client.dart';

// TODO: Reassemble should re-merge all protobuf

class NetworkManager
    with
        NetworkProfiles,
        ApiClientOffer,
        NetworkProposals,
        NetworkCommon,
        NetworkNotifications,
        ApiClientDemo
    implements ApiClient, NetworkInternals {
  Function() onChanged = () {};

  // Implement broadcast streams down here as you need them.
  // Please don't forget to clean up.

  @override
  Stream<Int64> get profileChanged {
    return _profileChanged.stream;
  }

  @override
  Stream<Int64> get offerChanged {
    return _offerChanged.stream;
  }

  @override
  Stream<Int64> get proposalChanged {
    return _proposalChanged.stream;
  }

  @override
  Stream<void> get offersChanged {
    return _offersChanged.stream;
  }

  @override
  Stream<void> get demoAllOffersChanged {
    return _demoAllOffersChanged.stream;
  }

  @override
  Stream<void> get proposalsChanged {
    return _proposalsChanged.stream;
  }

  @override
  Stream<Int64> get proposalChatsChanged {
    return _proposalChatsChanged.stream;
  }

  @override
  Stream<DataProposalChat> get proposalChatNotification {
    return _proposalChatNotification.stream;
  }

  @override
  Stream<void> get commonChanged {
    return _commonChanged.stream;
  }

  final StreamController<Int64> _profileChanged =
      StreamController<Int64>.broadcast(sync: true);
  final StreamController<Int64> _offerChanged =
      StreamController<Int64>.broadcast(sync: true);
  final StreamController<Int64> _proposalChanged =
      StreamController<Int64>.broadcast(sync: true);

  final StreamController<void> _offersChanged =
      StreamController<void>.broadcast(sync: true);
  final StreamController<void> _demoAllOffersChanged =
      StreamController<void>.broadcast(sync: true);
  final StreamController<void> _proposalsChanged =
      StreamController<void>.broadcast(sync: true);
  final StreamController<Int64> _proposalChatsChanged =
      StreamController<Int64>.broadcast(sync: true);

  final StreamController<DataProposalChat> _proposalChatNotification =
      StreamController<DataProposalChat>.broadcast();

  final StreamController<void> _commonChanged =
      StreamController<void>.broadcast(sync: true);

  @override
  void onProfileChanged(Int64 id) {
    onChanged();
    _profileChanged.add(id);
  }

  @override
  void onOfferChanged(Int64 id) {
    onChanged();
    _offerChanged.add(id);
  }

  @override
  void onOffersChanged() {
    onChanged();
    _offersChanged.add(null);
  }

  @override
  void onDemoAllOffersChanged() {
    onChanged();
    _demoAllOffersChanged.add(null);
  }

  @override
  void onProposalsChanged() {
    onChanged();
    _proposalsChanged.add(null);
  }

  @override
  void onProposalChanged(Int64 id) {
    onChanged();
    _proposalChanged.add(id);
  }

  @override
  void onProposalChatsChanged(Int64 id) {
    onChanged();
    _proposalChatsChanged.add(id);
  }

  @override
  void onProposalChatNotification(DataProposalChat chat) {
    onChanged();
    _proposalChatNotification.add(chat);
  }

  // This is called anytime the connection or account state changes (network.account, network.connected)
  @override
  void onCommonChanged() {
    onChanged();
    _commonChanged.add(null);
  }

  void initialize() {
    // Initialize base dependencies
    commonInitBase();
  }

  void start() {
    // Initialize notifications
    initNotifications();
    // Start the network
    commonInitReady();
  }

  void dispose() {
    disposeCommon();
    disposeNotifications();
    _profileChanged.close();
    _offerChanged.close();
    _offersChanged.close();
    _demoAllOffersChanged.close();
    _proposalChanged.close();
    _proposalChatsChanged.close();
    _proposalChatNotification.close();
    _commonChanged.close();
  }

  void updateDependencies(
      ConfigData config, MultiAccountStore multiAccountStore) {
    syncConfig(config);
    syncMultiAccountStore(multiAccountStore);
    dependencyChangedCommon();
  }
}

/* end of file */
