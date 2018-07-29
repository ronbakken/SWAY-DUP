/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/widgets.dart';

import 'network/network_manager.dart';

// Fullscreen widget while the network is still loading. Shows a swirly progress thingy, and a sad face if the network is offline
class LoadingNetwork extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NetworkInterface network = NetworkManager.of(context);
    assert(network != null);
    return Text("Loading network");
  }
}

/* end of file */
