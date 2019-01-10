///
//  Generated code. Do not modify.
//  source: backend_push.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'backend_push.pb.dart';
export 'backend_push.pb.dart';

class BackendPushClient extends Client {
  static final _$push = new ClientMethod<ReqPush, ResPush>(
      '/inf.BackendPush/Push',
      (ReqPush value) => value.writeToBuffer(),
      (List<int> value) => new ResPush.fromBuffer(value));
  static final _$setFirebaseToken =
      new ClientMethod<ReqSetFirebaseToken, ResSetFirebaseToken>(
          '/inf.BackendPush/SetFirebaseToken',
          (ReqSetFirebaseToken value) => value.writeToBuffer(),
          (List<int> value) => new ResSetFirebaseToken.fromBuffer(value));
  static final _$setAccountName =
      new ClientMethod<ReqSetAccountName, ResSetAccountName>(
          '/inf.BackendPush/SetAccountName',
          (ReqSetAccountName value) => value.writeToBuffer(),
          (List<int> value) => new ResSetAccountName.fromBuffer(value));

  BackendPushClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<ResPush> push(ReqPush request, {CallOptions options}) {
    final call = $createCall(_$push, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<ResSetFirebaseToken> setFirebaseToken(
      ReqSetFirebaseToken request,
      {CallOptions options}) {
    final call = $createCall(
        _$setFirebaseToken, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<ResSetAccountName> setAccountName(ReqSetAccountName request,
      {CallOptions options}) {
    final call = $createCall(
        _$setAccountName, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class BackendPushServiceBase extends Service {
  String get $name => 'inf.BackendPush';

  BackendPushServiceBase() {
    $addMethod(new ServiceMethod<ReqPush, ResPush>(
        'Push',
        push_Pre,
        false,
        false,
        (List<int> value) => new ReqPush.fromBuffer(value),
        (ResPush value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<ReqSetFirebaseToken, ResSetFirebaseToken>(
        'SetFirebaseToken',
        setFirebaseToken_Pre,
        false,
        false,
        (List<int> value) => new ReqSetFirebaseToken.fromBuffer(value),
        (ResSetFirebaseToken value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<ReqSetAccountName, ResSetAccountName>(
        'SetAccountName',
        setAccountName_Pre,
        false,
        false,
        (List<int> value) => new ReqSetAccountName.fromBuffer(value),
        (ResSetAccountName value) => value.writeToBuffer()));
  }

  $async.Future<ResPush> push_Pre(
      ServiceCall call, $async.Future request) async {
    return push(call, await request);
  }

  $async.Future<ResSetFirebaseToken> setFirebaseToken_Pre(
      ServiceCall call, $async.Future request) async {
    return setFirebaseToken(call, await request);
  }

  $async.Future<ResSetAccountName> setAccountName_Pre(
      ServiceCall call, $async.Future request) async {
    return setAccountName(call, await request);
  }

  $async.Future<ResPush> push(ServiceCall call, ReqPush request);
  $async.Future<ResSetFirebaseToken> setFirebaseToken(
      ServiceCall call, ReqSetFirebaseToken request);
  $async.Future<ResSetAccountName> setAccountName(
      ServiceCall call, ReqSetAccountName request);
}
