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
  static final _$notify = new ClientMethod<NotifyRequest, NotifyResponse>(
      '/api.InfMessaging/Notify',
      (NotifyRequest value) => value.writeToBuffer(),
      (List<int> value) => new NotifyResponse.fromBuffer(value));

  InfMessagingClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<NotifyResponse> notify(NotifyRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$notify, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class InfMessagingServiceBase extends Service {
  String get $name => 'api.InfMessaging';

  InfMessagingServiceBase() {
    $addMethod(new ServiceMethod<NotifyRequest, NotifyResponse>(
        'Notify',
        notify_Pre,
        false,
        false,
        (List<int> value) => new NotifyRequest.fromBuffer(value),
        (NotifyResponse value) => value.writeToBuffer()));
  }

  $async.Future<NotifyResponse> notify_Pre(
      ServiceCall call, $async.Future request) async {
    return notify(call, await request);
  }

  $async.Future<NotifyResponse> notify(ServiceCall call, NotifyRequest request);
}
