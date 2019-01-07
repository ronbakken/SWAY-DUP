///
//  Generated code. Do not modify.
//  source: api_push.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'net_push_protobuf.pb.dart' as $1;
export 'api_push.pb.dart';

class ApiPushClient extends Client {
  static final _$listen = new ClientMethod<$1.NetListen, $1.NetPush>(
      '/inf_common.ApiPush/Listen',
      ($1.NetListen value) => value.writeToBuffer(),
      (List<int> value) => new $1.NetPush.fromBuffer(value));

  ApiPushClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseStream<$1.NetPush> listen($1.NetListen request,
      {CallOptions options}) {
    final call = $createCall(
        _$listen, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseStream(call);
  }
}

abstract class ApiPushServiceBase extends Service {
  String get $name => 'inf_common.ApiPush';

  ApiPushServiceBase() {
    $addMethod(new ServiceMethod<$1.NetListen, $1.NetPush>(
        'Listen',
        listen_Pre,
        false,
        true,
        (List<int> value) => new $1.NetListen.fromBuffer(value),
        ($1.NetPush value) => value.writeToBuffer()));
  }

  $async.Stream<$1.NetPush> listen_Pre(
      ServiceCall call, $async.Future request) async* {
    yield* listen(call, (await request) as $1.NetListen);
  }

  $async.Stream<$1.NetPush> listen(ServiceCall call, $1.NetListen request);
}
