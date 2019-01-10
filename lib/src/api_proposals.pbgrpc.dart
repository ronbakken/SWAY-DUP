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
      '/inf.ApiProposals/Apply',
      ($5.NetApplyProposal value) => value.writeToBuffer(),
      (List<int> value) => new $5.NetProposal.fromBuffer(value));
  static final _$direct =
      new ClientMethod<$5.NetDirectProposal, $5.NetProposal>(
          '/inf.ApiProposals/Direct',
          ($5.NetDirectProposal value) => value.writeToBuffer(),
          (List<int> value) => new $5.NetProposal.fromBuffer(value));
  static final _$list = new ClientMethod<$5.NetListProposals, $5.NetProposal>(
      '/inf.ApiProposals/List',
      ($5.NetListProposals value) => value.writeToBuffer(),
      (List<int> value) => new $5.NetProposal.fromBuffer(value));
  static final _$get = new ClientMethod<$5.NetGetProposal, $5.NetProposal>(
      '/inf.ApiProposals/Get',
      ($5.NetGetProposal value) => value.writeToBuffer(),
      (List<int> value) => new $5.NetProposal.fromBuffer(value));
  static final _$listChats =
      new ClientMethod<$5.NetGetProposal, $5.NetProposalChat>(
          '/inf.ApiProposals/ListChats',
          ($5.NetGetProposal value) => value.writeToBuffer(),
          (List<int> value) => new $5.NetProposalChat.fromBuffer(value));

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
}

abstract class ApiProposalsServiceBase extends Service {
  String get $name => 'inf.ApiProposals';

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
}
