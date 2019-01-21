///
//  Generated code. Do not modify.
//  source: inf_config.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'empty.pb.dart' as $0;
import 'inf_config.pb.dart';
export 'inf_config.pb.dart';

class InfConfigClient extends Client {
  static final _$getVersions = new ClientMethod<$0.Empty, GetVersionsResponse>(
      '/api.InfConfig/GetVersions',
      ($0.Empty value) => value.writeToBuffer(),
      (List<int> value) => new GetVersionsResponse.fromBuffer(value));
  static final _$getAppConfig =
      new ClientMethod<$0.Empty, GetAppConfigResponse>(
          '/api.InfConfig/GetAppConfig',
          ($0.Empty value) => value.writeToBuffer(),
          (List<int> value) => new GetAppConfigResponse.fromBuffer(value));
  static final _$getWelcomeImages =
      new ClientMethod<$0.Empty, GetWelcomeImagesResponse>(
          '/api.InfConfig/GetWelcomeImages',
          ($0.Empty value) => value.writeToBuffer(),
          (List<int> value) => new GetWelcomeImagesResponse.fromBuffer(value));

  InfConfigClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<GetVersionsResponse> getVersions($0.Empty request,
      {CallOptions options}) {
    final call = $createCall(
        _$getVersions, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<GetAppConfigResponse> getAppConfig($0.Empty request,
      {CallOptions options}) {
    final call = $createCall(
        _$getAppConfig, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseStream<GetWelcomeImagesResponse> getWelcomeImages($0.Empty request,
      {CallOptions options}) {
    final call = $createCall(
        _$getWelcomeImages, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseStream(call);
  }
}

abstract class InfConfigServiceBase extends Service {
  String get $name => 'api.InfConfig';

  InfConfigServiceBase() {
    $addMethod(new ServiceMethod<$0.Empty, GetVersionsResponse>(
        'GetVersions',
        getVersions_Pre,
        false,
        false,
        (List<int> value) => new $0.Empty.fromBuffer(value),
        (GetVersionsResponse value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$0.Empty, GetAppConfigResponse>(
        'GetAppConfig',
        getAppConfig_Pre,
        false,
        false,
        (List<int> value) => new $0.Empty.fromBuffer(value),
        (GetAppConfigResponse value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$0.Empty, GetWelcomeImagesResponse>(
        'GetWelcomeImages',
        getWelcomeImages_Pre,
        false,
        true,
        (List<int> value) => new $0.Empty.fromBuffer(value),
        (GetWelcomeImagesResponse value) => value.writeToBuffer()));
  }

  $async.Future<GetVersionsResponse> getVersions_Pre(
      ServiceCall call, $async.Future request) async {
    return getVersions(call, await request);
  }

  $async.Future<GetAppConfigResponse> getAppConfig_Pre(
      ServiceCall call, $async.Future request) async {
    return getAppConfig(call, await request);
  }

  $async.Stream<GetWelcomeImagesResponse> getWelcomeImages_Pre(
      ServiceCall call, $async.Future request) async* {
    yield* getWelcomeImages(call, (await request) as $0.Empty);
  }

  $async.Future<GetVersionsResponse> getVersions(
      ServiceCall call, $0.Empty request);
  $async.Future<GetAppConfigResponse> getAppConfig(
      ServiceCall call, $0.Empty request);
  $async.Stream<GetWelcomeImagesResponse> getWelcomeImages(
      ServiceCall call, $0.Empty request);
}
