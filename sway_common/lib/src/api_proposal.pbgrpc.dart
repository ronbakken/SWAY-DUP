///
//  Generated code. Do not modify.
//  source: api_proposal.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'net_proposal_protobuf.pb.dart' as $6;
export 'api_proposal.pb.dart';

class ApiProposalClient extends $grpc.Client {
  static final _$wantDeal =
      $grpc.ClientMethod<$6.NetProposalWantDeal, $6.NetProposal>(
          '/inf.ApiProposal/WantDeal',
          ($6.NetProposalWantDeal value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $6.NetProposal.fromBuffer(value));
  static final _$negotiate =
      $grpc.ClientMethod<$6.NetProposalNegotiate, $6.NetProposal>(
          '/inf.ApiProposal/Negotiate',
          ($6.NetProposalNegotiate value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $6.NetProposal.fromBuffer(value));
  static final _$reject =
      $grpc.ClientMethod<$6.NetProposalReject, $6.NetProposal>(
          '/inf.ApiProposal/Reject',
          ($6.NetProposalReject value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $6.NetProposal.fromBuffer(value));
  static final _$report =
      $grpc.ClientMethod<$6.NetProposalReport, $6.NetProposal>(
          '/inf.ApiProposal/Report',
          ($6.NetProposalReport value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $6.NetProposal.fromBuffer(value));
  static final _$dispute =
      $grpc.ClientMethod<$6.NetProposalDispute, $6.NetProposal>(
          '/inf.ApiProposal/Dispute',
          ($6.NetProposalDispute value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $6.NetProposal.fromBuffer(value));
  static final _$complete =
      $grpc.ClientMethod<$6.NetProposalCompletion, $6.NetProposal>(
          '/inf.ApiProposal/Complete',
          ($6.NetProposalCompletion value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $6.NetProposal.fromBuffer(value));
  static final _$chatPlain =
      $grpc.ClientMethod<$6.NetChatPlain, $6.NetProposalChat>(
          '/inf.ApiProposal/ChatPlain',
          ($6.NetChatPlain value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $6.NetProposalChat.fromBuffer(value));
  static final _$chatNegotiate =
      $grpc.ClientMethod<$6.NetChatNegotiate, $6.NetProposal>(
          '/inf.ApiProposal/ChatNegotiate',
          ($6.NetChatNegotiate value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $6.NetProposal.fromBuffer(value));
  static final _$chatImageKey =
      $grpc.ClientMethod<$6.NetChatImageKey, $6.NetProposalChat>(
          '/inf.ApiProposal/ChatImageKey',
          ($6.NetChatImageKey value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $6.NetProposalChat.fromBuffer(value));

  ApiProposalClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$6.NetProposal> wantDeal($6.NetProposalWantDeal request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$wantDeal, request, options: options);
  }

  $grpc.ResponseFuture<$6.NetProposal> negotiate(
      $6.NetProposalNegotiate request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$negotiate, request, options: options);
  }

  $grpc.ResponseFuture<$6.NetProposal> reject($6.NetProposalReject request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$reject, request, options: options);
  }

  $grpc.ResponseFuture<$6.NetProposal> report($6.NetProposalReport request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$report, request, options: options);
  }

  $grpc.ResponseFuture<$6.NetProposal> dispute($6.NetProposalDispute request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$dispute, request, options: options);
  }

  $grpc.ResponseFuture<$6.NetProposal> complete(
      $6.NetProposalCompletion request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$complete, request, options: options);
  }

  $grpc.ResponseFuture<$6.NetProposalChat> chatPlain($6.NetChatPlain request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$chatPlain, request, options: options);
  }

  $grpc.ResponseFuture<$6.NetProposal> chatNegotiate(
      $6.NetChatNegotiate request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$chatNegotiate, request, options: options);
  }

  $grpc.ResponseFuture<$6.NetProposalChat> chatImageKey(
      $6.NetChatImageKey request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$chatImageKey, request, options: options);
  }
}

abstract class ApiProposalServiceBase extends $grpc.Service {
  $core.String get $name => 'inf.ApiProposal';

