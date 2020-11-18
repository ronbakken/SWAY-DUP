/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

library inf_common;

export 'package:inf_common/inf_common.dart';

export 'package:inf_common/src/backend_explore.pb.dart';
export 'package:inf_common/src/backend_explore.pbgrpc.dart';

export 'package:inf_common/src/backend_push.pb.dart';
export 'package:inf_common/src/backend_push.pbgrpc.dart';

export 'package:inf_common/src/backend_jwt.pb.dart';
export 'package:inf_common/src/backend_jwt.pbgrpc.dart';

import 'dart:convert';

import 'package:grpc/grpc.dart' as grpc;
import 'package:inf_common/inf_common.dart';

DataAuth authFromJwtPayload(
  grpc.ServiceCall call, {
  bool applicationToken = false,
}) {
  if (!call.clientMetadata.containsKey('authorization') &&
      !call.clientMetadata.containsKey('authority')) {
    throw grpc.GrpcError.unauthenticated('Authorization missing.');
  }
  if (!call.clientMetadata.containsKey('x-jwt-payload')) {
    throw grpc.GrpcError.unauthenticated('Payload not decoded by proxy.');
  }
  dynamic payload;
  try {
    payload = json.decode(
      utf8.decode(
        base64.decode(
          // Base64 encoded strings must be divisible by 4.
          // Envoy Proxy does not normalize the string.
          base64.normalize(
            call.clientMetadata['x-jwt-payload'],
          ),
        ),
      ),
    );
  } catch (error, _) {
    throw grpc.GrpcError.unauthenticated('Payload cannot be decoded.');
  }
  dynamic pb = payload['pb'];
  if (pb == null) {
    if (applicationToken) {
      return DataAuth();
    } else {
      throw grpc.GrpcError.unauthenticated('Application token not permitted.');
    }
  } else if (applicationToken) {
    throw grpc.GrpcError.unauthenticated('Expect application token.');
  }
  DataAuth auth;
  try {
    auth = DataAuth()..mergeFromBuffer(base64.decode(pb));
    auth.freeze();
  } catch (error, _) {
    throw grpc.GrpcError.unauthenticated('Payload buffer cannot be decoded.');
  }
  return auth;
}

/* end of file */
