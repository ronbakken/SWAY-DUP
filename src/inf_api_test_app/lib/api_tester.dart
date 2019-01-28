import 'dart:async';
import 'dart:typed_data';

import 'package:inf_api_client/inf_api_client.dart';
import 'package:grpc/grpc.dart';

ApiTester apiTester = ApiTester();

class ApiTester {
  ClientChannel channel;
  InfConfigClient configClient;
  InfSystemClient systemClient;

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
}
