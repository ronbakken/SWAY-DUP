import 'package:inf/backend/services/system_service_.dart';
import 'package:rxdart/rxdart.dart';

class SystemServiceImplementation implements SystemService {
  final BehaviorSubject<NetworkConnectionState> _connectionSubject =
      BehaviorSubject<NetworkConnectionState>();

  final BehaviorSubject<LifecycleState> _appLifecycleSubject =
      BehaviorSubject<LifecycleState>();

  SystemServiceImplementation() {
    //
  }

  @override
  Observable<NetworkConnectionState> get connectionState => _connectionSubject;

  @override
  Observable<LifecycleState> get appLifecycleState => _appLifecycleSubject;

  @override
  void setLifecycleState(LifecycleState state) {
    _appLifecycleSubject.add(state);
  }
}
