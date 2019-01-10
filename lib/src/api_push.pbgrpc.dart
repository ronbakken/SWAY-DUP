///
//  Generated code. Do not modify.
//  source: api_push.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'net_push_protobuf.pb.dart' as $6;
export 'api_push.pb.dart';

class ApiPushClient extends Client {
  static final _$listen = new ClientMethod<$6.NetListen, $6.NetPush>(
      '/inf.ApiPush/Listen',
      ($6.NetListen value) => value.writeToBuffer(),
      (List<int> value) => new $6.NetPush.fromBuffer(value));

  ApiPushClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseStream<$6.NetPush> listen($6.NetListen request,
      {CallOptions options}) {
    final call = $createCall(
        _$listen, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseStream(call);
  }
}

abstract class ApiPushServiceBase extends Service {
  String get $name => 'inf.ApiPush';

  ApiPushServiceBase() {
    $addMethod(new ServiceMethod<$6.NetListen, $6.NetPush>(
        'Listen',
        listen_Pre,
        false,
        true,
        (List<int> value) => new $6.NetListen.fromBuffer(value),
        ($6.NetPush value) => value.writeToBuffer()));
  }

  $async.Stream<$6.NetPush> listen_Pre(
      ServiceCall call, $async.Future request) async* {
    yield* listen(call, (await request) as $6.NetListen);
  }

  $async.Stream<$6.NetPush> listen(ServiceCall call, $6.NetListen request);
}
