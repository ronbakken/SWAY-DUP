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
  String refreshToken;
  String accessToken;

  ApiAccountClient accountClient;
  ApiOAuthClient oauthClient;
  NetAccount accountless;

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
      '127.0.0.1', // '192.168.43.202', // 
      port: 8080, // Connect to Envoy Proxy
      options: const grpc.ChannelOptions(
        credentials: grpc.ChannelCredentials.insecure(),
      ),
    );
  });

  setUp(() async {
    final ApiSessionClient sessionClient = ApiSessionClient(channel,
        options: grpc.CallOptions(metadata: <String, String>{
          'authorization': 'Bearer ${config.services.applicationToken}'
        }));
    final NetSession session =
        await sessionClient.create(sessionCreateRequest);
    refreshToken = session.refreshToken;
    accessToken = session.accessToken;
    accountClient = ApiAccountClient(channel,
        options: grpc.CallOptions(metadata: <String, String>{
          'authorization': 'Bearer $accessToken'
        }));
    oauthClient = ApiOAuthClient(channel,
        options: grpc.CallOptions(metadata: <String, String>{
          'authorization': 'Bearer $accessToken'
        }));
    final NetSetAccountType setTypeRequest = NetSetAccountType();
    setTypeRequest.accountType = AccountType.influencer;
    accountless = await accountClient.setType(setTypeRequest);
  });

  tearDownAll(() async {
    await channel.terminate();
  });

  test('Validate OAuth test setup', () async {
    expect(refreshToken, isNot(isEmpty));
    expect(accessToken, isNot(isEmpty));
    expect(accountless.account.sessionId, isNot(equals(Int64.ZERO)));
    expect(accountless.account.accountId, equals(Int64.ZERO));
    expect(accountless.account.accountType, equals(AccountType.influencer));
  });
  
  test('Twitter OAuth url', () async {
    final NetOAuthGetUrl request = NetOAuthGetUrl();
    request.oauthProvider = OAuthProviderIds.twitter.value;
    final NetOAuthUrl response = await oauthClient.getUrl(request);
    log.fine(response);
    expect(response.authUrl, isNotEmpty);
    expect(response.callbackUrl, isNotEmpty);
    final http.Response httpResponse = await httpClient.get(response.authUrl);
    expect(httpResponse.statusCode, equals(200));
    // https://www.infmarketplace.com/wait.html?oauth_token=PTTfSwAAAAAA5_oKAAABaFbaMcQ&oauth_verifier=AbAOYhR2U4odp2MneAvuL3sUW1yx7mhT
  });

  
  test('Twitter connect', () async {
    final NetOAuthConnect request = NetOAuthConnect();
    request.oauthProvider = OAuthProviderIds.twitter.value;
    // request.callbackQuery = 'oauth_token=3_xZDQAAAAAA5_oKAAABaFbrrDo&oauth_verifier=yHXL3ceSRhYgDnILzswFJJjSOmvnluTm';
    request.callbackQuery = 'oauth_token=Nar9jgAAAAAA5_oKAAABaFck5I4&oauth_verifier=qfZMPjjyRa7av67BEGfokDaADj23uMW7';
    final NetOAuthConnection response = await accountClient.connectProvider(request);
    expect(response.hasSocialMedia(), isTrue);
    expect(response.socialMedia.connected, isTrue);
    // 0:"oauth_token" -> "1085053886933565440-t6ce1nK4D7yjxtjciRXEBQjjJb6Cue"
    // 1:"oauth_token_secret" -> "zQgdWQ40LB6sVsj76Q7LiV20lOTaAlpYHJ2Vt8KCKQgNF"
    // 2:"user_id" -> "1085053886933565440"
    // 3:"screen_name" -> "infsandbox"
    // 0:"oauth_token" -> "1085549519767400449-enBoFc1UbJcBA3OUGUuYSwkEKFWDyV"
    // 1:"oauth_token_secret" -> "KUtP7MtArBfo4mNfFdlmdiTcMzu5XaxsmY4OWxWbcZF2q"
    // 2:"user_id" -> "1085549519767400449"
    // 3:"screen_name" -> "IBoxsand"
  });
  

  test('Twitter connect with outdated token should fail', () async {
    final NetOAuthConnect request = NetOAuthConnect();
    request.oauthProvider = OAuthProviderIds.twitter.value;
    request.callbackQuery = 'oauth_token=Yiyo5AAAAAAA5_oKAAABaFbpZSE&oauth_verifier=5oiE03PWyDg5CKRWP8urgpvQB5CeVepe';
    expect(accountClient.connectProvider(request), throwsA(const TypeMatcher<grpc.GrpcError>()));
  });

  test('Twitter connect with token and secret instead of verifier', () async {
    // This is used by test users and by the twitter kit plugin
    final NetOAuthConnect request = NetOAuthConnect();
    request.oauthProvider = OAuthProviderIds.twitter.value;
    request.callbackQuery = 'oauth_token=1085053886933565440-t6ce1nK4D7yjxtjciRXEBQjjJb6Cue&oauth_token_secret=zQgdWQ40LB6sVsj76Q7LiV20lOTaAlpYHJ2Vt8KCKQgNF';
    final NetOAuthConnection response = await accountClient.connectProvider(request);
    log.fine(response.socialMedia);
    expect(response.hasSocialMedia(), isTrue);
    expect(response.socialMedia.connected, isTrue);
    expect(response.socialMedia.screenName, equals('infsandbox'));
  });
  
  test('Facebook OAuth url', () async {
    final NetOAuthGetUrl request = NetOAuthGetUrl();
    request.oauthProvider = OAuthProviderIds.facebook.value;
    final NetOAuthUrl response = await oauthClient.getUrl(request);
    log.fine(response);
    expect(response.authUrl, isNotEmpty);
    expect(response.callbackUrl, isNotEmpty);
    final http.Response httpResponse = await httpClient.get(response.authUrl);
    expect(httpResponse.statusCode, equals(200));
  });
}

/* end of file */
