import 'package:inf/backend/services/connection_service_.dart';
import 'package:rxdart/rxdart.dart';


class ConnectionServiceImplementation implements ConnectionService
{
    @override
    Observable<NetWorkConnectionState> get connectionState => _connectionSubject;

    BehaviorSubject<NetWorkConnectionState> _connectionSubject = new BehaviorSubject<NetWorkConnectionState>();
}