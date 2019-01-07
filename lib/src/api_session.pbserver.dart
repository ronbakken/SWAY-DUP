///
//  Generated code. Do not modify.
//  source: api_session.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart';

import 'api_session.pbjson.dart';

export 'api_session.pb.dart';

abstract class ApiSessionServiceBase extends GeneratedService {
  GeneratedMessage createRequest(String method) {
    switch (method) {
      default:
        throw new ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<GeneratedMessage> handleCall(
      ServerContext ctx, String method, GeneratedMessage request) {
    switch (method) {
      default:
        throw new ArgumentError('Unknown method: $method');
    }
  }

  Map<String, dynamic> get $json => ApiSessionServiceBase$json;
  Map<String, Map<String, dynamic>> get $messageJson =>
      ApiSessionServiceBase$messageJson;
}
