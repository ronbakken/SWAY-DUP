///
//  Generated code. Do not modify.
//  source: inf_list.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'inf_list.pb.dart';
export 'inf_list.pb.dart';

class InfListClient extends Client {
  static final _$list = new ClientMethod<ListRequest, ListResponse>(
      '/api.InfList/List',
      (ListRequest value) => value.writeToBuffer(),
      (List<int> value) => new ListResponse.fromBuffer(value));

  InfListClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseStream<ListResponse> list($async.Stream<ListRequest> request,
      {CallOptions options}) {
    final call = $createCall(_$list, request, options: options);
    return new ResponseStream(call);
  }
}

abstract class InfListServiceBase extends Service {
  String get $name => 'api.InfList';

  InfListServiceBase() {
    $addMethod(new ServiceMethod<ListRequest, ListResponse>(
        'List',
        list,
        true,
        true,
        (List<int> value) => new ListRequest.fromBuffer(value),
        (ListResponse value) => value.writeToBuffer()));
  }

  $async.Stream<ListResponse> list(
      ServiceCall call, $async.Stream<ListRequest> request);
}
