///
//  Generated code. Do not modify.
//  source: backend_explore.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'backend_explore.pb.dart';
export 'backend_explore.pb.dart';

class BackendExploreClient extends Client {
  static final _$insertProfile =
      new ClientMethod<InsertProfileRequest, InsertProfileResponse>(
          '/inf.BackendExplore/InsertProfile',
          (InsertProfileRequest value) => value.writeToBuffer(),
          (List<int> value) => new InsertProfileResponse.fromBuffer(value));
  static final _$updateProfile =
      new ClientMethod<UpdateProfileRequest, UpdateProfileResponse>(
          '/inf.BackendExplore/UpdateProfile',
          (UpdateProfileRequest value) => value.writeToBuffer(),
          (List<int> value) => new UpdateProfileResponse.fromBuffer(value));
  static final _$getProfile =
      new ClientMethod<GetProfileRequest, GetProfileResponse>(
          '/inf.BackendExplore/GetProfile',
          (GetProfileRequest value) => value.writeToBuffer(),
          (List<int> value) => new GetProfileResponse.fromBuffer(value));
  static final _$insertOffer =
      new ClientMethod<InsertOfferRequest, InsertOfferResponse>(
          '/inf.BackendExplore/InsertOffer',
          (InsertOfferRequest value) => value.writeToBuffer(),
          (List<int> value) => new InsertOfferResponse.fromBuffer(value));
  static final _$updateOffer =
      new ClientMethod<UpdateOfferRequest, UpdateOfferResponse>(
          '/inf.BackendExplore/UpdateOffer',
          (UpdateOfferRequest value) => value.writeToBuffer(),
          (List<int> value) => new UpdateOfferResponse.fromBuffer(value));
  static final _$getOffer = new ClientMethod<GetOfferRequest, GetOfferResponse>(
      '/inf.BackendExplore/GetOffer',
      (GetOfferRequest value) => value.writeToBuffer(),
      (List<int> value) => new GetOfferResponse.fromBuffer(value));
  static final _$listOffersFromSender = new ClientMethod<
          ListOffersFromSenderRequest, ListOffersFromSenderResponse>(
      '/inf.BackendExplore/ListOffersFromSender',
      (ListOffersFromSenderRequest value) => value.writeToBuffer(),
      (List<int> value) => new ListOffersFromSenderResponse.fromBuffer(value));

  BackendExploreClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<InsertProfileResponse> insertProfile(
      InsertProfileRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$insertProfile, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<UpdateProfileResponse> updateProfile(
      UpdateProfileRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$updateProfile, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<GetProfileResponse> getProfile(GetProfileRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$getProfile, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<InsertOfferResponse> insertOffer(InsertOfferRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$insertOffer, new $async.Stream.fromIterable([request]),
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

  ResponseFuture<GetOfferResponse> getOffer(GetOfferRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$getOffer, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<ListOffersFromSenderResponse> listOffersFromSender(
      ListOffersFromSenderRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$listOffersFromSender, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class BackendExploreServiceBase extends Service {
  String get $name => 'inf.BackendExplore';

  BackendExploreServiceBase() {
    $addMethod(new ServiceMethod<InsertProfileRequest, InsertProfileResponse>(
        'InsertProfile',
        insertProfile_Pre,
        false,
        false,
        (List<int> value) => new InsertProfileRequest.fromBuffer(value),
        (InsertProfileResponse value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<UpdateProfileRequest, UpdateProfileResponse>(
        'UpdateProfile',
        updateProfile_Pre,
        false,
        false,
        (List<int> value) => new UpdateProfileRequest.fromBuffer(value),
        (UpdateProfileResponse value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<GetProfileRequest, GetProfileResponse>(
        'GetProfile',
        getProfile_Pre,
        false,
        false,
        (List<int> value) => new GetProfileRequest.fromBuffer(value),
        (GetProfileResponse value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<InsertOfferRequest, InsertOfferResponse>(
        'InsertOffer',
        insertOffer_Pre,
        false,
        false,
        (List<int> value) => new InsertOfferRequest.fromBuffer(value),
        (InsertOfferResponse value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<UpdateOfferRequest, UpdateOfferResponse>(
        'UpdateOffer',
        updateOffer_Pre,
        false,
        false,
        (List<int> value) => new UpdateOfferRequest.fromBuffer(value),
        (UpdateOfferResponse value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<GetOfferRequest, GetOfferResponse>(
        'GetOffer',
        getOffer_Pre,
        false,
        false,
        (List<int> value) => new GetOfferRequest.fromBuffer(value),
        (GetOfferResponse value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<ListOffersFromSenderRequest,
            ListOffersFromSenderResponse>(
        'ListOffersFromSender',
        listOffersFromSender_Pre,
        false,
        false,
        (List<int> value) => new ListOffersFromSenderRequest.fromBuffer(value),
        (ListOffersFromSenderResponse value) => value.writeToBuffer()));
  }

  $async.Future<InsertProfileResponse> insertProfile_Pre(
      ServiceCall call, $async.Future request) async {
    return insertProfile(call, await request);
  }

  $async.Future<UpdateProfileResponse> updateProfile_Pre(
      ServiceCall call, $async.Future request) async {
    return updateProfile(call, await request);
  }

  $async.Future<GetProfileResponse> getProfile_Pre(
      ServiceCall call, $async.Future request) async {
    return getProfile(call, await request);
  }

  $async.Future<InsertOfferResponse> insertOffer_Pre(
      ServiceCall call, $async.Future request) async {
    return insertOffer(call, await request);
  }

  $async.Future<UpdateOfferResponse> updateOffer_Pre(
      ServiceCall call, $async.Future request) async {
    return updateOffer(call, await request);
  }

  $async.Future<GetOfferResponse> getOffer_Pre(
      ServiceCall call, $async.Future request) async {
    return getOffer(call, await request);
  }

  $async.Future<ListOffersFromSenderResponse> listOffersFromSender_Pre(
      ServiceCall call, $async.Future request) async {
    return listOffersFromSender(call, await request);
  }

  $async.Future<InsertProfileResponse> insertProfile(
      ServiceCall call, InsertProfileRequest request);
  $async.Future<UpdateProfileResponse> updateProfile(
      ServiceCall call, UpdateProfileRequest request);
  $async.Future<GetProfileResponse> getProfile(
      ServiceCall call, GetProfileRequest request);
  $async.Future<InsertOfferResponse> insertOffer(
      ServiceCall call, InsertOfferRequest request);
  $async.Future<UpdateOfferResponse> updateOffer(
      ServiceCall call, UpdateOfferRequest request);
  $async.Future<GetOfferResponse> getOffer(
      ServiceCall call, GetOfferRequest request);
  $async.Future<ListOffersFromSenderResponse> listOffersFromSender(
      ServiceCall call, ListOffersFromSenderRequest request);
}
