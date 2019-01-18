///
//  Generated code. Do not modify.
//  source: inf_auth.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'inf_auth.pb.dart';
import 'empty.pb.dart' as $0;
import 'user.pb.dart' as $1;
export 'inf_auth.pb.dart';

class InfAuthClient extends Client {
  static final _$sendLoginEmail = new ClientMethod<LoginEmailRequest, $0.Empty>(
      '/api.InfAuth/SendLoginEmail',
      (LoginEmailRequest value) => value.writeToBuffer(),
      (List<int> value) => new $0.Empty.fromBuffer(value));
  static final _$validateInvitationCode =
      new ClientMethod<InvitationCode, InvitationCodeState>(
          '/api.InfAuth/ValidateInvitationCode',
          (InvitationCode value) => value.writeToBuffer(),
          (List<int> value) => new InvitationCodeState.fromBuffer(value));
  static final _$createNewUser =
      new ClientMethod<CreateNewUserRequest, RefreshTokenMessage>(
          '/api.InfAuth/CreateNewUser',
          (CreateNewUserRequest value) => value.writeToBuffer(),
          (List<int> value) => new RefreshTokenMessage.fromBuffer(value));
  static final _$requestRefreshToken =
      new ClientMethod<RefreshTokenRequest, RefreshTokenMessage>(
          '/api.InfAuth/RequestRefreshToken',
          (RefreshTokenRequest value) => value.writeToBuffer(),
          (List<int> value) => new RefreshTokenMessage.fromBuffer(value));
  static final _$login =
      new ClientMethod<RefreshTokenMessage, LoginResultMessage>(
          '/api.InfAuth/Login',
          (RefreshTokenMessage value) => value.writeToBuffer(),
          (List<int> value) => new LoginResultMessage.fromBuffer(value));
  static final _$getCurrentUser =
      new ClientMethod<RefreshTokenMessage, $1.User>(
          '/api.InfAuth/GetCurrentUser',
          (RefreshTokenMessage value) => value.writeToBuffer(),
          (List<int> value) => new $1.User.fromBuffer(value));
  static final _$updateUser = new ClientMethod<UpdateUserRequest, $0.Empty>(
      '/api.InfAuth/UpdateUser',
      (UpdateUserRequest value) => value.writeToBuffer(),
      (List<int> value) => new $0.Empty.fromBuffer(value));
  static final _$getSocialMediaAccountsForUser =
      new ClientMethod<SocialMediaRequest, SocialMediaAccounts>(
          '/api.InfAuth/GetSocialMediaAccountsForUser',
          (SocialMediaRequest value) => value.writeToBuffer(),
          (List<int> value) => new SocialMediaAccounts.fromBuffer(value));

  InfAuthClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<$0.Empty> sendLoginEmail(LoginEmailRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$sendLoginEmail, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<InvitationCodeState> validateInvitationCode(
      InvitationCode request,
      {CallOptions options}) {
    final call = $createCall(
        _$validateInvitationCode, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<RefreshTokenMessage> createNewUser(
      CreateNewUserRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$createNewUser, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<RefreshTokenMessage> requestRefreshToken(
      RefreshTokenRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$requestRefreshToken, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<LoginResultMessage> login(RefreshTokenMessage request,
      {CallOptions options}) {
    final call = $createCall(_$login, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$1.User> getCurrentUser(RefreshTokenMessage request,
      {CallOptions options}) {
    final call = $createCall(
        _$getCurrentUser, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$0.Empty> updateUser(UpdateUserRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$updateUser, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<SocialMediaAccounts> getSocialMediaAccountsForUser(
      SocialMediaRequest request,
      {CallOptions options}) {
    final call = $createCall(_$getSocialMediaAccountsForUser,
        new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class InfAuthServiceBase extends Service {
  String get $name => 'api.InfAuth';

  InfAuthServiceBase() {
    $addMethod(new ServiceMethod<LoginEmailRequest, $0.Empty>(
        'SendLoginEmail',
        sendLoginEmail_Pre,
        false,
        false,
        (List<int> value) => new LoginEmailRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<InvitationCode, InvitationCodeState>(
        'ValidateInvitationCode',
        validateInvitationCode_Pre,
        false,
        false,
        (List<int> value) => new InvitationCode.fromBuffer(value),
        (InvitationCodeState value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<CreateNewUserRequest, RefreshTokenMessage>(
        'CreateNewUser',
        createNewUser_Pre,
        false,
        false,
        (List<int> value) => new CreateNewUserRequest.fromBuffer(value),
        (RefreshTokenMessage value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<RefreshTokenRequest, RefreshTokenMessage>(
        'RequestRefreshToken',
        requestRefreshToken_Pre,
        false,
        false,
        (List<int> value) => new RefreshTokenRequest.fromBuffer(value),
        (RefreshTokenMessage value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<RefreshTokenMessage, LoginResultMessage>(
        'Login',
        login_Pre,
        false,
        false,
        (List<int> value) => new RefreshTokenMessage.fromBuffer(value),
        (LoginResultMessage value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<RefreshTokenMessage, $1.User>(
        'GetCurrentUser',
        getCurrentUser_Pre,
        false,
        false,
        (List<int> value) => new RefreshTokenMessage.fromBuffer(value),
        ($1.User value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<UpdateUserRequest, $0.Empty>(
        'UpdateUser',
        updateUser_Pre,
        false,
        false,
        (List<int> value) => new UpdateUserRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<SocialMediaRequest, SocialMediaAccounts>(
        'GetSocialMediaAccountsForUser',
        getSocialMediaAccountsForUser_Pre,
        false,
        false,
        (List<int> value) => new SocialMediaRequest.fromBuffer(value),
        (SocialMediaAccounts value) => value.writeToBuffer()));
  }

  $async.Future<$0.Empty> sendLoginEmail_Pre(
      ServiceCall call, $async.Future request) async {
    return sendLoginEmail(call, await request);
  }

  $async.Future<InvitationCodeState> validateInvitationCode_Pre(
      ServiceCall call, $async.Future request) async {
    return validateInvitationCode(call, await request);
  }

  $async.Future<RefreshTokenMessage> createNewUser_Pre(
      ServiceCall call, $async.Future request) async {
    return createNewUser(call, await request);
  }

  $async.Future<RefreshTokenMessage> requestRefreshToken_Pre(
      ServiceCall call, $async.Future request) async {
    return requestRefreshToken(call, await request);
  }

  $async.Future<LoginResultMessage> login_Pre(
      ServiceCall call, $async.Future request) async {
    return login(call, await request);
  }

  $async.Future<$1.User> getCurrentUser_Pre(
      ServiceCall call, $async.Future request) async {
    return getCurrentUser(call, await request);
  }

  $async.Future<$0.Empty> updateUser_Pre(
      ServiceCall call, $async.Future request) async {
    return updateUser(call, await request);
  }

  $async.Future<SocialMediaAccounts> getSocialMediaAccountsForUser_Pre(
      ServiceCall call, $async.Future request) async {
    return getSocialMediaAccountsForUser(call, await request);
  }

  $async.Future<$0.Empty> sendLoginEmail(
      ServiceCall call, LoginEmailRequest request);
  $async.Future<InvitationCodeState> validateInvitationCode(
      ServiceCall call, InvitationCode request);
  $async.Future<RefreshTokenMessage> createNewUser(
      ServiceCall call, CreateNewUserRequest request);
  $async.Future<RefreshTokenMessage> requestRefreshToken(
      ServiceCall call, RefreshTokenRequest request);
  $async.Future<LoginResultMessage> login(
      ServiceCall call, RefreshTokenMessage request);
  $async.Future<$1.User> getCurrentUser(
      ServiceCall call, RefreshTokenMessage request);
  $async.Future<$0.Empty> updateUser(
      ServiceCall call, UpdateUserRequest request);
  $async.Future<SocialMediaAccounts> getSocialMediaAccountsForUser(
      ServiceCall call, SocialMediaRequest request);
}
