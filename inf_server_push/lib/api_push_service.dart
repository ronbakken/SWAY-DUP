/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';

import 'package:inf_server_push/backend_push_service.dart';
import 'package:logging/logging.dart';

import 'package:grpc/grpc.dart' as grpc;

import 'package:sway_common/inf_common.dart';

class ApiPushService extends ApiPushServiceBase {
  static final Logger opsLog = Logger('InfOps.ApiPushService');
  static final Logger devLog = Logger('InfDev.ApiPushService');
  final BackendPushService backend;

  ApiPushService(this.backend);

  @override
  Stream<NetPush> listen(grpc.ServiceCall call, NetListen request) {
    return backend.listen(call, request);
  }

  @override
  Future<NetKeepAlive> keepAlive(
      grpc.ServiceCall call, NetKeepAlive request) async {
    return NetKeepAlive();
  }
}

/* end of file */
