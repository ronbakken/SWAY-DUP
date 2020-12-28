///
//  Generated code. Do not modify.
//  source: sample_jwt.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'sample_jwt.pb.dart' as $0;
export 'sample_jwt.pb.dart';

class SampleJwtClient extends $grpc.Client {
  static final _$generate = $grpc.ClientMethod<$0.ReqGenerate, $0.ResGenerate>(
      '/sample_jwt.SampleJwt/Generate',
      ($0.ReqGenerate value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ResGenerate.fromBuffer(value));
  static final _$validate = $grpc.ClientMethod<$0.ReqValidate, $0.ResValidate>(
      '/sample_jwt.SampleJwt/Validate',
      ($0.ReqValidate value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ResValidate.fromBuffer(value));

  SampleJwtClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.ResGenerate> generate($0.ReqGenerate request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$generate, request, options: options);
  }

  $grpc.ResponseFuture<$0.ResValidate> validate($0.ReqValidate request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$validate, request, options: options);
  }
}

abstract class SampleJwtServiceBase extends $grpc.Service {
  $core.String get $name => 'sample_jwt.SampleJwt';

  SampleJwtServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ReqGenerate, $0.ResGenerate>(
        'Generate',
        generate_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ReqGenerate.fromBuffer(value),
        ($0.ResGenerate value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReqValidate, $0.ResValidate>(
        'Validate',
        validate_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ReqValidate.fromBuffer(value),
        ($0.ResValidate value) => value.writeToBuffer()));
  }

  $async.Future<$0.ResGenerate> generate_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ReqGenerate> request) async {
    return generate(call, await request);
  }

  $async.Future<$0.ResValidate> validate_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ReqValidate> request) async {
    return validate(call, await request);
  }

  $async.Future<$0.ResGenerate> generate(
      $grpc.ServiceCall call, $0.ReqGenerate request);
  $async.Future<$0.ResValidate> validate(
      $grpc.ServiceCall call, $0.ReqValidate request);
}
