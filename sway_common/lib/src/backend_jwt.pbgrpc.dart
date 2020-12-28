///
//  Generated code. Do not modify.
//  source: backend_jwt.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'backend_jwt.pb.dart' as $10;
export 'backend_jwt.pb.dart';

class BackendJwtClient extends $grpc.Client {
  static final _$sign = $grpc.ClientMethod<$10.ReqSign, $10.ResSign>(
      '/inf.BackendJwt/Sign',
      ($10.ReqSign value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $10.ResSign.fromBuffer(value));
  static final _$getKeyStore =
      $grpc.ClientMethod<$10.ReqGetKeyStore, $10.ResGetKeyStore>(
          '/inf.BackendJwt/GetKeyStore',
          ($10.ReqGetKeyStore value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $10.ResGetKeyStore.fromBuffer(value));

  BackendJwtClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$10.ResSign> sign($10.ReqSign request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$sign, request, options: options);
  }

  $grpc.ResponseFuture<$10.ResGetKeyStore> getKeyStore(
      $10.ReqGetKeyStore request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$getKeyStore, request, options: options);
  }
}

abstract class BackendJwtServiceBase extends $grpc.Service {
  $core.String get $name => 'inf.BackendJwt';

  BackendJwtServiceBase() {
    $addMethod($grpc.ServiceMethod<$10.ReqSign, $10.ResSign>(
        'Sign',
        sign_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $10.ReqSign.fromBuffer(value),
        ($10.ResSign value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$10.ReqGetKeyStore, $10.ResGetKeyStore>(
        'GetKeyStore',
        getKeyStore_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $10.ReqGetKeyStore.fromBuffer(value),
        ($10.ResGetKeyStore value) => value.writeToBuffer()));
  }

  $async.Future<$10.ResSign> sign_Pre(
      $grpc.ServiceCall call, $async.Future<$10.ReqSign> request) async {
    return sign(call, await request);
  }

  $async.Future<$10.ResGetKeyStore> getKeyStore_Pre(
      $grpc.ServiceCall call, $async.Future<$10.ReqGetKeyStore> request) async {
    return getKeyStore(call, await request);
  }

  $async.Future<$10.ResSign> sign($grpc.ServiceCall call, $10.ReqSign request);
  $async.Future<$10.ResGetKeyStore> getKeyStore(
      $grpc.ServiceCall call, $10.ReqGetKeyStore request);
}
