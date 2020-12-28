///
//  Generated code. Do not modify.
//  source: backend_push.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'backend_push.pb.dart' as $11;
export 'backend_push.pb.dart';

class BackendPushClient extends $grpc.Client {
  static final _$push = $grpc.ClientMethod<$11.ReqPush, $11.ResPush>(
      '/inf.BackendPush/Push',
      ($11.ReqPush value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $11.ResPush.fromBuffer(value));
  static final _$setFirebaseToken =
      $grpc.ClientMethod<$11.ReqSetFirebaseToken, $11.ResSetFirebaseToken>(
          '/inf.BackendPush/SetFirebaseToken',
          ($11.ReqSetFirebaseToken value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $11.ResSetFirebaseToken.fromBuffer(value));

  BackendPushClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$11.ResPush> push($11.ReqPush request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$push, request, options: options);
  }

  $grpc.ResponseFuture<$11.ResSetFirebaseToken> setFirebaseToken(
      $11.ReqSetFirebaseToken request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$setFirebaseToken, request, options: options);
  }
}

abstract class BackendPushServiceBase extends $grpc.Service {
  $core.String get $name => 'inf.BackendPush';

  BackendPushServiceBase() {
    $addMethod($grpc.ServiceMethod<$11.ReqPush, $11.ResPush>(
        'Push',
        push_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $11.ReqPush.fromBuffer(value),
        ($11.ResPush value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$11.ReqSetFirebaseToken, $11.ResSetFirebaseToken>(
            'SetFirebaseToken',
            setFirebaseToken_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $11.ReqSetFirebaseToken.fromBuffer(value),
            ($11.ResSetFirebaseToken value) => value.writeToBuffer()));
  }

  $async.Future<$11.ResPush> push_Pre(
      $grpc.ServiceCall call, $async.Future<$11.ReqPush> request) async {
    return push(call, await request);
  }

  $async.Future<$11.ResSetFirebaseToken> setFirebaseToken_Pre(
      $grpc.ServiceCall call,
      $async.Future<$11.ReqSetFirebaseToken> request) async {
    return setFirebaseToken(call, await request);
  }

  $async.Future<$11.ResPush> push($grpc.ServiceCall call, $11.ReqPush request);
  $async.Future<$11.ResSetFirebaseToken> setFirebaseToken(
      $grpc.ServiceCall call, $11.ReqSetFirebaseToken request);
}
