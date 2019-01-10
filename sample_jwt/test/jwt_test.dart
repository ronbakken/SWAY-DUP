/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:convert';

import 'package:sample_jwt/sample_jwt_service.dart';
import 'package:logging/logging.dart';
import 'package:grpc/grpc.dart' as grpc;
import "package:test/test.dart";

void main() {
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

  // API gRPC
  grpc.Server grpcApi;
  grpc.ClientChannel channel;
  setUp(() async {
    
    grpcApi = grpc.Server(
      <grpc.Service>[SampleJwtService()],
      <grpc.Interceptor>[
        // TODO: Add interceptor for JWT
      ],
    );
    await grpcApi.serve(port: 7900);
    Logger('Main').info('Listening: ${grpcApi.port}');
    
    channel = grpc.ClientChannel(
      'localhost',
      port: 7901, // Connect to Envoy Proxy
      options: const grpc.ChannelOptions(
        credentials: grpc.ChannelCredentials.insecure(),
      ),
    );
  });

  tearDown(() async {
    await channel.terminate();
    await grpcApi.shutdown();
  });

  const String applicationToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.'
      'eyJpc3MiOiJodHRwczovL2luZnNhbmRib3guYXBwIiwiYXVkIjoiaW5mc2FuZGJveCIsInBiIjp7fSwiaWF0IjoxNTQ3MDg4MTc5fQ.'
      'QWT-X5v1ojiFEQPOcrEAWPvV4dHwAJZBgJq-1HbDkoHThnAESwh31_HXwFjQGC8yHlg5SxGsn7ingoO41c0QfN_64DTOQpM_yQ8IS0QpCZKRrPtXdabq5pH2UPFXko3XsDL6Hp5tjOkbXpoLV_WwubtQjBVFGimWLC5EDBBxcyRgJvj5RN2FlQRXhhO8dgic_sYJI7HF-r-K8QhDLcsnysf-9jYozbcAvQqKZI10t2Hp0J3__wIb4SfbRuXHpWyvli4LdLo0u4MZjxeRJmk880PypzX-w2LSL9PsQowwUQ8tAQXsO5WqhNDlufL3WxZpV3fr1VbqfeueCZtJp922HA';

  test('Can generate JWT token', () async {
    final SampleJwtClient client = SampleJwtClient(channel,
        options: grpc.CallOptions(metadata: <String, String>{'authorization': 'Bearer $applicationToken'}));
    final String payload = json.encode(<String, String>{'hello': 'world one'});
    Logger('One').finest('Payload sent: $payload');
    final ReqGenerate reqGenerate = ReqGenerate();
    reqGenerate.payload = payload;
    final ResGenerate resGenerate = await client.generate(reqGenerate);
    expect(resGenerate.hasToken(), isTrue);
    final String jwt = resGenerate.token;
    expect(jwt.isEmpty, isFalse);
    Logger('One').finest('Token received: $jwt');
  });
}

/* end of file */
