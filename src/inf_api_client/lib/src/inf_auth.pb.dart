///
//  Generated code. Do not modify.
//  source: inf_auth.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'user.pb.dart' as $5;

import 'user.pbenum.dart' as $5;

class SendLoginEmailRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SendLoginEmailRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'email')
    ..e<$5.UserType>(2, 'userType', $pb.PbFieldType.OE, $5.UserType.unknownUserType, $5.UserType.valueOf, $5.UserType.values)
    ..aOS(3, 'invitationCode')
    ..hasRequiredFields = false
  ;

  SendLoginEmailRequest() : super();
  SendLoginEmailRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SendLoginEmailRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SendLoginEmailRequest clone() => new SendLoginEmailRequest()..mergeFromMessage(this);
  SendLoginEmailRequest copyWith(void Function(SendLoginEmailRequest) updates) => super.copyWith((message) => updates(message as SendLoginEmailRequest));
  $pb.BuilderInfo get info_ => _i;
  static SendLoginEmailRequest create() => new SendLoginEmailRequest();
  SendLoginEmailRequest createEmptyInstance() => create();
  static $pb.PbList<SendLoginEmailRequest> createRepeated() => new $pb.PbList<SendLoginEmailRequest>();
  static SendLoginEmailRequest getDefault() => _defaultInstance ??= create()..freeze();
  static SendLoginEmailRequest _defaultInstance;
  static void $checkItem(SendLoginEmailRequest v) {
    if (v is! SendLoginEmailRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get email => $_getS(0, '');
  set email(String v) { $_setString(0, v); }
  bool hasEmail() => $_has(0);
  void clearEmail() => clearField(1);

  $5.UserType get userType => $_getN(1);
  set userType($5.UserType v) { setField(2, v); }
  bool hasUserType() => $_has(1);
  void clearUserType() => clearField(2);

  String get invitationCode => $_getS(2, '');
  set invitationCode(String v) { $_setString(2, v); }
  bool hasInvitationCode() => $_has(2);
  void clearInvitationCode() => clearField(3);
}

class CreateNewUserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CreateNewUserRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'loginToken')
    ..a<$5.UserDto>(2, 'userData', $pb.PbFieldType.OM, $5.UserDto.getDefault, $5.UserDto.create)
    ..aOS(3, 'deviceId')
    ..hasRequiredFields = false
  ;

  CreateNewUserRequest() : super();
  CreateNewUserRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateNewUserRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateNewUserRequest clone() => new CreateNewUserRequest()..mergeFromMessage(this);
  CreateNewUserRequest copyWith(void Function(CreateNewUserRequest) updates) => super.copyWith((message) => updates(message as CreateNewUserRequest));
  $pb.BuilderInfo get info_ => _i;
  static CreateNewUserRequest create() => new CreateNewUserRequest();
  CreateNewUserRequest createEmptyInstance() => create();
  static $pb.PbList<CreateNewUserRequest> createRepeated() => new $pb.PbList<CreateNewUserRequest>();
  static CreateNewUserRequest getDefault() => _defaultInstance ??= create()..freeze();
  static CreateNewUserRequest _defaultInstance;
  static void $checkItem(CreateNewUserRequest v) {
    if (v is! CreateNewUserRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get loginToken => $_getS(0, '');
  set loginToken(String v) { $_setString(0, v); }
  bool hasLoginToken() => $_has(0);
  void clearLoginToken() => clearField(1);

  $5.UserDto get userData => $_getN(1);
  set userData($5.UserDto v) { setField(2, v); }
  bool hasUserData() => $_has(1);
  void clearUserData() => clearField(2);

  String get deviceId => $_getS(2, '');
  set deviceId(String v) { $_setString(2, v); }
  bool hasDeviceId() => $_has(2);
  void clearDeviceId() => clearField(3);
}

class CreateNewUserResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CreateNewUserResponse', package: const $pb.PackageName('api'))
    ..aOS(1, 'refreshToken')
    ..a<$5.UserDto>(2, 'userData', $pb.PbFieldType.OM, $5.UserDto.getDefault, $5.UserDto.create)
    ..hasRequiredFields = false
  ;

  CreateNewUserResponse() : super();
  CreateNewUserResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateNewUserResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateNewUserResponse clone() => new CreateNewUserResponse()..mergeFromMessage(this);
  CreateNewUserResponse copyWith(void Function(CreateNewUserResponse) updates) => super.copyWith((message) => updates(message as CreateNewUserResponse));
  $pb.BuilderInfo get info_ => _i;
  static CreateNewUserResponse create() => new CreateNewUserResponse();
  CreateNewUserResponse createEmptyInstance() => create();
  static $pb.PbList<CreateNewUserResponse> createRepeated() => new $pb.PbList<CreateNewUserResponse>();
  static CreateNewUserResponse getDefault() => _defaultInstance ??= create()..freeze();
  static CreateNewUserResponse _defaultInstance;
  static void $checkItem(CreateNewUserResponse v) {
    if (v is! CreateNewUserResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get refreshToken => $_getS(0, '');
  set refreshToken(String v) { $_setString(0, v); }
  bool hasRefreshToken() => $_has(0);
  void clearRefreshToken() => clearField(1);

  $5.UserDto get userData => $_getN(1);
  set userData($5.UserDto v) { setField(2, v); }
  bool hasUserData() => $_has(1);
  void clearUserData() => clearField(2);
}

class LoginWithLoginTokenRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('LoginWithLoginTokenRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'loginToken')
    ..hasRequiredFields = false
  ;

  LoginWithLoginTokenRequest() : super();
  LoginWithLoginTokenRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LoginWithLoginTokenRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LoginWithLoginTokenRequest clone() => new LoginWithLoginTokenRequest()..mergeFromMessage(this);
  LoginWithLoginTokenRequest copyWith(void Function(LoginWithLoginTokenRequest) updates) => super.copyWith((message) => updates(message as LoginWithLoginTokenRequest));
  $pb.BuilderInfo get info_ => _i;
  static LoginWithLoginTokenRequest create() => new LoginWithLoginTokenRequest();
  LoginWithLoginTokenRequest createEmptyInstance() => create();
  static $pb.PbList<LoginWithLoginTokenRequest> createRepeated() => new $pb.PbList<LoginWithLoginTokenRequest>();
  static LoginWithLoginTokenRequest getDefault() => _defaultInstance ??= create()..freeze();
  static LoginWithLoginTokenRequest _defaultInstance;
  static void $checkItem(LoginWithLoginTokenRequest v) {
    if (v is! LoginWithLoginTokenRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get loginToken => $_getS(0, '');
  set loginToken(String v) { $_setString(0, v); }
  bool hasLoginToken() => $_has(0);
  void clearLoginToken() => clearField(1);
}

class LoginWithLoginTokenResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('LoginWithLoginTokenResponse', package: const $pb.PackageName('api'))
    ..aOS(1, 'refreshToken')
    ..a<$5.UserDto>(2, 'userData', $pb.PbFieldType.OM, $5.UserDto.getDefault, $5.UserDto.create)
    ..hasRequiredFields = false
  ;

  LoginWithLoginTokenResponse() : super();
  LoginWithLoginTokenResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LoginWithLoginTokenResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LoginWithLoginTokenResponse clone() => new LoginWithLoginTokenResponse()..mergeFromMessage(this);
  LoginWithLoginTokenResponse copyWith(void Function(LoginWithLoginTokenResponse) updates) => super.copyWith((message) => updates(message as LoginWithLoginTokenResponse));
  $pb.BuilderInfo get info_ => _i;
  static LoginWithLoginTokenResponse create() => new LoginWithLoginTokenResponse();
  LoginWithLoginTokenResponse createEmptyInstance() => create();
  static $pb.PbList<LoginWithLoginTokenResponse> createRepeated() => new $pb.PbList<LoginWithLoginTokenResponse>();
  static LoginWithLoginTokenResponse getDefault() => _defaultInstance ??= create()..freeze();
  static LoginWithLoginTokenResponse _defaultInstance;
  static void $checkItem(LoginWithLoginTokenResponse v) {
    if (v is! LoginWithLoginTokenResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get refreshToken => $_getS(0, '');
  set refreshToken(String v) { $_setString(0, v); }
  bool hasRefreshToken() => $_has(0);
  void clearRefreshToken() => clearField(1);

  $5.UserDto get userData => $_getN(1);
  set userData($5.UserDto v) { setField(2, v); }
  bool hasUserData() => $_has(1);
  void clearUserData() => clearField(2);
}

class GetAccessTokenRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetAccessTokenRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'refreshToken')
    ..hasRequiredFields = false
  ;

  GetAccessTokenRequest() : super();
  GetAccessTokenRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetAccessTokenRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetAccessTokenRequest clone() => new GetAccessTokenRequest()..mergeFromMessage(this);
  GetAccessTokenRequest copyWith(void Function(GetAccessTokenRequest) updates) => super.copyWith((message) => updates(message as GetAccessTokenRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetAccessTokenRequest create() => new GetAccessTokenRequest();
  GetAccessTokenRequest createEmptyInstance() => create();
  static $pb.PbList<GetAccessTokenRequest> createRepeated() => new $pb.PbList<GetAccessTokenRequest>();
  static GetAccessTokenRequest getDefault() => _defaultInstance ??= create()..freeze();
  static GetAccessTokenRequest _defaultInstance;
  static void $checkItem(GetAccessTokenRequest v) {
    if (v is! GetAccessTokenRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get refreshToken => $_getS(0, '');
  set refreshToken(String v) { $_setString(0, v); }
  bool hasRefreshToken() => $_has(0);
  void clearRefreshToken() => clearField(1);
}

class GetAccessTokenResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetAccessTokenResponse', package: const $pb.PackageName('api'))
    ..aOS(1, 'accessToken')
    ..hasRequiredFields = false
  ;

  GetAccessTokenResponse() : super();
  GetAccessTokenResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetAccessTokenResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetAccessTokenResponse clone() => new GetAccessTokenResponse()..mergeFromMessage(this);
  GetAccessTokenResponse copyWith(void Function(GetAccessTokenResponse) updates) => super.copyWith((message) => updates(message as GetAccessTokenResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetAccessTokenResponse create() => new GetAccessTokenResponse();
  GetAccessTokenResponse createEmptyInstance() => create();
  static $pb.PbList<GetAccessTokenResponse> createRepeated() => new $pb.PbList<GetAccessTokenResponse>();
  static GetAccessTokenResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetAccessTokenResponse _defaultInstance;
  static void $checkItem(GetAccessTokenResponse v) {
    if (v is! GetAccessTokenResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get accessToken => $_getS(0, '');
  set accessToken(String v) { $_setString(0, v); }
  bool hasAccessToken() => $_has(0);
  void clearAccessToken() => clearField(1);
}

class LoginWithRefreshTokenRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('LoginWithRefreshTokenRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'refreshToken')
    ..hasRequiredFields = false
  ;

  LoginWithRefreshTokenRequest() : super();
  LoginWithRefreshTokenRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LoginWithRefreshTokenRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LoginWithRefreshTokenRequest clone() => new LoginWithRefreshTokenRequest()..mergeFromMessage(this);
  LoginWithRefreshTokenRequest copyWith(void Function(LoginWithRefreshTokenRequest) updates) => super.copyWith((message) => updates(message as LoginWithRefreshTokenRequest));
  $pb.BuilderInfo get info_ => _i;
  static LoginWithRefreshTokenRequest create() => new LoginWithRefreshTokenRequest();
  LoginWithRefreshTokenRequest createEmptyInstance() => create();
  static $pb.PbList<LoginWithRefreshTokenRequest> createRepeated() => new $pb.PbList<LoginWithRefreshTokenRequest>();
  static LoginWithRefreshTokenRequest getDefault() => _defaultInstance ??= create()..freeze();
  static LoginWithRefreshTokenRequest _defaultInstance;
  static void $checkItem(LoginWithRefreshTokenRequest v) {
    if (v is! LoginWithRefreshTokenRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get refreshToken => $_getS(0, '');
  set refreshToken(String v) { $_setString(0, v); }
  bool hasRefreshToken() => $_has(0);
  void clearRefreshToken() => clearField(1);
}

class LoginWithRefreshTokenResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('LoginWithRefreshTokenResponse', package: const $pb.PackageName('api'))
    ..aOS(1, 'accessToken')
    ..a<$5.UserDto>(2, 'userData', $pb.PbFieldType.OM, $5.UserDto.getDefault, $5.UserDto.create)
    ..hasRequiredFields = false
  ;

  LoginWithRefreshTokenResponse() : super();
  LoginWithRefreshTokenResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LoginWithRefreshTokenResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LoginWithRefreshTokenResponse clone() => new LoginWithRefreshTokenResponse()..mergeFromMessage(this);
  LoginWithRefreshTokenResponse copyWith(void Function(LoginWithRefreshTokenResponse) updates) => super.copyWith((message) => updates(message as LoginWithRefreshTokenResponse));
  $pb.BuilderInfo get info_ => _i;
  static LoginWithRefreshTokenResponse create() => new LoginWithRefreshTokenResponse();
  LoginWithRefreshTokenResponse createEmptyInstance() => create();
  static $pb.PbList<LoginWithRefreshTokenResponse> createRepeated() => new $pb.PbList<LoginWithRefreshTokenResponse>();
  static LoginWithRefreshTokenResponse getDefault() => _defaultInstance ??= create()..freeze();
  static LoginWithRefreshTokenResponse _defaultInstance;
  static void $checkItem(LoginWithRefreshTokenResponse v) {
    if (v is! LoginWithRefreshTokenResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get accessToken => $_getS(0, '');
  set accessToken(String v) { $_setString(0, v); }
  bool hasAccessToken() => $_has(0);
  void clearAccessToken() => clearField(1);

  $5.UserDto get userData => $_getN(1);
  set userData($5.UserDto v) { setField(2, v); }
  bool hasUserData() => $_has(1);
  void clearUserData() => clearField(2);
}

class LogoutRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('LogoutRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'refreshToken')
    ..hasRequiredFields = false
  ;

  LogoutRequest() : super();
  LogoutRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LogoutRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LogoutRequest clone() => new LogoutRequest()..mergeFromMessage(this);
  LogoutRequest copyWith(void Function(LogoutRequest) updates) => super.copyWith((message) => updates(message as LogoutRequest));
  $pb.BuilderInfo get info_ => _i;
  static LogoutRequest create() => new LogoutRequest();
  LogoutRequest createEmptyInstance() => create();
  static $pb.PbList<LogoutRequest> createRepeated() => new $pb.PbList<LogoutRequest>();
  static LogoutRequest getDefault() => _defaultInstance ??= create()..freeze();
  static LogoutRequest _defaultInstance;
  static void $checkItem(LogoutRequest v) {
    if (v is! LogoutRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get refreshToken => $_getS(0, '');
  set refreshToken(String v) { $_setString(0, v); }
  bool hasRefreshToken() => $_has(0);
  void clearRefreshToken() => clearField(1);
}

