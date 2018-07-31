/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

// import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'inf.pb.dart';

class ConfigManager extends StatefulWidget {
  const ConfigManager({
    Key key,
    this.startupConfig,
    this.child,
  }) : super(key: key);

  final ConfigData startupConfig;
  final Widget child;

  static ConfigData of(BuildContext context) {
    final _InheritedConfigManager inherited = context.inheritFromWidgetOfExactType(_InheritedConfigManager);
    //assert(inherited != null);
    return inherited != null ? inherited.config : null;
  }

  @override
  _ConfigManagerState createState() => new _ConfigManagerState();
}

class _ConfigManagerState extends State<ConfigManager> {
  ConfigData config;

  reloadConfig() async {
    var configData = await rootBundle.load('assets/config.bin');
    ConfigData config = new ConfigData();
    config.mergeFromBuffer(configData.buffer.asUint8List());
    if (config.timestamp > this.config.timestamp
      && config.clientVersion == this.config.clientVersion) {
      setState(() {
        print("[INF] Reloaded config from APK");
        this.config = config;
      });
    } else {
        print("[INF] No changes to config detected");
    }
    downloadConfig();
  }

  downloadConfig() async {
    print("[INF] Downloading updated config... ***TODO***");
    var downloadUrls = new Set<String>();
    downloadUrls.addAll(config.downloadUrls);
    downloadUrls.addAll(widget.startupConfig.downloadUrls);
    // TODO: Download config
    // TODO: On failure, see if there's a config in cache, use that
    // TODO: Only use cached config if version is okay
    // TODO: Try download again as soon as there is a network connection (re-schedule a few times every minute, I suppose...)
  }

  @override
  void initState() {
    super.initState();
    config = widget.startupConfig;
    downloadConfig();
  }

  @override
  void reassemble() { 
    super.reassemble();
    reloadConfig();
  }

  @override
  void dispose() {
    // ...
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedConfigManager(
      config: config,
      child: widget.child,
    );
  }
}

class _InheritedConfigManager extends InheritedWidget {
  const _InheritedConfigManager({
    Key key,
    @required this.config,
    @required Widget child,
  }) : /*assert(config != null),*/
       super(key: key, child: child);

  final ConfigData config;

  @override
  bool updateShouldNotify(_InheritedConfigManager old) => config != old.config;
}

/* end of file */
