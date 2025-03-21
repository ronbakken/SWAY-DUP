/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:sway_common/inf_common.dart';
import 'package:inf_server_push/db_upgrade_push.dart';

import 'package:logging/logging.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:grpc/grpc.dart' as grpc;

import 'package:inf_server_push/api_push_service.dart';
import 'package:inf_server_push/backend_push_service.dart';

Future<void> main(List<String> arguments) async {
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
  Logger('InfOps').info('Sway Push Service');
  final String configFile = Platform.environment['SWAY_CONFIG'] ??
      '../../sway_config/blob/config_local_server.bin';
  Logger('InfOps').info("Config file: '$configFile'");
  final Uint8List configBytes = await File(configFile).readAsBytes();
  final ConfigData config = ConfigData();
  config.mergeFromBuffer(configBytes);

  // SQL client
  final sqljocky.ConnectionPool sql = sqljocky.ConnectionPool(
      host: Platform.environment['SWAY_GENERAL_DB_HOST'] ??
          config.services.generalDbHost,
      port: config.services.generalDbPort,
      user: config.services.generalDbUser,
      password: config.services.generalDbPassword,
      db: config.services.generalDbDatabase,
      max: 17);
  await dbUpgradePush(sql);

  final BackendPushService backend = BackendPushService(config, sql);
  final ApiPushService api = ApiPushService(backend);

  // Push API gRPC
  final grpc.Server grpcApi = grpc.Server(
    <grpc.Service>[api],
    <grpc.Interceptor>[
      // TODO: API tracking
    ],
  );
  final Future<void> grpcApiServing = grpcApi.serve(port: 8910);

  // Push Backend gRPC
  final grpc.Server grpcBackend = grpc.Server(
    <grpc.Service>[backend],
    <grpc.Interceptor>[
      // TODO: Backend tracking
    ],
  );
  final Future<void> grpcBackendServing = grpcBackend.serve(port: 8919);

  // Listen to WebSocket
  final HttpServer server =
      await HttpServer.bind(InternetAddress.anyIPv4, 8911);
  server.listen((HttpRequest request) async {
    if (request.uri.path == '/ws' || request.uri.path == '/ws/') {
      try {
        final WebSocket ws = await WebSocketTransformer.upgrade(request);
        try {
          await for (NetPush push in backend.listenWebSocket(ws, request)) {
            ws.add(push.writeToBuffer());
          }
        } catch (error, stackTrace) {
          Logger('InfOps')
              .severe('Error while pushing data', error, stackTrace);
          try {
            await ws.close();
          } catch (_, __) {
            //empty
          }
        }
      } catch (error, stackTrace) {
        Logger('InfOps')
            .severe('Error upgrading request to WebSocket', error, stackTrace);
      }
    } else {
      Logger('InfOps').fine("Unknown path '${request.uri.path}'.");
      try {
        request.response.statusCode = HttpStatus.forbidden;
        await request.response.close();
      } catch (error, stackTrace) {
        Logger('InfOps')
            .severe('Error sending forbidden response', error, stackTrace);
      }
    }
  }, onDone: () async {
    await grpcApi.shutdown();
    await grpcBackend.shutdown();
  });

  // Wait for listening
  await Future.wait(<Future<void>>[grpcApiServing, grpcBackendServing]);
  Logger('InfOps').info(
      'Listening: api: ${grpcApi.port}, ws: ${server.port}, backend: ${grpcBackend.port}');

  // TODO: Exit if any of the listeners exits... No mechanism to wait for gRPC exit right now...
  // await ...;
  // await grpcApi.shutdown();
  // await grpcBackend.shutdown();
  // Logger('InfOps').info('Done');
}

/* end of file */
