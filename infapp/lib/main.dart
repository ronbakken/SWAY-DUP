/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// WORKAROUND: https://github.com/dart-lang/sdk/issues/33076
import 'package:inf/demo/demo.dart' show DemoApp;
import 'package:inf/network_mobile/cross_account_store.dart';
import 'package:inf/protobuf/inf_protobuf.dart';

Future<ConfigData> loadConfig() async {
  var configData = await rootBundle.load('assets/config.bin');
  ConfigData config = new ConfigData();
  config.mergeFromBuffer(configData.buffer.asUint8List());
  return config;
}

Future<CrossAccountStore> loadCrossAccountStore(String startupDomain) async {
  CrossAccountStore store = new CrossAccountStore();
  await store.initialize(startupDomain);
  return store;
}

launchApp() async {
  // Load well-known config from APK
  ConfigData config = await loadConfig();
  // Load known local accounts from SharedPreferences
  CrossAccountStore crossAccountStore = await loadCrossAccountStore(config.services.domain);
  // Run flutter app with the loaded config
  runApp(new DemoApp(
    startupConfig: config,
    crossAccountStore: crossAccountStore,
  ));
}

void main() {
  launchApp();
}

/* end of file */
