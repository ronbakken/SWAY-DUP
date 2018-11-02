import 'package:inf/backend/services/connection_service_.dart';
import 'package:rxdart/rxdart.dart';


class ConnectionServiceImplementation implements ConnectionService
{
    @override
    Observable<ConnectionState> get connectionState => _connectionSubject;

    BehaviorSubject<ConnectionState> _connectionSubject = new BehaviorSubject<ConnectionState>();
}