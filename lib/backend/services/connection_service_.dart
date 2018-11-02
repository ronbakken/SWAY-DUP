import 'package:rxdart/rxdart.dart';

enum ConnectionState {connected, noNetwork, notConnected, reconnecting  }

abstract class ConnectionService
{
    Observable<ConnectionState> get connectionState => null;

}