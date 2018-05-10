/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'demo.dart' show DemoApp;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'inf.pb.dart';

Future<ConfigData> loadConfig() async {
  var configData = await rootBundle.load('assets/config.bin');
  ConfigData config = new ConfigData();
  config.mergeFromBuffer(configData.buffer.asUint8List());
  return config;
}

launchApp() async {
  ConfigData config = await loadConfig();
  runApp(new DemoApp(
    startupConfig: config,
  ));
}

void main() {
  launchApp();
}

/* end of file */
