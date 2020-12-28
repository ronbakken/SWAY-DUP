/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:sway_mobile_app/network_generic/api.dart';
import 'package:sway_mobile_app/network_generic/api_internals.dart';
import 'package:sway_mobile_app/network_generic/api_account.dart';
import 'package:sway_mobile_app/network_generic/api_profiles.dart';
import 'package:sway_mobile_app/network_generic/api_offers.dart';
import 'package:sway_mobile_app/network_generic/api_proposals.dart';
import 'package:sway_mobile_app/network_generic/api_explore.dart';
import 'package:sway_mobile_app/network_generic/api_push.dart';
import 'package:sway_mobile_app/network_generic/multi_account_store.dart';
import 'package:sway_mobile_app/network_mobile/mobile_notifications.dart';
import 'package:sway_common/inf_common.dart';

export 'package:sway_mobile_app/network_generic/api.dart';

// TODO: Reassemble should re-merge all protobuf, in case protobuf schema changed

class ApiClient
    with
        ApiAccount,
        ApiProfiles,
        ApiOffers,
        ApiProposals,
        ApiExplore,
        ApiPush,
        MobileNotifications
    implements Api, ApiInternals {
  Function() onChanged = () {};

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
    initAccount();
    initProfiles();
    initOffers();
    initProposals();
    initExplore();
    initPush();
    initNotifications();
  }

  void start() {
    // Initialize notifications
    // Start the network
    accountStartSession();
  }

  Future<void> dispose() async {
    disposeNotifications();
    await disposePush();
    disposeExplore();
    disposeProposals();
    disposeOffers();
    disposeProfiles();
    disposeAccount();
    await _profileChanged.close();
    await _offerChanged.close();
    await _offersChanged.close();
    await _demoAllOffersChanged.close();
    await _proposalChanged.close();
    await _proposalChatsChanged.close();
    await _proposalChatNotification.close();
    await _commonChanged.close();
  }

  void updateDependencies(
      ConfigData config, MultiAccountStore multiAccountStore) {
    syncConfig(config);
    syncMultiAccountStore(multiAccountStore);
    accountDependencyChanged();
  }
}

/* end of file */
