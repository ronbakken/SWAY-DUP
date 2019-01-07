///
//  Generated code. Do not modify.
//  source: api_account.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;
// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'net_account_protobuf.pb.dart' as $2;

class ApiAccountApi {
  $pb.RpcClient _client;
  ApiAccountApi(this._client);

  $async.Future<$2.NetAccount> setType(
      $pb.ClientContext ctx, $2.NetSetAccountType request) {
    var emptyResponse = new $2.NetAccount();
    return _client.invoke<$2.NetAccount>(
        ctx, 'ApiAccount', 'SetType', request, emptyResponse);
  }

  $async.Future<$2.NetAccount> create_(
      $pb.ClientContext ctx, $2.NetAccountCreate request) {
    var emptyResponse = new $2.NetAccount();
    return _client.invoke<$2.NetAccount>(
        ctx, 'ApiAccount', 'Create', request, emptyResponse);
  }

  $async.Future<$2.NetOAuthConnection> connectProvider(
      $pb.ClientContext ctx, $2.NetOAuthConnection request) {
    var emptyResponse = new $2.NetOAuthConnection();
    return _client.invoke<$2.NetOAuthConnection>(
        ctx, 'ApiAccount', 'ConnectProvider', request, emptyResponse);
  }

  $async.Future<$2.NetAccount> setFirebaseToken(
      $pb.ClientContext ctx, $2.NetSetFirebaseToken request) {
    var emptyResponse = new $2.NetAccount();
    return _client.invoke<$2.NetAccount>(
        ctx, 'ApiAccount', 'SetFirebaseToken', request, emptyResponse);
  }
}
