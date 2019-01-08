/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// https://pub.dartlang.org/packages/sqljocky5
// INSERT INTO `business_accounts` (`business_id`, `name`, `home_address`, `home_gps`) VALUES (NULL, 'Kahuna Burger', 'Los Angeles', GeomFromText('POINT(0 0)'));

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:inf_common/inf_common.dart';
import 'package:inf_server_api/api_account_service.dart';

import 'package:inf_server_api/api_oauth_service.dart';
import 'package:inf_server_api/api_session_service.dart';
import 'package:inf_server_api/api_storage_service.dart';
import 'package:inf_server_api/api_explore_service.dart';

import 'package:inf_server_api/elasticsearch.dart';
import 'package:inf_server_api/broadcast_center.dart';

import 'package:logging/logging.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;
import 'package:http_client/console.dart' as http_client;
import 'package:http/http.dart' as http;
import 'package:grpc/grpc.dart' as grpc;
import 'package:oauth1/oauth1.dart' as oauth1;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Future<void> selfTestSql(sqljocky.ConnectionPool sql) async {
  // ⚠️✔️❌🛑 // Emojis make code run faster
  final Logger opsLog = Logger('InfOps.SelfTest');
  try {
    final List<sqljocky.Row> selfTest1 = await (await sql
            .query('SELECT message FROM self_test WHERE self_test_id=1'))
        .toList();
    if ('${selfTest1[0][0]}' != 'Zipper Sorting 😏') {
      opsLog.severe(
          '[❌] SQL Self Test: expected: "Zipper Sorting 😏", actual: "${selfTest1[0][0]}"'); // CRITICAL - OPERATIONS
    } else {
      opsLog.info('[✔️] SQL Self Test');
    }
  } catch (error, stackTrace) {
    opsLog.severe('[❌] SQL Self Test', error, stackTrace); // CRITICAL - OPERATIONS
  }
}

Future<void> _selfTestOAuth1(
    ConfigData config, List<oauth1.Authorization> oauth1Auth) async {
  final Logger opsLog = Logger('InfOps.SelfTest');
  try {
    for (int providerId = 0; providerId < oauth1Auth.length; ++providerId) {
      final ConfigOAuthProvider provider = config.oauthProviders[providerId];
      if (provider.mechanism == OAuthMechanism.oauth1) {
        final oauth1.Authorization auth = oauth1Auth[providerId];
        opsLog.info('[✔️] OAuth1 ($providerId): ' +
            (await auth.requestTemporaryCredentials(provider.callbackUrl))
                .credentials
                .toJSON()
                .toString());
      }
    }
  } catch (error, stackTrace) {
    opsLog.severe('[❌] OAuth1 Self Test', error, stackTrace);
  }
}

Future<void> run(List<String> arguments) async {
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
  Logger('InfOps').level = Level.ALL;
  Logger('InfDev').level = Level.ALL;
  Logger('SqlJocky').level = Level.WARNING;
  Logger('SqlJocky.BufferedSocket').level = Level.WARNING;

  // Server Configuration
  final String configFile =
      arguments.isNotEmpty ? arguments[0] : 'assets/config_server.bin';
  Logger('InfOps').info("Config file: '$configFile'.");
  final Uint8List configBytes = await File(configFile).readAsBytes();
  final ConfigData config = ConfigData();
  config.mergeFromBuffer(configBytes);

  // Run Account DB SQL client
  final sqljocky.ConnectionPool accountDb = sqljocky.ConnectionPool(
      host: config.services.accountDbHost,
      port: config.services.accountDbPort,
      user: config.services.accountDbUser,
      password: config.services.accountDbPassword,
      db: config.services.accountDbDatabase,
      max: 17);
  selfTestSql(accountDb);

  // Run Proposal DB SQL client
  final sqljocky.ConnectionPool proposalDb = sqljocky.ConnectionPool(
      host: config.services.proposalDbHost,
      port: config.services.proposalDbPort,
      user: config.services.proposalDbUser,
      password: config.services.proposalDbPassword,
      db: config.services.proposalDbDatabase,
      max: 17);
  selfTestSql(proposalDb);

  // Spaces
  final dospace.Spaces spaces = dospace.Spaces(
    region: config.services.spacesRegion,
    accessKey: config.services.spacesKey,
    secretKey: config.services.spacesSecret,
    httpClient: http_client.ConsoleClient(),
  );
  final dospace.Bucket bucket = spaces.bucket(config.services.spacesBucket);
  if (!(await spaces.listAllBuckets()).contains(config.services.spacesBucket)) {
    throw Exception('Missing bucket');
  } else {
    Logger('InfDev').finest('Bucket OK');
  }

  // Elasticsearch
  final Elasticsearch elasticsearch = Elasticsearch(config);

  final BroadcastCenter bc =
      BroadcastCenter(config, accountDb, proposalDb, bucket);

  final http.Client httpClient = http.Client();

  final List<oauth1.Authorization> oauth1Auth =
      List<oauth1.Authorization>(config.oauthProviders.length);
  for (int providerId = 0; providerId < oauth1Auth.length; ++providerId) {
    final ConfigOAuthProvider provider = config.oauthProviders[providerId];
    if (provider.mechanism == OAuthMechanism.oauth1) {
      final oauth1.Platform platform = oauth1.Platform(
          provider.host + provider.requestTokenUrl,
          provider.host + provider.authenticateUrl,
          provider.host + provider.accessTokenUrl,
          oauth1.SignatureMethods.hmacSha1);
      final oauth1.ClientCredentials clientCredentials =
          oauth1.ClientCredentials(
              provider.consumerKey, provider.consumerSecret);
      oauth1Auth[providerId] =
          oauth1.Authorization(clientCredentials, platform, httpClient);
    }
  }
  _selfTestOAuth1(config, oauth1Auth);

  // Listen to gRPC
  final grpc.Server grpcServer = grpc.Server(
    <grpc.Service>[
      ApiSessionService(config, accountDb),
      ApiAccountService(config, accountDb, bc, oauth1Auth),
      ApiOAuthService(config, oauth1Auth),
      ApiStorageService(config, bucket),
      ApiExploreService(config, elasticsearch)
    ],
    <grpc.Interceptor>[
      // TODO(kaetemi): Add interceptor for JWT
    ],
  );
  final Future<void> grpcServing = grpcServer.serve(port: 8900);

  // Listen to WebSocket

  // Exit if any of the listeners exits
  await Future.any(<Future<void>>[grpcServing]);

  await grpcServer.shutdown();
  await spaces.close();
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/* end of file */
