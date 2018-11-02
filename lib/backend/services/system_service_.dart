import 'package:flutter/scheduler.dart';
import 'package:rxdart/rxdart.dart';

enum NetWorkConnectionState {connected, noNetwork, notConnected, reconnecting  }

abstract class SystemService
{
    Observable<NetWorkConnectionState> get connectionState => null;

    Observable<AppLifecycleState> get appLifecycleState => null;

}