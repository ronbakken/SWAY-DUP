import 'dart:async';

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
  @override
  InfBlobStorageClient blobStorageClient;
  @override
  InfInvitationCodesClient invitationCodeClient;
  @override
  InfUsersClient usersClient;

  ClientChannel channel;

  String host;
  int port;

  @override
  Observable<bool> get connectionChanged => _connectionChangedSubject.distinct();

  final BehaviorSubject<bool> _connectionChangedSubject = BehaviorSubject<bool>();

  StreamSubscription _networkStateSubscription;
  StreamSubscription _serverPeriodicCheckSubscription;

  InfApiClientsServiceImplementation();

  @override
  void init(String host, port) {
    _networkStateSubscription =
        backend.get<SystemService>().connectionStateChanges.debounce(Duration(seconds: 2)).listen((state) async {
      // if we have a network connection check if the server is online
      if (state != NetworkConnectionState.none) {
        if (await backend.get<InfApiClientsService>().isServerAlive()) {
          _connectionChangedSubject.add(true);
          return;
        }
        await _serverPeriodicCheckSubscription?.cancel();
        _serverPeriodicCheckSubscription = Observable.periodic(Duration(seconds: 10)).startWith(0).listen((_) async {
          // try to reach the server
          if (await backend.get<InfApiClientsService>().isServerAlive()) {
            _connectionChangedSubject.add(true);
            await _serverPeriodicCheckSubscription?.cancel();
          } else {
            _connectionChangedSubject.add(false);
          }
        });
      } else {
        _connectionChangedSubject.add(false);
      }
    });
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
    blobStorageClient = InfBlobStorageClient(channel);
    invitationCodeClient = InfInvitationCodesClient(channel);
    usersClient = InfUsersClient(channel);
  }

  @override
  Future<bool> isServerAlive() async {
    try {
      var result = await systemClient.pingServer(Empty(), options: CallOptions(timeout: const Duration(seconds: 5)));
      if (result is AliveMessage) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
