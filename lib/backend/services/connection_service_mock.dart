import 'package:inf/backend/services/connection_service_.dart';
import 'package:rxdart/rxdart.dart';


class ConnectionServiceMock implements ConnectionService
{

  BehaviorSubject<ConnectionState> _connectionSubject = new BehaviorSubject<ConnectionState>();

  @override
  Observable<ConnectionState> get connectionState => _connectionSubject;


  ConnectionServiceMock(ConnectionState state)
  {
      _connectionSubject.add(state);
  }
  


}