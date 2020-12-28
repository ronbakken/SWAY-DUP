///
//  Generated code. Do not modify.
//  source: api_offers.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'net_offer_protobuf.pb.dart' as $3;
import 'net_report_protobuf.pb.dart' as $4;
export 'api_offers.pb.dart';

class ApiOffersClient extends $grpc.Client {
  static final _$create = $grpc.ClientMethod<$3.NetCreateOffer, $3.NetOffer>(
      '/inf.ApiOffers/Create',
      ($3.NetCreateOffer value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.NetOffer.fromBuffer(value));
  static final _$list = $grpc.ClientMethod<$3.NetListOffers, $3.NetOffer>(
      '/inf.ApiOffers/List',
      ($3.NetListOffers value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.NetOffer.fromBuffer(value));
  static final _$get = $grpc.ClientMethod<$3.NetGetOffer, $3.NetOffer>(
      '/inf.ApiOffers/Get',
      ($3.NetGetOffer value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.NetOffer.fromBuffer(value));
  static final _$report = $grpc.ClientMethod<$4.NetReportOffer, $4.NetReport>(
      '/inf.ApiOffers/Report',
      ($4.NetReportOffer value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.NetReport.fromBuffer(value));

  ApiOffersClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$3.NetOffer> create($3.NetCreateOffer request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseStream<$3.NetOffer> list($3.NetListOffers request,
      {$grpc.CallOptions options}) {
    return $createStreamingCall(_$list, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$3.NetOffer> get($3.NetGetOffer request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseFuture<$4.NetReport> report($4.NetReportOffer request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$report, request, options: options);
  }
}

abstract class ApiOffersServiceBase extends $grpc.Service {
  $core.String get $name => 'inf.ApiOffers';

  ApiOffersServiceBase() {
    $addMethod($grpc.ServiceMethod<$3.NetCreateOffer, $3.NetOffer>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.NetCreateOffer.fromBuffer(value),
        ($3.NetOffer value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.NetListOffers, $3.NetOffer>(
        'List',
        list_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $3.NetListOffers.fromBuffer(value),
        ($3.NetOffer value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.NetGetOffer, $3.NetOffer>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.NetGetOffer.fromBuffer(value),
        ($3.NetOffer value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.NetReportOffer, $4.NetReport>(
        'Report',
        report_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.NetReportOffer.fromBuffer(value),
        ($4.NetReport value) => value.writeToBuffer()));
  }

  $async.Future<$3.NetOffer> create_Pre(
      $grpc.ServiceCall call, $async.Future<$3.NetCreateOffer> request) async {
    return create(call, await request);
  }

  $async.Stream<$3.NetOffer> list_Pre(
      $grpc.ServiceCall call, $async.Future<$3.NetListOffers> request) async* {
    yield* list(call, await request);
  }

  $async.Future<$3.NetOffer> get_Pre(
      $grpc.ServiceCall call, $async.Future<$3.NetGetOffer> request) async {
    return get(call, await request);
  }

  $async.Future<$4.NetReport> report_Pre(
      $grpc.ServiceCall call, $async.Future<$4.NetReportOffer> request) async {
    return report(call, await request);
  }

  $async.Future<$3.NetOffer> create(
      $grpc.ServiceCall call, $3.NetCreateOffer request);
  $async.Stream<$3.NetOffer> list(
      $grpc.ServiceCall call, $3.NetListOffers request);
  $async.Future<$3.NetOffer> get(
      $grpc.ServiceCall call, $3.NetGetOffer request);
  $async.Future<$4.NetReport> report(
      $grpc.ServiceCall call, $4.NetReportOffer request);
}
