/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:grpc/grpc.dart' as grpc;

import 'package:sample_jwt/src/protos/sample_jwt.pb.dart';
import 'package:sample_jwt/src/protos/sample_jwt.pbgrpc.dart';
export 'package:sample_jwt/src/protos/sample_jwt.pb.dart';
export 'package:sample_jwt/src/protos/sample_jwt.pbgrpc.dart';

class SampleJwtService extends SampleJwtServiceBase {
  static final Logger log = Logger('SampleJwtService');

  @override
  Future<ResGenerate> generate(grpc.ServiceCall call, ReqGenerate request) async {
    log.severe(call.clientMetadata);
    log.severe(request);
    final ResGenerate response = ResGenerate();
    return response;
  }

  @override
  Future<ResValidate> validate(grpc.ServiceCall call, ReqValidate request) async {
    log.severe(call.clientMetadata);
    log.severe(request);
    final ResValidate response = ResValidate();
    return response;
  }

}

/* end of file */
