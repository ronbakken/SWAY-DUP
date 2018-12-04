/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/api_client_offer.dart';
import 'package:inf/network_generic/network_common.dart';
import 'package:inf/network_generic/network_offers_business.dart';
import 'package:inf/network_generic/network_offers_demo.dart';
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
        NetworkOffersBusiness,
        NetworkOffersDemo,
        NetworkProposals,
        NetworkCommon,
        NetworkNotifications
    implements ApiClient, NetworkInternals {
  Function() onChanged = () {};

  // Implement broadcast streams down here as you need them.
  // Please don't forget to clean up.

  @override
  Stream<Change<Int64>> get profileChanged {
    return _profileChanged.stream;
  }

  @override
  Stream<Change<Int64>> get offerChanged {
    return _offerChanged.stream;
  }

  @override
  Stream<void> get offersChanged {
    return _offersChanged.stream;
  }

  @override
  Stream<Change<Int64>> get offerDemoChanged {
    return _offerDemoChanged.stream;
  }

  @override
  Stream<Change<Int64>> get offerProposalChanged {
    return _offerProposalChanged.stream;
  }

  @override
  Stream<Change<DataProposalChat>> get offerProposalChatChanged {
    return _offerProposalChatChanged.stream;
  }

  @override
  Stream<void> get commonChanged {
    return _commonChanged.stream;
  }

  final StreamController<Change<Int64>> _profileChanged =
      StreamController<Change<Int64>>.broadcast(sync: true);
  final StreamController<Change<Int64>> _offerChanged =
      StreamController<Change<Int64>>.broadcast(sync: true);
  final StreamController<void> _offersChanged =
      StreamController<Change<Int64>>.broadcast(sync: true);
  final StreamController<Change<Int64>> _offerDemoChanged =
      StreamController<Change<Int64>>.broadcast(sync: true);
  final StreamController<Change<Int64>> _offerProposalChanged =
      StreamController<Change<Int64>>.broadcast(sync: true);
  final StreamController<Change<DataProposalChat>> _offerProposalChatChanged =
      StreamController<Change<DataProposalChat>>.broadcast(sync: true);
  final StreamController<void> _commonChanged =
      StreamController<void>.broadcast(sync: true);

  void onProfileChanged(ChangeAction action, Int64 id) {
    onChanged();
    _profileChanged.add(Change<Int64>(action, id));
  }

  void onOfferChanged(ChangeAction action, Int64 id) {
    onChanged();
    _offerChanged.add(Change<Int64>(action, id));
  }

  void onOffersChanged() {
    onChanged();
    _offersChanged.add(null);
  }

  void onOffersDemoChanged(ChangeAction action, Int64 id) {
    onChanged();
    _offerDemoChanged.add(Change<Int64>(action, id));
  }

  void onProposalChanged(ChangeAction action, Int64 id) {
    onChanged();
    _offerProposalChanged.add(Change<Int64>(action, id));
  }

  void onProposalChatChanged(ChangeAction action, DataProposalChat chat) {
    onChanged();
    _offerProposalChatChanged.add(Change<DataProposalChat>(action, chat));
  }

  // This is called anytime the connection or account state changes (network.account, network.connected)
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
    _offerDemoChanged.close();
    _offerProposalChanged.close();
    _offerProposalChatChanged.close();
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
