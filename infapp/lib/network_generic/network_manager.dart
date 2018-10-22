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

  // Hook broadcast streams down here as you need them.
  // Please don't forget to clean up.

  void onProfileChanged(ChangeAction action, Int64 id) {
    onChanged();
  }

  void onOfferChanged(ChangeAction action, Int64 id) {
    onChanged();
  }

  void onOffersBusinessChanged(ChangeAction action, Int64 id) {
    onChanged();
  }

  void onOffersDemoChanged(ChangeAction action, Int64 id) {
    onChanged();
  }

  void onProposalChanged(ChangeAction action, Int64 id) {
    onChanged();
  }

  void onProposalChatChanged(ChangeAction action, DataApplicantChat chat) {
    onChanged();
  }

  // This is called anytime the connection or account state changes (network.account, network.connected)
  void onCommonChanged() {
    onChanged();
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
}
