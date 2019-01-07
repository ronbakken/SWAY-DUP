///
//  Generated code. Do not modify.
//  source: api_account.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart';

import 'net_account_protobuf.pb.dart' as $2;
import 'api_account.pbjson.dart';

export 'api_account.pb.dart';

abstract class ApiAccountServiceBase extends GeneratedService {
  $async.Future<$2.NetAccount> setType(
      ServerContext ctx, $2.NetSetAccountType request);
  $async.Future<$2.NetAccount> create(
      ServerContext ctx, $2.NetAccountCreate request);
  $async.Future<$2.NetOAuthConnection> connectProvider(
      ServerContext ctx, $2.NetOAuthConnection request);
  $async.Future<$2.NetAccount> setFirebaseToken(
      ServerContext ctx, $2.NetSetFirebaseToken request);

  GeneratedMessage createRequest(String method) {
    switch (method) {
      case 'SetType':
        return new $2.NetSetAccountType();
      case 'Create':
        return new $2.NetAccountCreate();
      case 'ConnectProvider':
        return new $2.NetOAuthConnection();
      case 'SetFirebaseToken':
        return new $2.NetSetFirebaseToken();
      default:
        throw new ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<GeneratedMessage> handleCall(
      ServerContext ctx, String method, GeneratedMessage request) {
    switch (method) {
      case 'SetType':
        return this.setType(ctx, request);
      case 'Create':
        return this.create(ctx, request);
      case 'ConnectProvider':
        return this.connectProvider(ctx, request);
      case 'SetFirebaseToken':
        return this.setFirebaseToken(ctx, request);
      default:
        throw new ArgumentError('Unknown method: $method');
    }
  }

  Map<String, dynamic> get $json => ApiAccountServiceBase$json;
  Map<String, Map<String, dynamic>> get $messageJson =>
      ApiAccountServiceBase$messageJson;
}
