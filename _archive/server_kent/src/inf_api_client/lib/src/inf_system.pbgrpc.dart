///
//  Generated code. Do not modify.
//  source: inf_system.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:grpc/service_api.dart' as $grpc;

import 'dart:core' as $core show int, String, List;

import 'empty.pb.dart' as $0;
import 'inf_system.pb.dart';
export 'inf_system.pb.dart';

class InfSystemClient extends $grpc.Client {
  static final _$pingServer = $grpc.ClientMethod<$0.Empty, AliveMessage>(
      '/api.InfSystem/PingServer',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => AliveMessage.fromBuffer(value));

  InfSystemClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<AliveMessage> pingServer($0.Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$pingServer, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class InfSystemServiceBase extends $grpc.Service {
  $core.String get $name => 'api.InfSystem';

  InfSystemServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, AliveMessage>(
        'PingServer',
        pingServer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        (AliveMessage value) => value.writeToBuffer()));
  }

  $async.Future<AliveMessage> pingServer_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return pingServer(call, await request);
  }

  $async.Future<AliveMessage> pingServer(
      $grpc.ServiceCall call, $0.Empty request);
}
