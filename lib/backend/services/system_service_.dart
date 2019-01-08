import 'package:rxdart/rxdart.dart';

enum NetworkConnectionState { connected, noNetwork, notConnected, reconnecting }

enum LifecycleState { resumed, paused }

abstract class SystemService {
  Observable<NetworkConnectionState> get connectionState => null;

  Observable<LifecycleState> get appLifecycleState => null;

  void setLifecycleState(LifecycleState state);
}
