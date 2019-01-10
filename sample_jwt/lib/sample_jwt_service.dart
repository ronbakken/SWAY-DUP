/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:grpc/grpc.dart' as grpc;

import 'package:sample_jwt/src/protos/sample_jwt.pb.dart';
import 'package:sample_jwt/src/protos/sample_jwt.pbgrpc.dart';
export 'package:sample_jwt/src/protos/sample_jwt.pb.dart';
export 'package:sample_jwt/src/protos/sample_jwt.pbgrpc.dart';

import 'package:inf_common/inf_backend.dart';

class SampleJwtService extends SampleJwtServiceBase {
  static final Logger log = Logger('SampleJwtService');
  final grpc.ClientChannel backendJwtChannel = grpc.ClientChannel(
    '127.0.0.1',
    port: 8919,
    options: const grpc.ChannelOptions(
      credentials: grpc.ChannelCredentials.insecure(),
    ),
  );
  BackendJwtClient backendJwt;
  SampleJwtService() {
    backendJwt = BackendJwtClient(backendJwtChannel);
  }

  Future<void> shutdown() async {
    backendJwt = null;
    await backendJwtChannel.shutdown();
  }

  @override
  Future<ResGenerate> generate(
      grpc.ServiceCall call, ReqGenerate request) async {
    log.finest(call.clientMetadata);
    // log.severe(request);
    if (!call.clientMetadata.containsKey('authorization') &&
        !call.clientMetadata.containsKey('authority')) {
      throw grpc.GrpcError.unauthenticated('Authorization missing.');
    }
    if (!call.clientMetadata.containsKey('x-jwt-payload')) {
      throw grpc.GrpcError.unauthenticated('Payload not decoded by proxy.');
    }
    final ReqSign signRequest = ReqSign();
    signRequest.claim = json.encode(<String, dynamic>{
      'iss': 'https://infsandbox.app',
      'aud': 'infsandbox',
      'ps': request.payload,
      'pb': <String, dynamic>{}
    });
    signRequest.freeze();
    log.finest('Forward request $signRequest.');
    final ResSign signResponse = await backendJwt.sign(
      signRequest,
      options: grpc.CallOptions(
        metadata: <String, String>{
          'x-request-id': call.clientMetadata['x-request-id'],
        },
        // TODO: timeout: call.deadline.difference(DateTime.now()),
      ),
    );
    final ResGenerate response = ResGenerate();
    response.token = signResponse.token;
    return response;
  }

  @override
  Future<ResValidate> validate(
      grpc.ServiceCall call, ReqValidate request) async {
    if (!call.clientMetadata.containsKey('authorization') &&
        !call.clientMetadata.containsKey('authority')) {
      throw grpc.GrpcError.unauthenticated('Authorization missing.');
    }
    if (!call.clientMetadata.containsKey('x-jwt-payload')) {
      throw grpc.GrpcError.unauthenticated('Payload not decoded by proxy.');
    }
    final dynamic payload = json.decode(
        utf8.decode(base64.decode(call.clientMetadata['x-jwt-payload'])));
    if (payload['ps'] == null) {
      throw grpc.GrpcError.permissionDenied('Payload string missing.');
    }
    final ResValidate response = ResValidate();
    response.payload = payload['ps'];
    return response;
  }
}

/* end of file */
