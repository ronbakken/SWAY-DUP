import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';

typedef NetWorkConnectionBuilder = Widget Function(BuildContext context, NetworkConnectionState connectionState);

class ConnectionBuilder extends StatelessWidget {
  final NetWorkConnectionBuilder builder;
  final NetworkConnectionState initialState;

  ConnectionBuilder({
    Key key,
    @required this.builder,
    this.initialState = NetworkConnectionState.connected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NetworkConnectionState>(
      initialData: initialState,
      stream: backend.get<SystemService>().connectionState,
      builder: (BuildContext context, AsyncSnapshot<NetworkConnectionState> snapShot) {
        if (snapShot.hasData) {
          return builder(context, snapShot.data);
        } else {
          return builder(context, NetworkConnectionState.notConnected);
        }
      },
    );
  }
}
