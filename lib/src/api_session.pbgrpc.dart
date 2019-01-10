///
//  Generated code. Do not modify.
//  source: api_session.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'net_ident_protobuf.pb.dart' as $7;
export 'api_session.pb.dart';

class ApiSessionClient extends Client {
  static final _$create = new ClientMethod<$7.NetSessionCreate, $7.NetSession>(
      '/inf.ApiSession/Create',
      ($7.NetSessionCreate value) => value.writeToBuffer(),
      (List<int> value) => new $7.NetSession.fromBuffer(value));
  static final _$open = new ClientMethod<$7.NetSessionOpen, $7.NetSession>(
      '/inf.ApiSession/Open',
      ($7.NetSessionOpen value) => value.writeToBuffer(),
      (List<int> value) => new $7.NetSession.fromBuffer(value));

  ApiSessionClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<$7.NetSession> create($7.NetSessionCreate request,
      {CallOptions options}) {
    final call = $createCall(
        _$create, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$7.NetSession> open($7.NetSessionOpen request,
      {CallOptions options}) {
    final call = $createCall(_$open, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class ApiSessionServiceBase extends Service {
  String get $name => 'inf.ApiSession';

  ApiSessionServiceBase() {
    $addMethod(new ServiceMethod<$7.NetSessionCreate, $7.NetSession>(
        'Create',
        create_Pre,
        false,
        false,
        (List<int> value) => new $7.NetSessionCreate.fromBuffer(value),
        ($7.NetSession value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$7.NetSessionOpen, $7.NetSession>(
        'Open',
        open_Pre,
        false,
        false,
        (List<int> value) => new $7.NetSessionOpen.fromBuffer(value),
        ($7.NetSession value) => value.writeToBuffer()));
  }

  $async.Future<$7.NetSession> create_Pre(
      ServiceCall call, $async.Future request) async {
    return create(call, await request);
  }

  $async.Future<$7.NetSession> open_Pre(
      ServiceCall call, $async.Future request) async {
    return open(call, await request);
  }

  $async.Future<$7.NetSession> create(
      ServiceCall call, $7.NetSessionCreate request);
  $async.Future<$7.NetSession> open(
      ServiceCall call, $7.NetSessionOpen request);
}
