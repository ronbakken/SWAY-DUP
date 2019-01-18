///
//  Generated code. Do not modify.
//  source: inf_system.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'empty.pb.dart' as $0;
import 'inf_system.pb.dart';
export 'inf_system.pb.dart';

class InfSystemClient extends Client {
  static final _$pingServer = new ClientMethod<$0.Empty, AliveMessage>(
      '/api.InfSystem/PingServer',
      ($0.Empty value) => value.writeToBuffer(),
      (List<int> value) => new AliveMessage.fromBuffer(value));

  InfSystemClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<AliveMessage> pingServer($0.Empty request,
      {CallOptions options}) {
    final call = $createCall(
        _$pingServer, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class InfSystemServiceBase extends Service {
  String get $name => 'api.InfSystem';

  InfSystemServiceBase() {
    $addMethod(new ServiceMethod<$0.Empty, AliveMessage>(
        'PingServer',
        pingServer_Pre,
        false,
        false,
        (List<int> value) => new $0.Empty.fromBuffer(value),
        (AliveMessage value) => value.writeToBuffer()));
  }

  $async.Future<AliveMessage> pingServer_Pre(
      ServiceCall call, $async.Future request) async {
    return pingServer(call, await request);
  }

  $async.Future<AliveMessage> pingServer(ServiceCall call, $0.Empty request);
}
