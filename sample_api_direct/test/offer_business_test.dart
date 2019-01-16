/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:inf_common/inf_common.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'package:grpc/grpc.dart' as grpc;
import 'package:http/http.dart' as http;

Future<void> main() async {
  // Logging
  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    if (rec.error == null) {
      print(
          '${rec.loggerName}: ${rec.level.name}: ${rec.time}: ${rec.message}');
    } else {
      print(
          '${rec.loggerName}: ${rec.level.name}: ${rec.time}: ${rec.message}\n${rec.error.toString()}\n${rec.stackTrace.toString()}');
    }
  });
  final Logger log = Logger('OAuthTest');

  // Config
  const String configFile = '../assets/config_local.bin';
  log.info("Config file: '$configFile'");
  final Uint8List configBytes = await File(configFile).readAsBytes();
  final ConfigData config = ConfigData();
  config.mergeFromBuffer(configBytes);

  // Server Config
  const String serverConfigFile = '../assets/config_local_server.bin';
  log.info("Server Config file: '$serverConfigFile'");
  final Uint8List serverConfigBytes =
      await File(serverConfigFile).readAsBytes();
  final ConfigData serverConfig = ConfigData();
  serverConfig.mergeFromBuffer(serverConfigBytes);

  // Setup
  http.Client httpClient;
  grpc.ClientChannel channel;
  String influencerAccessToken;
  String businessAccessToken;
  ApiAccountClient influencerAccountClient;
  ApiAccountClient businessAccountClient;
  DataAccount influencerAccount;
  DataAccount businessAccount;

  final NetSessionCreate sessionCreateRequest = NetSessionCreate();
  sessionCreateRequest.domain = config.services.domain;
  sessionCreateRequest.clientVersion = config.clientVersion;
  sessionCreateRequest.deviceToken = Uint8List(32);
  sessionCreateRequest.deviceName = 'oauth_test';
  sessionCreateRequest.deviceInfo = '{}';
  sessionCreateRequest.freeze();

  setUpAll(() async {
    httpClient = http.Client();
    channel = grpc.ClientChannel(
      '192.168.43.202', //'127.0.0.1', // 
      port: 8080, // Connect to Envoy Proxy
      options: const grpc.ChannelOptions(
        credentials: grpc.ChannelCredentials.insecure(),
      ),
    );
    final ApiSessionClient sessionClient = ApiSessionClient(channel,
        options: grpc.CallOptions(metadata: <String, String>{
          'authorization': 'Bearer ${config.services.applicationToken}'
        }));
    final NetSession influencerSession =
        await sessionClient.create(sessionCreateRequest);
    influencerAccessToken = influencerSession.accessToken;
    final NetSession businessSession =
        await sessionClient.create(sessionCreateRequest);
    businessAccessToken = businessSession.accessToken;
    influencerAccountClient = ApiAccountClient(
      channel,
      options: grpc.CallOptions(
        metadata: <String, String>{
          'authorization': 'Bearer $influencerAccessToken'
        },
      ),
    );
    businessAccountClient = ApiAccountClient(
      channel,
      options: grpc.CallOptions(
        metadata: <String, String>{
          'authorization': 'Bearer $businessAccessToken'
        },
      ),
    );
    final NetSetAccountType setTypeRequest = NetSetAccountType();
    setTypeRequest.accountType = AccountType.influencer;
    await influencerAccountClient.setType(setTypeRequest);
    setTypeRequest.accountType = AccountType.business;
    await businessAccountClient.setType(setTypeRequest);
    final NetOAuthConnect request = NetOAuthConnect();
    request.oauthProvider = OAuthProviderIds.twitter.value;

    // Log into or create influencer account
    request.callbackQuery =
        'oauth_token=1085053886933565440-t6ce1nK4D7yjxtjciRXEBQjjJb6Cue&oauth_token_secret=zQgdWQ40LB6sVsj76Q7LiV20lOTaAlpYHJ2Vt8KCKQgNF';
    NetOAuthConnection response =
        await influencerAccountClient.connectProvider(request);
    expect(response.hasSocialMedia(), isTrue);
    expect(response.socialMedia.connected, isTrue);
    if (!response.hasAccount()) {
      final NetAccountCreate createRequest = NetAccountCreate();
      createRequest.latitude = 34.0718836; // Nearby Wally's
      createRequest.longitude = -118.4032531;
      final NetSession account =
          await influencerAccountClient.create(createRequest);
      if (account.hasAccount()) {
        influencerAccount = account.account;
      }
    } else {
      influencerAccount = response.account;
    }

    expect(influencerAccount, isNotNull);
    // Log into or create business account
    request.callbackQuery =
        'oauth_token=1085549519767400449-enBoFc1UbJcBA3OUGUuYSwkEKFWDyV&oauth_token_secret=KUtP7MtArBfo4mNfFdlmdiTcMzu5XaxsmY4OWxWbcZF2q';
    response =
        await businessAccountClient.connectProvider(request);
    expect(response.hasSocialMedia(), isTrue);
    expect(response.socialMedia.connected, isTrue);
    if (!response.hasAccount()) {
      final NetAccountCreate createRequest = NetAccountCreate();
    createRequest.latitude = 34.0807925; // Nearby Craig's
    createRequest.longitude = -118.3886626;
      final NetSession account =
          await businessAccountClient.create(createRequest);
      if (account.hasAccount()) {
        businessAccount = account.account;
      }
    } else {
      businessAccount = response.account;
    }
    expect(businessAccount, isNotNull);
    log.fine(influencerAccount);
    log.fine(businessAccount);
    expect(influencerAccount.accountType, equals(AccountType.influencer));
    expect(businessAccount.accountType, equals(AccountType.business));
    expect(influencerAccount.name, equals('INF Sandbox'));
    expect(businessAccount.name, equals('INF Boxsand'));
  });

  tearDownAll(() async {
    await channel.terminate();
  });

  /*
  test('Upload image', () async {
  });
  */

  /*
  test('Create an offer', () async {
  });
  */
}

/* end of file */
