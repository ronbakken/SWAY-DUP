import 'package:inf/backend/services/system_service_.dart';
import 'package:rxdart/rxdart.dart';
import 'package:connectivity/connectivity.dart';

class SystemServiceImplementation implements SystemService {
  final BehaviorSubject<NetworkConnectionState> _connectionSubject = BehaviorSubject<NetworkConnectionState>();

  final BehaviorSubject<LifecycleState> _appLifecycleSubject = BehaviorSubject<LifecycleState>();

  final Map<ConnectivityResult, NetworkConnectionState> _networkStateTranslator = {
    ConnectivityResult.none: NetworkConnectionState.none,
    ConnectivityResult.mobile: NetworkConnectionState.mobile,
    ConnectivityResult.wifi: NetworkConnectionState.wifi,
  };

  SystemServiceImplementation() {
    Connectivity().onConnectivityChanged.listen((state) {
      connectionState = _networkStateTranslator[state];
      _connectionSubject.add(connectionState);
    });
  }

  @override
  Observable<NetworkConnectionState> get connectionStateChanges => _connectionSubject;

  @override
  Observable<LifecycleState> get appLifecycleState => _appLifecycleSubject;

  @override
  void setLifecycleState(LifecycleState state) {
    _appLifecycleSubject.add(state);
  }


  @override
  NetworkConnectionState connectionState;
}
