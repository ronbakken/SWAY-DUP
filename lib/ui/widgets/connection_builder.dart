import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';

typedef NetWorkConnectionBuilder = Widget Function(BuildContext context, NetWorkConnectionState connectionState);


class ConnectionBuilder extends StatelessWidget {

    final NetWorkConnectionBuilder builder;
    final NetWorkConnectionState initialState;

  ConnectionBuilder({
    Key key,
    @required
    this.builder,
    this.initialState = NetWorkConnectionState.connected
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NetWorkConnectionState>(
      initialData: initialState,
      stream: backend<SystemService>().connectionState,
      builder: (context, snapShot) {
        if (snapShot.hasData) 
        {
          return builder(context,snapShot.data);
        }
        else
        {
          return builder(context,NetWorkConnectionState.notConnected);
        }
      });
  }
}
