///
//  Generated code. Do not modify.
//  source: api_session.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

export 'api_session.pb.dart';

class ApiSessionClient extends Client {
  ApiSessionClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);
}

abstract class ApiSessionServiceBase extends Service {
  String get $name => 'inf_common.ApiSession';

  ApiSessionServiceBase() {}
}
