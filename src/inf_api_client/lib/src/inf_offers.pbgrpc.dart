///
//  Generated code. Do not modify.
//  source: inf_offers.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'inf_offers.pb.dart';
export 'inf_offers.pb.dart';

class InfOffersClient extends Client {
  static final _$getOffer = new ClientMethod<GetOfferRequest, GetOfferResponse>(
      '/api.InfOffers/GetOffer',
      (GetOfferRequest value) => value.writeToBuffer(),
      (List<int> value) => new GetOfferResponse.fromBuffer(value));
  static final _$updateOffer =
      new ClientMethod<UpdateOfferRequest, UpdateOfferResponse>(
          '/api.InfOffers/UpdateOffer',
          (UpdateOfferRequest value) => value.writeToBuffer(),
          (List<int> value) => new UpdateOfferResponse.fromBuffer(value));

  InfOffersClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<GetOfferResponse> getOffer(GetOfferRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$getOffer, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<UpdateOfferResponse> updateOffer(UpdateOfferRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$updateOffer, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class InfOffersServiceBase extends Service {
  String get $name => 'api.InfOffers';

  InfOffersServiceBase() {
    $addMethod(new ServiceMethod<GetOfferRequest, GetOfferResponse>(
        'GetOffer',
        getOffer_Pre,
        false,
        false,
        (List<int> value) => new GetOfferRequest.fromBuffer(value),
        (GetOfferResponse value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<UpdateOfferRequest, UpdateOfferResponse>(
        'UpdateOffer',
        updateOffer_Pre,
        false,
        false,
        (List<int> value) => new UpdateOfferRequest.fromBuffer(value),
        (UpdateOfferResponse value) => value.writeToBuffer()));
  }

  $async.Future<GetOfferResponse> getOffer_Pre(
      ServiceCall call, $async.Future request) async {
    return getOffer(call, await request);
  }

  $async.Future<UpdateOfferResponse> updateOffer_Pre(
      ServiceCall call, $async.Future request) async {
    return updateOffer(call, await request);
  }

  $async.Future<GetOfferResponse> getOffer(
      ServiceCall call, GetOfferRequest request);
  $async.Future<UpdateOfferResponse> updateOffer(
      ServiceCall call, UpdateOfferRequest request);
}
