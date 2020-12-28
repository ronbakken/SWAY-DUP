///
//  Generated code. Do not modify.
//  source: api_storage.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'net_storage_protobuf.pb.dart' as $8;
export 'api_storage.pb.dart';

class ApiStorageClient extends $grpc.Client {
  static final _$signImageUpload =
      $grpc.ClientMethod<$8.NetUploadImage, $8.NetUploadSigned>(
          '/inf.ApiStorage/SignImageUpload',
          ($8.NetUploadImage value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $8.NetUploadSigned.fromBuffer(value));

  ApiStorageClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$8.NetUploadSigned> signImageUpload(
      $8.NetUploadImage request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$signImageUpload, request, options: options);
  }
}

abstract class ApiStorageServiceBase extends $grpc.Service {
  $core.String get $name => 'inf.ApiStorage';

  ApiStorageServiceBase() {
    $addMethod($grpc.ServiceMethod<$8.NetUploadImage, $8.NetUploadSigned>(
        'SignImageUpload',
        signImageUpload_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $8.NetUploadImage.fromBuffer(value),
        ($8.NetUploadSigned value) => value.writeToBuffer()));
  }

  $async.Future<$8.NetUploadSigned> signImageUpload_Pre(
      $grpc.ServiceCall call, $async.Future<$8.NetUploadImage> request) async {
    return signImageUpload(call, await request);
  }

  $async.Future<$8.NetUploadSigned> signImageUpload(
      $grpc.ServiceCall call, $8.NetUploadImage request);
}
