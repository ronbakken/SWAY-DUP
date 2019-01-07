///
//  Generated code. Do not modify.
//  source: api_push.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;
// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'net_push_protobuf.pb.dart' as $5;

class ApiPushApi {
  $pb.RpcClient _client;
  ApiPushApi(this._client);

  $async.Future<$5.NetPush> listen(
      $pb.ClientContext ctx, $5.NetListen request) {
    var emptyResponse = new $5.NetPush();
    return _client.invoke<$5.NetPush>(
        ctx, 'ApiPush', 'Listen', request, emptyResponse);
  }
}
