/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/services.dart' show rootBundle;

import 'package:inf_common/inf_common.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

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

class ConfigManager {
  static final Logger log = new Logger('Inf.Config');

  final ConfigData startupConfig;
  ConfigData get config {
    return _config;
  }

  ConfigData _config;
  Function() _onChanged;

  ConfigManager({
    @required this.startupConfig,
    Function() onChanged,
  }) : _onChanged = onChanged ?? (() {}) {
    _config = startupConfig;
    downloadConfig();
  }

  Future<void> reloadConfig() async {
    var configData = await rootBundle.load('assets/config.bin');
    ConfigData config = new ConfigData();
    config.mergeFromBuffer(configData.buffer.asUint8List());
    if (config.timestamp > _config.timestamp &&
        config.clientVersion == _config.clientVersion) {
      log.fine("Reloaded config from APK");
      config.freeze();
      _config = config;
      _onChanged();
    } else {
      log.fine("No changes to config detected");
    }
    downloadConfig();
  }

  Future<void> downloadConfig() async {
    log.info("Downloading updated config... ***TODO***");
    var downloadUrls = new Set<String>();
    downloadUrls.add(_config.services.configUrl);
    downloadUrls.add(startupConfig.services.configUrl);
    // TODO: Download config
    // TODO: On failure, see if there's a config in cache, use that
    // TODO: Only use cached config if version is okay
    // TODO: Try download again as soon as there is a network connection (re-schedule a few times every minute, I suppose...)
  }
}

/* end of file */
