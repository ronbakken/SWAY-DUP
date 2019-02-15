///
//  Generated code. Do not modify.
//  source: inf_mapping.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'inf_mapping.pb.dart';
export 'inf_mapping.pb.dart';

class InfMappingClient extends Client {
  static final _$search = new ClientMethod<SearchRequest, SearchResponse>(
      '/api.InfMapping/Search',
      (SearchRequest value) => value.writeToBuffer(),
      (List<int> value) => new SearchResponse.fromBuffer(value));

  InfMappingClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseStream<SearchResponse> search($async.Stream<SearchRequest> request,
      {CallOptions options}) {
    final call = $createCall(_$search, request, options: options);
    return new ResponseStream(call);
  }
}

abstract class InfMappingServiceBase extends Service {
  String get $name => 'api.InfMapping';

  InfMappingServiceBase() {
    $addMethod(new ServiceMethod<SearchRequest, SearchResponse>(
        'Search',
        search,
        true,
        true,
        (List<int> value) => new SearchRequest.fromBuffer(value),
        (SearchResponse value) => value.writeToBuffer()));
  }

  $async.Stream<SearchResponse> search(
      ServiceCall call, $async.Stream<SearchRequest> request);
}
