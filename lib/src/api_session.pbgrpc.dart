///
//  Generated code. Do not modify.
//  source: api_session.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'net_ident_protobuf.pb.dart' as $1;
export 'api_session.pb.dart';

class ApiSessionClient extends Client {
  static final _$create = new ClientMethod<$1.NetSessionCreate, $1.NetSession>(
      '/inf.ApiSession/Create',
      ($1.NetSessionCreate value) => value.writeToBuffer(),
      (List<int> value) => new $1.NetSession.fromBuffer(value));
  static final _$open = new ClientMethod<$1.NetSessionOpen, $1.NetSession>(
      '/inf.ApiSession/Open',
      ($1.NetSessionOpen value) => value.writeToBuffer(),
      (List<int> value) => new $1.NetSession.fromBuffer(value));

  ApiSessionClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<$1.NetSession> create($1.NetSessionCreate request,
      {CallOptions options}) {
    final call = $createCall(
        _$create, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$1.NetSession> open($1.NetSessionOpen request,
      {CallOptions options}) {
    final call = $createCall(_$open, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class ApiSessionServiceBase extends Service {
  String get $name => 'inf.ApiSession';

  ApiSessionServiceBase() {
    $addMethod(new ServiceMethod<$1.NetSessionCreate, $1.NetSession>(
        'Create',
        create_Pre,
        false,
        false,
        (List<int> value) => new $1.NetSessionCreate.fromBuffer(value),
        ($1.NetSession value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$1.NetSessionOpen, $1.NetSession>(
        'Open',
        open_Pre,
        false,
        false,
        (List<int> value) => new $1.NetSessionOpen.fromBuffer(value),
        ($1.NetSession value) => value.writeToBuffer()));
  }

  $async.Future<$1.NetSession> create_Pre(
      ServiceCall call, $async.Future request) async {
    return create(call, await request);
  }

  $async.Future<$1.NetSession> open_Pre(
      ServiceCall call, $async.Future request) async {
    return open(call, await request);
  }

  $async.Future<$1.NetSession> create(
      ServiceCall call, $1.NetSessionCreate request);
  $async.Future<$1.NetSession> open(
      ServiceCall call, $1.NetSessionOpen request);
}
