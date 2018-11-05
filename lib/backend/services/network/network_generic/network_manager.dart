/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:inf/backend/services/network/network_generic/network_common.dart';
import 'package:inf/backend/services/network/network_generic/network_offers_business.dart';
import 'package:inf/backend/services/network/network_generic/network_offers_demo.dart';
import 'package:inf/backend/services/network/network_generic/network_proposals.dart';
import 'package:inf/backend/services/network/network_mobile/network_notifications.dart';
import 'package:inf/backend/services/network/network_generic/change.dart';
import 'package:inf/backend/services/network/network_generic/network_offers.dart';
import 'package:inf/backend/services/network/network_generic/network_profiles.dart';
import 'package:inf/backend/services/network/network_generic/multi_account_store.dart';
import 'package:inf/backend/services/network/network_generic/network_interface.dart';
import 'package:inf/backend/services/network/network_generic/network_internals.dart';
import 'package:inf/backend/services/network/protobuf/inf_protobuf.dart';

export 'package:inf/backend/services/network/network_generic/network_interface.dart';

// TODO: Reassemble should re-merge all protobuf

class NetworkManager
    with
        NetworkProfiles,
        NetworkOffers,
        NetworkOffersBusiness,
        NetworkOffersDemo,
        NetworkProposals,
        NetworkCommon,
        NetworkNotifications
    implements NetworkInterface, NetworkInternals {
  Function() onChanged = () {};

  // Implement broadcast streams down here as you need them.
  // Please don't forget to clean up.

  Stream<Change<Int64>> get profileChanged {
    return _profileChanged.stream;
  }

  Stream<Change<Int64>> get offerChanged {
    return _offerChanged.stream;
  }

  Stream<Change<Int64>> get offerBusinessChanged {
    return _offerBusinessChanged.stream;
  }

  Stream<Change<Int64>> get offerDemoChanged {
    return _offerDemoChanged.stream;
  }

  Stream<Change<Int64>> get offerProposalChanged {
    return _offerProposalChanged.stream;
  }

  Stream<Change<DataApplicantChat>> get offerProposalChatChanged {
    return _offerProposalChatChanged.stream;
  }

  Stream<void> get commonChanged {
    return _commonChanged.stream;
  }

  final StreamController<Change<Int64>> _profileChanged =
      new StreamController<Change<Int64>>();
  final StreamController<Change<Int64>> _offerChanged =
      new StreamController<Change<Int64>>();
  final StreamController<Change<Int64>> _offerBusinessChanged =
      new StreamController<Change<Int64>>();
  final StreamController<Change<Int64>> _offerDemoChanged =
      new StreamController<Change<Int64>>();
  final StreamController<Change<Int64>> _offerProposalChanged =
      new StreamController<Change<Int64>>();
  final StreamController<Change<DataApplicantChat>> _offerProposalChatChanged =
      new StreamController<Change<DataApplicantChat>>();
  final StreamController<void> _commonChanged = new StreamController<void>();

  void onProfileChanged(ChangeAction action, Int64 id) {
    onChanged();
    _profileChanged.add(new Change<Int64>(action, id));
  }

  void onOfferChanged(ChangeAction action, Int64 id) {
    onChanged();
    _offerChanged.add(new Change<Int64>(action, id));
  }

  void onOffersBusinessChanged(ChangeAction action, Int64 id) {
    onChanged();
    _offerBusinessChanged.add(new Change<Int64>(action, id));
  }

  void onOffersDemoChanged(ChangeAction action, Int64 id) {
    onChanged();
    _offerDemoChanged.add(new Change<Int64>(action, id));
  }

  void onProposalChanged(ChangeAction action, Int64 id) {
    onChanged();
    _offerProposalChanged.add(new Change<Int64>(action, id));
  }

  void onProposalChatChanged(ChangeAction action, DataApplicantChat chat) {
    onChanged();
    _offerProposalChatChanged.add(new Change<DataApplicantChat>(action, chat));
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
    _offerBusinessChanged.close();
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
