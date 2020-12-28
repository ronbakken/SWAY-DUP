///
//  Generated code. Do not modify.
//  source: api_account.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'net_account_protobuf.pb.dart' as $0;
import 'net_ident_protobuf.pb.dart' as $1;
export 'api_account.pb.dart';

class ApiAccountClient extends $grpc.Client {
  static final _$setType =
      $grpc.ClientMethod<$0.NetSetAccountType, $0.NetAccount>(
          '/inf.ApiAccount/SetType',
          ($0.NetSetAccountType value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.NetAccount.fromBuffer(value));
  static final _$connectProvider =
      $grpc.ClientMethod<$0.NetOAuthConnect, $0.NetOAuthConnection>(
          '/inf.ApiAccount/ConnectProvider',
          ($0.NetOAuthConnect value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.NetOAuthConnection.fromBuffer(value));
  static final _$create =
      $grpc.ClientMethod<$0.NetAccountCreate, $1.NetSession>(
          '/inf.ApiAccount/Create',
          ($0.NetAccountCreate value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.NetSession.fromBuffer(value));
  static final _$setFirebaseToken =
      $grpc.ClientMethod<$0.NetSetFirebaseToken, $0.NetAccount>(
          '/inf.ApiAccount/SetFirebaseToken',
          ($0.NetSetFirebaseToken value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.NetAccount.fromBuffer(value));

  ApiAccountClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.NetAccount> setType($0.NetSetAccountType request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$setType, request, options: options);
  }

  $grpc.ResponseFuture<$0.NetOAuthConnection> connectProvider(
      $0.NetOAuthConnect request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$connectProvider, request, options: options);
  }

  $grpc.ResponseFuture<$1.NetSession> create($0.NetAccountCreate request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$0.NetAccount> setFirebaseToken(
      $0.NetSetFirebaseToken request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$setFirebaseToken, request, options: options);
  }
}

abstract class ApiAccountServiceBase extends $grpc.Service {
  $core.String get $name => 'inf.ApiAccount';

  ApiAccountServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.NetSetAccountType, $0.NetAccount>(
        'SetType',
        setType_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.NetSetAccountType.fromBuffer(value),
        ($0.NetAccount value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.NetOAuthConnect, $0.NetOAuthConnection>(
        'ConnectProvider',
        connectProvider_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.NetOAuthConnect.fromBuffer(value),
        ($0.NetOAuthConnection value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.NetAccountCreate, $1.NetSession>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.NetAccountCreate.fromBuffer(value),
        ($1.NetSession value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.NetSetFirebaseToken, $0.NetAccount>(
        'SetFirebaseToken',
        setFirebaseToken_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.NetSetFirebaseToken.fromBuffer(value),
        ($0.NetAccount value) => value.writeToBuffer()));
  }

  $async.Future<$0.NetAccount> setType_Pre($grpc.ServiceCall call,
      $async.Future<$0.NetSetAccountType> request) async {
    return setType(call, await request);
  }

  $async.Future<$0.NetOAuthConnection> connectProvider_Pre(
      $grpc.ServiceCall call, $async.Future<$0.NetOAuthConnect> request) async {
    return connectProvider(call, await request);
  }

  $async.Future<$1.NetSession> create_Pre($grpc.ServiceCall call,
      $async.Future<$0.NetAccountCreate> request) async {
    return create(call, await request);
  }

  $async.Future<$0.NetAccount> setFirebaseToken_Pre($grpc.ServiceCall call,
      $async.Future<$0.NetSetFirebaseToken> request) async {
    return setFirebaseToken(call, await request);
  }

  $async.Future<$0.NetAccount> setType(
      $grpc.ServiceCall call, $0.NetSetAccountType request);
  $async.Future<$0.NetOAuthConnection> connectProvider(
      $grpc.ServiceCall call, $0.NetOAuthConnect request);
  $async.Future<$1.NetSession> create(
      $grpc.ServiceCall call, $0.NetAccountCreate request);
  $async.Future<$0.NetAccount> setFirebaseToken(
      $grpc.ServiceCall call, $0.NetSetFirebaseToken request);
}
