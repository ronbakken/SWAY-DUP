/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';

import 'package:inf/network_inheritable/network_provider.dart';

class NetworkStatus extends StatelessWidget {
  NetworkStatus({Key key}) : super(key: key);

  static Widget buildOptional(BuildContext context, [Widget alternative]) {
    NetworkInterface network = NetworkProvider.of(context);
    switch (network.connected) {
      case NetworkConnectionState.ready:
        return alternative;
      default:
        return new NetworkStatus().build(context);
    }
  }

  static final _minimalContainer = new Container(width: 0.0, height: 0.0);
  static final _progressIndicator = new LinearProgressIndicator();
  static final _offlineBuilder = new Builder(builder: (context) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new Material(
            color: Theme.of(context).errorColor,
            child: new Padding(
              padding: new EdgeInsets.all(8.0),
              child: Text("Disconnected from the server."),
            ),
          ),
        ),
      ],
    );
  });
  static final _failingBuilder = new Builder(builder: (context) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new Material(
            color: Theme.of(context).errorColor,
            child: new Padding(
              padding: new EdgeInsets.all(8.0),
              child: Text("Disconnected from the server."),
            ),
          ),
        ),
      ],
    );
  });

  @override
  Widget build(BuildContext context) {
    NetworkInterface network = NetworkProvider.of(context);
    switch (network.connected) {
      case NetworkConnectionState.ready:
        return _minimalContainer;
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
