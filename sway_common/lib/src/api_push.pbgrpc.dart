///
//  Generated code. Do not modify.
//  source: api_push.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'net_push_protobuf.pb.dart' as $7;
export 'api_push.pb.dart';

class ApiPushClient extends Client {
  static final _$listen = new ClientMethod<$7.NetListen, $7.NetPush>(
      '/inf.ApiPush/Listen',
      ($7.NetListen value) => value.writeToBuffer(),
      (List<int> value) => new $7.NetPush.fromBuffer(value));
  static final _$keepAlive = new ClientMethod<$7.NetKeepAlive, $7.NetKeepAlive>(
      '/inf.ApiPush/KeepAlive',
      ($7.NetKeepAlive value) => value.writeToBuffer(),
      (List<int> value) => new $7.NetKeepAlive.fromBuffer(value));

  ApiPushClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseStream<$7.NetPush> listen($7.NetListen request,
      {CallOptions options}) {
    final call = $createCall(
        _$listen, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseStream(call);
  }

  ResponseFuture<$7.NetKeepAlive> keepAlive($7.NetKeepAlive request,
      {CallOptions options}) {
    final call = $createCall(
        _$keepAlive, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class ApiPushServiceBase extends Service {
  String get $name => 'inf.ApiPush';

  ApiPushServiceBase() {
    $addMethod(new ServiceMethod<$7.NetListen, $7.NetPush>(
        'Listen',
        listen_Pre,
        false,
        true,
        (List<int> value) => new $7.NetListen.fromBuffer(value),
        ($7.NetPush value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$7.NetKeepAlive, $7.NetKeepAlive>(
        'KeepAlive',
        keepAlive_Pre,
        false,
        false,
        (List<int> value) => new $7.NetKeepAlive.fromBuffer(value),
        ($7.NetKeepAlive value) => value.writeToBuffer()));
  }

  $async.Stream<$7.NetPush> listen_Pre(
      ServiceCall call, $async.Future request) async* {
    yield* listen(call, (await request) as $7.NetListen);
  }

  $async.Future<$7.NetKeepAlive> keepAlive_Pre(
      ServiceCall call, $async.Future request) async {
    return keepAlive(call, await request);
  }

  $async.Stream<$7.NetPush> listen(ServiceCall call, $7.NetListen request);
  $async.Future<$7.NetKeepAlive> keepAlive(
      ServiceCall call, $7.NetKeepAlive request);
}
