///
//  Generated code. Do not modify.
//  source: backend_explore.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'backend_explore.pb.dart' as $9;
export 'backend_explore.pb.dart';

class BackendExploreClient extends $grpc.Client {
  static final _$insertProfile =
      $grpc.ClientMethod<$9.InsertProfileRequest, $9.InsertProfileResponse>(
          '/inf.BackendExplore/InsertProfile',
          ($9.InsertProfileRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $9.InsertProfileResponse.fromBuffer(value));
  static final _$updateProfile =
      $grpc.ClientMethod<$9.UpdateProfileRequest, $9.UpdateProfileResponse>(
          '/inf.BackendExplore/UpdateProfile',
          ($9.UpdateProfileRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $9.UpdateProfileResponse.fromBuffer(value));
  static final _$getProfile =
      $grpc.ClientMethod<$9.GetProfileRequest, $9.GetProfileResponse>(
          '/inf.BackendExplore/GetProfile',
          ($9.GetProfileRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $9.GetProfileResponse.fromBuffer(value));
  static final _$insertOffer =
      $grpc.ClientMethod<$9.InsertOfferRequest, $9.InsertOfferResponse>(
          '/inf.BackendExplore/InsertOffer',
          ($9.InsertOfferRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $9.InsertOfferResponse.fromBuffer(value));
  static final _$updateOffer =
      $grpc.ClientMethod<$9.UpdateOfferRequest, $9.UpdateOfferResponse>(
          '/inf.BackendExplore/UpdateOffer',
          ($9.UpdateOfferRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $9.UpdateOfferResponse.fromBuffer(value));
  static final _$getOffer =
      $grpc.ClientMethod<$9.GetOfferRequest, $9.GetOfferResponse>(
          '/inf.BackendExplore/GetOffer',
          ($9.GetOfferRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $9.GetOfferResponse.fromBuffer(value));
  static final _$listOffersFromSender = $grpc.ClientMethod<
          $9.ListOffersFromSenderRequest, $9.ListOffersFromSenderResponse>(
      '/inf.BackendExplore/ListOffersFromSender',
      ($9.ListOffersFromSenderRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $9.ListOffersFromSenderResponse.fromBuffer(value));

  BackendExploreClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$9.InsertProfileResponse> insertProfile(
      $9.InsertProfileRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$insertProfile, request, options: options);
  }

  $grpc.ResponseFuture<$9.UpdateProfileResponse> updateProfile(
      $9.UpdateProfileRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$updateProfile, request, options: options);
  }

  $grpc.ResponseFuture<$9.GetProfileResponse> getProfile(
      $9.GetProfileRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$getProfile, request, options: options);
  }

  $grpc.ResponseFuture<$9.InsertOfferResponse> insertOffer(
      $9.InsertOfferRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$insertOffer, request, options: options);
  }

  $grpc.ResponseFuture<$9.UpdateOfferResponse> updateOffer(
      $9.UpdateOfferRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$updateOffer, request, options: options);
  }

  $grpc.ResponseFuture<$9.GetOfferResponse> getOffer($9.GetOfferRequest request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$getOffer, request, options: options);
  }

  $grpc.ResponseStream<$9.ListOffersFromSenderResponse> listOffersFromSender(
      $9.ListOffersFromSenderRequest request,
      {$grpc.CallOptions options}) {
    return $createStreamingCall(
        _$listOffersFromSender, $async.Stream.fromIterable([request]),
        options: options);
  }
}

abstract class BackendExploreServiceBase extends $grpc.Service {
  $core.String get $name => 'inf.BackendExplore';

  BackendExploreServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$9.InsertProfileRequest, $9.InsertProfileResponse>(
            'InsertProfile',
            insertProfile_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $9.InsertProfileRequest.fromBuffer(value),
            ($9.InsertProfileResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$9.UpdateProfileRequest, $9.UpdateProfileResponse>(
            'UpdateProfile',
            updateProfile_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $9.UpdateProfileRequest.fromBuffer(value),
            ($9.UpdateProfileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$9.GetProfileRequest, $9.GetProfileResponse>(
        'GetProfile',
        getProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $9.GetProfileRequest.fromBuffer(value),
        ($9.GetProfileResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$9.InsertOfferRequest, $9.InsertOfferResponse>(
            'InsertOffer',
            insertOffer_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $9.InsertOfferRequest.fromBuffer(value),
            ($9.InsertOfferResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$9.UpdateOfferRequest, $9.UpdateOfferResponse>(
            'UpdateOffer',
            updateOffer_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $9.UpdateOfferRequest.fromBuffer(value),
            ($9.UpdateOfferResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$9.GetOfferRequest, $9.GetOfferResponse>(
        'GetOffer',
        getOffer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $9.GetOfferRequest.fromBuffer(value),
        ($9.GetOfferResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$9.ListOffersFromSenderRequest,
            $9.ListOffersFromSenderResponse>(
        'ListOffersFromSender',
        listOffersFromSender_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $9.ListOffersFromSenderRequest.fromBuffer(value),
        ($9.ListOffersFromSenderResponse value) => value.writeToBuffer()));
  }

  $async.Future<$9.InsertProfileResponse> insertProfile_Pre(
      $grpc.ServiceCall call,
      $async.Future<$9.InsertProfileRequest> request) async {
    return insertProfile(call, await request);
  }

  $async.Future<$9.UpdateProfileResponse> updateProfile_Pre(
      $grpc.ServiceCall call,
      $async.Future<$9.UpdateProfileRequest> request) async {
    return updateProfile(call, await request);
  }

  $async.Future<$9.GetProfileResponse> getProfile_Pre($grpc.ServiceCall call,
      $async.Future<$9.GetProfileRequest> request) async {
    return getProfile(call, await request);
  }

  $async.Future<$9.InsertOfferResponse> insertOffer_Pre($grpc.ServiceCall call,
      $async.Future<$9.InsertOfferRequest> request) async {
    return insertOffer(call, await request);
  }

  $async.Future<$9.UpdateOfferResponse> updateOffer_Pre($grpc.ServiceCall call,
      $async.Future<$9.UpdateOfferRequest> request) async {
    return updateOffer(call, await request);
  }

  $async.Future<$9.GetOfferResponse> getOffer_Pre(
      $grpc.ServiceCall call, $async.Future<$9.GetOfferRequest> request) async {
    return getOffer(call, await request);
  }

  $async.Stream<$9.ListOffersFromSenderResponse> listOffersFromSender_Pre(
      $grpc.ServiceCall call,
      $async.Future<$9.ListOffersFromSenderRequest> request) async* {
    yield* listOffersFromSender(call, await request);
  }

  $async.Future<$9.InsertProfileResponse> insertProfile(
      $grpc.ServiceCall call, $9.InsertProfileRequest request);
  $async.Future<$9.UpdateProfileResponse> updateProfile(
      $grpc.ServiceCall call, $9.UpdateProfileRequest request);
  $async.Future<$9.GetProfileResponse> getProfile(
      $grpc.ServiceCall call, $9.GetProfileRequest request);
  $async.Future<$9.InsertOfferResponse> insertOffer(
      $grpc.ServiceCall call, $9.InsertOfferRequest request);
  $async.Future<$9.UpdateOfferResponse> updateOffer(
      $grpc.ServiceCall call, $9.UpdateOfferRequest request);
  $async.Future<$9.GetOfferResponse> getOffer(
      $grpc.ServiceCall call, $9.GetOfferRequest request);
  $async.Stream<$9.ListOffersFromSenderResponse> listOffersFromSender(
      $grpc.ServiceCall call, $9.ListOffersFromSenderRequest request);
}
