///
//  Generated code. Do not modify.
//  source: inf_api.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:grpc/service_api.dart' as $grpc;

import 'dart:core' as $core show int, String, List;

import 'inf_api.pb.dart';
export 'inf_api.pb.dart';

class InfApiClient extends $grpc.Client {
  static final _$sayHello = $grpc.ClientMethod<HelloRequest, HelloReply>(
      '/api.InfApi/SayHello',
      (HelloRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => HelloReply.fromBuffer(value));
  static final _$sayHelloAgain = $grpc.ClientMethod<HelloRequest, HelloReply>(
      '/api.InfApi/SayHelloAgain',
      (HelloRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => HelloReply.fromBuffer(value));

  InfApiClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<HelloReply> sayHello(HelloRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$sayHello, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<HelloReply> sayHelloAgain(HelloRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$sayHelloAgain, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class InfApiServiceBase extends $grpc.Service {
  $core.String get $name => 'api.InfApi';

  InfApiServiceBase() {
    $addMethod($grpc.ServiceMethod<HelloRequest, HelloReply>(
        'SayHello',
        sayHello_Pre,
        false,
        false,
        ($core.List<$core.int> value) => HelloRequest.fromBuffer(value),
        (HelloReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<HelloRequest, HelloReply>(
        'SayHelloAgain',
        sayHelloAgain_Pre,
        false,
        false,
        ($core.List<$core.int> value) => HelloRequest.fromBuffer(value),
        (HelloReply value) => value.writeToBuffer()));
  }

  $async.Future<HelloReply> sayHello_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return sayHello(call, await request);
  }

  $async.Future<HelloReply> sayHelloAgain_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return sayHelloAgain(call, await request);
  }

  $async.Future<HelloReply> sayHello(
      $grpc.ServiceCall call, HelloRequest request);
  $async.Future<HelloReply> sayHelloAgain(
      $grpc.ServiceCall call, HelloRequest request);
}
