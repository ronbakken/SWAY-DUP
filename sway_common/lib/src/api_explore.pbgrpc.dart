///
//  Generated code. Do not modify.
//  source: api_explore.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'net_demo_protobuf.pb.dart' as $2;
import 'net_offer_protobuf.pb.dart' as $3;
export 'api_explore.pb.dart';

class ApiExploreClient extends Client {
  static final _$demoAll = new ClientMethod<$2.NetDemoAllOffers, $3.NetOffer>(
      '/inf.ApiExplore/DemoAll',
      ($2.NetDemoAllOffers value) => value.writeToBuffer(),
      (List<int> value) => new $3.NetOffer.fromBuffer(value));

  ApiExploreClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseStream<$3.NetOffer> demoAll($2.NetDemoAllOffers request,
      {CallOptions options}) {
    final call = $createCall(
        _$demoAll, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseStream(call);
  }
}

abstract class ApiExploreServiceBase extends Service {
  String get $name => 'inf.ApiExplore';

  ApiExploreServiceBase() {
    $addMethod(new ServiceMethod<$2.NetDemoAllOffers, $3.NetOffer>(
        'DemoAll',
        demoAll_Pre,
        false,
        true,
        (List<int> value) => new $2.NetDemoAllOffers.fromBuffer(value),
        ($3.NetOffer value) => value.writeToBuffer()));
  }

  $async.Stream<$3.NetOffer> demoAll_Pre(
      ServiceCall call, $async.Future request) async* {
    yield* demoAll(call, (await request) as $2.NetDemoAllOffers);
  }

  $async.Stream<$3.NetOffer> demoAll(
      ServiceCall call, $2.NetDemoAllOffers request);
}
