///
//  Generated code. Do not modify.
//  source: net_get_service.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async';

import 'package:protobuf/protobuf.dart';

import 'net_get_protobuf.pb.dart' as $2;
import 'net_get_service.pbjson.dart';

export 'net_get_service.pb.dart';

abstract class NetGetServiceBase extends GeneratedService {
  Future<$2.NetGetAccountRes> getAccount(
      ServerContext ctx, $2.NetGetAccountReq request);
  Future<$2.NetGetOfferRes> getOffer(
      ServerContext ctx, $2.NetGetOfferReq request);
  Future<$2.NetGetApplicantRes> getProposal(
      ServerContext ctx, $2.NetGetApplicantReq request);

  GeneratedMessage createRequest(String method) {
    switch (method) {
      case 'getAccount':
        return new $2.NetGetAccountReq();
      case 'getOffer':
        return new $2.NetGetOfferReq();
      case 'getProposal':
        return new $2.NetGetApplicantReq();
      default:
        throw new ArgumentError('Unknown method: $method');
    }
  }

  Future<GeneratedMessage> handleCall(
      ServerContext ctx, String method, GeneratedMessage request) {
    switch (method) {
      case 'getAccount':
        return this.getAccount(ctx, request);
      case 'getOffer':
        return this.getOffer(ctx, request);
      case 'getProposal':
        return this.getProposal(ctx, request);
      default:
        throw new ArgumentError('Unknown method: $method');
    }
  }

  Map<String, dynamic> get $json => NetGetService$json;
  Map<String, Map<String, dynamic>> get $messageJson =>
      NetGetService$messageJson;
}
