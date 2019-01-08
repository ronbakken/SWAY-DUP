///
//  Generated code. Do not modify.
//  source: api_storage.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'net_storage_protobuf.pb.dart' as $8;
export 'api_storage.pb.dart';

class ApiStorageClient extends Client {
  static final _$signImageUpload =
      new ClientMethod<$8.NetUploadImage, $8.NetUploadSigned>(
          '/inf_common.ApiStorage/SignImageUpload',
          ($8.NetUploadImage value) => value.writeToBuffer(),
          (List<int> value) => new $8.NetUploadSigned.fromBuffer(value));

  ApiStorageClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<$8.NetUploadSigned> signImageUpload($8.NetUploadImage request,
      {CallOptions options}) {
    final call = $createCall(
        _$signImageUpload, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class ApiStorageServiceBase extends Service {
  String get $name => 'inf_common.ApiStorage';

  ApiStorageServiceBase() {
    $addMethod(new ServiceMethod<$8.NetUploadImage, $8.NetUploadSigned>(
        'SignImageUpload',
        signImageUpload_Pre,
        false,
        false,
        (List<int> value) => new $8.NetUploadImage.fromBuffer(value),
        ($8.NetUploadSigned value) => value.writeToBuffer()));
  }

  $async.Future<$8.NetUploadSigned> signImageUpload_Pre(
      ServiceCall call, $async.Future request) async {
    return signImageUpload(call, await request);
  }

  $async.Future<$8.NetUploadSigned> signImageUpload(
      ServiceCall call, $8.NetUploadImage request);
}
