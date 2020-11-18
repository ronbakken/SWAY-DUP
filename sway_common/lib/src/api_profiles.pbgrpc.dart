///
//  Generated code. Do not modify.
//  source: api_profiles.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'net_profile_protobuf.pb.dart' as $5;
export 'api_profiles.pb.dart';

class ApiProfilesClient extends Client {
  static final _$get = new ClientMethod<$5.NetGetProfile, $5.NetProfile>(
      '/inf.ApiProfiles/Get',
      ($5.NetGetProfile value) => value.writeToBuffer(),
      (List<int> value) => new $5.NetProfile.fromBuffer(value));

  ApiProfilesClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<$5.NetProfile> get($5.NetGetProfile request,
      {CallOptions options}) {
    final call = $createCall(_$get, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class ApiProfilesServiceBase extends Service {
  String get $name => 'inf.ApiProfiles';

  ApiProfilesServiceBase() {
    $addMethod(new ServiceMethod<$5.NetGetProfile, $5.NetProfile>(
        'Get',
        get_Pre,
        false,
        false,
        (List<int> value) => new $5.NetGetProfile.fromBuffer(value),
        ($5.NetProfile value) => value.writeToBuffer()));
  }

  $async.Future<$5.NetProfile> get_Pre(
      ServiceCall call, $async.Future request) async {
    return get(call, await request);
  }

  $async.Future<$5.NetProfile> get(ServiceCall call, $5.NetGetProfile request);
}
