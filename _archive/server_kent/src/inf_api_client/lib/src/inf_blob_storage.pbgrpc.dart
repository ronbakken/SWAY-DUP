///
//  Generated code. Do not modify.
//  source: inf_blob_storage.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:grpc/service_api.dart' as $grpc;

import 'dart:core' as $core show int, String, List;

import 'inf_blob_storage.pb.dart';
export 'inf_blob_storage.pb.dart';

class InfBlobStorageClient extends $grpc.Client {
  static final _$getUploadUrl =
      $grpc.ClientMethod<GetUploadUrlRequest, GetUploadUrlResponse>(
          '/api.InfBlobStorage/GetUploadUrl',
          (GetUploadUrlRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              GetUploadUrlResponse.fromBuffer(value));

  InfBlobStorageClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<GetUploadUrlResponse> getUploadUrl(
      GetUploadUrlRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getUploadUrl, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class InfBlobStorageServiceBase extends $grpc.Service {
  $core.String get $name => 'api.InfBlobStorage';

  InfBlobStorageServiceBase() {
    $addMethod($grpc.ServiceMethod<GetUploadUrlRequest, GetUploadUrlResponse>(
        'GetUploadUrl',
        getUploadUrl_Pre,
        false,
        false,
        ($core.List<$core.int> value) => GetUploadUrlRequest.fromBuffer(value),
        (GetUploadUrlResponse value) => value.writeToBuffer()));
  }

  $async.Future<GetUploadUrlResponse> getUploadUrl_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getUploadUrl(call, await request);
  }

  $async.Future<GetUploadUrlResponse> getUploadUrl(
      $grpc.ServiceCall call, GetUploadUrlRequest request);
}
