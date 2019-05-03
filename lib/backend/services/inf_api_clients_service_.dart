import 'dart:async';
import 'dart:typed_data';

import 'package:inf_api_client/inf_api_client.dart';
import 'package:rxdart/rxdart.dart';

export 'package:inf_api_client/inf_api_client.dart';

abstract class InfApiClientsService {
  bool isConnected;
  InfConfigClient configClient;
  InfAuthClient authClient;
  InfSystemClient systemClient;
  InfBlobStorageClient blobStorageClient;
  InfInvitationCodesClient invitationCodeClient;
  InfUsersClient usersClient;
  InfListClient listClient;
  InfListenClient listenClient;
  InfOffersClient offerClient;
  InfMessagingClient messagingClient;

  Observable<bool> get connectionChanged;

  void init(String host, int port, [ByteData certificates, String certificateAuthority]);

  Future<bool> isServerAlive();
}
