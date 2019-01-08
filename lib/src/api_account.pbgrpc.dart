///
//  Generated code. Do not modify.
//  source: api_account.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'net_account_protobuf.pb.dart' as $0;
export 'api_account.pb.dart';

class ApiAccountClient extends Client {
  static final _$setType =
      new ClientMethod<$0.NetSetAccountType, $0.NetAccount>(
          '/inf_common.ApiAccount/SetType',
          ($0.NetSetAccountType value) => value.writeToBuffer(),
          (List<int> value) => new $0.NetAccount.fromBuffer(value));
  static final _$connectProvider =
      new ClientMethod<$0.NetOAuthConnect, $0.NetOAuthConnection>(
          '/inf_common.ApiAccount/ConnectProvider',
          ($0.NetOAuthConnect value) => value.writeToBuffer(),
          (List<int> value) => new $0.NetOAuthConnection.fromBuffer(value));
  static final _$create = new ClientMethod<$0.NetAccountCreate, $0.NetAccount>(
      '/inf_common.ApiAccount/Create',
      ($0.NetAccountCreate value) => value.writeToBuffer(),
      (List<int> value) => new $0.NetAccount.fromBuffer(value));
  static final _$setFirebaseToken =
      new ClientMethod<$0.NetSetFirebaseToken, $0.NetAccount>(
          '/inf_common.ApiAccount/SetFirebaseToken',
          ($0.NetSetFirebaseToken value) => value.writeToBuffer(),
          (List<int> value) => new $0.NetAccount.fromBuffer(value));

  ApiAccountClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<$0.NetAccount> setType($0.NetSetAccountType request,
      {CallOptions options}) {
    final call = $createCall(
        _$setType, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$0.NetOAuthConnection> connectProvider(
      $0.NetOAuthConnect request,
      {CallOptions options}) {
    final call = $createCall(
        _$connectProvider, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$0.NetAccount> create($0.NetAccountCreate request,
      {CallOptions options}) {
    final call = $createCall(
        _$create, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$0.NetAccount> setFirebaseToken($0.NetSetFirebaseToken request,
      {CallOptions options}) {
    final call = $createCall(
        _$setFirebaseToken, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class ApiAccountServiceBase extends Service {
  String get $name => 'inf_common.ApiAccount';

  ApiAccountServiceBase() {
    $addMethod(new ServiceMethod<$0.NetSetAccountType, $0.NetAccount>(
        'SetType',
        setType_Pre,
        false,
        false,
        (List<int> value) => new $0.NetSetAccountType.fromBuffer(value),
        ($0.NetAccount value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$0.NetOAuthConnect, $0.NetOAuthConnection>(
        'ConnectProvider',
        connectProvider_Pre,
        false,
        false,
        (List<int> value) => new $0.NetOAuthConnect.fromBuffer(value),
        ($0.NetOAuthConnection value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$0.NetAccountCreate, $0.NetAccount>(
        'Create',
        create_Pre,
        false,
        false,
        (List<int> value) => new $0.NetAccountCreate.fromBuffer(value),
        ($0.NetAccount value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$0.NetSetFirebaseToken, $0.NetAccount>(
        'SetFirebaseToken',
        setFirebaseToken_Pre,
        false,
        false,
        (List<int> value) => new $0.NetSetFirebaseToken.fromBuffer(value),
        ($0.NetAccount value) => value.writeToBuffer()));
  }

  $async.Future<$0.NetAccount> setType_Pre(
      ServiceCall call, $async.Future request) async {
    return setType(call, await request);
  }

  $async.Future<$0.NetOAuthConnection> connectProvider_Pre(
      ServiceCall call, $async.Future request) async {
    return connectProvider(call, await request);
  }

  $async.Future<$0.NetAccount> create_Pre(
      ServiceCall call, $async.Future request) async {
    return create(call, await request);
  }

  $async.Future<$0.NetAccount> setFirebaseToken_Pre(
      ServiceCall call, $async.Future request) async {
    return setFirebaseToken(call, await request);
  }

  $async.Future<$0.NetAccount> setType(
      ServiceCall call, $0.NetSetAccountType request);
  $async.Future<$0.NetOAuthConnection> connectProvider(
      ServiceCall call, $0.NetOAuthConnect request);
  $async.Future<$0.NetAccount> create(
      ServiceCall call, $0.NetAccountCreate request);
  $async.Future<$0.NetAccount> setFirebaseToken(
      ServiceCall call, $0.NetSetFirebaseToken request);
}
