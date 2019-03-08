import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:grpc/grpc.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/inf_api_clients_service_.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rxdart/rxdart.dart';

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
  @override
  InfListClient listClient;
  @override
  InfListenClient listenClient;

  @override
  InfOffersClient offerClient;

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
  void init(String host, int port, [ByteData certificates, String certificateAuthority]) {
    _networkStateSubscription =
        backend<SystemService>().connectionStateChanges.debounce(const Duration(seconds: 2)).listen((state) async {
      // if we have a network connection check if the server is online
      if (state != NetworkConnectionState.none) {
        if (await backend<InfApiClientsService>().isServerAlive()) {
          _connectionChangedSubject.add(true);
          return;
        }
        await _serverPeriodicCheckSubscription?.cancel();
        _serverPeriodicCheckSubscription =
            Observable.periodic(const Duration(seconds: 10)).startWith(0).listen((_) async {
          // try to reach the server
          if (await backend<InfApiClientsService>().isServerAlive()) {
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

    ChannelCredentials channelCredentials;
    if (certificates != null) {
      channelCredentials = ChannelCredentials.secure(
        certificates: certificates.buffer.asUint8List(),
        authority: certificateAuthority,
        onBadCertificate: (X509Certificate certificate, String host) {
          print('bad cert: $host\n\tsubject: ${certificate.subject}\n\tissuer: ${certificate.issuer}');
          return false;
        },
      );
    } else {
      channelCredentials = const ChannelCredentials.insecure();
    }

    channel = new ClientChannel(
      host,
      port: port,
      options: ChannelOptions(
        credentials: channelCredentials,
      ),
    );

    configClient = InfConfigClient(channel);
    authClient = InfAuthClient(channel);
    systemClient = InfSystemClient(channel);
    blobStorageClient = InfBlobStorageClient(channel);
    invitationCodeClient = InfInvitationCodesClient(channel);
    usersClient = InfUsersClient(channel);
    listClient = InfListClient(channel);
    listenClient = InfListenClient(channel);
    offerClient = InfOffersClient(channel);
  }

  @override
  Future<bool> isServerAlive() async {
    try {
      var result = await systemClient.pingServer(Empty(), options: CallOptions(timeout: const Duration(seconds: 5)));
      if (result is AliveMessage) {
        return true;
      }
    } catch (e, st) {
      print('$e\n$st');
      return false;
    }
    return false;
  }
}
