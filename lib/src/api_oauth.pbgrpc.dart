///
//  Generated code. Do not modify.
//  source: api_oauth.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'net_account_protobuf.pb.dart' as $0;
export 'api_oauth.pb.dart';

class ApiOAuthClient extends Client {
  static final _$getUrl = new ClientMethod<$0.NetOAuthGetUrl, $0.NetOAuthUrl>(
      '/inf_common.ApiOAuth/GetUrl',
      ($0.NetOAuthGetUrl value) => value.writeToBuffer(),
      (List<int> value) => new $0.NetOAuthUrl.fromBuffer(value));
  static final _$getSecrets =
      new ClientMethod<$0.NetOAuthGetSecrets, $0.NetOAuthSecrets>(
          '/inf_common.ApiOAuth/GetSecrets',
          ($0.NetOAuthGetSecrets value) => value.writeToBuffer(),
          (List<int> value) => new $0.NetOAuthSecrets.fromBuffer(value));

  ApiOAuthClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<$0.NetOAuthUrl> getUrl($0.NetOAuthGetUrl request,
      {CallOptions options}) {
    final call = $createCall(
        _$getUrl, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$0.NetOAuthSecrets> getSecrets($0.NetOAuthGetSecrets request,
      {CallOptions options}) {
    final call = $createCall(
        _$getSecrets, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class ApiOAuthServiceBase extends Service {
  String get $name => 'inf_common.ApiOAuth';

  ApiOAuthServiceBase() {
    $addMethod(new ServiceMethod<$0.NetOAuthGetUrl, $0.NetOAuthUrl>(
        'GetUrl',
        getUrl_Pre,
        false,
        false,
        (List<int> value) => new $0.NetOAuthGetUrl.fromBuffer(value),
        ($0.NetOAuthUrl value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$0.NetOAuthGetSecrets, $0.NetOAuthSecrets>(
        'GetSecrets',
        getSecrets_Pre,
        false,
        false,
        (List<int> value) => new $0.NetOAuthGetSecrets.fromBuffer(value),
        ($0.NetOAuthSecrets value) => value.writeToBuffer()));
  }

  $async.Future<$0.NetOAuthUrl> getUrl_Pre(
      ServiceCall call, $async.Future request) async {
    return getUrl(call, await request);
  }

  $async.Future<$0.NetOAuthSecrets> getSecrets_Pre(
      ServiceCall call, $async.Future request) async {
    return getSecrets(call, await request);
  }

  $async.Future<$0.NetOAuthUrl> getUrl(
      ServiceCall call, $0.NetOAuthGetUrl request);
  $async.Future<$0.NetOAuthSecrets> getSecrets(
      ServiceCall call, $0.NetOAuthGetSecrets request);
}
