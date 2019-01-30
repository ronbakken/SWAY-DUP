import 'dart:async';
import 'dart:typed_data';

import 'package:inf_api_client/inf_api_client.dart';
import 'package:grpc/grpc.dart';

ApiTester apiTester = ApiTester();

class ApiTester {
  ClientChannel channel;
  InfConfigClient configClient;
  InfSystemClient systemClient;
  InfAuthClient authClient;
  InfBlobStorageClient blobStorageClient;

  String refreshToken;
  String accesToken;

  void connectToServer(String host, int port) async {
    channel?.terminate();
    channel = new ClientChannel(
      host,
      port: port,
      options: const ChannelOptions(
        credentials: const ChannelCredentials.insecure(),
      ),
    );
    (await channel.getConnection()).onStateChanged = (ClientConnection connection) {
      print('onStateChanged: ${connection.state}');
    };

    configClient = InfConfigClient(channel);
    systemClient = InfSystemClient(channel);
    authClient = InfAuthClient(channel);
    blobStorageClient = InfBlobStorageClient(channel);

    var result = await configClient.getVersions(Empty());
    print("Connected");
    print("Versions:");
    print(result.toDebugString());
  }

  Future<Uint8List> getAppConfig() async {
    var result = await configClient.getAppConfig(Empty());
    print("AppConfig:");
    print(result.toDebugString());
    print("${result.appConfigData.categories.length} Categories");
    print(result.appConfigData.categories.first.iconData.length.toString());
    return Uint8List.fromList(result.appConfigData.categories.first.iconData);
  }

  Future<void> ping() async
  {
    var result = await systemClient.pingServer(Empty());
    if (result is AliveMessage)
    {
      print('Alive');
    }
  }

  StreamSubscription welcomeImageSubscription;
  static int count = 0;

  void listenToWelcomeImages() {
    final caller = configClient.hashCode.toRadixString(16);
    welcomeImageSubscription = configClient.getWelcomeImages(Empty()).listen((images) {
      count++;
      print('response $caller $count: ${images.imageUrls.length}');
    }, onError: onError);
  }

  void onError(error) {
    print('welcome error: $error');
  }

  void stopWelcomeImages() {
    welcomeImageSubscription?.cancel();
  }

  void loginWithToken() async
  {
    var loginToken =   "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJsb2dpbiIsImVtYWlsIjoiYnVya2hhcnRzZW5naW5lZXJpbmdAZ21haWwuY29tIiwidXNlclN0YXR1cyI6IldhaXRpbmdGb3JBY3RpdmF0aW9uIiwiaW52aXRhdGlvbkNvZGUiOiJFRkU4S1ZKSyIsIm5iZiI6MTU0ODgzOTk0NCwiZXhwIjoxNTQ4ODgzMTQ0LCJpYXQiOjE1NDg4Mzk5NDQsImlzcyI6Imh0dHBzOi8vYXBpLmluZi1tYXJrZXRwbGFjZS5jb20iLCJhdWQiOiJJbmZsdWVuY2VyIn0.Nf7Or1mEtygB5IrQWQup6VwlKpVvL0I70OMcEnuTTZE";


    var result = await authClient.loginWithLoginToken(LoginWithLoginTokenRequest()..loginToken = loginToken);
    refreshToken = result.refreshToken;

    var accessTokenResult = await authClient.loginWithRefreshToken(LoginWithRefreshTokenRequest()..refreshToken = refreshToken);
    accesToken = accessTokenResult.accessToken;
    var user = accessTokenResult.userData;

    print(user);
  }

  void requestUploadLink() async 
  {
    var result = await blobStorageClient.getUploadUrl(GetUploadUrlRequest()..fileName ='test.txt', options: CallOptions(metadata: {'Authorization' : 'Bearer $accesToken'}));
    print(result.uploadUrl);
  }
}

// {
//     "id": "burkhartsengineering@gmail.com",
//     "version": 1,
//     "userId": "burkhartsengineering@gmail.com",
//     "status": 1,
//     "loginToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJsb2dpbiIsImVtYWlsIjoiYnVya2hhcnRzZW5naW5lZXJpbmdAZ21haWwuY29tIiwidXNlclN0YXR1cyI6IldhaXRpbmdGb3JBY3RpdmF0aW9uIiwiaW52aXRhdGlvbkNvZGUiOiJFRkU4S1ZKSyIsIm5iZiI6MTU0ODgzOTk0NCwiZXhwIjoxNTQ4ODgzMTQ0LCJpYXQiOjE1NDg4Mzk5NDQsImlzcyI6Imh0dHBzOi8vYXBpLmluZi1tYXJrZXRwbGFjZS5jb20iLCJhdWQiOiJJbmZsdWVuY2VyIn0.Nf7Or1mEtygB5IrQWQup6VwlKpVvL0I70OMcEnuTTZE",
//     "_rid": "UJRyAOSaIW0CAAAAAAAAAA==",
//     "_self": "dbs/UJRyAA==/colls/UJRyAOSaIW0=/docs/UJRyAOSaIW0CAAAAAAAAAA==/",
//     "_etag": "\"1300b75c-0000-0000-0000-5c516c090000\"",
//     "_attachments": "attachments/",
//     "_ts": 1548839945
// }

// {
//     "id": "EFE8KVJK",
//     "version": 1,
//     "code": "EFE8KVJK",
//     "expiryTimestamp": "2019-02-07T00:12:19.1601219Z UTC",
//     "_rid": "Z+dZAK6ePFcBAAAAAAAAAA==",
//     "_self": "dbs/Z+dZAA==/colls/Z+dZAK6ePFc=/docs/Z+dZAK6ePFcBAAAAAAAAAA==/",
//     "_etag": "\"00007803-0000-0000-0000-5c5154ab0000\"",
//     "_attachments": "attachments/",
//     "_ts": 1548833963
// }