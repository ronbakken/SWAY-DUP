///
//  Generated code. Do not modify.
//  source: api_proposals.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'net_proposal_protobuf.pb.dart' as $6;
export 'api_proposals.pb.dart';

class ApiProposalsClient extends $grpc.Client {
  static final _$apply =
      $grpc.ClientMethod<$6.NetApplyProposal, $6.NetProposal>(
          '/inf.ApiProposals/Apply',
          ($6.NetApplyProposal value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $6.NetProposal.fromBuffer(value));
  static final _$direct =
      $grpc.ClientMethod<$6.NetDirectProposal, $6.NetProposal>(
          '/inf.ApiProposals/Direct',
          ($6.NetDirectProposal value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $6.NetProposal.fromBuffer(value));
  static final _$list = $grpc.ClientMethod<$6.NetListProposals, $6.NetProposal>(
      '/inf.ApiProposals/List',
      ($6.NetListProposals value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $6.NetProposal.fromBuffer(value));
  static final _$get = $grpc.ClientMethod<$6.NetGetProposal, $6.NetProposal>(
      '/inf.ApiProposals/Get',
      ($6.NetGetProposal value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $6.NetProposal.fromBuffer(value));
  static final _$listChats =
      $grpc.ClientMethod<$6.NetListChats, $6.NetProposalChat>(
          '/inf.ApiProposals/ListChats',
          ($6.NetListChats value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $6.NetProposalChat.fromBuffer(value));

  ApiProposalsClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$6.NetProposal> apply($6.NetApplyProposal request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$apply, request, options: options);
  }

  $grpc.ResponseFuture<$6.NetProposal> direct($6.NetDirectProposal request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$direct, request, options: options);
  }

  $grpc.ResponseStream<$6.NetProposal> list($6.NetListProposals request,
      {$grpc.CallOptions options}) {
    return $createStreamingCall(_$list, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$6.NetProposal> get($6.NetGetProposal request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$get, request, options: options);
  }

  $grpc.ResponseStream<$6.NetProposalChat> listChats($6.NetListChats request,
      {$grpc.CallOptions options}) {
    return $createStreamingCall(
        _$listChats, $async.Stream.fromIterable([request]),
        options: options);
  }
}

abstract class ApiProposalsServiceBase extends $grpc.Service {
  $core.String get $name => 'inf.ApiProposals';

  ApiProposalsServiceBase() {
    $addMethod($grpc.ServiceMethod<$6.NetApplyProposal, $6.NetProposal>(
        'Apply',
        apply_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.NetApplyProposal.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.NetDirectProposal, $6.NetProposal>(
        'Direct',
        direct_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.NetDirectProposal.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.NetListProposals, $6.NetProposal>(
        'List',
        list_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $6.NetListProposals.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.NetGetProposal, $6.NetProposal>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.NetGetProposal.fromBuffer(value),
        ($6.NetProposal value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.NetListChats, $6.NetProposalChat>(
        'ListChats',
        listChats_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $6.NetListChats.fromBuffer(value),
        ($6.NetProposalChat value) => value.writeToBuffer()));
  }

  $async.Future<$6.NetProposal> apply_Pre($grpc.ServiceCall call,
      $async.Future<$6.NetApplyProposal> request) async {
    return apply(call, await request);
  }

  $async.Future<$6.NetProposal> direct_Pre($grpc.ServiceCall call,
      $async.Future<$6.NetDirectProposal> request) async {
    return direct(call, await request);
  }

  $async.Stream<$6.NetProposal> list_Pre($grpc.ServiceCall call,
      $async.Future<$6.NetListProposals> request) async* {
    yield* list(call, await request);
  }

  $async.Future<$6.NetProposal> get_Pre(
      $grpc.ServiceCall call, $async.Future<$6.NetGetProposal> request) async {
    return get(call, await request);
  }

  $async.Stream<$6.NetProposalChat> listChats_Pre(
      $grpc.ServiceCall call, $async.Future<$6.NetListChats> request) async* {
    yield* listChats(call, await request);
  }

  $async.Future<$6.NetProposal> apply(
      $grpc.ServiceCall call, $6.NetApplyProposal request);
  $async.Future<$6.NetProposal> direct(
      $grpc.ServiceCall call, $6.NetDirectProposal request);
  $async.Stream<$6.NetProposal> list(
      $grpc.ServiceCall call, $6.NetListProposals request);
  $async.Future<$6.NetProposal> get(
      $grpc.ServiceCall call, $6.NetGetProposal request);
  $async.Stream<$6.NetProposalChat> listChats(
      $grpc.ServiceCall call, $6.NetListChats request);
}
