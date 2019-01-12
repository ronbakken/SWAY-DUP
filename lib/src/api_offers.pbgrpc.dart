///
//  Generated code. Do not modify.
//  source: api_offers.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'net_offer_protobuf.pb.dart' as $3;
import 'net_report_protobuf.pb.dart' as $4;
export 'api_offers.pb.dart';

class ApiOffersClient extends Client {
  static final _$create = new ClientMethod<$3.NetCreateOffer, $3.NetOffer>(
      '/inf.ApiOffers/Create',
      ($3.NetCreateOffer value) => value.writeToBuffer(),
      (List<int> value) => new $3.NetOffer.fromBuffer(value));
  static final _$list = new ClientMethod<$3.NetListOffers, $3.NetOffer>(
      '/inf.ApiOffers/List',
      ($3.NetListOffers value) => value.writeToBuffer(),
      (List<int> value) => new $3.NetOffer.fromBuffer(value));
  static final _$get = new ClientMethod<$3.NetGetOffer, $3.NetOffer>(
      '/inf.ApiOffers/Get',
      ($3.NetGetOffer value) => value.writeToBuffer(),
      (List<int> value) => new $3.NetOffer.fromBuffer(value));
  static final _$report = new ClientMethod<$4.NetReportOffer, $4.NetReport>(
      '/inf.ApiOffers/Report',
      ($4.NetReportOffer value) => value.writeToBuffer(),
      (List<int> value) => new $4.NetReport.fromBuffer(value));

  ApiOffersClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<$3.NetOffer> create($3.NetCreateOffer request,
      {CallOptions options}) {
    final call = $createCall(
        _$create, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseStream<$3.NetOffer> list($3.NetListOffers request,
      {CallOptions options}) {
    final call = $createCall(_$list, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseStream(call);
  }

  ResponseFuture<$3.NetOffer> get($3.NetGetOffer request,
      {CallOptions options}) {
    final call = $createCall(_$get, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$4.NetReport> report($4.NetReportOffer request,
      {CallOptions options}) {
    final call = $createCall(
        _$report, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class ApiOffersServiceBase extends Service {
  String get $name => 'inf.ApiOffers';

  ApiOffersServiceBase() {
    $addMethod(new ServiceMethod<$3.NetCreateOffer, $3.NetOffer>(
        'Create',
        create_Pre,
        false,
        false,
        (List<int> value) => new $3.NetCreateOffer.fromBuffer(value),
        ($3.NetOffer value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$3.NetListOffers, $3.NetOffer>(
        'List',
        list_Pre,
        false,
        true,
        (List<int> value) => new $3.NetListOffers.fromBuffer(value),
        ($3.NetOffer value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$3.NetGetOffer, $3.NetOffer>(
        'Get',
        get_Pre,
        false,
        false,
        (List<int> value) => new $3.NetGetOffer.fromBuffer(value),
        ($3.NetOffer value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$4.NetReportOffer, $4.NetReport>(
        'Report',
        report_Pre,
        false,
        false,
        (List<int> value) => new $4.NetReportOffer.fromBuffer(value),
        ($4.NetReport value) => value.writeToBuffer()));
  }

  $async.Future<$3.NetOffer> create_Pre(
      ServiceCall call, $async.Future request) async {
    return create(call, await request);
  }

  $async.Stream<$3.NetOffer> list_Pre(
      ServiceCall call, $async.Future request) async* {
    yield* list(call, (await request) as $3.NetListOffers);
  }

  $async.Future<$3.NetOffer> get_Pre(
      ServiceCall call, $async.Future request) async {
    return get(call, await request);
  }

  $async.Future<$4.NetReport> report_Pre(
      ServiceCall call, $async.Future request) async {
    return report(call, await request);
  }

  $async.Future<$3.NetOffer> create(
      ServiceCall call, $3.NetCreateOffer request);
  $async.Stream<$3.NetOffer> list(ServiceCall call, $3.NetListOffers request);
  $async.Future<$3.NetOffer> get(ServiceCall call, $3.NetGetOffer request);
  $async.Future<$4.NetReport> report(
      ServiceCall call, $4.NetReportOffer request);
}
