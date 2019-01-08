///
//  Generated code. Do not modify.
//  source: api_session.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'net_ident_protobuf.pb.dart' as $2;
export 'api_session.pb.dart';

class ApiSessionClient extends Client {
  static final _$create = new ClientMethod<$2.NetSessionCreate, $2.NetSession>(
      '/inf_common.ApiSession/Create',
      ($2.NetSessionCreate value) => value.writeToBuffer(),
      (List<int> value) => new $2.NetSession.fromBuffer(value));
  static final _$open = new ClientMethod<$2.NetSessionOpen, $2.NetSession>(
      '/inf_common.ApiSession/Open',
      ($2.NetSessionOpen value) => value.writeToBuffer(),
      (List<int> value) => new $2.NetSession.fromBuffer(value));

  ApiSessionClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseStream<$2.NetSession> create($2.NetSessionCreate request,
      {CallOptions options}) {
    final call = $createCall(
        _$create, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseStream(call);
  }

  ResponseStream<$2.NetSession> open($2.NetSessionOpen request,
      {CallOptions options}) {
    final call = $createCall(_$open, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseStream(call);
  }
}

abstract class ApiSessionServiceBase extends Service {
  String get $name => 'inf_common.ApiSession';

  ApiSessionServiceBase() {
    $addMethod(new ServiceMethod<$2.NetSessionCreate, $2.NetSession>(
        'Create',
        create_Pre,
        false,
        true,
        (List<int> value) => new $2.NetSessionCreate.fromBuffer(value),
        ($2.NetSession value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$2.NetSessionOpen, $2.NetSession>(
        'Open',
        open_Pre,
        false,
        true,
        (List<int> value) => new $2.NetSessionOpen.fromBuffer(value),
        ($2.NetSession value) => value.writeToBuffer()));
  }

  $async.Stream<$2.NetSession> create_Pre(
      ServiceCall call, $async.Future request) async* {
    yield* create(call, (await request) as $2.NetSessionCreate);
  }

  $async.Stream<$2.NetSession> open_Pre(
      ServiceCall call, $async.Future request) async* {
    yield* open(call, (await request) as $2.NetSessionOpen);
  }

  $async.Stream<$2.NetSession> create(
      ServiceCall call, $2.NetSessionCreate request);
  $async.Stream<$2.NetSession> open(
      ServiceCall call, $2.NetSessionOpen request);
}
