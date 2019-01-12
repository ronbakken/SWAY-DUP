///
//  Generated code. Do not modify.
//  source: api_proposals.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'net_proposal_protobuf.pb.dart' as $6;
export 'api_proposals.pb.dart';

class ApiProposalsClient extends Client {
  static final _$apply = new ClientMethod<$6.NetApplyProposal, $6.NetProposal>(
      '/inf.ApiProposals/Apply',
      ($6.NetApplyProposal value) => value.writeToBuffer(),
      (List<int> value) => new $6.NetProposal.fromBuffer(value));
  static final _$direct =
      new ClientMethod<$6.NetDirectProposal, $6.NetProposal>(
          '/inf.ApiProposals/Direct',
          ($6.NetDirectProposal value) => value.writeToBuffer(),
          (List<int> value) => new $6.NetProposal.fromBuffer(value));
  static final _$list = new ClientMethod<$6.NetListProposals, $6.NetProposal>(
      '/inf.ApiProposals/List',
      ($6.NetListProposals value) => value.writeToBuffer(),
      (List<int> value) => new $6.NetProposal.fromBuffer(value));
  static final _$get = new ClientMethod<$6.NetGetProposal, $6.NetProposal>(
      '/inf.ApiProposals/Get',
      ($6.NetGetProposal value) => value.writeToBuffer(),
      (List<int> value) => new $6.NetProposal.fromBuffer(value));
  static final _$listChats =
      new ClientMethod<$6.NetListChats, $6.NetProposalChat>(
          '/inf.ApiProposals/ListChats',
          ($6.NetListChats value) => value.writeToBuffer(),
          (List<int> value) => new $6.NetProposalChat.fromBuffer(value));

  ApiProposalsClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<$6.NetProposal> apply($6.NetApplyProposal request,
      {CallOptions options}) {
    final call = $createCall(_$apply, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$6.NetProposal> direct($6.NetDirectProposal request,
      {CallOptions options}) {
    final call = $createCall(
        _$direct, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseStream<$6.NetProposal> list($6.NetListProposals request,
      {CallOptions options}) {
    final call = $createCall(_$list, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseStream(call);
  }

  ResponseFuture<$6.NetProposal> get($6.NetGetProposal request,
      {CallOptions options}) {
    final call = $createCall(_$get, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseStream<$6.NetProposalChat> listChats($6.NetListChats request,
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
    $addMethod(new ServiceMethod<$6.NetApplyProposal, $6.NetProposal>(
        'Apply',
        apply_Pre,
        false,
        false,
        (List<int> value) => new $6.NetApplyProposal.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$6.NetDirectProposal, $6.NetProposal>(
        'Direct',
        direct_Pre,
        false,
        false,
        (List<int> value) => new $6.NetDirectProposal.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$6.NetListProposals, $6.NetProposal>(
        'List',
        list_Pre,
        false,
        true,
        (List<int> value) => new $6.NetListProposals.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$6.NetGetProposal, $6.NetProposal>(
        'Get',
        get_Pre,
        false,
        false,
        (List<int> value) => new $6.NetGetProposal.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<$6.NetListChats, $6.NetProposalChat>(
        'ListChats',
        listChats_Pre,
        false,
        true,
        (List<int> value) => new $6.NetListChats.fromBuffer(value),
        ($6.NetProposalChat value) => value.writeToBuffer()));
  }

  $async.Future<$6.NetProposal> apply_Pre(
      ServiceCall call, $async.Future request) async {
    return apply(call, await request);
  }

  $async.Future<$6.NetProposal> direct_Pre(
      ServiceCall call, $async.Future request) async {
    return direct(call, await request);
  }

  $async.Stream<$6.NetProposal> list_Pre(
      ServiceCall call, $async.Future request) async* {
    yield* list(call, (await request) as $6.NetListProposals);
  }

  $async.Future<$6.NetProposal> get_Pre(
      ServiceCall call, $async.Future request) async {
    return get(call, await request);
  }

  $async.Stream<$6.NetProposalChat> listChats_Pre(
      ServiceCall call, $async.Future request) async* {
    yield* listChats(call, (await request) as $6.NetListChats);
  }

  $async.Future<$6.NetProposal> apply(
      ServiceCall call, $6.NetApplyProposal request);
  $async.Future<$6.NetProposal> direct(
      ServiceCall call, $6.NetDirectProposal request);
  $async.Stream<$6.NetProposal> list(
      ServiceCall call, $6.NetListProposals request);
  $async.Future<$6.NetProposal> get(
      ServiceCall call, $6.NetGetProposal request);
  $async.Stream<$6.NetProposalChat> listChats(
      ServiceCall call, $6.NetListChats request);
}
