///
//  Generated code. Do not modify.
//  source: inf_offers.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:grpc/service_api.dart' as $grpc;

import 'dart:core' as $core show int, String, List;

import 'inf_offers.pb.dart';
export 'inf_offers.pb.dart';

class InfOffersClient extends $grpc.Client {
  static final _$getOffer =
      $grpc.ClientMethod<GetOfferRequest, GetOfferResponse>(
          '/api.InfOffers/GetOffer',
          (GetOfferRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => GetOfferResponse.fromBuffer(value));
  static final _$updateOffer =
      $grpc.ClientMethod<UpdateOfferRequest, UpdateOfferResponse>(
          '/api.InfOffers/UpdateOffer',
          (UpdateOfferRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              UpdateOfferResponse.fromBuffer(value));

  InfOffersClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<GetOfferResponse> getOffer(GetOfferRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getOffer, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<UpdateOfferResponse> updateOffer(
      UpdateOfferRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$updateOffer, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class InfOffersServiceBase extends $grpc.Service {
  $core.String get $name => 'api.InfOffers';

  InfOffersServiceBase() {
    $addMethod($grpc.ServiceMethod<GetOfferRequest, GetOfferResponse>(
        'GetOffer',
        getOffer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => GetOfferRequest.fromBuffer(value),
        (GetOfferResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<UpdateOfferRequest, UpdateOfferResponse>(
        'UpdateOffer',
        updateOffer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => UpdateOfferRequest.fromBuffer(value),
        (UpdateOfferResponse value) => value.writeToBuffer()));
  }

  $async.Future<GetOfferResponse> getOffer_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getOffer(call, await request);
  }

  $async.Future<UpdateOfferResponse> updateOffer_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return updateOffer(call, await request);
  }

  $async.Future<GetOfferResponse> getOffer(
      $grpc.ServiceCall call, GetOfferRequest request);
  $async.Future<UpdateOfferResponse> updateOffer(
      $grpc.ServiceCall call, UpdateOfferRequest request);
}
