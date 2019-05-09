///
//  Generated code. Do not modify.
//  source: inf_auth.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:grpc/service_api.dart' as $grpc;

import 'dart:core' as $core show int, String, List;

import 'inf_auth.pb.dart';
import 'empty.pb.dart' as $0;
export 'inf_auth.pb.dart';

class InfAuthClient extends $grpc.Client {
  static final _$sendLoginEmail =
      $grpc.ClientMethod<SendLoginEmailRequest, $0.Empty>(
          '/api.InfAuth/SendLoginEmail',
          (SendLoginEmailRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$activateUser =
      $grpc.ClientMethod<ActivateUserRequest, ActivateUserResponse>(
          '/api.InfAuth/ActivateUser',
          (ActivateUserRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              ActivateUserResponse.fromBuffer(value));
  static final _$loginWithLoginToken = $grpc.ClientMethod<
          LoginWithLoginTokenRequest, LoginWithLoginTokenResponse>(
      '/api.InfAuth/LoginWithLoginToken',
      (LoginWithLoginTokenRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          LoginWithLoginTokenResponse.fromBuffer(value));
  static final _$loginWithRefreshToken = $grpc.ClientMethod<
          LoginWithRefreshTokenRequest, LoginWithRefreshTokenResponse>(
      '/api.InfAuth/LoginWithRefreshToken',
      (LoginWithRefreshTokenRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          LoginWithRefreshTokenResponse.fromBuffer(value));
  static final _$getAccessToken =
      $grpc.ClientMethod<GetAccessTokenRequest, GetAccessTokenResponse>(
          '/api.InfAuth/GetAccessToken',
          (GetAccessTokenRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              GetAccessTokenResponse.fromBuffer(value));
  static final _$logout = $grpc.ClientMethod<LogoutRequest, $0.Empty>(
      '/api.InfAuth/Logout',
      (LogoutRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));

  InfAuthClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.Empty> sendLoginEmail(SendLoginEmailRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$sendLoginEmail, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<ActivateUserResponse> activateUser(
      ActivateUserRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$activateUser, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<LoginWithLoginTokenResponse> loginWithLoginToken(
      LoginWithLoginTokenRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$loginWithLoginToken, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<LoginWithRefreshTokenResponse> loginWithRefreshToken(
      LoginWithRefreshTokenRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$loginWithRefreshToken, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<GetAccessTokenResponse> getAccessToken(
      GetAccessTokenRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getAccessToken, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Empty> logout(LogoutRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$logout, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class InfAuthServiceBase extends $grpc.Service {
  $core.String get $name => 'api.InfAuth';

  InfAuthServiceBase() {
    $addMethod($grpc.ServiceMethod<SendLoginEmailRequest, $0.Empty>(
        'SendLoginEmail',
        sendLoginEmail_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            SendLoginEmailRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<ActivateUserRequest, ActivateUserResponse>(
        'ActivateUser',
        activateUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => ActivateUserRequest.fromBuffer(value),
        (ActivateUserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<LoginWithLoginTokenRequest,
            LoginWithLoginTokenResponse>(
        'LoginWithLoginToken',
        loginWithLoginToken_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            LoginWithLoginTokenRequest.fromBuffer(value),
        (LoginWithLoginTokenResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<LoginWithRefreshTokenRequest,
            LoginWithRefreshTokenResponse>(
        'LoginWithRefreshToken',
        loginWithRefreshToken_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            LoginWithRefreshTokenRequest.fromBuffer(value),
        (LoginWithRefreshTokenResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<GetAccessTokenRequest, GetAccessTokenResponse>(
            'GetAccessToken',
            getAccessToken_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                GetAccessTokenRequest.fromBuffer(value),
            (GetAccessTokenResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<LogoutRequest, $0.Empty>(
        'Logout',
        logout_Pre,
        false,
        false,
        ($core.List<$core.int> value) => LogoutRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$0.Empty> sendLoginEmail_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return sendLoginEmail(call, await request);
  }

  $async.Future<ActivateUserResponse> activateUser_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return activateUser(call, await request);
  }

  $async.Future<LoginWithLoginTokenResponse> loginWithLoginToken_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return loginWithLoginToken(call, await request);
  }

  $async.Future<LoginWithRefreshTokenResponse> loginWithRefreshToken_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return loginWithRefreshToken(call, await request);
  }

  $async.Future<GetAccessTokenResponse> getAccessToken_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getAccessToken(call, await request);
  }

  $async.Future<$0.Empty> logout_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return logout(call, await request);
  }

  $async.Future<$0.Empty> sendLoginEmail(
      $grpc.ServiceCall call, SendLoginEmailRequest request);
  $async.Future<ActivateUserResponse> activateUser(
      $grpc.ServiceCall call, ActivateUserRequest request);
  $async.Future<LoginWithLoginTokenResponse> loginWithLoginToken(
      $grpc.ServiceCall call, LoginWithLoginTokenRequest request);
  $async.Future<LoginWithRefreshTokenResponse> loginWithRefreshToken(
      $grpc.ServiceCall call, LoginWithRefreshTokenRequest request);
  $async.Future<GetAccessTokenResponse> getAccessToken(
      $grpc.ServiceCall call, GetAccessTokenRequest request);
  $async.Future<$0.Empty> logout($grpc.ServiceCall call, LogoutRequest request);
}
