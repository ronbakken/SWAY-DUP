/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

import 'package:sway_mobile_app/network_inheritable/api_provider.dart';
import 'package:logging/logging.dart';

class NetworkStatus extends StatelessWidget {
  NetworkStatus({Key key}) : super(key: key);

  static Widget buildOptional(BuildContext context, [Widget alternative]) {
    final Api network = ApiProvider.of(context);
    switch (network.connected) {
      case NetworkConnectionState.ready:
        if (network.account.accountId == Int64.ZERO) {
          return alternative;
        }
        switch (network.receiving) {
          case NetworkConnectionState.ready:
            return alternative;
          default:
            return NetworkStatus().build(context);
        }
        break; //< Required by linter bug
      default:
        return NetworkStatus().build(context);
    }
  }

  static final Widget _minimalContainer = Container(width: 0.0, height: 0.0);
  static final Widget _progressIndicator = LinearProgressIndicator();
  static final Widget _offlineBuilder = Builder(builder: (context) {
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
  static final Widget _failingBuilder = Builder(builder: (context) {
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
    // Logger('Inf.NetworkStatus').finest('Connected: ${network.connected}, Receiving: ${network.receiving}');
    switch (network.connected) {
      case NetworkConnectionState.ready:
        if (network.account.accountId == Int64.ZERO) {
          return _minimalContainer;
        }
        switch (network.receiving) {
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
        break; //< Required by linter bug
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
