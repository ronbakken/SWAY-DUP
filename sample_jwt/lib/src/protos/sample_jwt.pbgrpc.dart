///
//  Generated code. Do not modify.
//  source: protos/sample_jwt.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'sample_jwt.pb.dart';
export 'sample_jwt.pb.dart';

class SampleJwtClient extends Client {
  static final _$generate = new ClientMethod<ReqGenerate, ResGenerate>(
      '/sample_jwt.SampleJwt/Generate',
      (ReqGenerate value) => value.writeToBuffer(),
      (List<int> value) => new ResGenerate.fromBuffer(value));
  static final _$validate = new ClientMethod<ReqValidate, ResValidate>(
      '/sample_jwt.SampleJwt/Validate',
      (ReqValidate value) => value.writeToBuffer(),
      (List<int> value) => new ResValidate.fromBuffer(value));

  SampleJwtClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<ResGenerate> generate(ReqGenerate request,
      {CallOptions options}) {
    final call = $createCall(
        _$generate, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<ResValidate> validate(ReqValidate request,
      {CallOptions options}) {
    final call = $createCall(
        _$validate, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class SampleJwtServiceBase extends Service {
  String get $name => 'sample_jwt.SampleJwt';

  SampleJwtServiceBase() {
    $addMethod(new ServiceMethod<ReqGenerate, ResGenerate>(
        'Generate',
        generate_Pre,
        false,
        false,
        (List<int> value) => new ReqGenerate.fromBuffer(value),
        (ResGenerate value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<ReqValidate, ResValidate>(
        'Validate',
        validate_Pre,
        false,
        false,
        (List<int> value) => new ReqValidate.fromBuffer(value),
        (ResValidate value) => value.writeToBuffer()));
  }

  $async.Future<ResGenerate> generate_Pre(
      ServiceCall call, $async.Future request) async {
    return generate(call, await request);
  }

  $async.Future<ResValidate> validate_Pre(
      ServiceCall call, $async.Future request) async {
    return validate(call, await request);
  }

  $async.Future<ResGenerate> generate(ServiceCall call, ReqGenerate request);
  $async.Future<ResValidate> validate(ServiceCall call, ReqValidate request);
}
