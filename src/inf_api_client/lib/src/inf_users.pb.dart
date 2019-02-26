///
//  Generated code. Do not modify.
//  source: inf_users.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'user.pb.dart' as $10;

class GetUserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetUserRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'userId')
    ..hasRequiredFields = false
  ;

  GetUserRequest() : super();
  GetUserRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetUserRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetUserRequest clone() => new GetUserRequest()..mergeFromMessage(this);
  GetUserRequest copyWith(void Function(GetUserRequest) updates) => super.copyWith((message) => updates(message as GetUserRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetUserRequest create() => new GetUserRequest();
  GetUserRequest createEmptyInstance() => create();
  static $pb.PbList<GetUserRequest> createRepeated() => new $pb.PbList<GetUserRequest>();
  static GetUserRequest getDefault() => _defaultInstance ??= create()..freeze();
  static GetUserRequest _defaultInstance;
  static void $checkItem(GetUserRequest v) {
    if (v is! GetUserRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get userId => $_getS(0, '');
  set userId(String v) { $_setString(0, v); }
  bool hasUserId() => $_has(0);
  void clearUserId() => clearField(1);
}

class GetUserResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetUserResponse', package: const $pb.PackageName('api'))
    ..a<$10.UserDto>(1, 'user', $pb.PbFieldType.OM, $10.UserDto.getDefault, $10.UserDto.create)
    ..hasRequiredFields = false
  ;

  GetUserResponse() : super();
  GetUserResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetUserResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetUserResponse clone() => new GetUserResponse()..mergeFromMessage(this);
  GetUserResponse copyWith(void Function(GetUserResponse) updates) => super.copyWith((message) => updates(message as GetUserResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetUserResponse create() => new GetUserResponse();
  GetUserResponse createEmptyInstance() => create();
  static $pb.PbList<GetUserResponse> createRepeated() => new $pb.PbList<GetUserResponse>();
  static GetUserResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetUserResponse _defaultInstance;
  static void $checkItem(GetUserResponse v) {
    if (v is! GetUserResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $10.UserDto get user => $_getN(0);
  set user($10.UserDto v) { setField(1, v); }
  bool hasUser() => $_has(0);
  void clearUser() => clearField(1);
}

class UpdateUserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateUserRequest', package: const $pb.PackageName('api'))
    ..a<$10.UserDto>(1, 'user', $pb.PbFieldType.OM, $10.UserDto.getDefault, $10.UserDto.create)
    ..hasRequiredFields = false
  ;

  UpdateUserRequest() : super();
  UpdateUserRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateUserRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateUserRequest clone() => new UpdateUserRequest()..mergeFromMessage(this);
  UpdateUserRequest copyWith(void Function(UpdateUserRequest) updates) => super.copyWith((message) => updates(message as UpdateUserRequest));
  $pb.BuilderInfo get info_ => _i;
  static UpdateUserRequest create() => new UpdateUserRequest();
  UpdateUserRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateUserRequest> createRepeated() => new $pb.PbList<UpdateUserRequest>();
  static UpdateUserRequest getDefault() => _defaultInstance ??= create()..freeze();
  static UpdateUserRequest _defaultInstance;
  static void $checkItem(UpdateUserRequest v) {
    if (v is! UpdateUserRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $10.UserDto get user => $_getN(0);
  set user($10.UserDto v) { setField(1, v); }
  bool hasUser() => $_has(0);
  void clearUser() => clearField(1);
}

class UpdateUserResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateUserResponse', package: const $pb.PackageName('api'))
    ..a<$10.UserDto>(1, 'user', $pb.PbFieldType.OM, $10.UserDto.getDefault, $10.UserDto.create)
    ..hasRequiredFields = false
  ;

  UpdateUserResponse() : super();
  UpdateUserResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateUserResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateUserResponse clone() => new UpdateUserResponse()..mergeFromMessage(this);
  UpdateUserResponse copyWith(void Function(UpdateUserResponse) updates) => super.copyWith((message) => updates(message as UpdateUserResponse));
  $pb.BuilderInfo get info_ => _i;
  static UpdateUserResponse create() => new UpdateUserResponse();
  UpdateUserResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateUserResponse> createRepeated() => new $pb.PbList<UpdateUserResponse>();
  static UpdateUserResponse getDefault() => _defaultInstance ??= create()..freeze();
  static UpdateUserResponse _defaultInstance;
  static void $checkItem(UpdateUserResponse v) {
    if (v is! UpdateUserResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $10.UserDto get user => $_getN(0);
  set user($10.UserDto v) { setField(1, v); }
  bool hasUser() => $_has(0);
  void clearUser() => clearField(1);
}

