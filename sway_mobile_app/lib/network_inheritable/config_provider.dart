/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inf/network_mobile/config_downloader.dart';

import 'package:inf_common/inf_common.dart' show ConfigData;

class ConfigProvider extends StatefulWidget {
  const ConfigProvider({
    Key key,
    this.startupConfig,
    this.child,
  }) : super(key: key);

  final ConfigData startupConfig;
  final Widget child;

  static ConfigData of(BuildContext context) {
    final _InheritedConfigProvider inherited =
        context.inheritFromWidgetOfExactType(_InheritedConfigProvider);
    //assert(inherited != null);
    return inherited != null ? inherited.config : null;
  }

  @override
  _ConfigProviderState createState() => _ConfigProviderState();
}

class _ConfigProviderState extends State<ConfigProvider> {
  ConfigDownloader manager;

  @override
  void initState() {
    super.initState();
    manager = ConfigDownloader(
        startupConfig: widget.startupConfig,
        onChanged: () {
          setState(() {});
        });
  }

  @override
  void reassemble() {
    super.reassemble();
    manager.reloadConfig();
  }

  @override
  void dispose() {
    // ...
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedConfigProvider(
      config: manager.config,
      child: widget.child,
    );
  }
}

class _InheritedConfigProvider extends InheritedWidget {
  const _InheritedConfigProvider({
    Key key,
    @required this.config,
    @required Widget child,
  }) : /*assert(config != null),*/
        super(key: key, child: child);

  final ConfigData config;

  @override
  bool updateShouldNotify(_InheritedConfigProvider old) => config != old.config;
}

/* end of file */
