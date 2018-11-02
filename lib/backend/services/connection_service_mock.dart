import 'package:inf/backend/services/connection_service_.dart';
import 'package:rxdart/rxdart.dart';


class ConnectionServiceMock implements ConnectionService
{

  BehaviorSubject<NetWorkConnectionState> _connectionSubject = new BehaviorSubject<NetWorkConnectionState>();

  @override
  Observable<NetWorkConnectionState> get connectionState => _connectionSubject;


  ConnectionServiceMock(NetWorkConnectionState state)
  {
      _connectionSubject.add(state);
  }
  


}