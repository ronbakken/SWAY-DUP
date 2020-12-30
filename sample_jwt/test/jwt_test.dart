/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

// import 'dart:convert';

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
        // TODO: API tracking
      ],
    );
    await grpcApi.serve(port: 7900);
    Logger('Main').info('Listening: ${grpcApi.port}');

    channel = grpc.ClientChannel(
      '127.0.0.1',
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

  // const String applicationToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.'
  //    'eyJpc3MiOiJodHRwczovL2luZnNhbmRib3guYXBwIiwiYXVkIjoiaW5mc2FuZGJveCIsInBiIjp7fSwiaWF0IjoxNTQ3MDg4MTc5fQ.'
  //    'QWT-X5v1ojiFEQPOcrEAWPvV4dHwAJZBgJq-1HbDkoHThnAESwh31_HXwFjQGC8yHlg5SxGsn7ingoO41c0QfN_64DTOQpM_yQ8IS0QpCZKRrPtXdabq5pH2UPFXko3XsDL6Hp5tjOkbXpoLV_WwubtQjBVFGimWLC5EDBBxcyRgJvj5RN2FlQRXhhO8dgic_sYJI7HF-r-K8QhDLcsnysf-9jYozbcAvQqKZI10t2Hp0J3__wIb4SfbRuXHpWyvli4LdLo0u4MZjxeRJmk880PypzX-w2LSL9PsQowwUQ8tAQXsO5WqhNDlufL3WxZpV3fr1VbqfeueCZtJp922HA';

  // const String applicationToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.'
  //     'eyJpc3MiOiJodHRwczovL2luZnNhbmRib3guYXBwIiwiYXVkIjoiaW5mc2FuZGJveCIsInBiIjp7fSwiaWF0IjoxNTQ3MDk1Njc4fQ.'
  //     'ndQ8B0N6Nix1A8mdahpcpdZJgFIODOlpqRyoadqUzZYTOCgQuvbqWsjRT1xs60mxrAnT-RCr0Gsb-YPBqhhLErBS9guggCdnJCTYgrvpBxMWov9v2QluMJ6Dqhbgm9fk6btaxaePGSG_DvyBx5ySEDZzC3j8iC3deZy2scNRKTbckFggJhyHPcw0q7goHYW-mTYBMCzp-qhXHeZ5X6iZ-2U8fhh5wCIa8KmUH5nENGlcBoHnjL18KywYrEC0fCTN8Ym9kO3Vpm-_BI9Nw2segzYL1gC0Jz5r6qUA4cQQdBJCRWq9iH-7LKIGzw9phCj0vUcaH-Vv4FK1TzJJ9Qh52w';

  const String applicationToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.'
      'eyJpc3MiOiJodHRwczovL3N3YXktZGV2Lm5ldCIsImF1ZCI6InN3YXktZGV2IiwiaWF0IjoxNjA5MjM0ODMwfQ.'
      'm6tTdUq2EBG_CUox93MDHsRVi2RhiMRu2Qy9c9p2Exaiz-ttS8mI0YzbeM6jxzhDo52JaBaOM9AUrlA70tmAyRD8AKXOvvmvcIJzcxiHg1w9h_AVogdj0YXQYha0g2NJw_aMhdzkqrZYDi8pSnut0iqNnHh20mA24KgmYooa2-6MfAXBKyErp_aykQMkkNeUDsT-H8LH8rsadtTtXkcgD4vFu6SX7SnpTn8YEwOdmHKPgRogSmHme-10o-QmGeJeeGAsOM3rbap_Ez6bIVGUia_0Gh9qwlOMkkhBgjMZ0clhIcP92e0s1i0YUSxADzXQTEnuDodYykLOxeIrgo_U3Q';

  String generatedToken;
  const String payload = 'hello world one';

  test('Can generate JWT token', () async {
    final SampleJwtClient client = SampleJwtClient(channel,
        options: grpc.CallOptions(metadata: <String, String>{
          'authorization': 'Bearer $applicationToken'
        }));
    Logger('One').finest('Payload sent: $payload');
    final ReqGenerate reqGenerate = ReqGenerate();
    reqGenerate.payload = payload;
    final ResGenerate resGenerate = await client.generate(reqGenerate);
    expect(resGenerate.hasToken(), isTrue);
    final String jwt = resGenerate.token;
    expect(jwt.isEmpty, isFalse);
    Logger('One').finest('Token received: $jwt');
    generatedToken = jwt;
  });

  test('Generated JWT token is valid', () async {
    final SampleJwtClient client = SampleJwtClient(channel,
        options: grpc.CallOptions(metadata: <String, String>{
          'authorization': 'Bearer $generatedToken'
        }));
    final ReqValidate reqValidate = ReqValidate();
    final ResValidate resValidate = await client.validate(reqValidate);
    expect(resValidate.payload, equals(payload));
  });

  const String wrongToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
      'eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.'
      'SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';

  test('Wrong JWT fails', () async {
    final SampleJwtClient client = SampleJwtClient(channel,
        options: grpc.CallOptions(
            metadata: <String, String>{'authorization': 'Bearer $wrongToken'}));
    final ReqGenerate reqGenerate = ReqGenerate();
    reqGenerate.payload = payload;
    expect(client.generate(reqGenerate),
        throwsA(const TypeMatcher<grpc.GrpcError>())); // type 16
  });

  test('Missing JWT fails', () async {
    final SampleJwtClient client = SampleJwtClient(channel);
    final ReqGenerate reqGenerate = ReqGenerate();
    reqGenerate.payload = payload;
    expect(client.generate(reqGenerate),
        throwsA(const TypeMatcher<grpc.GrpcError>())); // type 16
  });
}

/* end of file */
