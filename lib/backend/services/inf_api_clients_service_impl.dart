import 'package:grpc/grpc.dart';
import 'package:inf/backend/services/inf_api_clients_service_.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:inf/backend/backend.dart';

class InfApiClientsServiceImplementation implements InfApiClientsService {
  @override
  bool isConnected;
  @override
  InfConfigClient configClient;
  @override
  InfAuthClient authClient;
  @override
  InfSystemClient systemClient;

  ClientChannel channel;

  String host;
  int port;

  @override
  Observable<bool> get connectionChanged => connectionChangedSubject;

  BehaviorSubject<bool> connectionChangedSubject = BehaviorSubject<bool>();

  InfApiClientsServiceImplementation();

  @override
  void init(String host, port) {
    this.host = host;

    channel = new ClientChannel(
      host,
      port: port,
      options: const ChannelOptions(
        credentials: const ChannelCredentials.insecure(),
      ),
    );

    configClient = InfConfigClient(channel);
    authClient = InfAuthClient(channel);
    systemClient = InfSystemClient(channel);
  }



  @override
  Future<bool> isServerAlive() async {
    try
    {
        var result = await systemClient.pingServer(Empty(), options: CallOptions(timeout: const Duration(seconds: 5)));
        if (result is AliveMessage)
        {
          return true;
        }
    }
    catch (e)
    {
        return false;
    }
    return false;
  }


}
