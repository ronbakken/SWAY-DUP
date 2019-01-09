import 'package:inf_api_client/inf_api_client.dart';
import 'package:rxdart/rxdart.dart';

abstract class InfApiClientsService
{
    bool isConnected;
    InfConfigClient configClient;
    InfAuthClient authClient;

    Observable<bool> get connectionChanged;

    void init(String host, int port);

}