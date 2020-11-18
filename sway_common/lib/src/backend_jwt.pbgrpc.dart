///
//  Generated code. Do not modify.
//  source: backend_jwt.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'backend_jwt.pb.dart';
export 'backend_jwt.pb.dart';

class BackendJwtClient extends Client {
  static final _$sign = new ClientMethod<ReqSign, ResSign>(
      '/inf.BackendJwt/Sign',
      (ReqSign value) => value.writeToBuffer(),
      (List<int> value) => new ResSign.fromBuffer(value));
  static final _$getKeyStore = new ClientMethod<ReqGetKeyStore, ResGetKeyStore>(
      '/inf.BackendJwt/GetKeyStore',
      (ReqGetKeyStore value) => value.writeToBuffer(),
      (List<int> value) => new ResGetKeyStore.fromBuffer(value));

  BackendJwtClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<ResSign> sign(ReqSign request, {CallOptions options}) {
    final call = $createCall(_$sign, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<ResGetKeyStore> getKeyStore(ReqGetKeyStore request,
      {CallOptions options}) {
    final call = $createCall(
        _$getKeyStore, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class BackendJwtServiceBase extends Service {
  String get $name => 'inf.BackendJwt';

  BackendJwtServiceBase() {
    $addMethod(new ServiceMethod<ReqSign, ResSign>(
        'Sign',
        sign_Pre,
        false,
        false,
        (List<int> value) => new ReqSign.fromBuffer(value),
        (ResSign value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<ReqGetKeyStore, ResGetKeyStore>(
        'GetKeyStore',
        getKeyStore_Pre,
        false,
        false,
        (List<int> value) => new ReqGetKeyStore.fromBuffer(value),
        (ResGetKeyStore value) => value.writeToBuffer()));
  }

  $async.Future<ResSign> sign_Pre(
      ServiceCall call, $async.Future request) async {
    return sign(call, await request);
  }

  $async.Future<ResGetKeyStore> getKeyStore_Pre(
      ServiceCall call, $async.Future request) async {
    return getKeyStore(call, await request);
  }

  $async.Future<ResSign> sign(ServiceCall call, ReqSign request);
  $async.Future<ResGetKeyStore> getKeyStore(
      ServiceCall call, ReqGetKeyStore request);
}
