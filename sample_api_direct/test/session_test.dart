/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

// import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:sway_common/inf_common.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'package:grpc/grpc.dart' as grpc;

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
  const String configFile = '../../sway_config/blob/config_local.bin';
  Logger('Test').info("Config file: '$configFile'");
  final Uint8List configBytes = await File(configFile).readAsBytes();
  final ConfigData config = ConfigData();
  config.mergeFromBuffer(configBytes);

  const bool devOverride = false;
  const String devIp = '192.168.43.202';

  // API gRPC
  grpc.ClientChannel channel;
  setUp(() async {
    channel = grpc.ClientChannel(
      devOverride ? devIp : '127.0.0.1',
      port: 8080, // Connect to Envoy Proxy
      options: const grpc.ChannelOptions(
        credentials: grpc.ChannelCredentials.insecure(),
      ),
    );
  });

  tearDown(() async {
    await channel.terminate();
  });

  final String applicationToken = config.services.applicationToken;

  test('Has application token', () async {
    Logger('Token').fine(applicationToken);
    expect(applicationToken, isNot(isEmpty));
  });

  const String wrongToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
      'eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.'
      'SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';

  final NetSessionCreate createRequest = NetSessionCreate();
  createRequest.domain = config.services.domain;
  createRequest.clientVersion = config.clientVersion;
  createRequest.deviceToken = Uint8List(32);
  createRequest.deviceName = 'sample_api_direct';
  createRequest.deviceInfo = '{}';
  createRequest.freeze();

  test('Wrong JWT fails', () async {
    final ApiSessionClient client = ApiSessionClient(channel,
        options: grpc.CallOptions(
            metadata: <String, String>{'authorization': 'Bearer $wrongToken'}));
    expect(client.create(createRequest),
        throwsA(const TypeMatcher<grpc.GrpcError>()));
  });

  test('Missing JWT fails', () async {
    final ApiSessionClient client = ApiSessionClient(channel);
    expect(client.create(createRequest),
        throwsA(const TypeMatcher<grpc.GrpcError>()));
  });

  // TODO: Expiry of the token should be part of the NetSession response (don't parse JWT tokens on the client)

  String sessionOneRefresh;
  String sessionOneAccess;

  test('Can create a new session', () async {
    final ApiSessionClient client = ApiSessionClient(
      channel,
      options: grpc.CallOptions(
        metadata: <String, String>{'authorization': 'Bearer $applicationToken'},
      ),
    );
    final NetSession session = await client.create(createRequest);
    sessionOneRefresh = session.refreshToken;
    sessionOneAccess = session.accessToken;
    expect(session.account, isNotNull);
    expect(session.account.sessionId.toInt(), isNonZero);
    expect(session.account.accountId.toInt(), isZero);
    expect(session.account.firebaseToken, isEmpty);
    expect(sessionOneRefresh, isNot(isEmpty));
    expect(sessionOneAccess, isNot(isEmpty));

    // Precondition for next tests
    expect(session.account.accountType, equals(AccountType.unknown));
  });

  test('Can set type of accountless session, test access token', () async {
    final ApiAccountClient client = ApiAccountClient(
      channel,
      options: grpc.CallOptions(
        metadata: <String, String>{'authorization': 'Bearer $sessionOneAccess'},
      ),
    );
    final NetSetAccountType request = NetSetAccountType();
    request.accountType = AccountType.influencer;
    final NetAccount account = await client.setType(request);
    expect(account.account.accountType, equals(AccountType.influencer));
  });

  test('Cannot use refresh token to set accountless type', () async {
    final ApiAccountClient client = ApiAccountClient(
      channel,
      options: grpc.CallOptions(
        metadata: <String, String>{
          'authorization': 'Bearer $sessionOneRefresh'
        },
      ),
    );
    final NetSetAccountType request = NetSetAccountType();
    request.accountType = AccountType.business;
    expect(
        client.setType(request), throwsA(const TypeMatcher<grpc.GrpcError>()));
  });

  test('Cannot use application token to set accountless type', () async {
    final ApiAccountClient client = ApiAccountClient(
      channel,
      options: grpc.CallOptions(
        metadata: <String, String>{'authorization': 'Bearer $applicationToken'},
      ),
    );
    final NetSetAccountType request = NetSetAccountType();
    request.accountType = AccountType.business;
    expect(
        client.setType(request), throwsA(const TypeMatcher<grpc.GrpcError>()));
  });

  final NetSessionOpen openRequest = NetSessionOpen();
  openRequest.domain = config.services.domain;
  openRequest.clientVersion = config.clientVersion;
  openRequest.freeze();

  test('Cannot open a session with an access token', () async {
    final ApiSessionClient client = ApiSessionClient(
      channel,
      options: grpc.CallOptions(
        metadata: <String, String>{'authorization': 'Bearer $sessionOneAccess'},
      ),
    );
    expect(
        client.open(openRequest), throwsA(const TypeMatcher<grpc.GrpcError>()));
  });

  test('Cannot open a session with an application token', () async {
    final ApiSessionClient client = ApiSessionClient(
      channel,
      options: grpc.CallOptions(
        metadata: <String, String>{'authorization': 'Bearer $applicationToken'},
      ),
    );
    expect(
        client.open(openRequest), throwsA(const TypeMatcher<grpc.GrpcError>()));
  });

  String sessionOneAccessSecond;

  test('Can open an existing session', () async {
    final ApiSessionClient client = ApiSessionClient(
      channel,
      options: grpc.CallOptions(
        metadata: <String, String>{
          'authorization': 'Bearer $sessionOneRefresh'
        },
      ),
    );
    final NetSession session = await client.open(openRequest);
    sessionOneAccessSecond = session.accessToken;
    expect(session.account, isNotNull);
    expect(session.account.sessionId.toInt(), isNonZero);
    expect(session.account.accountId.toInt(), isZero);
    expect(session.account.firebaseToken, isEmpty);
    expect(sessionOneAccessSecond, isNot(isEmpty));

    // Depends on previous changes
    expect(session.account.accountType, equals(AccountType.influencer));
  });
}

/* end of file */
