///
//  Generated code. Do not modify.
//  source: inf_auth.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'inf_auth.pb.dart';
import 'empty.pb.dart' as $0;
export 'inf_auth.pb.dart';

class InfAuthClient extends Client {
  static final _$sendLoginEmail =
      new ClientMethod<SendLoginEmailRequest, $0.Empty>(
          '/api.InfAuth/SendLoginEmail',
          (SendLoginEmailRequest value) => value.writeToBuffer(),
          (List<int> value) => new $0.Empty.fromBuffer(value));
  static final _$createNewUser =
      new ClientMethod<CreateNewUserRequest, CreateNewUserResponse>(
          '/api.InfAuth/CreateNewUser',
          (CreateNewUserRequest value) => value.writeToBuffer(),
          (List<int> value) => new CreateNewUserResponse.fromBuffer(value));
  static final _$loginWithLoginToken =
      new ClientMethod<LoginWithLoginTokenRequest, LoginWithLoginTokenResponse>(
          '/api.InfAuth/LoginWithLoginToken',
          (LoginWithLoginTokenRequest value) => value.writeToBuffer(),
          (List<int> value) =>
              new LoginWithLoginTokenResponse.fromBuffer(value));
  static final _$loginWithRefreshToken = new ClientMethod<
          LoginWithRefreshTokenRequest, LoginWithRefreshTokenResponse>(
      '/api.InfAuth/LoginWithRefreshToken',
      (LoginWithRefreshTokenRequest value) => value.writeToBuffer(),
      (List<int> value) => new LoginWithRefreshTokenResponse.fromBuffer(value));
  static final _$getAccessToken =
      new ClientMethod<GetAccessTokenRequest, GetAccessTokenResponse>(
          '/api.InfAuth/GetAccessToken',
          (GetAccessTokenRequest value) => value.writeToBuffer(),
          (List<int> value) => new GetAccessTokenResponse.fromBuffer(value));
  static final _$logout = new ClientMethod<LogoutRequest, $0.Empty>(
      '/api.InfAuth/Logout',
      (LogoutRequest value) => value.writeToBuffer(),
      (List<int> value) => new $0.Empty.fromBuffer(value));

  InfAuthClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<$0.Empty> sendLoginEmail(SendLoginEmailRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$sendLoginEmail, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<CreateNewUserResponse> createNewUser(
      CreateNewUserRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$createNewUser, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<LoginWithLoginTokenResponse> loginWithLoginToken(
      LoginWithLoginTokenRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$loginWithLoginToken, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<LoginWithRefreshTokenResponse> loginWithRefreshToken(
      LoginWithRefreshTokenRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$loginWithRefreshToken, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<GetAccessTokenResponse> getAccessToken(
      GetAccessTokenRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$getAccessToken, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$0.Empty> logout(LogoutRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$logout, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class InfAuthServiceBase extends Service {
  String get $name => 'api.InfAuth';

  InfAuthServiceBase() {
    $addMethod(new ServiceMethod<SendLoginEmailRequest, $0.Empty>(
        'SendLoginEmail',
        sendLoginEmail_Pre,
        false,
        false,
        (List<int> value) => new SendLoginEmailRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<CreateNewUserRequest, CreateNewUserResponse>(
        'CreateNewUser',
        createNewUser_Pre,
        false,
        false,
        (List<int> value) => new CreateNewUserRequest.fromBuffer(value),
        (CreateNewUserResponse value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<LoginWithLoginTokenRequest,
            LoginWithLoginTokenResponse>(
        'LoginWithLoginToken',
        loginWithLoginToken_Pre,
        false,
        false,
        (List<int> value) => new LoginWithLoginTokenRequest.fromBuffer(value),
        (LoginWithLoginTokenResponse value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<LoginWithRefreshTokenRequest,
            LoginWithRefreshTokenResponse>(
        'LoginWithRefreshToken',
        loginWithRefreshToken_Pre,
        false,
        false,
        (List<int> value) => new LoginWithRefreshTokenRequest.fromBuffer(value),
        (LoginWithRefreshTokenResponse value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<GetAccessTokenRequest, GetAccessTokenResponse>(
        'GetAccessToken',
        getAccessToken_Pre,
        false,
        false,
        (List<int> value) => new GetAccessTokenRequest.fromBuffer(value),
        (GetAccessTokenResponse value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<LogoutRequest, $0.Empty>(
        'Logout',
        logout_Pre,
        false,
        false,
        (List<int> value) => new LogoutRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$0.Empty> sendLoginEmail_Pre(
      ServiceCall call, $async.Future request) async {
    return sendLoginEmail(call, await request);
  }

  $async.Future<CreateNewUserResponse> createNewUser_Pre(
      ServiceCall call, $async.Future request) async {
    return createNewUser(call, await request);
  }

  $async.Future<LoginWithLoginTokenResponse> loginWithLoginToken_Pre(
      ServiceCall call, $async.Future request) async {
    return loginWithLoginToken(call, await request);
  }

  $async.Future<LoginWithRefreshTokenResponse> loginWithRefreshToken_Pre(
      ServiceCall call, $async.Future request) async {
    return loginWithRefreshToken(call, await request);
  }

  $async.Future<GetAccessTokenResponse> getAccessToken_Pre(
      ServiceCall call, $async.Future request) async {
    return getAccessToken(call, await request);
  }

  $async.Future<$0.Empty> logout_Pre(
      ServiceCall call, $async.Future request) async {
    return logout(call, await request);
  }

  $async.Future<$0.Empty> sendLoginEmail(
      ServiceCall call, SendLoginEmailRequest request);
  $async.Future<CreateNewUserResponse> createNewUser(
      ServiceCall call, CreateNewUserRequest request);
  $async.Future<LoginWithLoginTokenResponse> loginWithLoginToken(
      ServiceCall call, LoginWithLoginTokenRequest request);
  $async.Future<LoginWithRefreshTokenResponse> loginWithRefreshToken(
      ServiceCall call, LoginWithRefreshTokenRequest request);
  $async.Future<GetAccessTokenResponse> getAccessToken(
      ServiceCall call, GetAccessTokenRequest request);
  $async.Future<$0.Empty> logout(ServiceCall call, LogoutRequest request);
}
