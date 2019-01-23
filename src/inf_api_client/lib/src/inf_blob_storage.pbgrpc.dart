///
//  Generated code. Do not modify.
//  source: inf_blob_storage.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'inf_blob_storage.pb.dart';
export 'inf_blob_storage.pb.dart';

class InfBlobStorageClient extends Client {
  static final _$getUploadUrl =
      new ClientMethod<GetUploadUrlRequest, GetUploadUrlResponse>(
          '/api.InfBlobStorage/GetUploadUrl',
          (GetUploadUrlRequest value) => value.writeToBuffer(),
          (List<int> value) => new GetUploadUrlResponse.fromBuffer(value));

  InfBlobStorageClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<GetUploadUrlResponse> getUploadUrl(GetUploadUrlRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$getUploadUrl, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class InfBlobStorageServiceBase extends Service {
  String get $name => 'api.InfBlobStorage';

  InfBlobStorageServiceBase() {
    $addMethod(new ServiceMethod<GetUploadUrlRequest, GetUploadUrlResponse>(
        'GetUploadUrl',
        getUploadUrl_Pre,
        false,
        false,
        (List<int> value) => new GetUploadUrlRequest.fromBuffer(value),
        (GetUploadUrlResponse value) => value.writeToBuffer()));
  }

  $async.Future<GetUploadUrlResponse> getUploadUrl_Pre(
      ServiceCall call, $async.Future request) async {
    return getUploadUrl(call, await request);
  }

  $async.Future<GetUploadUrlResponse> getUploadUrl(
      ServiceCall call, GetUploadUrlRequest request);
}
