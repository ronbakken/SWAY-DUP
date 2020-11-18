///
//  Generated code. Do not modify.
//  source: inf_config.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:grpc/service_api.dart' as $grpc;

import 'dart:core' as $core show int, String, List;

import 'empty.pb.dart' as $0;
import 'inf_config.pb.dart';
export 'inf_config.pb.dart';

class InfConfigClient extends $grpc.Client {
  static final _$getVersions =
      $grpc.ClientMethod<$0.Empty, GetVersionsResponse>(
          '/api.InfConfig/GetVersions',
          ($0.Empty value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              GetVersionsResponse.fromBuffer(value));
  static final _$getAppConfig =
      $grpc.ClientMethod<$0.Empty, GetAppConfigResponse>(
          '/api.InfConfig/GetAppConfig',
          ($0.Empty value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              GetAppConfigResponse.fromBuffer(value));
  static final _$getWelcomeImages =
      $grpc.ClientMethod<$0.Empty, GetWelcomeImagesResponse>(
          '/api.InfConfig/GetWelcomeImages',
          ($0.Empty value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              GetWelcomeImagesResponse.fromBuffer(value));

  InfConfigClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<GetVersionsResponse> getVersions($0.Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getVersions, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<GetAppConfigResponse> getAppConfig($0.Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getAppConfig, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseStream<GetWelcomeImagesResponse> getWelcomeImages(
      $0.Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getWelcomeImages, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseStream(call);
  }
}

abstract class InfConfigServiceBase extends $grpc.Service {
  $core.String get $name => 'api.InfConfig';

  InfConfigServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, GetVersionsResponse>(
        'GetVersions',
        getVersions_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        (GetVersionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, GetAppConfigResponse>(
        'GetAppConfig',
        getAppConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        (GetAppConfigResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, GetWelcomeImagesResponse>(
        'GetWelcomeImages',
        getWelcomeImages_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        (GetWelcomeImagesResponse value) => value.writeToBuffer()));
  }

  $async.Future<GetVersionsResponse> getVersions_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getVersions(call, await request);
  }

  $async.Future<GetAppConfigResponse> getAppConfig_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getAppConfig(call, await request);
  }

  $async.Stream<GetWelcomeImagesResponse> getWelcomeImages_Pre(
      $grpc.ServiceCall call, $async.Future request) async* {
    yield* getWelcomeImages(call, (await request) as $0.Empty);
  }

  $async.Future<GetVersionsResponse> getVersions(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<GetAppConfigResponse> getAppConfig(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Stream<GetWelcomeImagesResponse> getWelcomeImages(
      $grpc.ServiceCall call, $0.Empty request);
}
