///
//  Generated code. Do not modify.
//  source: api_proposals.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'net_proposal_protobuf.pb.dart' as $5;
export 'api_proposals.pb.dart';

class ApiProposalsClient extends Client {
  static final _$apply = new ClientMethod<$5.NetApplyProposal, $5.NetProposal>(
      '/inf_common.ApiProposals/Apply',
      ($5.NetApplyProposal value) => value.writeToBuffer(),
      (List<int> value) => new $5.NetProposal.fromBuffer(value));
  static final _$direct =
      new ClientMethod<$5.NetDirectProposal, $5.NetProposal>(
          '/inf_common.ApiProposals/Direct',
          ($5.NetDirectProposal value) => value.writeToBuffer(),
          (List<int> value) => new $5.NetProposal.fromBuffer(value));
  static final _$list = new ClientMethod<$5.NetListProposals, $5.NetProposal>(
      '/inf_common.ApiProposals/List',
      ($5.NetListProposals value) => value.writeToBuffer(),
      (List<int> value) => new $5.NetProposal.fromBuffer(value));
  static final _$get = new ClientMethod<$5.NetGetProposal, $5.NetProposal>(
      '/inf_common.ApiProposals/Get',
      ($5.NetGetProposal value) => value.writeToBuffer(),
      (List<int> value) => new $5.NetProposal.fromBuffer(value));
  static final _$listChats =
      new ClientMethod<$5.NetGetProposal, $5.NetProposalChat>(
          '/inf_common.ApiProposals/ListChats',
          ($5.NetGetProposal value) => value.writeToBuffer(),
          (List<int> value) => new $5.NetProposalChat.fromBuffer(value));
  static final _$wantDeal =
      new ClientMethod<$5.NetProposalWantDeal, $5.NetProposal>(
          '/inf_common.ApiProposals/WantDeal',
          ($5.NetProposalWantDeal value) => value.writeToBuffer(),
          (List<int> value) => new $5.NetProposal.fromBuffer(value));
  static final _$negotiate =
      new ClientMethod<$5.NetProposalNegotiate, $5.NetProposal>(
          '/inf_common.ApiProposals/Negotiate',
          ($5.NetProposalNegotiate value) => value.writeToBuffer(),
          (List<int> value) => new $5.NetProposal.fromBuffer(value));
  static final _$reject =
      new ClientMethod<$5.NetProposalReject, $5.NetProposal>(
          '/inf_common.ApiProposals/Reject',
          ($5.NetProposalReject value) => value.writeToBuffer(),
          (List<int> value) => new $5.NetProposal.fromBuffer(value));
  static final _$report =
      new ClientMethod<$5.NetProposalReport, $5.NetProposal>(
          '/inf_common.ApiProposals/Report',
          ($5.NetProposalReport value) => value.writeToBuffer(),
          (List<int> value) => new $5.NetProposal.fromBuffer(value));
  static final _$dispute =
      new ClientMethod<$5.NetProposalDispute, $5.NetProposal>(
          '/inf_common.ApiProposals/Dispute',
          ($5.NetProposalDispute value) => value.writeToBuffer(),
          (List<int> value) => new $5.NetProposal.fromBuffer(value));
  static final _$complete =
      new ClientMethod<$5.NetProposalCompletion, $5.NetProposal>(
          '/inf_common.ApiProposals/Complete',
          ($5.NetProposalCompletion value) => value.writeToBuffer(),
          (List<int> value) => new $5.NetProposal.fromBuffer(value));
  static final _$chatPlain = new ClientMethod<$5.NetChatPlain, $5.NetProposal>(
      '/inf_common.ApiProposals/ChatPlain',
      ($5.NetChatPlain value) => value.writeToBuffer(),
      (List<int> value) => new $5.NetProposal.fromBuffer(value));
  static final _$chatNegotiate =
      new ClientMethod<$5.NetChatNegotiate, $5.NetProposal>(
          '/inf_common.ApiProposals/ChatNegotiate',
          ($5.NetChatNegotiate value) => value.writeToBuffer(),
          (List<int> value) => new $5.NetProposal.fromBuffer(value));
  static final _$chatImageKey =
      new ClientMethod<$5.NetChatImageKey, $5.NetProposal>(
          '/inf_common.ApiProposals/ChatImageKey',
          ($5.NetChatImageKey value) => value.writeToBuffer(),
          (List<int> value) => new $5.NetProposal.fromBuffer(value));

  ApiProposalsClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<$5.NetProposal> apply($5.NetApplyProposal request,
      {CallOptions options}) {
    final call = $createCall(_$apply, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$5.NetProposal> direct($5.NetDirectProposal request,
      {CallOptions options}) {
    final call = $createCall(
        _$direct, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseStream<$5.NetProposal> list($5.NetListProposals request,
      {CallOptions options}) {
    final call = $createCall(_$list, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseStream(call);
  }

  ResponseFuture<$5.NetProposal> get($5.NetGetProposal request,
      {CallOptions options}) {
    final call = $createCall(_$get, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseStream<$5.NetProposalChat> listChats($5.NetGetProposal request,
      {CallOptions options}) {
    final call = $createCall(
        _$listChats, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseStream(call);
  }

  ResponseFuture<$5.NetProposal> wantDeal($5.NetProposalWantDeal request,
      {CallOptions options}) {
    final call = $createCall(
        _$wantDeal, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$5.NetProposal> negotiate($5.NetProposalNegotiate request,
      {CallOptions options}) {
    final call = $createCall(
        _$negotiate, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$5.NetProposal> reject($5.NetProposalReject request,
      {CallOptions options}) {
    final call = $createCall(
        _$reject, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$5.NetProposal> report($5.NetProposalReport request,
      {CallOptions options}) {
    final call = $createCall(
        _$report, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$5.NetProposal> dispute($5.NetProposalDispute request,
      {CallOptions options}) {
    final call = $createCall(
        _$dispute, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$5.NetProposal> complete($5.NetProposalCompletion request,
      {CallOptions options}) {
    final call = $createCall(
        _$complete, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$5.NetProposal> chatPlain($5.NetChatPlain request,
      {CallOptions options}) {
    final call = $createCall(
        _$chatPlain, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$5.NetProposal> chatNegotiate($5.NetChatNegotiate request,
      {CallOptions options}) {
    final call = $createCall(
        _$chatNegotiate, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$5.NetProposal> chatImageKey($5.NetChatImageKey request,
      {CallOptions options}) {
    final call = $createCall(
        _$chatImageKey, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class ApiProposalsServiceBase extends Service {
  String get $name => 'inf_common.ApiProposals';

  ApiProposalsServiceBase() {
    $addMethod(new ServiceMethod<$5.NetApplyProposal, $5.NetProposal>(
        'Apply',
        apply_Pre,
        false,
        false,
        (List<int> value) => new $5.NetApplyProposal.fromBuffer(value),
        ($5.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$5.NetDirectProposal, $5.NetProposal>(
        'Direct',
        direct_Pre,
        false,
        false,
        (List<int> value) => new $5.NetDirectProposal.fromBuffer(value),
        ($5.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$5.NetListProposals, $5.NetProposal>(
        'List',
        list_Pre,
        false,
        true,
        (List<int> value) => new $5.NetListProposals.fromBuffer(value),
        ($5.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$5.NetGetProposal, $5.NetProposal>(
        'Get',
        get_Pre,
        false,
        false,
        (List<int> value) => new $5.NetGetProposal.fromBuffer(value),
        ($5.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$5.NetGetProposal, $5.NetProposalChat>(
        'ListChats',
        listChats_Pre,
        false,
        true,
        (List<int> value) => new $5.NetGetProposal.fromBuffer(value),
        ($5.NetProposalChat value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$5.NetProposalWantDeal, $5.NetProposal>(
        'WantDeal',
        wantDeal_Pre,
        false,
        false,
        (List<int> value) => new $5.NetProposalWantDeal.fromBuffer(value),
        ($5.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$5.NetProposalNegotiate, $5.NetProposal>(
        'Negotiate',
        negotiate_Pre,
        false,
        false,
        (List<int> value) => new $5.NetProposalNegotiate.fromBuffer(value),
        ($5.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$5.NetProposalReject, $5.NetProposal>(
        'Reject',
        reject_Pre,
        false,
        false,
        (List<int> value) => new $5.NetProposalReject.fromBuffer(value),
        ($5.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$5.NetProposalReport, $5.NetProposal>(
        'Report',
        report_Pre,
        false,
        false,
        (List<int> value) => new $5.NetProposalReport.fromBuffer(value),
        ($5.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$5.NetProposalDispute, $5.NetProposal>(
        'Dispute',
        dispute_Pre,
        false,
        false,
        (List<int> value) => new $5.NetProposalDispute.fromBuffer(value),
        ($5.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$5.NetProposalCompletion, $5.NetProposal>(
        'Complete',
        complete_Pre,
        false,
        false,
        (List<int> value) => new $5.NetProposalCompletion.fromBuffer(value),
        ($5.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$5.NetChatPlain, $5.NetProposal>(
        'ChatPlain',
        chatPlain_Pre,
        false,
        false,
        (List<int> value) => new $5.NetChatPlain.fromBuffer(value),
        ($5.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$5.NetChatNegotiate, $5.NetProposal>(
        'ChatNegotiate',
        chatNegotiate_Pre,
        false,
        false,
        (List<int> value) => new $5.NetChatNegotiate.fromBuffer(value),
        ($5.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$5.NetChatImageKey, $5.NetProposal>(
        'ChatImageKey',
        chatImageKey_Pre,
        false,
        false,
        (List<int> value) => new $5.NetChatImageKey.fromBuffer(value),
        ($5.NetProposal value) => value.writeToBuffer()));
  }

  $async.Future<$5.NetProposal> apply_Pre(
      ServiceCall call, $async.Future request) async {
    return apply(call, await request);
  }

  $async.Future<$5.NetProposal> direct_Pre(
      ServiceCall call, $async.Future request) async {
    return direct(call, await request);
  }

  $async.Stream<$5.NetProposal> list_Pre(
      ServiceCall call, $async.Future request) async* {
    yield* list(call, (await request) as $5.NetListProposals);
  }

  $async.Future<$5.NetProposal> get_Pre(
      ServiceCall call, $async.Future request) async {
    return get(call, await request);
  }

  $async.Stream<$5.NetProposalChat> listChats_Pre(
      ServiceCall call, $async.Future request) async* {
    yield* listChats(call, (await request) as $5.NetGetProposal);
  }

  $async.Future<$5.NetProposal> wantDeal_Pre(
      ServiceCall call, $async.Future request) async {
    return wantDeal(call, await request);
  }

  $async.Future<$5.NetProposal> negotiate_Pre(
      ServiceCall call, $async.Future request) async {
    return negotiate(call, await request);
  }

  $async.Future<$5.NetProposal> reject_Pre(
      ServiceCall call, $async.Future request) async {
    return reject(call, await request);
  }

  $async.Future<$5.NetProposal> report_Pre(
      ServiceCall call, $async.Future request) async {
    return report(call, await request);
  }

  $async.Future<$5.NetProposal> dispute_Pre(
      ServiceCall call, $async.Future request) async {
    return dispute(call, await request);
  }

  $async.Future<$5.NetProposal> complete_Pre(
      ServiceCall call, $async.Future request) async {
    return complete(call, await request);
  }

  $async.Future<$5.NetProposal> chatPlain_Pre(
      ServiceCall call, $async.Future request) async {
    return chatPlain(call, await request);
  }

  $async.Future<$5.NetProposal> chatNegotiate_Pre(
      ServiceCall call, $async.Future request) async {
    return chatNegotiate(call, await request);
  }

  $async.Future<$5.NetProposal> chatImageKey_Pre(
      ServiceCall call, $async.Future request) async {
    return chatImageKey(call, await request);
  }

  $async.Future<$5.NetProposal> apply(
      ServiceCall call, $5.NetApplyProposal request);
  $async.Future<$5.NetProposal> direct(
      ServiceCall call, $5.NetDirectProposal request);
  $async.Stream<$5.NetProposal> list(
      ServiceCall call, $5.NetListProposals request);
  $async.Future<$5.NetProposal> get(
      ServiceCall call, $5.NetGetProposal request);
  $async.Stream<$5.NetProposalChat> listChats(
      ServiceCall call, $5.NetGetProposal request);
  $async.Future<$5.NetProposal> wantDeal(
      ServiceCall call, $5.NetProposalWantDeal request);
  $async.Future<$5.NetProposal> negotiate(
      ServiceCall call, $5.NetProposalNegotiate request);
  $async.Future<$5.NetProposal> reject(
      ServiceCall call, $5.NetProposalReject request);
  $async.Future<$5.NetProposal> report(
      ServiceCall call, $5.NetProposalReport request);
  $async.Future<$5.NetProposal> dispute(
      ServiceCall call, $5.NetProposalDispute request);
  $async.Future<$5.NetProposal> complete(
      ServiceCall call, $5.NetProposalCompletion request);
  $async.Future<$5.NetProposal> chatPlain(
      ServiceCall call, $5.NetChatPlain request);
  $async.Future<$5.NetProposal> chatNegotiate(
      ServiceCall call, $5.NetChatNegotiate request);
  $async.Future<$5.NetProposal> chatImageKey(
      ServiceCall call, $5.NetChatImageKey request);
}
