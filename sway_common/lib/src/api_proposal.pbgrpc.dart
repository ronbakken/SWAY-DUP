///
//  Generated code. Do not modify.
//  source: api_proposal.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'net_proposal_protobuf.pb.dart' as $6;
export 'api_proposal.pb.dart';

class ApiProposalClient extends Client {
  static final _$wantDeal =
      new ClientMethod<$6.NetProposalWantDeal, $6.NetProposal>(
          '/inf.ApiProposal/WantDeal',
          ($6.NetProposalWantDeal value) => value.writeToBuffer(),
          (List<int> value) => new $6.NetProposal.fromBuffer(value));
  static final _$negotiate =
      new ClientMethod<$6.NetProposalNegotiate, $6.NetProposal>(
          '/inf.ApiProposal/Negotiate',
          ($6.NetProposalNegotiate value) => value.writeToBuffer(),
          (List<int> value) => new $6.NetProposal.fromBuffer(value));
  static final _$reject =
      new ClientMethod<$6.NetProposalReject, $6.NetProposal>(
          '/inf.ApiProposal/Reject',
          ($6.NetProposalReject value) => value.writeToBuffer(),
          (List<int> value) => new $6.NetProposal.fromBuffer(value));
  static final _$report =
      new ClientMethod<$6.NetProposalReport, $6.NetProposal>(
          '/inf.ApiProposal/Report',
          ($6.NetProposalReport value) => value.writeToBuffer(),
          (List<int> value) => new $6.NetProposal.fromBuffer(value));
  static final _$dispute =
      new ClientMethod<$6.NetProposalDispute, $6.NetProposal>(
          '/inf.ApiProposal/Dispute',
          ($6.NetProposalDispute value) => value.writeToBuffer(),
          (List<int> value) => new $6.NetProposal.fromBuffer(value));
  static final _$complete =
      new ClientMethod<$6.NetProposalCompletion, $6.NetProposal>(
          '/inf.ApiProposal/Complete',
          ($6.NetProposalCompletion value) => value.writeToBuffer(),
          (List<int> value) => new $6.NetProposal.fromBuffer(value));
  static final _$chatPlain =
      new ClientMethod<$6.NetChatPlain, $6.NetProposalChat>(
          '/inf.ApiProposal/ChatPlain',
          ($6.NetChatPlain value) => value.writeToBuffer(),
          (List<int> value) => new $6.NetProposalChat.fromBuffer(value));
  static final _$chatNegotiate =
      new ClientMethod<$6.NetChatNegotiate, $6.NetProposal>(
          '/inf.ApiProposal/ChatNegotiate',
          ($6.NetChatNegotiate value) => value.writeToBuffer(),
          (List<int> value) => new $6.NetProposal.fromBuffer(value));
  static final _$chatImageKey =
      new ClientMethod<$6.NetChatImageKey, $6.NetProposalChat>(
          '/inf.ApiProposal/ChatImageKey',
          ($6.NetChatImageKey value) => value.writeToBuffer(),
          (List<int> value) => new $6.NetProposalChat.fromBuffer(value));

  ApiProposalClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<$6.NetProposal> wantDeal($6.NetProposalWantDeal request,
      {CallOptions options}) {
    final call = $createCall(
        _$wantDeal, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$6.NetProposal> negotiate($6.NetProposalNegotiate request,
      {CallOptions options}) {
    final call = $createCall(
        _$negotiate, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$6.NetProposal> reject($6.NetProposalReject request,
      {CallOptions options}) {
    final call = $createCall(
        _$reject, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$6.NetProposal> report($6.NetProposalReport request,
      {CallOptions options}) {
    final call = $createCall(
        _$report, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$6.NetProposal> dispute($6.NetProposalDispute request,
      {CallOptions options}) {
    final call = $createCall(
        _$dispute, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$6.NetProposal> complete($6.NetProposalCompletion request,
      {CallOptions options}) {
    final call = $createCall(
        _$complete, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$6.NetProposalChat> chatPlain($6.NetChatPlain request,
      {CallOptions options}) {
    final call = $createCall(
        _$chatPlain, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$6.NetProposal> chatNegotiate($6.NetChatNegotiate request,
      {CallOptions options}) {
    final call = $createCall(
        _$chatNegotiate, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$6.NetProposalChat> chatImageKey($6.NetChatImageKey request,
      {CallOptions options}) {
    final call = $createCall(
        _$chatImageKey, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class ApiProposalServiceBase extends Service {
  String get $name => 'inf.ApiProposal';

  ApiProposalServiceBase() {
    $addMethod(new ServiceMethod<$6.NetProposalWantDeal, $6.NetProposal>(
        'WantDeal',
        wantDeal_Pre,
        false,
        false,
        (List<int> value) => new $6.NetProposalWantDeal.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$6.NetProposalNegotiate, $6.NetProposal>(
        'Negotiate',
        negotiate_Pre,
        false,
        false,
        (List<int> value) => new $6.NetProposalNegotiate.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$6.NetProposalReject, $6.NetProposal>(
        'Reject',
        reject_Pre,
        false,
        false,
        (List<int> value) => new $6.NetProposalReject.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$6.NetProposalReport, $6.NetProposal>(
        'Report',
        report_Pre,
        false,
        false,
        (List<int> value) => new $6.NetProposalReport.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$6.NetProposalDispute, $6.NetProposal>(
        'Dispute',
        dispute_Pre,
        false,
        false,
        (List<int> value) => new $6.NetProposalDispute.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$6.NetProposalCompletion, $6.NetProposal>(
        'Complete',
        complete_Pre,
        false,
        false,
        (List<int> value) => new $6.NetProposalCompletion.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$6.NetChatPlain, $6.NetProposalChat>(
        'ChatPlain',
        chatPlain_Pre,
        false,
        false,
        (List<int> value) => new $6.NetChatPlain.fromBuffer(value),
        ($6.NetProposalChat value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$6.NetChatNegotiate, $6.NetProposal>(
        'ChatNegotiate',
        chatNegotiate_Pre,
        false,
        false,
        (List<int> value) => new $6.NetChatNegotiate.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$6.NetChatImageKey, $6.NetProposalChat>(
        'ChatImageKey',
        chatImageKey_Pre,
        false,
        false,
        (List<int> value) => new $6.NetChatImageKey.fromBuffer(value),
        ($6.NetProposalChat value) => value.writeToBuffer()));
  }

  $async.Future<$6.NetProposal> wantDeal_Pre(
      ServiceCall call, $async.Future request) async {
    return wantDeal(call, await request);
  }

  $async.Future<$6.NetProposal> negotiate_Pre(
      ServiceCall call, $async.Future request) async {
    return negotiate(call, await request);
  }

  $async.Future<$6.NetProposal> reject_Pre(
      ServiceCall call, $async.Future request) async {
    return reject(call, await request);
  }

  $async.Future<$6.NetProposal> report_Pre(
      ServiceCall call, $async.Future request) async {
    return report(call, await request);
  }

  $async.Future<$6.NetProposal> dispute_Pre(
      ServiceCall call, $async.Future request) async {
    return dispute(call, await request);
  }

  $async.Future<$6.NetProposal> complete_Pre(
      ServiceCall call, $async.Future request) async {
    return complete(call, await request);
  }

  $async.Future<$6.NetProposalChat> chatPlain_Pre(
      ServiceCall call, $async.Future request) async {
    return chatPlain(call, await request);
  }

  $async.Future<$6.NetProposal> chatNegotiate_Pre(
      ServiceCall call, $async.Future request) async {
    return chatNegotiate(call, await request);
  }

  $async.Future<$6.NetProposalChat> chatImageKey_Pre(
      ServiceCall call, $async.Future request) async {
    return chatImageKey(call, await request);
  }

  $async.Future<$6.NetProposal> wantDeal(
      ServiceCall call, $6.NetProposalWantDeal request);
  $async.Future<$6.NetProposal> negotiate(
      ServiceCall call, $6.NetProposalNegotiate request);
  $async.Future<$6.NetProposal> reject(
      ServiceCall call, $6.NetProposalReject request);
  $async.Future<$6.NetProposal> report(
      ServiceCall call, $6.NetProposalReport request);
  $async.Future<$6.NetProposal> dispute(
      ServiceCall call, $6.NetProposalDispute request);
  $async.Future<$6.NetProposal> complete(
      ServiceCall call, $6.NetProposalCompletion request);
  $async.Future<$6.NetProposalChat> chatPlain(
      ServiceCall call, $6.NetChatPlain request);
  $async.Future<$6.NetProposal> chatNegotiate(
      ServiceCall call, $6.NetChatNegotiate request);
  $async.Future<$6.NetProposalChat> chatImageKey(
      ServiceCall call, $6.NetChatImageKey request);
}
