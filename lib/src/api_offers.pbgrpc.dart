///
//  Generated code. Do not modify.
//  source: api_offers.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'net_offer_protobuf.pb.dart' as $2;
import 'net_report_protobuf.pb.dart' as $3;
export 'api_offers.pb.dart';

class ApiOffersClient extends Client {
  static final _$create = new ClientMethod<$2.NetCreateOffer, $2.NetOffer>(
      '/inf_common.ApiOffers/Create',
      ($2.NetCreateOffer value) => value.writeToBuffer(),
      (List<int> value) => new $2.NetOffer.fromBuffer(value));
  static final _$list = new ClientMethod<$2.NetListOffers, $2.NetOffer>(
      '/inf_common.ApiOffers/List',
      ($2.NetListOffers value) => value.writeToBuffer(),
      (List<int> value) => new $2.NetOffer.fromBuffer(value));
  static final _$get = new ClientMethod<$2.NetGetOffer, $2.NetOffer>(
      '/inf_common.ApiOffers/Get',
      ($2.NetGetOffer value) => value.writeToBuffer(),
      (List<int> value) => new $2.NetOffer.fromBuffer(value));
  static final _$report = new ClientMethod<$3.NetReportOffer, $3.NetReport>(
      '/inf_common.ApiOffers/Report',
      ($3.NetReportOffer value) => value.writeToBuffer(),
      (List<int> value) => new $3.NetReport.fromBuffer(value));

  ApiOffersClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<$2.NetOffer> create($2.NetCreateOffer request,
      {CallOptions options}) {
    final call = $createCall(
        _$create, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseStream<$2.NetOffer> list($2.NetListOffers request,
      {CallOptions options}) {
    final call = $createCall(_$list, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseStream(call);
  }

  ResponseFuture<$2.NetOffer> get($2.NetGetOffer request,
      {CallOptions options}) {
    final call = $createCall(_$get, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$3.NetReport> report($3.NetReportOffer request,
      {CallOptions options}) {
    final call = $createCall(
        _$report, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class ApiOffersServiceBase extends Service {
  String get $name => 'inf_common.ApiOffers';

  ApiOffersServiceBase() {
    $addMethod(new ServiceMethod<$2.NetCreateOffer, $2.NetOffer>(
        'Create',
        create_Pre,
        false,
        false,
        (List<int> value) => new $2.NetCreateOffer.fromBuffer(value),
        ($2.NetOffer value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$2.NetListOffers, $2.NetOffer>(
        'List',
        list_Pre,
        false,
        true,
        (List<int> value) => new $2.NetListOffers.fromBuffer(value),
        ($2.NetOffer value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$2.NetGetOffer, $2.NetOffer>(
        'Get',
        get_Pre,
        false,
        false,
        (List<int> value) => new $2.NetGetOffer.fromBuffer(value),
        ($2.NetOffer value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$3.NetReportOffer, $3.NetReport>(
        'Report',
        report_Pre,
        false,
        false,
        (List<int> value) => new $3.NetReportOffer.fromBuffer(value),
        ($3.NetReport value) => value.writeToBuffer()));
  }

  $async.Future<$2.NetOffer> create_Pre(
      ServiceCall call, $async.Future request) async {
    return create(call, await request);
  }

  $async.Stream<$2.NetOffer> list_Pre(
      ServiceCall call, $async.Future request) async* {
    yield* list(call, (await request) as $2.NetListOffers);
  }

  $async.Future<$2.NetOffer> get_Pre(
      ServiceCall call, $async.Future request) async {
    return get(call, await request);
  }

  $async.Future<$3.NetReport> report_Pre(
      ServiceCall call, $async.Future request) async {
    return report(call, await request);
  }

  $async.Future<$2.NetOffer> create(
      ServiceCall call, $2.NetCreateOffer request);
  $async.Stream<$2.NetOffer> list(ServiceCall call, $2.NetListOffers request);
  $async.Future<$2.NetOffer> get(ServiceCall call, $2.NetGetOffer request);
  $async.Future<$3.NetReport> report(
      ServiceCall call, $3.NetReportOffer request);
}
