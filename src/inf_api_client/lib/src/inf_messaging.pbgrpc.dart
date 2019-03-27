///
//  Generated code. Do not modify.
//  source: inf_messaging.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'inf_messaging.pb.dart';
export 'inf_messaging.pb.dart';

class InfMessagingClient extends Client {
  static final _$createConversation =
      new ClientMethod<CreateConversationRequest, CreateConversationResponse>(
          '/api.InfMessaging/CreateConversation',
          (CreateConversationRequest value) => value.writeToBuffer(),
          (List<int> value) =>
              new CreateConversationResponse.fromBuffer(value));
  static final _$closeConversation =
      new ClientMethod<CloseConversationRequest, CloseConversationResponse>(
          '/api.InfMessaging/CloseConversation',
          (CloseConversationRequest value) => value.writeToBuffer(),
          (List<int> value) => new CloseConversationResponse.fromBuffer(value));
  static final _$createMessage =
      new ClientMethod<CreateMessageRequest, CreateMessageResponse>(
          '/api.InfMessaging/CreateMessage',
          (CreateMessageRequest value) => value.writeToBuffer(),
          (List<int> value) => new CreateMessageResponse.fromBuffer(value));

  InfMessagingClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<CreateConversationResponse> createConversation(
      CreateConversationRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$createConversation, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<CloseConversationResponse> closeConversation(
      CloseConversationRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$closeConversation, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<CreateMessageResponse> createMessage(
      CreateMessageRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$createMessage, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class InfMessagingServiceBase extends Service {
  String get $name => 'api.InfMessaging';

  InfMessagingServiceBase() {
    $addMethod(new ServiceMethod<CreateConversationRequest,
            CreateConversationResponse>(
        'CreateConversation',
        createConversation_Pre,
        false,
        false,
        (List<int> value) => new CreateConversationRequest.fromBuffer(value),
        (CreateConversationResponse value) => value.writeToBuffer()));
    $addMethod(
        new ServiceMethod<CloseConversationRequest, CloseConversationResponse>(
            'CloseConversation',
            closeConversation_Pre,
            false,
            false,
            (List<int> value) => new CloseConversationRequest.fromBuffer(value),
            (CloseConversationResponse value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<CreateMessageRequest, CreateMessageResponse>(
        'CreateMessage',
        createMessage_Pre,
        false,
        false,
        (List<int> value) => new CreateMessageRequest.fromBuffer(value),
        (CreateMessageResponse value) => value.writeToBuffer()));
  }

  $async.Future<CreateConversationResponse> createConversation_Pre(
      ServiceCall call, $async.Future request) async {
    return createConversation(call, await request);
  }

  $async.Future<CloseConversationResponse> closeConversation_Pre(
      ServiceCall call, $async.Future request) async {
    return closeConversation(call, await request);
  }

  $async.Future<CreateMessageResponse> createMessage_Pre(
      ServiceCall call, $async.Future request) async {
    return createMessage(call, await request);
  }

  $async.Future<CreateConversationResponse> createConversation(
      ServiceCall call, CreateConversationRequest request);
  $async.Future<CloseConversationResponse> closeConversation(
      ServiceCall call, CloseConversationRequest request);
  $async.Future<CreateMessageResponse> createMessage(
      ServiceCall call, CreateMessageRequest request);
}
