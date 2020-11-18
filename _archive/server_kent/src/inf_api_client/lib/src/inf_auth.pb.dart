///
//  Generated code. Do not modify.
//  source: inf_auth.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'user.pb.dart' as $5;

import 'user.pbenum.dart' as $5;

class SendLoginEmailRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SendLoginEmailRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'email')
    ..e<$5.UserType>(2, 'userType', $pb.PbFieldType.OE, $5.UserType.unknownType, $5.UserType.valueOf, $5.UserType.values)
    ..aOS(3, 'invitationCode')
    ..hasRequiredFields = false
  ;

  SendLoginEmailRequest() : super();
  SendLoginEmailRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SendLoginEmailRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SendLoginEmailRequest clone() => SendLoginEmailRequest()..mergeFromMessage(this);
  SendLoginEmailRequest copyWith(void Function(SendLoginEmailRequest) updates) => super.copyWith((message) => updates(message as SendLoginEmailRequest));
  $pb.BuilderInfo get info_ => _i;
  static SendLoginEmailRequest create() => SendLoginEmailRequest();
  SendLoginEmailRequest createEmptyInstance() => create();
  static $pb.PbList<SendLoginEmailRequest> createRepeated() => $pb.PbList<SendLoginEmailRequest>();
  static SendLoginEmailRequest getDefault() => _defaultInstance ??= create()..freeze();
  static SendLoginEmailRequest _defaultInstance;

  $core.String get email => $_getS(0, '');
  set email($core.String v) { $_setString(0, v); }
  $core.bool hasEmail() => $_has(0);
  void clearEmail() => clearField(1);

  $5.UserType get userType => $_getN(1);
  set userType($5.UserType v) { setField(2, v); }
  $core.bool hasUserType() => $_has(1);
  void clearUserType() => clearField(2);

  $core.String get invitationCode => $_getS(2, '');
  set invitationCode($core.String v) { $_setString(2, v); }
  $core.bool hasInvitationCode() => $_has(2);
  void clearInvitationCode() => clearField(3);
}

class ActivateUserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ActivateUserRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'loginToken')
    ..a<$5.UserDto>(2, 'user', $pb.PbFieldType.OM, $5.UserDto.getDefault, $5.UserDto.create)
    ..hasRequiredFields = false
  ;

  ActivateUserRequest() : super();
  ActivateUserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ActivateUserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ActivateUserRequest clone() => ActivateUserRequest()..mergeFromMessage(this);
  ActivateUserRequest copyWith(void Function(ActivateUserRequest) updates) => super.copyWith((message) => updates(message as ActivateUserRequest));
  $pb.BuilderInfo get info_ => _i;
  static ActivateUserRequest create() => ActivateUserRequest();
  ActivateUserRequest createEmptyInstance() => create();
  static $pb.PbList<ActivateUserRequest> createRepeated() => $pb.PbList<ActivateUserRequest>();
  static ActivateUserRequest getDefault() => _defaultInstance ??= create()..freeze();
  static ActivateUserRequest _defaultInstance;

  $core.String get loginToken => $_getS(0, '');
  set loginToken($core.String v) { $_setString(0, v); }
  $core.bool hasLoginToken() => $_has(0);
  void clearLoginToken() => clearField(1);

  $5.UserDto get user => $_getN(1);
  set user($5.UserDto v) { setField(2, v); }
  $core.bool hasUser() => $_has(1);
  void clearUser() => clearField(2);
}

class ActivateUserResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ActivateUserResponse', package: const $pb.PackageName('api'))
    ..a<$5.UserDto>(2, 'user', $pb.PbFieldType.OM, $5.UserDto.getDefault, $5.UserDto.create)
    ..hasRequiredFields = false
  ;

  ActivateUserResponse() : super();
  ActivateUserResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ActivateUserResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ActivateUserResponse clone() => ActivateUserResponse()..mergeFromMessage(this);
  ActivateUserResponse copyWith(void Function(ActivateUserResponse) updates) => super.copyWith((message) => updates(message as ActivateUserResponse));
  $pb.BuilderInfo get info_ => _i;
  static ActivateUserResponse create() => ActivateUserResponse();
  ActivateUserResponse createEmptyInstance() => create();
  static $pb.PbList<ActivateUserResponse> createRepeated() => $pb.PbList<ActivateUserResponse>();
  static ActivateUserResponse getDefault() => _defaultInstance ??= create()..freeze();
  static ActivateUserResponse _defaultInstance;

  $5.UserDto get user => $_getN(0);
  set user($5.UserDto v) { setField(2, v); }
  $core.bool hasUser() => $_has(0);
  void clearUser() => clearField(2);
}

class LoginWithLoginTokenRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('LoginWithLoginTokenRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'loginToken')
    ..hasRequiredFields = false
  ;

  LoginWithLoginTokenRequest() : super();
  LoginWithLoginTokenRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LoginWithLoginTokenRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LoginWithLoginTokenRequest clone() => LoginWithLoginTokenRequest()..mergeFromMessage(this);
  LoginWithLoginTokenRequest copyWith(void Function(LoginWithLoginTokenRequest) updates) => super.copyWith((message) => updates(message as LoginWithLoginTokenRequest));
  $pb.BuilderInfo get info_ => _i;
  static LoginWithLoginTokenRequest create() => LoginWithLoginTokenRequest();
  LoginWithLoginTokenRequest createEmptyInstance() => create();
  static $pb.PbList<LoginWithLoginTokenRequest> createRepeated() => $pb.PbList<LoginWithLoginTokenRequest>();
  static LoginWithLoginTokenRequest getDefault() => _defaultInstance ??= create()..freeze();
  static LoginWithLoginTokenRequest _defaultInstance;

  $core.String get loginToken => $_getS(0, '');
  set loginToken($core.String v) { $_setString(0, v); }
  $core.bool hasLoginToken() => $_has(0);
  void clearLoginToken() => clearField(1);
}

class LoginWithLoginTokenResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('LoginWithLoginTokenResponse', package: const $pb.PackageName('api'))
    ..aOS(1, 'refreshToken')
    ..a<$5.UserDto>(2, 'user', $pb.PbFieldType.OM, $5.UserDto.getDefault, $5.UserDto.create)
    ..hasRequiredFields = false
  ;

  LoginWithLoginTokenResponse() : super();
  LoginWithLoginTokenResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LoginWithLoginTokenResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LoginWithLoginTokenResponse clone() => LoginWithLoginTokenResponse()..mergeFromMessage(this);
  LoginWithLoginTokenResponse copyWith(void Function(LoginWithLoginTokenResponse) updates) => super.copyWith((message) => updates(message as LoginWithLoginTokenResponse));
  $pb.BuilderInfo get info_ => _i;
  static LoginWithLoginTokenResponse create() => LoginWithLoginTokenResponse();
  LoginWithLoginTokenResponse createEmptyInstance() => create();
  static $pb.PbList<LoginWithLoginTokenResponse> createRepeated() => $pb.PbList<LoginWithLoginTokenResponse>();
  static LoginWithLoginTokenResponse getDefault() => _defaultInstance ??= create()..freeze();
  static LoginWithLoginTokenResponse _defaultInstance;

  $core.String get refreshToken => $_getS(0, '');
  set refreshToken($core.String v) { $_setString(0, v); }
  $core.bool hasRefreshToken() => $_has(0);
  void clearRefreshToken() => clearField(1);

  $5.UserDto get user => $_getN(1);
  set user($5.UserDto v) { setField(2, v); }
  $core.bool hasUser() => $_has(1);
  void clearUser() => clearField(2);
}

class GetAccessTokenRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetAccessTokenRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'refreshToken')
    ..hasRequiredFields = false
  ;

  GetAccessTokenRequest() : super();
  GetAccessTokenRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetAccessTokenRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetAccessTokenRequest clone() => GetAccessTokenRequest()..mergeFromMessage(this);
  GetAccessTokenRequest copyWith(void Function(GetAccessTokenRequest) updates) => super.copyWith((message) => updates(message as GetAccessTokenRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetAccessTokenRequest create() => GetAccessTokenRequest();
  GetAccessTokenRequest createEmptyInstance() => create();
  static $pb.PbList<GetAccessTokenRequest> createRepeated() => $pb.PbList<GetAccessTokenRequest>();
  static GetAccessTokenRequest getDefault() => _defaultInstance ??= create()..freeze();
  static GetAccessTokenRequest _defaultInstance;

  $core.String get refreshToken => $_getS(0, '');
  set refreshToken($core.String v) { $_setString(0, v); }
  $core.bool hasRefreshToken() => $_has(0);
  void clearRefreshToken() => clearField(1);
}

class GetAccessTokenResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetAccessTokenResponse', package: const $pb.PackageName('api'))
    ..aOS(1, 'accessToken')
    ..hasRequiredFields = false
  ;

  GetAccessTokenResponse() : super();
  GetAccessTokenResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetAccessTokenResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetAccessTokenResponse clone() => GetAccessTokenResponse()..mergeFromMessage(this);
  GetAccessTokenResponse copyWith(void Function(GetAccessTokenResponse) updates) => super.copyWith((message) => updates(message as GetAccessTokenResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetAccessTokenResponse create() => GetAccessTokenResponse();
  GetAccessTokenResponse createEmptyInstance() => create();
  static $pb.PbList<GetAccessTokenResponse> createRepeated() => $pb.PbList<GetAccessTokenResponse>();
  static GetAccessTokenResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetAccessTokenResponse _defaultInstance;

  $core.String get accessToken => $_getS(0, '');
  set accessToken($core.String v) { $_setString(0, v); }
  $core.bool hasAccessToken() => $_has(0);
  void clearAccessToken() => clearField(1);
}

class LoginWithRefreshTokenRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('LoginWithRefreshTokenRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'refreshToken')
    ..hasRequiredFields = false
  ;

  LoginWithRefreshTokenRequest() : super();
  LoginWithRefreshTokenRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LoginWithRefreshTokenRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LoginWithRefreshTokenRequest clone() => LoginWithRefreshTokenRequest()..mergeFromMessage(this);
  LoginWithRefreshTokenRequest copyWith(void Function(LoginWithRefreshTokenRequest) updates) => super.copyWith((message) => updates(message as LoginWithRefreshTokenRequest));
  $pb.BuilderInfo get info_ => _i;
  static LoginWithRefreshTokenRequest create() => LoginWithRefreshTokenRequest();
  LoginWithRefreshTokenRequest createEmptyInstance() => create();
  static $pb.PbList<LoginWithRefreshTokenRequest> createRepeated() => $pb.PbList<LoginWithRefreshTokenRequest>();
  static LoginWithRefreshTokenRequest getDefault() => _defaultInstance ??= create()..freeze();
  static LoginWithRefreshTokenRequest _defaultInstance;

  $core.String get refreshToken => $_getS(0, '');
  set refreshToken($core.String v) { $_setString(0, v); }
  $core.bool hasRefreshToken() => $_has(0);
  void clearRefreshToken() => clearField(1);
}

class LoginWithRefreshTokenResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('LoginWithRefreshTokenResponse', package: const $pb.PackageName('api'))
    ..aOS(1, 'accessToken')
    ..a<$5.UserDto>(2, 'user', $pb.PbFieldType.OM, $5.UserDto.getDefault, $5.UserDto.create)
    ..hasRequiredFields = false
  ;

  LoginWithRefreshTokenResponse() : super();
  LoginWithRefreshTokenResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LoginWithRefreshTokenResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LoginWithRefreshTokenResponse clone() => LoginWithRefreshTokenResponse()..mergeFromMessage(this);
  LoginWithRefreshTokenResponse copyWith(void Function(LoginWithRefreshTokenResponse) updates) => super.copyWith((message) => updates(message as LoginWithRefreshTokenResponse));
  $pb.BuilderInfo get info_ => _i;
  static LoginWithRefreshTokenResponse create() => LoginWithRefreshTokenResponse();
  LoginWithRefreshTokenResponse createEmptyInstance() => create();
  static $pb.PbList<LoginWithRefreshTokenResponse> createRepeated() => $pb.PbList<LoginWithRefreshTokenResponse>();
  static LoginWithRefreshTokenResponse getDefault() => _defaultInstance ??= create()..freeze();
  static LoginWithRefreshTokenResponse _defaultInstance;

  $core.String get accessToken => $_getS(0, '');
  set accessToken($core.String v) { $_setString(0, v); }
  $core.bool hasAccessToken() => $_has(0);
  void clearAccessToken() => clearField(1);

  $5.UserDto get user => $_getN(1);
  set user($5.UserDto v) { setField(2, v); }
  $core.bool hasUser() => $_has(1);
  void clearUser() => clearField(2);
}

class LogoutRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('LogoutRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'refreshToken')
    ..hasRequiredFields = false
  ;

  LogoutRequest() : super();
  LogoutRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LogoutRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LogoutRequest clone() => LogoutRequest()..mergeFromMessage(this);
  LogoutRequest copyWith(void Function(LogoutRequest) updates) => super.copyWith((message) => updates(message as LogoutRequest));
  $pb.BuilderInfo get info_ => _i;
  static LogoutRequest create() => LogoutRequest();
  LogoutRequest createEmptyInstance() => create();
  static $pb.PbList<LogoutRequest> createRepeated() => $pb.PbList<LogoutRequest>();
  static LogoutRequest getDefault() => _defaultInstance ??= create()..freeze();
  static LogoutRequest _defaultInstance;

  $core.String get refreshToken => $_getS(0, '');
  set refreshToken($core.String v) { $_setString(0, v); }
  $core.bool hasRefreshToken() => $_has(0);
  void clearRefreshToken() => clearField(1);
}

