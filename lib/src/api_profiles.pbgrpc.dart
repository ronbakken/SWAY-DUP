///
//  Generated code. Do not modify.
//  source: api_profiles.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'net_profile_protobuf.pb.dart' as $4;
export 'api_profiles.pb.dart';

class ApiProfilesClient extends Client {
  static final _$get = new ClientMethod<$4.NetGetProfile, $4.NetProfile>(
      '/inf_common.ApiProfiles/Get',
      ($4.NetGetProfile value) => value.writeToBuffer(),
      (List<int> value) => new $4.NetProfile.fromBuffer(value));

  ApiProfilesClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<$4.NetProfile> get($4.NetGetProfile request,
      {CallOptions options}) {
    final call = $createCall(_$get, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class ApiProfilesServiceBase extends Service {
  String get $name => 'inf_common.ApiProfiles';

  ApiProfilesServiceBase() {
    $addMethod(new ServiceMethod<$4.NetGetProfile, $4.NetProfile>(
        'Get',
        get_Pre,
        false,
        false,
        (List<int> value) => new $4.NetGetProfile.fromBuffer(value),
        ($4.NetProfile value) => value.writeToBuffer()));
  }

  $async.Future<$4.NetProfile> get_Pre(
      ServiceCall call, $async.Future request) async {
    return get(call, await request);
  }

  $async.Future<$4.NetProfile> get(ServiceCall call, $4.NetGetProfile request);
}
