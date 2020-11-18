///
//  Generated code. Do not modify.
//  source: inf_list.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:grpc/service_api.dart' as $grpc;

import 'dart:core' as $core show int, String, List;

import 'inf_list.pb.dart';
export 'inf_list.pb.dart';

class InfListClient extends $grpc.Client {
  static final _$list = $grpc.ClientMethod<ListRequest, ListResponse>(
      '/api.InfList/List',
      (ListRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => ListResponse.fromBuffer(value));

  InfListClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseStream<ListResponse> list($async.Stream<ListRequest> request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$list, request, options: options);
    return $grpc.ResponseStream(call);
  }
}

abstract class InfListServiceBase extends $grpc.Service {
  $core.String get $name => 'api.InfList';

  InfListServiceBase() {
    $addMethod($grpc.ServiceMethod<ListRequest, ListResponse>(
        'List',
        list,
        true,
        true,
        ($core.List<$core.int> value) => ListRequest.fromBuffer(value),
        (ListResponse value) => value.writeToBuffer()));
  }

  $async.Stream<ListResponse> list(
      $grpc.ServiceCall call, $async.Stream<ListRequest> request);
}
