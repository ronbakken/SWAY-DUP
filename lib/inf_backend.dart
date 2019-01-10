/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

library inf_common;

export 'package:inf_common/inf_common.dart';

export 'package:inf_common/src/backend_push.pb.dart';
export 'package:inf_common/src/backend_push.pbgrpc.dart';

export 'package:inf_common/src/backend_jwt.pb.dart';
export 'package:inf_common/src/backend_jwt.pbgrpc.dart';

import 'dart:convert';

import 'package:grpc/grpc.dart' as grpc;
import 'package:inf_common/inf_common.dart';

DataAuth authFromJwtPayload(grpc.ServiceCall call) {
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
        utf8.decode(base64.decode(call.clientMetadata['x-jwt-payload'])));
  } catch (error, _) {
    throw grpc.GrpcError.unauthenticated('Payload cannot be decoded.');
  }
  dynamic pb = payload['pb'];
  if (pb == null) {
    // return DataAuth();
    throw grpc.GrpcError.unauthenticated('Payload buffer missing.');
  }
  DataAuth auth;
  try {
    auth = DataAuth()..mergeFromJsonMap(pb);
  } catch (error, _) {
    throw grpc.GrpcError.unauthenticated('Payload buffer cannot be decoded.');
  }
  return auth;
}

/* end of file */
