/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

/*

TODO: Split of the actual ConfigManager, rename to ConfigProvider for the inheritable, add Stream support for notifying of new ConfigData

*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:inf_common/inf_common.dart';

String translateGlobalAccountStateReason(
    GlobalAccountStateReason globalAccountStateReason) {
  switch (globalAccountStateReason) {
    case GlobalAccountStateReason.newAccount:
      return "Your INF Marketplace account status can not be loaded at the moment."; // // "Your account has not yet been created."; // This is a bug
    case GlobalAccountStateReason.accountBanned:
      return "Your INF Marketplace account has been banned. Please contact support.";
    case GlobalAccountStateReason.createDenied:
      return "Your INF Marketplace account was not approved. Please contact support.";
    case GlobalAccountStateReason.approved:
      return "Welcome to the INF Marketplace. Your account has been approved. Congratulations!";
    case GlobalAccountStateReason.demoApproved:
      return "Welcome to the INF Marketplace. We are delighted to have you as an early tester!";
    case GlobalAccountStateReason.pending:
      return "Your INF Marketplace account is pending approval. Hold on tight!";
    case GlobalAccountStateReason.requireInfo:
      return "We require more information to process your INF Marketplace account. Please contact support.";
  }
  return "There is an issue with your INF Marketplace account. Please contact support.";
}

class ConfigManager extends StatefulWidget {
  const ConfigManager({
    Key key,
    this.startupConfig,
    this.child,
  }) : super(key: key);

  final ConfigData startupConfig;
  final Widget child;

  static ConfigData of(BuildContext context) {
    final _InheritedConfigManager inherited =
        context.inheritFromWidgetOfExactType(_InheritedConfigManager);
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
    if (config.timestamp > this.config.timestamp &&
        config.clientVersion == this.config.clientVersion) {
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
    downloadUrls.add(config.services.configUrl);
    downloadUrls.add(widget.startupConfig.services.configUrl);
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
