import 'package:rxdart/rxdart.dart';

enum NetWorkConnectionState {connected, noNetwork, notConnected, reconnecting  }

abstract class ConnectionService
{
    Observable<NetWorkConnectionState> get connectionState => null;

}