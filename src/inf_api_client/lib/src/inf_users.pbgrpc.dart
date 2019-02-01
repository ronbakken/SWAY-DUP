///
//  Generated code. Do not modify.
//  source: inf_users.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'inf_users.pb.dart';
export 'inf_users.pb.dart';

class InfUsersClient extends Client {
  static final _$getUser = new ClientMethod<GetUserRequest, GetUserResponse>(
      '/api.InfUsers/GetUser',
      (GetUserRequest value) => value.writeToBuffer(),
      (List<int> value) => new GetUserResponse.fromBuffer(value));
  static final _$updateUser =
      new ClientMethod<UpdateUserRequest, UpdateUserResponse>(
          '/api.InfUsers/UpdateUser',
          (UpdateUserRequest value) => value.writeToBuffer(),
          (List<int> value) => new UpdateUserResponse.fromBuffer(value));
  static final _$searchUsers =
      new ClientMethod<SearchUsersRequest, SearchUsersResponse>(
          '/api.InfUsers/SearchUsers',
          (SearchUsersRequest value) => value.writeToBuffer(),
          (List<int> value) => new SearchUsersResponse.fromBuffer(value));

  InfUsersClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<GetUserResponse> getUser(GetUserRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$getUser, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<UpdateUserResponse> updateUser(UpdateUserRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$updateUser, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<SearchUsersResponse> searchUsers(SearchUsersRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$searchUsers, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class InfUsersServiceBase extends Service {
  String get $name => 'api.InfUsers';

  InfUsersServiceBase() {
    $addMethod(new ServiceMethod<GetUserRequest, GetUserResponse>(
        'GetUser',
        getUser_Pre,
        false,
        false,
        (List<int> value) => new GetUserRequest.fromBuffer(value),
        (GetUserResponse value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<UpdateUserRequest, UpdateUserResponse>(
        'UpdateUser',
        updateUser_Pre,
        false,
        false,
        (List<int> value) => new UpdateUserRequest.fromBuffer(value),
        (UpdateUserResponse value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<SearchUsersRequest, SearchUsersResponse>(
        'SearchUsers',
        searchUsers_Pre,
        false,
        false,
        (List<int> value) => new SearchUsersRequest.fromBuffer(value),
        (SearchUsersResponse value) => value.writeToBuffer()));
  }

  $async.Future<GetUserResponse> getUser_Pre(
      ServiceCall call, $async.Future request) async {
    return getUser(call, await request);
  }

  $async.Future<UpdateUserResponse> updateUser_Pre(
      ServiceCall call, $async.Future request) async {
    return updateUser(call, await request);
  }

  $async.Future<SearchUsersResponse> searchUsers_Pre(
      ServiceCall call, $async.Future request) async {
    return searchUsers(call, await request);
  }

  $async.Future<GetUserResponse> getUser(
      ServiceCall call, GetUserRequest request);
  $async.Future<UpdateUserResponse> updateUser(
      ServiceCall call, UpdateUserRequest request);
  $async.Future<SearchUsersResponse> searchUsers(
      ServiceCall call, SearchUsersRequest request);
}