  ApiProposalServiceBase() {
    $addMethod($grpc.ServiceMethod<$6.NetProposalWantDeal, $6.NetProposal>(
        'WantDeal',
        wantDeal_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $6.NetProposalWantDeal.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.NetProposalNegotiate, $6.NetProposal>(
        'Negotiate',
        negotiate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $6.NetProposalNegotiate.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.NetProposalReject, $6.NetProposal>(
        'Reject',
        reject_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.NetProposalReject.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.NetProposalReport, $6.NetProposal>(
        'Report',
        report_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.NetProposalReport.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.NetProposalDispute, $6.NetProposal>(
        'Dispute',
        dispute_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $6.NetProposalDispute.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.NetProposalCompletion, $6.NetProposal>(
        'Complete',
        complete_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $6.NetProposalCompletion.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.NetChatPlain, $6.NetProposalChat>(
        'ChatPlain',
        chatPlain_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.NetChatPlain.fromBuffer(value),
        ($6.NetProposalChat value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.NetChatNegotiate, $6.NetProposal>(
        'ChatNegotiate',
        chatNegotiate_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.NetChatNegotiate.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.NetChatImageKey, $6.NetProposalChat>(
        'ChatImageKey',
        chatImageKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.NetChatImageKey.fromBuffer(value),
        ($6.NetProposalChat value) => value.writeToBuffer()));
  }

  $async.Future<$6.NetProposal> wantDeal_Pre($grpc.ServiceCall call,
      $async.Future<$6.NetProposalWantDeal> request) async {
    return wantDeal(call, await request);
  }

  $async.Future<$6.NetProposal> negotiate_Pre($grpc.ServiceCall call,
      $async.Future<$6.NetProposalNegotiate> request) async {
    return negotiate(call, await request);
  }

  $async.Future<$6.NetProposal> reject_Pre($grpc.ServiceCall call,
      $async.Future<$6.NetProposalReject> request) async {
    return reject(call, await request);
  }

  $async.Future<$6.NetProposal> report_Pre($grpc.ServiceCall call,
      $async.Future<$6.NetProposalReport> request) async {
    return report(call, await request);
  }

  $async.Future<$6.NetProposal> dispute_Pre($grpc.ServiceCall call,
      $async.Future<$6.NetProposalDispute> request) async {
    return dispute(call, await request);
  }

  $async.Future<$6.NetProposal> complete_Pre($grpc.ServiceCall call,
      $async.Future<$6.NetProposalCompletion> request) async {
    return complete(call, await request);
  }

  $async.Future<$6.NetProposalChat> chatPlain_Pre(
      $grpc.ServiceCall call, $async.Future<$6.NetChatPlain> request) async {
    return chatPlain(call, await request);
  }

  $async.Future<$6.NetProposal> chatNegotiate_Pre($grpc.ServiceCall call,
      $async.Future<$6.NetChatNegotiate> request) async {
    return chatNegotiate(call, await request);
  }

  $async.Future<$6.NetProposalChat> chatImageKey_Pre(
      $grpc.ServiceCall call, $async.Future<$6.NetChatImageKey> request) async {
    return chatImageKey(call, await request);
  }

  $async.Future<$6.NetProposal> wantDeal(
      $grpc.ServiceCall call, $6.NetProposalWantDeal request);
  $async.Future<$6.NetProposal> negotiate(
      $grpc.ServiceCall call, $6.NetProposalNegotiate request);
  $async.Future<$6.NetProposal> reject(
      $grpc.ServiceCall call, $6.NetProposalReject request);
  $async.Future<$6.NetProposal> report(
      $grpc.ServiceCall call, $6.NetProposalReport request);
  $async.Future<$6.NetProposal> dispute(
      $grpc.ServiceCall call, $6.NetProposalDispute request);
  $async.Future<$6.NetProposal> complete(
      $grpc.ServiceCall call, $6.NetProposalCompletion request);
  $async.Future<$6.NetProposalChat> chatPlain(
      $grpc.ServiceCall call, $6.NetChatPlain request);
  $async.Future<$6.NetProposal> chatNegotiate(
      $grpc.ServiceCall call, $6.NetChatNegotiate request);
  $async.Future<$6.NetProposalChat> chatImageKey(
      $grpc.ServiceCall call, $6.NetChatImageKey request);
}
