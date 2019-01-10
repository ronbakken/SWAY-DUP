///
//  Generated code. Do not modify.
//  source: api_explore.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'net_demo_protobuf.pb.dart' as $1;
import 'net_offer_protobuf.pb.dart' as $2;
export 'api_explore.pb.dart';

class ApiExploreClient extends Client {
  static final _$demoAll = new ClientMethod<$1.NetDemoAllOffers, $2.NetOffer>(
      '/inf.ApiExplore/DemoAll',
      ($1.NetDemoAllOffers value) => value.writeToBuffer(),
      (List<int> value) => new $2.NetOffer.fromBuffer(value));

  ApiExploreClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseStream<$2.NetOffer> demoAll($1.NetDemoAllOffers request,
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
    $addMethod(new ServiceMethod<$1.NetDemoAllOffers, $2.NetOffer>(
        'DemoAll',
        demoAll_Pre,
        false,
        true,
        (List<int> value) => new $1.NetDemoAllOffers.fromBuffer(value),
        ($2.NetOffer value) => value.writeToBuffer()));
  }

  $async.Stream<$2.NetOffer> demoAll_Pre(
      ServiceCall call, $async.Future request) async* {
    yield* demoAll(call, (await request) as $1.NetDemoAllOffers);
  }

  $async.Stream<$2.NetOffer> demoAll(
      ServiceCall call, $1.NetDemoAllOffers request);
}
