///
//  Generated code. Do not modify.
//  source: inf_api.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'inf_api.pb.dart';
export 'inf_api.pb.dart';

class InfApiClient extends Client {
  static final _$sayHello = new ClientMethod<HelloRequest, HelloReply>(
      '/api.InfApi/SayHello',
      (HelloRequest value) => value.writeToBuffer(),
      (List<int> value) => new HelloReply.fromBuffer(value));
  static final _$sayHelloAgain = new ClientMethod<HelloRequest, HelloReply>(
      '/api.InfApi/SayHelloAgain',
      (HelloRequest value) => value.writeToBuffer(),
      (List<int> value) => new HelloReply.fromBuffer(value));

  InfApiClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<HelloReply> sayHello(HelloRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$sayHello, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<HelloReply> sayHelloAgain(HelloRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$sayHelloAgain, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class InfApiServiceBase extends Service {
  String get $name => 'api.InfApi';

  InfApiServiceBase() {
    $addMethod(new ServiceMethod<HelloRequest, HelloReply>(
        'SayHello',
        sayHello_Pre,
        false,
        false,
        (List<int> value) => new HelloRequest.fromBuffer(value),
        (HelloReply value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<HelloRequest, HelloReply>(
        'SayHelloAgain',
        sayHelloAgain_Pre,
        false,
        false,
        (List<int> value) => new HelloRequest.fromBuffer(value),
        (HelloReply value) => value.writeToBuffer()));
  }

  $async.Future<HelloReply> sayHello_Pre(
      ServiceCall call, $async.Future request) async {
    return sayHello(call, await request);
  }

  $async.Future<HelloReply> sayHelloAgain_Pre(
      ServiceCall call, $async.Future request) async {
    return sayHelloAgain(call, await request);
  }

  $async.Future<HelloReply> sayHello(ServiceCall call, HelloRequest request);
  $async.Future<HelloReply> sayHelloAgain(
      ServiceCall call, HelloRequest request);
}
