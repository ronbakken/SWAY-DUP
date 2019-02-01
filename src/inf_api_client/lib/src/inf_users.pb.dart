///
//  Generated code. Do not modify.
//  source: inf_users.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'user.pb.dart' as $4;
import 'location.pb.dart' as $1;

import 'user.pbenum.dart' as $4;

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
    ..a<$4.UserDto>(1, 'userData', $pb.PbFieldType.OM, $4.UserDto.getDefault, $4.UserDto.create)
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

  $4.UserDto get userData => $_getN(0);
  set userData($4.UserDto v) { setField(1, v); }
  bool hasUserData() => $_has(0);
  void clearUserData() => clearField(1);
}

class UpdateUserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateUserRequest', package: const $pb.PackageName('api'))
    ..a<$4.UserDto>(1, 'user', $pb.PbFieldType.OM, $4.UserDto.getDefault, $4.UserDto.create)
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

  $4.UserDto get user => $_getN(0);
  set user($4.UserDto v) { setField(1, v); }
  bool hasUser() => $_has(0);
  void clearUser() => clearField(1);
}

class UpdateUserResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateUserResponse', package: const $pb.PackageName('api'))
    ..a<$4.UserDto>(1, 'user', $pb.PbFieldType.OM, $4.UserDto.getDefault, $4.UserDto.create)
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

  $4.UserDto get user => $_getN(0);
  set user($4.UserDto v) { setField(1, v); }
  bool hasUser() => $_has(0);
  void clearUser() => clearField(1);
}

class SearchUsersRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SearchUsersRequest', package: const $pb.PackageName('api'))
    ..pp<$4.UserType>(1, 'userTypes', $pb.PbFieldType.PE, $4.UserType.$checkItem, null, $4.UserType.valueOf, $4.UserType.values)
    ..p<int>(2, 'categories', $pb.PbFieldType.P3)
    ..p<int>(3, 'socialMediaNetworkIds', $pb.PbFieldType.P3)
    ..a<$1.LocationDto>(4, 'location', $pb.PbFieldType.OM, $1.LocationDto.getDefault, $1.LocationDto.create)
    ..a<double>(5, 'locationDistanceKms', $pb.PbFieldType.OD)
    ..a<int>(6, 'minimumValue', $pb.PbFieldType.O3)
    ..aOS(7, 'phrase')
    ..hasRequiredFields = false
  ;

  SearchUsersRequest() : super();
  SearchUsersRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SearchUsersRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SearchUsersRequest clone() => new SearchUsersRequest()..mergeFromMessage(this);
  SearchUsersRequest copyWith(void Function(SearchUsersRequest) updates) => super.copyWith((message) => updates(message as SearchUsersRequest));
  $pb.BuilderInfo get info_ => _i;
  static SearchUsersRequest create() => new SearchUsersRequest();
  SearchUsersRequest createEmptyInstance() => create();
  static $pb.PbList<SearchUsersRequest> createRepeated() => new $pb.PbList<SearchUsersRequest>();
  static SearchUsersRequest getDefault() => _defaultInstance ??= create()..freeze();
  static SearchUsersRequest _defaultInstance;
  static void $checkItem(SearchUsersRequest v) {
    if (v is! SearchUsersRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<$4.UserType> get userTypes => $_getList(0);

  List<int> get categories => $_getList(1);

  List<int> get socialMediaNetworkIds => $_getList(2);

  $1.LocationDto get location => $_getN(3);
  set location($1.LocationDto v) { setField(4, v); }
  bool hasLocation() => $_has(3);
  void clearLocation() => clearField(4);

  double get locationDistanceKms => $_getN(4);
  set locationDistanceKms(double v) { $_setDouble(4, v); }
  bool hasLocationDistanceKms() => $_has(4);
  void clearLocationDistanceKms() => clearField(5);

  int get minimumValue => $_get(5, 0);
  set minimumValue(int v) { $_setSignedInt32(5, v); }
  bool hasMinimumValue() => $_has(5);
  void clearMinimumValue() => clearField(6);

  String get phrase => $_getS(6, '');
  set phrase(String v) { $_setString(6, v); }
  bool hasPhrase() => $_has(6);
  void clearPhrase() => clearField(7);
}

class SearchUsersResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SearchUsersResponse', package: const $pb.PackageName('api'))
    ..pp<$4.UserDto>(1, 'results', $pb.PbFieldType.PM, $4.UserDto.$checkItem, $4.UserDto.create)
    ..hasRequiredFields = false
  ;

  SearchUsersResponse() : super();
  SearchUsersResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SearchUsersResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SearchUsersResponse clone() => new SearchUsersResponse()..mergeFromMessage(this);
  SearchUsersResponse copyWith(void Function(SearchUsersResponse) updates) => super.copyWith((message) => updates(message as SearchUsersResponse));
  $pb.BuilderInfo get info_ => _i;
  static SearchUsersResponse create() => new SearchUsersResponse();
  SearchUsersResponse createEmptyInstance() => create();
  static $pb.PbList<SearchUsersResponse> createRepeated() => new $pb.PbList<SearchUsersResponse>();
  static SearchUsersResponse getDefault() => _defaultInstance ??= create()..freeze();
  static SearchUsersResponse _defaultInstance;
  static void $checkItem(SearchUsersResponse v) {
    if (v is! SearchUsersResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<$4.UserDto> get results => $_getList(0);
}

