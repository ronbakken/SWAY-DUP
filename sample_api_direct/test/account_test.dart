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

  // Config
  const String configFile = '../assets/config_local.bin';
  Logger('Test').info("Config file: '$configFile'");
  final Uint8List configBytes = await File(configFile).readAsBytes();
  final ConfigData config = ConfigData();
  config.mergeFromBuffer(configBytes);

  // Server Config
  const String serverConfigFile = '../assets/config_local_server.bin';
  Logger('Test').info("Server Config file: '$serverConfigFile'");
  final Uint8List serverConfigBytes =
      await File(serverConfigFile).readAsBytes();
  final ConfigData serverConfig = ConfigData();
  serverConfig.mergeFromBuffer(serverConfigBytes);

  // Setup
  http.Client httpClient;
  grpc.ClientChannel channel;
  ApiSessionClient sessionClient;
  String influencerAccessToken;
  String businessAccessToken;
  String supportAccessToken;
  dynamic influencerFacebook;
  dynamic businessFacebook;
  dynamic supportFacebook;

  setUpAll(() async {
    httpClient = http.Client();
    channel = grpc.ClientChannel(
      '192.168.43.202', // '127.0.0.1', //
      port: 8080, // Connect to Envoy Proxy
      options: const grpc.ChannelOptions(
        credentials: grpc.ChannelCredentials.insecure(),
      ),
    );
    sessionClient = ApiSessionClient(channel,
        options: grpc.CallOptions(metadata: <String, String>{
          'authorization': 'Bearer ${config.services.applicationToken}'
        }));
    final NetSessionCreate createRequest = NetSessionCreate();
    createRequest.domain = config.services.domain;
    createRequest.clientVersion = config.clientVersion;
    createRequest.deviceToken = Uint8List(32);
    createRequest.deviceName = 'account_test setUpAll';
    createRequest.deviceInfo = '{}';
    createRequest.freeze();
    final NetSession influencerSession =
        await sessionClient.create(createRequest);
    influencerAccessToken = influencerSession.accessToken;
    final NetSession businessSession =
        await sessionClient.create(createRequest);
    businessAccessToken = businessSession.accessToken;
    final NetSession supportSession = await sessionClient.create(createRequest);
    supportAccessToken = supportSession.accessToken;
    final ConfigOAuthProvider facebook =
        serverConfig.oauthProviders[OAuthProviderIds.facebook.value];
    /*
    final dynamic testUsersResponse = json.decode((await httpClient.get(
            Uri.parse(facebook.host +
                    '/v3.1/${facebook.clientId}/accounts/test-users')
                .replace(queryParameters: <String, dynamic>{
      'access_token': '${facebook.clientId}|${facebook.clientSecret}',
    })))
        .body);
    Logger('SetUp').fine('$testUsersResponse');
    */
    final String scope = Uri.splitQueryString(facebook.authQuery)['scope'];
    influencerFacebook = json.decode((await httpClient.post(Uri.parse(
                facebook.host +
                    '/v3.2/${facebook.clientId}/accounts/test-users')
            .replace(queryParameters: <String, dynamic>{
      'access_token': '${facebook.clientId}|${facebook.clientSecret}',
      'installed': 'true',
      'permissions': scope,
    })))
        .body);
    Logger('SetUp').fine('$influencerFacebook');
    businessFacebook = json.decode((await httpClient.post(Uri.parse(
                facebook.host +
                    '/v3.2/${facebook.clientId}/accounts/test-users')
            .replace(queryParameters: <String, dynamic>{
      'access_token': '${facebook.clientId}|${facebook.clientSecret}',
      'installed': 'true',
      'permissions': scope,
    })))
        .body);
    Logger('SetUp').fine('$businessFacebook');
    supportFacebook = json.decode((await httpClient.post(Uri.parse(
                facebook.host +
                    '/v3.2/${facebook.clientId}/accounts/test-users')
            .replace(queryParameters: <String, dynamic>{
      'access_token': '${facebook.clientId}|${facebook.clientSecret}',
      'installed': 'true',
      'permissions': scope,
    })))
        .body);
    Logger('SetUp').fine('$supportFacebook');
  });

  tearDownAll(() async {
    final ConfigOAuthProvider facebook =
        serverConfig.oauthProviders[OAuthProviderIds.facebook.value];
    if (supportFacebook['id'] != null) {
      final dynamic influencerDelete = json.decode((await httpClient.delete(
              Uri.parse(facebook.host + "/v3.2/${supportFacebook['id']}")
                  .replace(queryParameters: <String, dynamic>{
        'access_token': '${facebook.clientId}|${facebook.clientSecret}',
      })))
          .body);
      Logger('TearDown').fine('$influencerDelete');
    }
    if (businessFacebook['id'] != null) {
      final dynamic influencerDelete = json.decode((await httpClient.delete(
              Uri.parse(facebook.host + "/v3.2/${businessFacebook['id']}")
                  .replace(queryParameters: <String, dynamic>{
        'access_token': '${facebook.clientId}|${facebook.clientSecret}',
      })))
          .body);
      Logger('TearDown').fine('$influencerDelete');
    }
    if (influencerFacebook['id'] != null) {
      final dynamic influencerDelete = json.decode((await httpClient.delete(
              Uri.parse(facebook.host + "/v3.2/${influencerFacebook['id']}")
                  .replace(queryParameters: <String, dynamic>{
        'access_token': '${facebook.clientId}|${facebook.clientSecret}',
      })))
          .body);
      Logger('TearDown').fine('$influencerDelete');
    }
    await channel.terminate();
  });

  test('Validate test setup', () async {
    expect(influencerAccessToken, isNot(isEmpty));
    expect(businessAccessToken, isNot(isEmpty));
    expect(supportAccessToken, isNot(isEmpty));
    expect(supportFacebook['id'], isNotNull);
    expect(businessFacebook['id'], isNotNull);
    expect(influencerFacebook['id'], isNotNull);
    expect(supportFacebook['access_token'], isNotNull);
    expect(businessFacebook['access_token'], isNotNull);
    expect(influencerFacebook['access_token'], isNotNull);
  });

  test('Create influencer account', () async {
    final ApiAccountClient accountClient = ApiAccountClient(channel,
        options: grpc.CallOptions(metadata: <String, String>{
          'authorization': 'Bearer $influencerAccessToken'
        }));
    final NetSetAccountType setTypeRequest = NetSetAccountType();
    setTypeRequest.accountType = AccountType.influencer;
    final NetAccount accountless = await accountClient.setType(setTypeRequest);
    expect(accountless.account.accountType, equals(AccountType.influencer));
    expect(accountless.account.accountId, equals(Int64.ZERO));
    expect(accountless.account.sessionId, isNot(equals(Int64.ZERO)));
    final NetOAuthConnect connectRequest = NetOAuthConnect();
    connectRequest.oauthProvider = OAuthProviderIds.facebook.value;
    connectRequest.callbackQuery = 'access_token=${Uri.encodeQueryComponent(influencerFacebook['access_token'])}';
    final NetOAuthConnection connection = await accountClient.connectProvider(connectRequest);
    expect(connection.accessToken, isEmpty);
    expect(connection.hasAccount(), isFalse); // Account means login rather than sign up
    expect(connection.hasSocialMedia(), isTrue);
    expect(connection.socialMedia.connected, isTrue);
    Logger('Influencer').fine(connection);
    expect(connection.socialMedia.email, equals(influencerFacebook['email']));
    expect(connection.socialMedia.profileUrl, isNotEmpty);
    expect(connection.socialMedia.avatarUrl, isNotEmpty);
    expect(connection.socialMedia.canSignUp, isTrue);
    expect(connection.socialMedia.providerId, equals(OAuthProviderIds.facebook.value));
    final NetAccountCreate createRequest = NetAccountCreate();
    createRequest.latitude = 34.0718836; // Nearby Wally's
    createRequest.longitude = -118.4032531;
    final NetSession account = await accountClient.create(createRequest);
    // Updated account data
    expect(account.hasAccount(), isTrue);
    // Refresh token stays the same for a session
    expect(account.hasRefreshToken(), isFalse);
    // New access token upon account creation with account id embedded
    expect(account.hasAccessToken(), isTrue);
    expect(account.accessToken, isNotEmpty);
    influencerAccessToken = account.accessToken;
    expect(account.account.sessionId, equals(accountless.account.sessionId));
    expect(account.account.accountId, isNot(equals(Int64.ZERO)));
  });

  // TODO: Ensure tokens created for a different app id cannot be used

  // TODO: Login with existing influencer account

  // TODO: canSignUp when reopening halfway account creation should be true
}

/* end of file */
