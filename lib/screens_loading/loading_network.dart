/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:inf/network_inheritable/config_provider.dart';
import 'package:inf/network_inheritable/network_provider.dart';
import 'package:inf_common/inf_common.dart';

// Fullscreen widget while the network is still loading. Shows a swirly progress thingy, and a sad face if the network is offline
class LoadingNetwork extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ApiClient network = NetworkProvider.of(context);
    ConfigData config = ConfigProvider.of(context);
    assert(network != null);
    if (network.connected == NetworkConnectionState.failing) {
      // "Technical issues"
      // TODO: Handle case where WebviewScaffold fails as well!
      // We show a web url in case we need to alert users of maintenance.
      return WebviewScaffold(url: config.services.connectionFailedUrl);
    }
    if (network.connected == NetworkConnectionState.offline) {
      // "Cannot connect to server"
      // TODO: Handle case where WebviewScaffold fails as well!
      // We show a web url in case we need to alert users of maintenance.
      return WebviewScaffold(url: config.services.connectionFailedUrl);
    }
    return Scaffold(
      // Loading network
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: kToolbarHeight * 1.5,
                  child: Image(
                      image: AssetImage("assets/logo_appbar_ext_gray.png")),
                ),
              ),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

/* end of file */
