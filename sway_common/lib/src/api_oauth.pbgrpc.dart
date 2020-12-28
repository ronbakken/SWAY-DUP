///
//  Generated code. Do not modify.
//  source: api_oauth.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'net_account_protobuf.pb.dart' as $0;
export 'api_oauth.pb.dart';

class ApiOAuthClient extends $grpc.Client {
  static final _$getUrl = $grpc.ClientMethod<$0.NetOAuthGetUrl, $0.NetOAuthUrl>(
      '/inf.ApiOAuth/GetUrl',
      ($0.NetOAuthGetUrl value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.NetOAuthUrl.fromBuffer(value));
  static final _$getSecrets =
      $grpc.ClientMethod<$0.NetOAuthGetSecrets, $0.NetOAuthSecrets>(
          '/inf.ApiOAuth/GetSecrets',
          ($0.NetOAuthGetSecrets value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.NetOAuthSecrets.fromBuffer(value));

  ApiOAuthClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.NetOAuthUrl> getUrl($0.NetOAuthGetUrl request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$getUrl, request, options: options);
  }

  $grpc.ResponseFuture<$0.NetOAuthSecrets> getSecrets(
      $0.NetOAuthGetSecrets request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$getSecrets, request, options: options);
  }
}

abstract class ApiOAuthServiceBase extends $grpc.Service {
  $core.String get $name => 'inf.ApiOAuth';

  ApiOAuthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.NetOAuthGetUrl, $0.NetOAuthUrl>(
        'GetUrl',
        getUrl_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.NetOAuthGetUrl.fromBuffer(value),
        ($0.NetOAuthUrl value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.NetOAuthGetSecrets, $0.NetOAuthSecrets>(
        'GetSecrets',
        getSecrets_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.NetOAuthGetSecrets.fromBuffer(value),
        ($0.NetOAuthSecrets value) => value.writeToBuffer()));
  }

  $async.Future<$0.NetOAuthUrl> getUrl_Pre(
      $grpc.ServiceCall call, $async.Future<$0.NetOAuthGetUrl> request) async {
    return getUrl(call, await request);
  }

  $async.Future<$0.NetOAuthSecrets> getSecrets_Pre($grpc.ServiceCall call,
      $async.Future<$0.NetOAuthGetSecrets> request) async {
    return getSecrets(call, await request);
  }

  $async.Future<$0.NetOAuthUrl> getUrl(
      $grpc.ServiceCall call, $0.NetOAuthGetUrl request);
  $async.Future<$0.NetOAuthSecrets> getSecrets(
      $grpc.ServiceCall call, $0.NetOAuthGetSecrets request);
}
