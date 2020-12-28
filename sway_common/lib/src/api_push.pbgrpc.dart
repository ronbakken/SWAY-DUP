///
//  Generated code. Do not modify.
//  source: api_push.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'net_push_protobuf.pb.dart' as $7;
export 'api_push.pb.dart';

class ApiPushClient extends $grpc.Client {
  static final _$listen = $grpc.ClientMethod<$7.NetListen, $7.NetPush>(
      '/inf.ApiPush/Listen',
      ($7.NetListen value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $7.NetPush.fromBuffer(value));
  static final _$keepAlive =
      $grpc.ClientMethod<$7.NetKeepAlive, $7.NetKeepAlive>(
          '/inf.ApiPush/KeepAlive',
          ($7.NetKeepAlive value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $7.NetKeepAlive.fromBuffer(value));

  ApiPushClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseStream<$7.NetPush> listen($7.NetListen request,
      {$grpc.CallOptions options}) {
    return $createStreamingCall(_$listen, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$7.NetKeepAlive> keepAlive($7.NetKeepAlive request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$keepAlive, request, options: options);
  }
}

abstract class ApiPushServiceBase extends $grpc.Service {
  $core.String get $name => 'inf.ApiPush';

  ApiPushServiceBase() {
    $addMethod($grpc.ServiceMethod<$7.NetListen, $7.NetPush>(
        'Listen',
        listen_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $7.NetListen.fromBuffer(value),
        ($7.NetPush value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$7.NetKeepAlive, $7.NetKeepAlive>(
        'KeepAlive',
        keepAlive_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $7.NetKeepAlive.fromBuffer(value),
        ($7.NetKeepAlive value) => value.writeToBuffer()));
  }

  $async.Stream<$7.NetPush> listen_Pre(
      $grpc.ServiceCall call, $async.Future<$7.NetListen> request) async* {
    yield* listen(call, await request);
  }

  $async.Future<$7.NetKeepAlive> keepAlive_Pre(
      $grpc.ServiceCall call, $async.Future<$7.NetKeepAlive> request) async {
    return keepAlive(call, await request);
  }

  $async.Stream<$7.NetPush> listen(
      $grpc.ServiceCall call, $7.NetListen request);
  $async.Future<$7.NetKeepAlive> keepAlive(
      $grpc.ServiceCall call, $7.NetKeepAlive request);
}
