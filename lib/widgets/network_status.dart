/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';

import 'package:inf/network_inheritable/api_provider.dart';

class NetworkStatus extends StatelessWidget {
  NetworkStatus({Key key}) : super(key: key);

  static Widget buildOptional(BuildContext context, [Widget alternative]) {
    final Api network = ApiProvider.of(context);
    switch (network.connected) {
      case NetworkConnectionState.ready:
        return alternative;
      default:
        return NetworkStatus().build(context);
    }
  }

  static final _minimalContainer = Container(width: 0.0, height: 0.0);
  static final _progressIndicator = LinearProgressIndicator();
  static final _offlineBuilder = Builder(builder: (context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Material(
            color: Theme.of(context).errorColor,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Disconnected from the server."),
            ),
          ),
        ),
      ],
    );
  });
  static final _failingBuilder = Builder(builder: (context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Material(
            color: Theme.of(context).errorColor,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Disconnected from the server."),
            ),
          ),
        ),
      ],
    );
  });

  @override
  Widget build(BuildContext context) {
    final Api network = ApiProvider.of(context);
    switch (network.connected) {
      case NetworkConnectionState.ready:
        return _minimalContainer;
      case NetworkConnectionState.waiting:
      case NetworkConnectionState.connecting:
        return _progressIndicator;
      case NetworkConnectionState.offline:
        return _offlineBuilder;
      case NetworkConnectionState.failing:
        return _failingBuilder;
      default:
        return _minimalContainer;
    }
  }
}

/* end of file */
