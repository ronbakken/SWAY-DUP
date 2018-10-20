/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:inf/network_mobile/config_manager.dart';
import 'package:inf/network_mobile/network_manager.dart';
import 'package:inf/protobuf/inf_protobuf.dart';

// Fullscreen widget while the network is still loading. Shows a swirly progress thingy, and a sad face if the network is offline
class LoadingNetwork extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NetworkInterface network = NetworkManager.of(context);
    ConfigData config = ConfigManager.of(context);
    assert(network != null);
    if (network.connected == NetworkConnectionState.Failing) {
      // "Technical issues"
      return new WebviewScaffold(url: config.services.connectionFailedUrl);
    }
    if (network.connected == NetworkConnectionState.Offline) {
      // "Cannot connect to server"
      return new WebviewScaffold(url: config.services.connectionFailedUrl);
    }
    return new Scaffold(
      // Loading network
      body: new SafeArea(
        child: new Stack(
          fit: StackFit.expand,
          children: [
            new IgnorePointer(
              child: new Align(
                alignment: Alignment.topCenter,
                child: new SizedBox(
                  height: kToolbarHeight * 1.5,
                  child: Image(
                      image: new AssetImage("assets/logo_appbar_ext_gray.png")),
                ),
              ),
            ),
            new Center(
              child: new CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

/* end of file */
