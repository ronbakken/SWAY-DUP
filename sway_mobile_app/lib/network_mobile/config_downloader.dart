/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/services.dart' show ByteData, rootBundle;

import 'package:sway_common/inf_common.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';

String translateGlobalAccountStateReason(
    GlobalAccountStateReason globalAccountStateReason) {
  switch (globalAccountStateReason) {
    case GlobalAccountStateReason.newAccount:
      return 'Your INF Marketplace account status can not be loaded at the moment.'; // // "Your account has not yet been created."; // This is a bug
    case GlobalAccountStateReason.accountBanned:
      return 'Your INF Marketplace account has been banned. Please contact support.';
    case GlobalAccountStateReason.createDenied:
      return 'Your INF Marketplace account was not approved. Please contact support.';
    case GlobalAccountStateReason.approved:
      return 'Welcome to the INF Marketplace. Your account has been approved. Congratulations!';
    case GlobalAccountStateReason.demoApproved:
      return 'Welcome to the INF Marketplace. We are delighted to have you as an early tester!';
    case GlobalAccountStateReason.pending:
      return 'Your INF Marketplace account is pending approval. Hold on tight!';
    case GlobalAccountStateReason.requireInfo:
      return 'We require more information to process your INF Marketplace account. Please contact support.';
  }
  return 'There is an issue with your INF Marketplace account. Please contact support.';
}

class ConfigDownloader {
  static final Logger log = Logger('Inf.Config');

  final ConfigData startupConfig;
  ConfigData get config {
    return _config;
  }

  ConfigData _config;
  Function() _onChanged;

  ConfigDownloader({
    @required this.startupConfig,
    Function() onChanged,
  }) : _onChanged = onChanged ?? (() {}) {
    _config = startupConfig;
    downloadConfig();
  }

  static void process(ConfigData config) {
    for (ConfigOAuthProvider entry in config.oauthProviders) {
      if (entry.hasForegroundImageId()) {
        entry.foregroundImage = config.assets[entry.foregroundImageId].data;
      }
      if (entry.hasBackgroundImageId()) {
        entry.backgroundImage = config.assets[entry.backgroundImageId].data;
      }
      if (entry.hasMonochromeForegroundImageId()) {
        entry.monochromeForegroundImage =
            config.assets[entry.monochromeForegroundImageId].data;
      }
      if (entry.hasMonochromeBackgroundImageId()) {
        entry.monochromeBackgroundImage =
            config.assets[entry.monochromeBackgroundImageId].data;
      }
    }
    for (ConfigContentFormat entry in config.contentFormats) {
      if (entry.hasForegroundImageId()) {
        entry.foregroundImage = config.assets[entry.foregroundImageId].data;
      }
      if (entry.hasBackgroundImageId()) {
        entry.backgroundImage = config.assets[entry.backgroundImageId].data;
      }
      if (entry.hasMonochromeForegroundImageId()) {
        entry.monochromeForegroundImage =
            config.assets[entry.monochromeForegroundImageId].data;
      }
      if (entry.hasMonochromeBackgroundImageId()) {
        entry.monochromeBackgroundImage =
            config.assets[entry.monochromeBackgroundImageId].data;
      }
    }
    for (ConfigCategory entry in config.categories) {
      if (entry.hasForegroundImageId()) {
        entry.foregroundImage = config.assets[entry.foregroundImageId].data;
      }
      if (entry.hasBackgroundImageId()) {
        entry.backgroundImage = config.assets[entry.backgroundImageId].data;
      }
      if (entry.hasMonochromeForegroundImageId()) {
        entry.monochromeForegroundImage =
            config.assets[entry.monochromeForegroundImageId].data;
      }
      if (entry.hasMonochromeBackgroundImageId()) {
        entry.monochromeBackgroundImage =
            config.assets[entry.monochromeBackgroundImageId].data;
      }
    }
  }

  Future<void> reloadConfig() async {
    final ByteData configData = await rootBundle.load('assets/config.bin');
    final ConfigData config = ConfigData();
    config.mergeFromBuffer(configData.buffer.asUint8List());
    if (config.timestamp > _config.timestamp &&
        config.clientVersion == _config.clientVersion) {
      log.fine('Reloaded config from APK');
      process(config);
      config.freeze();
      _config = config;
      _onChanged();
    } else {
      log.fine('No changes to config detected');
    }
    unawaited(downloadConfig());
  }

  Future<void> downloadConfig() async {
    await Future<void>.delayed(Duration());
    log.info('Downloading updated config... ***TODO***');
    final Set<String> downloadUrls = Set<String>();
    downloadUrls.add(_config.services.configUrl);
    downloadUrls.add(startupConfig.services.configUrl);
    // TODO: Download config
    // TODO: On failure, see if there's a config in cache, use that
    // TODO: Only use cached config if version is okay
    // TODO: Try download again as soon as there is a network connection (re-schedule a few times every minute, I suppose...)
  }
}

/* end of file */
