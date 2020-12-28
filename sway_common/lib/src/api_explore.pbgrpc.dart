///
//  Generated code. Do not modify.
//  source: api_explore.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'net_demo_protobuf.pb.dart' as $2;
import 'net_offer_protobuf.pb.dart' as $3;
export 'api_explore.pb.dart';

class ApiExploreClient extends $grpc.Client {
  static final _$demoAll = $grpc.ClientMethod<$2.NetDemoAllOffers, $3.NetOffer>(
      '/inf.ApiExplore/DemoAll',
      ($2.NetDemoAllOffers value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.NetOffer.fromBuffer(value));

  ApiExploreClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseStream<$3.NetOffer> demoAll($2.NetDemoAllOffers request,
      {$grpc.CallOptions options}) {
    return $createStreamingCall(
        _$demoAll, $async.Stream.fromIterable([request]),
        options: options);
  }
}

abstract class ApiExploreServiceBase extends $grpc.Service {
  $core.String get $name => 'inf.ApiExplore';

  ApiExploreServiceBase() {
    $addMethod($grpc.ServiceMethod<$2.NetDemoAllOffers, $3.NetOffer>(
        'DemoAll',
        demoAll_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $2.NetDemoAllOffers.fromBuffer(value),
        ($3.NetOffer value) => value.writeToBuffer()));
  }

  $async.Stream<$3.NetOffer> demoAll_Pre($grpc.ServiceCall call,
      $async.Future<$2.NetDemoAllOffers> request) async* {
    yield* demoAll(call, await request);
  }

  $async.Stream<$3.NetOffer> demoAll(
      $grpc.ServiceCall call, $2.NetDemoAllOffers request);
}
