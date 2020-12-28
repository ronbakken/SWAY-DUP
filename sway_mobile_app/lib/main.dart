/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:sway_mobile_app/network_mobile/config_downloader.dart';

// WORKAROUND: https://github.com/dart-lang/sdk/issues/33076
import 'package:sway_mobile_app/prototype.dart' show Prototype;
import 'package:sway_mobile_app/network_generic/multi_account_store.dart';
import 'package:sway_common/inf_common.dart';
import 'package:logging/logging.dart';

Future<ConfigData> loadConfig() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ByteData configData = await rootBundle.load('assets/config.bin');
  final ConfigData config = ConfigData();
  config.mergeFromBuffer(configData.buffer.asUint8List());
  ConfigDownloader.process(config);
  config.freeze();
  return config;
}

Future<MultiAccountStore> loadMultiAccountStore(String startupDomain) async {
  final MultiAccountStore store = MultiAccountStore(startupDomain);
  await store.initialize();
  return store;
}

Future<void> launchApp() async {
  // Set up logging options
  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    if (rec.error == null) {
      print(
          '${rec.loggerName}: ${rec.level.name}: ${rec.time}: ${rec.message}');
    } else {
      print(
          '${rec.loggerName}: ${rec.level.name}: ${rec.time}: ${rec.message}\n${rec.error.toString()}\n${rec.stackTrace.toString()}');
    }
  });
  Logger('Inf').level = Level.ALL;
  Logger('Inf.Api').level = Level.ALL;
  Logger('Inf.Config').level = Level.ALL;
  Logger('Switchboard').level = Level.ALL;
  Logger('Switchboard.Mux').level = Level.ALL;
  Logger('Switchboard.Talk').level = Level.INFO;
  Logger('Switchboard.Router').level = Level.ALL;

  // Load well-known config from APK
  final ConfigData config = await loadConfig();
  config.freeze();
  // Override starting configuration endPoint
  // Load known local accounts from SharedPreferences
  final MultiAccountStore multiAccountStore =
      await loadMultiAccountStore(config.services.domain);

  // Run flutter app with the loaded config
  runApp(Prototype(
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
