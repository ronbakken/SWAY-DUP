///
//  Generated code. Do not modify.
//  source: inf_listen.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:grpc/service_api.dart' as $grpc;

import 'dart:core' as $core show int, String, List;

import 'inf_listen.pb.dart';
export 'inf_listen.pb.dart';

class InfListenClient extends $grpc.Client {
  static final _$listen = $grpc.ClientMethod<ListenRequest, ListenResponse>(
      '/api.InfListen/Listen',
      (ListenRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => ListenResponse.fromBuffer(value));

  InfListenClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseStream<ListenResponse> listen(
      $async.Stream<ListenRequest> request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$listen, request, options: options);
    return $grpc.ResponseStream(call);
  }
}

abstract class InfListenServiceBase extends $grpc.Service {
  $core.String get $name => 'api.InfListen';

  InfListenServiceBase() {
    $addMethod($grpc.ServiceMethod<ListenRequest, ListenResponse>(
        'Listen',
        listen,
        true,
        true,
        ($core.List<$core.int> value) => ListenRequest.fromBuffer(value),
        (ListenResponse value) => value.writeToBuffer()));
  }

  $async.Stream<ListenResponse> listen(
      $grpc.ServiceCall call, $async.Stream<ListenRequest> request);
}
