///
//  Generated code. Do not modify.
//  source: api_push.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart';

import 'net_push_protobuf.pb.dart' as $5;
import 'api_push.pbjson.dart';

export 'api_push.pb.dart';

abstract class ApiPushServiceBase extends GeneratedService {
  $async.Future<$5.NetPush> listen(ServerContext ctx, $5.NetListen request);

  GeneratedMessage createRequest(String method) {
    switch (method) {
      case 'Listen':
        return new $5.NetListen();
      default:
        throw new ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<GeneratedMessage> handleCall(
      ServerContext ctx, String method, GeneratedMessage request) {
    switch (method) {
      case 'Listen':
        return this.listen(ctx, request);
      default:
        throw new ArgumentError('Unknown method: $method');
    }
  }

  Map<String, dynamic> get $json => ApiPushServiceBase$json;
  Map<String, Map<String, dynamic>> get $messageJson =>
      ApiPushServiceBase$messageJson;
}
