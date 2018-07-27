/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'demo/demo.dart' show DemoApp;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'network/inf.pb.dart';

Future<ConfigData> loadConfig() async {
  var configData = await rootBundle.load('assets/config.bin');
  ConfigData config = new ConfigData();
  config.mergeFromBuffer(configData.buffer.asUint8List());
  return config;
}

launchApp() async {
  // Load well-known config from APK
  ConfigData config = await loadConfig();
  // Run flutter app with the loaded config
  runApp(new DemoApp(
    startupConfig: config,
  ));
}

void main() {
  launchApp();
}

/* end of file */
