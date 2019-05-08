///
//  Generated code. Do not modify.
//  source: inf_messaging.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:grpc/service_api.dart' as $grpc;

import 'dart:core' as $core show int, String, List;

import 'inf_messaging.pb.dart';
export 'inf_messaging.pb.dart';

class InfMessagingClient extends $grpc.Client {
  static final _$createConversation =
      $grpc.ClientMethod<CreateConversationRequest, CreateConversationResponse>(
          '/api.InfMessaging/CreateConversation',
          (CreateConversationRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              CreateConversationResponse.fromBuffer(value));
  static final _$closeConversation =
      $grpc.ClientMethod<CloseConversationRequest, CloseConversationResponse>(
          '/api.InfMessaging/CloseConversation',
          (CloseConversationRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              CloseConversationResponse.fromBuffer(value));
  static final _$createMessage =
      $grpc.ClientMethod<CreateMessageRequest, CreateMessageResponse>(
          '/api.InfMessaging/CreateMessage',
          (CreateMessageRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              CreateMessageResponse.fromBuffer(value));

  InfMessagingClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<CreateConversationResponse> createConversation(
      CreateConversationRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createConversation, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<CloseConversationResponse> closeConversation(
      CloseConversationRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$closeConversation, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<CreateMessageResponse> createMessage(
      CreateMessageRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createMessage, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class InfMessagingServiceBase extends $grpc.Service {
  $core.String get $name => 'api.InfMessaging';

  InfMessagingServiceBase() {
    $addMethod($grpc.ServiceMethod<CreateConversationRequest,
            CreateConversationResponse>(
        'CreateConversation',
        createConversation_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            CreateConversationRequest.fromBuffer(value),
        (CreateConversationResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<CloseConversationRequest,
            CloseConversationResponse>(
        'CloseConversation',
        closeConversation_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            CloseConversationRequest.fromBuffer(value),
        (CloseConversationResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<CreateMessageRequest, CreateMessageResponse>(
        'CreateMessage',
        createMessage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => CreateMessageRequest.fromBuffer(value),
        (CreateMessageResponse value) => value.writeToBuffer()));
  }

  $async.Future<CreateConversationResponse> createConversation_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return createConversation(call, await request);
  }

  $async.Future<CloseConversationResponse> closeConversation_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return closeConversation(call, await request);
  }

  $async.Future<CreateMessageResponse> createMessage_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return createMessage(call, await request);
  }

  $async.Future<CreateConversationResponse> createConversation(
      $grpc.ServiceCall call, CreateConversationRequest request);
  $async.Future<CloseConversationResponse> closeConversation(
      $grpc.ServiceCall call, CloseConversationRequest request);
  $async.Future<CreateMessageResponse> createMessage(
      $grpc.ServiceCall call, CreateMessageRequest request);
}
