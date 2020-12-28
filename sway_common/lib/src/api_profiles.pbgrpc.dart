///
//  Generated code. Do not modify.
//  source: api_profiles.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'net_profile_protobuf.pb.dart' as $5;
export 'api_profiles.pb.dart';

class ApiProfilesClient extends $grpc.Client {
  static final _$get = $grpc.ClientMethod<$5.NetGetProfile, $5.NetProfile>(
      '/inf.ApiProfiles/Get',
      ($5.NetGetProfile value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $5.NetProfile.fromBuffer(value));

  ApiProfilesClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$5.NetProfile> get($5.NetGetProfile request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$get, request, options: options);
  }
}

abstract class ApiProfilesServiceBase extends $grpc.Service {
  $core.String get $name => 'inf.ApiProfiles';

  ApiProfilesServiceBase() {
    $addMethod($grpc.ServiceMethod<$5.NetGetProfile, $5.NetProfile>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.NetGetProfile.fromBuffer(value),
        ($5.NetProfile value) => value.writeToBuffer()));
  }

  $async.Future<$5.NetProfile> get_Pre(
      $grpc.ServiceCall call, $async.Future<$5.NetGetProfile> request) async {
    return get(call, await request);
  }

  $async.Future<$5.NetProfile> get(
      $grpc.ServiceCall call, $5.NetGetProfile request);
}
