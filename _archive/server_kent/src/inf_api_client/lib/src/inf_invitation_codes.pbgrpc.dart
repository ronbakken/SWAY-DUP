///
//  Generated code. Do not modify.
//  source: inf_invitation_codes.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:grpc/service_api.dart' as $grpc;

import 'dart:core' as $core show int, String, List;

import 'empty.pb.dart' as $0;
import 'inf_invitation_codes.pb.dart';
export 'inf_invitation_codes.pb.dart';

class InfInvitationCodesClient extends $grpc.Client {
  static final _$generateInvitationCode =
      $grpc.ClientMethod<$0.Empty, GenerateInvitationCodeResponse>(
          '/api.InfInvitationCodes/GenerateInvitationCode',
          ($0.Empty value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              GenerateInvitationCodeResponse.fromBuffer(value));
  static final _$getInvitationCodeStatus = $grpc.ClientMethod<
          GetInvitationCodeStatusRequest, GetInvitationCodeStatusResponse>(
      '/api.InfInvitationCodes/GetInvitationCodeStatus',
      (GetInvitationCodeStatusRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          GetInvitationCodeStatusResponse.fromBuffer(value));

  InfInvitationCodesClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<GenerateInvitationCodeResponse> generateInvitationCode(
      $0.Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$generateInvitationCode, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<GetInvitationCodeStatusResponse> getInvitationCodeStatus(
      GetInvitationCodeStatusRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getInvitationCodeStatus, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class InfInvitationCodesServiceBase extends $grpc.Service {
  $core.String get $name => 'api.InfInvitationCodes';

  InfInvitationCodesServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, GenerateInvitationCodeResponse>(
        'GenerateInvitationCode',
        generateInvitationCode_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        (GenerateInvitationCodeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<GetInvitationCodeStatusRequest,
            GetInvitationCodeStatusResponse>(
        'GetInvitationCodeStatus',
        getInvitationCodeStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            GetInvitationCodeStatusRequest.fromBuffer(value),
        (GetInvitationCodeStatusResponse value) => value.writeToBuffer()));
  }

  $async.Future<GenerateInvitationCodeResponse> generateInvitationCode_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return generateInvitationCode(call, await request);
  }

  $async.Future<GetInvitationCodeStatusResponse> getInvitationCodeStatus_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return getInvitationCodeStatus(call, await request);
  }

  $async.Future<GenerateInvitationCodeResponse> generateInvitationCode(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<GetInvitationCodeStatusResponse> getInvitationCodeStatus(
      $grpc.ServiceCall call, GetInvitationCodeStatusRequest request);
}
