///
//  Generated code. Do not modify.
//  source: inf_listen.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'inf_listen.pb.dart';
export 'inf_listen.pb.dart';

class InfListenClient extends Client {
  static final _$listen = new ClientMethod<ListenRequest, ListenResponse>(
      '/api.InfListen/Listen',
      (ListenRequest value) => value.writeToBuffer(),
      (List<int> value) => new ListenResponse.fromBuffer(value));

  InfListenClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseStream<ListenResponse> listen($async.Stream<ListenRequest> request,
      {CallOptions options}) {
    final call = $createCall(_$listen, request, options: options);
    return new ResponseStream(call);
  }
}

abstract class InfListenServiceBase extends Service {
  String get $name => 'api.InfListen';

  InfListenServiceBase() {
    $addMethod(new ServiceMethod<ListenRequest, ListenResponse>(
        'Listen',
        listen,
        true,
        true,
        (List<int> value) => new ListenRequest.fromBuffer(value),
        (ListenResponse value) => value.writeToBuffer()));
  }

  $async.Stream<ListenResponse> listen(
      ServiceCall call, $async.Stream<ListenRequest> request);
}
