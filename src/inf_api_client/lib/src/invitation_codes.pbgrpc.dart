///
//  Generated code. Do not modify.
//  source: invitation_codes.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'empty.pb.dart' as $0;
import 'invitation_codes.pb.dart';
export 'invitation_codes.pb.dart';

class InvitationCodesClient extends Client {
  static final _$generateInvitationCode =
      new ClientMethod<$0.Empty, GenerateInvitationCodeResponse>(
          '/api.InvitationCodes/GenerateInvitationCode',
          ($0.Empty value) => value.writeToBuffer(),
          (List<int> value) =>
              new GenerateInvitationCodeResponse.fromBuffer(value));
  static final _$getInvitationCodeStatus = new ClientMethod<
          GetInvitationCodeStatusRequest, GetInvitationCodeStatusResponse>(
      '/api.InvitationCodes/GetInvitationCodeStatus',
      (GetInvitationCodeStatusRequest value) => value.writeToBuffer(),
      (List<int> value) =>
          new GetInvitationCodeStatusResponse.fromBuffer(value));

  InvitationCodesClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<GenerateInvitationCodeResponse> generateInvitationCode(
      $0.Empty request,
      {CallOptions options}) {
    final call = $createCall(
        _$generateInvitationCode, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<GetInvitationCodeStatusResponse> getInvitationCodeStatus(
      GetInvitationCodeStatusRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$getInvitationCodeStatus, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class InvitationCodesServiceBase extends Service {
  String get $name => 'api.InvitationCodes';

  InvitationCodesServiceBase() {
    $addMethod(new ServiceMethod<$0.Empty, GenerateInvitationCodeResponse>(
        'GenerateInvitationCode',
        generateInvitationCode_Pre,
        false,
        false,
        (List<int> value) => new $0.Empty.fromBuffer(value),
        (GenerateInvitationCodeResponse value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<GetInvitationCodeStatusRequest,
            GetInvitationCodeStatusResponse>(
        'GetInvitationCodeStatus',
        getInvitationCodeStatus_Pre,
        false,
        false,
        (List<int> value) =>
            new GetInvitationCodeStatusRequest.fromBuffer(value),
        (GetInvitationCodeStatusResponse value) => value.writeToBuffer()));
  }

  $async.Future<GenerateInvitationCodeResponse> generateInvitationCode_Pre(
      ServiceCall call, $async.Future request) async {
    return generateInvitationCode(call, await request);
  }

  $async.Future<GetInvitationCodeStatusResponse> getInvitationCodeStatus_Pre(
      ServiceCall call, $async.Future request) async {
    return getInvitationCodeStatus(call, await request);
  }

  $async.Future<GenerateInvitationCodeResponse> generateInvitationCode(
      ServiceCall call, $0.Empty request);
  $async.Future<GetInvitationCodeStatusResponse> getInvitationCodeStatus(
      ServiceCall call, GetInvitationCodeStatusRequest request);
}
