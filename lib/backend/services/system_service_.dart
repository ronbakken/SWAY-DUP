import 'package:flutter/scheduler.dart';
import 'package:rxdart/rxdart.dart';

enum NetworkConnectionState { connected, noNetwork, notConnected, reconnecting }

abstract class SystemService {
  Observable<NetworkConnectionState> get connectionState => null;

  Observable<AppLifecycleState> get appLifecycleState => null;
}
