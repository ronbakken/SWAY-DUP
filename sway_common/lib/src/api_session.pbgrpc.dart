///
//  Generated code. Do not modify.
//  source: api_session.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'net_ident_protobuf.pb.dart' as $1;
export 'api_session.pb.dart';

class ApiSessionClient extends $grpc.Client {
  static final _$create =
      $grpc.ClientMethod<$1.NetSessionCreate, $1.NetSession>(
          '/inf.ApiSession/Create',
          ($1.NetSessionCreate value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.NetSession.fromBuffer(value));
  static final _$open = $grpc.ClientMethod<$1.NetSessionOpen, $1.NetSession>(
      '/inf.ApiSession/Open',
      ($1.NetSessionOpen value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.NetSession.fromBuffer(value));

  ApiSessionClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$1.NetSession> create($1.NetSessionCreate request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$1.NetSession> open($1.NetSessionOpen request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$open, request, options: options);
  }
}

abstract class ApiSessionServiceBase extends $grpc.Service {
  $core.String get $name => 'inf.ApiSession';

  ApiSessionServiceBase() {
    $addMethod($grpc.ServiceMethod<$1.NetSessionCreate, $1.NetSession>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.NetSessionCreate.fromBuffer(value),
        ($1.NetSession value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.NetSessionOpen, $1.NetSession>(
        'Open',
        open_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.NetSessionOpen.fromBuffer(value),
        ($1.NetSession value) => value.writeToBuffer()));
  }

  $async.Future<$1.NetSession> create_Pre($grpc.ServiceCall call,
      $async.Future<$1.NetSessionCreate> request) async {
    return create(call, await request);
  }

  $async.Future<$1.NetSession> open_Pre(
      $grpc.ServiceCall call, $async.Future<$1.NetSessionOpen> request) async {
    return open(call, await request);
  }

  $async.Future<$1.NetSession> create(
      $grpc.ServiceCall call, $1.NetSessionCreate request);
  $async.Future<$1.NetSession> open(
      $grpc.ServiceCall call, $1.NetSessionOpen request);
}
