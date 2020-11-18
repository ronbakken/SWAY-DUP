import 'package:rxdart/rxdart.dart';

enum NetworkConnectionState { none, mobile, wifi }

enum LifecycleState { resumed, paused }

abstract class SystemService {

  NetworkConnectionState connectionState;

  Observable<NetworkConnectionState> get connectionStateChanges => null;

  Observable<LifecycleState> get appLifecycleState => null;

  void setLifecycleState(LifecycleState state);
}
