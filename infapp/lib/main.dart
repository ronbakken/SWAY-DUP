/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// WORKAROUND: https://github.com/dart-lang/sdk/issues/33076
import 'package:inf/demo.dart' show DemoApp;
import 'package:inf/network_generic/multi_account_store.dart';
import 'package:inf/protobuf/inf_protobuf.dart';

Future<ConfigData> loadConfig() async {
  var configData = await rootBundle.load('assets/config.bin');
  ConfigData config = new ConfigData();
  config.mergeFromBuffer(configData.buffer.asUint8List());
  return config;
}

Future<MultiAccountStore> loadMultiAccountStore(String startupDomain) async {
  MultiAccountStore store = new MultiAccountStore(startupDomain);
  await store.initialize();
  return store;
}

launchApp() async {
  // Load well-known config from APK
  ConfigData config = await loadConfig();
  // Load known local accounts from SharedPreferences
  MultiAccountStore multiAccountStore =
      await loadMultiAccountStore(config.services.domain);

  // Run flutter app with the loaded config
  runApp(new DemoApp(
    startupConfig: config,
    multiAccountStore: multiAccountStore,
  ));

  // Cleanup
  // await multiAccountStore.dispose();
}

void main() {
  launchApp();
}

/* end of file */
