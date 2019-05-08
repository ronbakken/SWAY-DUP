///
//  Generated code. Do not modify.
//  source: inf_users.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'user.pb.dart' as $5;

class GetUserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetUserRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'userId')
    ..hasRequiredFields = false
  ;

  GetUserRequest() : super();
  GetUserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetUserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetUserRequest clone() => GetUserRequest()..mergeFromMessage(this);
  GetUserRequest copyWith(void Function(GetUserRequest) updates) => super.copyWith((message) => updates(message as GetUserRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetUserRequest create() => GetUserRequest();
  GetUserRequest createEmptyInstance() => create();
  static $pb.PbList<GetUserRequest> createRepeated() => $pb.PbList<GetUserRequest>();
  static GetUserRequest getDefault() => _defaultInstance ??= create()..freeze();
  static GetUserRequest _defaultInstance;

  $core.String get userId => $_getS(0, '');
  set userId($core.String v) { $_setString(0, v); }
  $core.bool hasUserId() => $_has(0);
  void clearUserId() => clearField(1);
}

class GetUserResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetUserResponse', package: const $pb.PackageName('api'))
    ..a<$5.UserDto>(1, 'user', $pb.PbFieldType.OM, $5.UserDto.getDefault, $5.UserDto.create)
    ..hasRequiredFields = false
  ;

  GetUserResponse() : super();
  GetUserResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetUserResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetUserResponse clone() => GetUserResponse()..mergeFromMessage(this);
  GetUserResponse copyWith(void Function(GetUserResponse) updates) => super.copyWith((message) => updates(message as GetUserResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetUserResponse create() => GetUserResponse();
  GetUserResponse createEmptyInstance() => create();
  static $pb.PbList<GetUserResponse> createRepeated() => $pb.PbList<GetUserResponse>();
  static GetUserResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetUserResponse _defaultInstance;

  $5.UserDto get user => $_getN(0);
  set user($5.UserDto v) { setField(1, v); }
  $core.bool hasUser() => $_has(0);
  void clearUser() => clearField(1);
}

class UpdateUserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UpdateUserRequest', package: const $pb.PackageName('api'))
    ..a<$5.UserDto>(1, 'user', $pb.PbFieldType.OM, $5.UserDto.getDefault, $5.UserDto.create)
    ..hasRequiredFields = false
  ;

  UpdateUserRequest() : super();
  UpdateUserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateUserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateUserRequest clone() => UpdateUserRequest()..mergeFromMessage(this);
  UpdateUserRequest copyWith(void Function(UpdateUserRequest) updates) => super.copyWith((message) => updates(message as UpdateUserRequest));
  $pb.BuilderInfo get info_ => _i;
  static UpdateUserRequest create() => UpdateUserRequest();
  UpdateUserRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateUserRequest> createRepeated() => $pb.PbList<UpdateUserRequest>();
  static UpdateUserRequest getDefault() => _defaultInstance ??= create()..freeze();
  static UpdateUserRequest _defaultInstance;

  $5.UserDto get user => $_getN(0);
  set user($5.UserDto v) { setField(1, v); }
  $core.bool hasUser() => $_has(0);
  void clearUser() => clearField(1);
}

class UpdateUserResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UpdateUserResponse', package: const $pb.PackageName('api'))
    ..a<$5.UserDto>(1, 'user', $pb.PbFieldType.OM, $5.UserDto.getDefault, $5.UserDto.create)
    ..hasRequiredFields = false
  ;

  UpdateUserResponse() : super();
  UpdateUserResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateUserResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateUserResponse clone() => UpdateUserResponse()..mergeFromMessage(this);
  UpdateUserResponse copyWith(void Function(UpdateUserResponse) updates) => super.copyWith((message) => updates(message as UpdateUserResponse));
  $pb.BuilderInfo get info_ => _i;
  static UpdateUserResponse create() => UpdateUserResponse();
  UpdateUserResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateUserResponse> createRepeated() => $pb.PbList<UpdateUserResponse>();
  static UpdateUserResponse getDefault() => _defaultInstance ??= create()..freeze();
  static UpdateUserResponse _defaultInstance;

  $5.UserDto get user => $_getN(0);
  set user($5.UserDto v) { setField(1, v); }
  $core.bool hasUser() => $_has(0);
  void clearUser() => clearField(1);
}

