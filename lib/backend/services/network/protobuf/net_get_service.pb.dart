///
//  Generated code. Do not modify.
//  source: net_get_service.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async';
// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'net_get_protobuf.pb.dart' as $2;

class NetGetServiceApi {
  $pb.RpcClient _client;
  NetGetServiceApi(this._client);

  Future<$2.NetGetAccountRes> getAccount(
      $pb.ClientContext ctx, $2.NetGetAccountReq request) {
    var emptyResponse = new $2.NetGetAccountRes();
    return _client.invoke<$2.NetGetAccountRes>(
        ctx, 'NetGetService', 'getAccount', request, emptyResponse);
  }

  Future<$2.NetGetOfferRes> getOffer(
      $pb.ClientContext ctx, $2.NetGetOfferReq request) {
    var emptyResponse = new $2.NetGetOfferRes();
    return _client.invoke<$2.NetGetOfferRes>(
        ctx, 'NetGetService', 'getOffer', request, emptyResponse);
  }

  Future<$2.NetGetApplicantRes> getProposal(
      $pb.ClientContext ctx, $2.NetGetApplicantReq request) {
    var emptyResponse = new $2.NetGetApplicantRes();
    return _client.invoke<$2.NetGetApplicantRes>(
        ctx, 'NetGetService', 'getProposal', request, emptyResponse);
  }
}
