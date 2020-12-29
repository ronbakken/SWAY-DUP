/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:sway_common/inf_common.dart';
import 'package:inf_server_explore/elasticsearch.dart';

import 'package:logging/logging.dart';
import 'package:grpc/grpc.dart' as grpc;

import 'package:inf_server_explore/api_explore_service.dart';
import 'package:inf_server_explore/backend_explore_service.dart';

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
  Logger('InfOps').info('Sway Explore Service');
  final String configFile = Platform.environment['SWAY_CONFIG'] ??
      '../../sway_config/blob/config_local_server.bin';
  Logger('InfOps').info("Config file: '$configFile'");
  final Uint8List configBytes = await File(configFile).readAsBytes();
  final ConfigData config = ConfigData();
  config.mergeFromBuffer(configBytes);

  // Elasticsearch
  final Elasticsearch elasticsearch = Elasticsearch(config);

  final BackendExploreService backend =
      BackendExploreService(config, elasticsearch);
  final ApiExploreService api = ApiExploreService(config, elasticsearch);

  // Push API gRPC
  final grpc.Server grpcApi = grpc.Server(
    <grpc.Service>[api],
    <grpc.Interceptor>[
      // TODO: API tracking
    ],
  );
  final Future<void> grpcApiServing = grpcApi.serve(port: 8930);

  // Push Backend gRPC
  final grpc.Server grpcBackend = grpc.Server(
    <grpc.Service>[backend],
    <grpc.Interceptor>[
      // TODO: Backend tracking
    ],
  );
  final Future<void> grpcBackendServing = grpcBackend.serve(port: 8939);

  // Wait for listening
  await Future.wait(<Future<void>>[grpcApiServing, grpcBackendServing]);
  Logger('InfOps')
      .info('Listening: api: ${grpcApi.port}, backend: ${grpcBackend.port}');

  // TODO: Exit if any of the listeners exits... No mechanism to wait for gRPC exit right now...
  // await ...;
  // await grpcApi.shutdown();
  // await grpcBackend.shutdown();
  // Logger('InfOps').info('Done');
}

/* end of file */
