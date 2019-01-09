/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'package:sample_jwt/sample_jwt_service.dart';
import 'package:logging/logging.dart';
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
  Logger('InfOps').level = Level.ALL;
  Logger('InfDev').level = Level.ALL;
  Logger('SqlJocky').level = Level.WARNING;
  Logger('SqlJocky.BufferedSocket').level = Level.WARNING;

  // API gRPC
  final grpc.Server grpcApi = grpc.Server(
    <grpc.Service>[
      SampleJwtService()
    ],
    <grpc.Interceptor>[
      // TODO: Add interceptor for JWT
    ],
  );
  await grpcApi.serve(port: 8910);
  Logger('main').info('Listening: ${grpcApi.port}');
  

}

/* end of file */
