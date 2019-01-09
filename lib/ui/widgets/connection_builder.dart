import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';

typedef NetWorkConnectionBuilder = Widget Function(
    BuildContext context, NetworkConnectionState connectionState, Widget child);

class ConnectionBuilder extends StatelessWidget {
  final NetWorkConnectionBuilder builder;
  final NetworkConnectionState initialState;
  final Widget child;

  ConnectionBuilder({
    Key key,
    @required this.builder,
    this.child,
    this.initialState = NetworkConnectionState.wifi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NetworkConnectionState>(
      initialData: initialState,
      stream: backend.get<SystemService>().connectionStateChanges,
      builder: (BuildContext context,
          AsyncSnapshot<NetworkConnectionState> snapShot) {
        if (snapShot.hasData) {
          return builder(context, snapShot.data, child);
        } else {
          return builder(context, NetworkConnectionState.none, child);
        }
      },
    );
  }
}
