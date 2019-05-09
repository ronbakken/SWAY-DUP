///
//  Generated code. Do not modify.
//  source: inf_users.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:grpc/service_api.dart' as $grpc;

import 'dart:core' as $core show int, String, List;

import 'inf_users.pb.dart';
export 'inf_users.pb.dart';

class InfUsersClient extends $grpc.Client {
  static final _$getUser = $grpc.ClientMethod<GetUserRequest, GetUserResponse>(
      '/api.InfUsers/GetUser',
      (GetUserRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => GetUserResponse.fromBuffer(value));
  static final _$updateUser =
      $grpc.ClientMethod<UpdateUserRequest, UpdateUserResponse>(
          '/api.InfUsers/UpdateUser',
          (UpdateUserRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              UpdateUserResponse.fromBuffer(value));

  InfUsersClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<GetUserResponse> getUser(GetUserRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getUser, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<UpdateUserResponse> updateUser(UpdateUserRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$updateUser, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class InfUsersServiceBase extends $grpc.Service {
  $core.String get $name => 'api.InfUsers';

  InfUsersServiceBase() {
    $addMethod($grpc.ServiceMethod<GetUserRequest, GetUserResponse>(
        'GetUser',
        getUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => GetUserRequest.fromBuffer(value),
        (GetUserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<UpdateUserRequest, UpdateUserResponse>(
        'UpdateUser',
        updateUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => UpdateUserRequest.fromBuffer(value),
        (UpdateUserResponse value) => value.writeToBuffer()));
  }

  $async.Future<GetUserResponse> getUser_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getUser(call, await request);
  }

  $async.Future<UpdateUserResponse> updateUser_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return updateUser(call, await request);
  }

  $async.Future<GetUserResponse> getUser(
      $grpc.ServiceCall call, GetUserRequest request);
  $async.Future<UpdateUserResponse> updateUser(
      $grpc.ServiceCall call, UpdateUserRequest request);
}
