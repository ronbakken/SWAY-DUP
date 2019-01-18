///
//  Generated code. Do not modify.
//  source: inf_auth.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'user.pb.dart' as $1;
import 'social_media_account.pb.dart' as $3;

import 'inf_auth.pbenum.dart';

export 'inf_auth.pbenum.dart';

class LoginEmailRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('LoginEmailRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'email')
    ..hasRequiredFields = false
  ;

  LoginEmailRequest() : super();
  LoginEmailRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LoginEmailRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LoginEmailRequest clone() => new LoginEmailRequest()..mergeFromMessage(this);
  LoginEmailRequest copyWith(void Function(LoginEmailRequest) updates) => super.copyWith((message) => updates(message as LoginEmailRequest));
  $pb.BuilderInfo get info_ => _i;
  static LoginEmailRequest create() => new LoginEmailRequest();
  LoginEmailRequest createEmptyInstance() => create();
  static $pb.PbList<LoginEmailRequest> createRepeated() => new $pb.PbList<LoginEmailRequest>();
  static LoginEmailRequest getDefault() => _defaultInstance ??= create()..freeze();
  static LoginEmailRequest _defaultInstance;
  static void $checkItem(LoginEmailRequest v) {
    if (v is! LoginEmailRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get email => $_getS(0, '');
  set email(String v) { $_setString(0, v); }
  bool hasEmail() => $_has(0);
  void clearEmail() => clearField(1);
}

class RefreshTokenRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RefreshTokenRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'oneTimeToken')
    ..hasRequiredFields = false
  ;

  RefreshTokenRequest() : super();
  RefreshTokenRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RefreshTokenRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RefreshTokenRequest clone() => new RefreshTokenRequest()..mergeFromMessage(this);
  RefreshTokenRequest copyWith(void Function(RefreshTokenRequest) updates) => super.copyWith((message) => updates(message as RefreshTokenRequest));
  $pb.BuilderInfo get info_ => _i;
  static RefreshTokenRequest create() => new RefreshTokenRequest();
  RefreshTokenRequest createEmptyInstance() => create();
  static $pb.PbList<RefreshTokenRequest> createRepeated() => new $pb.PbList<RefreshTokenRequest>();
  static RefreshTokenRequest getDefault() => _defaultInstance ??= create()..freeze();
  static RefreshTokenRequest _defaultInstance;
  static void $checkItem(RefreshTokenRequest v) {
    if (v is! RefreshTokenRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get oneTimeToken => $_getS(0, '');
  set oneTimeToken(String v) { $_setString(0, v); }
  bool hasOneTimeToken() => $_has(0);
  void clearOneTimeToken() => clearField(1);
}

class RefreshTokenMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RefreshTokenMessage', package: const $pb.PackageName('api'))
    ..aOS(1, 'refreshToken')
    ..hasRequiredFields = false
  ;

  RefreshTokenMessage() : super();
  RefreshTokenMessage.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RefreshTokenMessage.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RefreshTokenMessage clone() => new RefreshTokenMessage()..mergeFromMessage(this);
  RefreshTokenMessage copyWith(void Function(RefreshTokenMessage) updates) => super.copyWith((message) => updates(message as RefreshTokenMessage));
  $pb.BuilderInfo get info_ => _i;
  static RefreshTokenMessage create() => new RefreshTokenMessage();
  RefreshTokenMessage createEmptyInstance() => create();
  static $pb.PbList<RefreshTokenMessage> createRepeated() => new $pb.PbList<RefreshTokenMessage>();
  static RefreshTokenMessage getDefault() => _defaultInstance ??= create()..freeze();
  static RefreshTokenMessage _defaultInstance;
  static void $checkItem(RefreshTokenMessage v) {
    if (v is! RefreshTokenMessage) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get refreshToken => $_getS(0, '');
  set refreshToken(String v) { $_setString(0, v); }
  bool hasRefreshToken() => $_has(0);
  void clearRefreshToken() => clearField(1);
}

class LoginResultMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('LoginResultMessage', package: const $pb.PackageName('api'))
    ..aOS(1, 'authorizationToken')
    ..a<$1.User>(2, 'userData', $pb.PbFieldType.OM, $1.User.getDefault, $1.User.create)
    ..hasRequiredFields = false
  ;

  LoginResultMessage() : super();
  LoginResultMessage.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LoginResultMessage.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LoginResultMessage clone() => new LoginResultMessage()..mergeFromMessage(this);
  LoginResultMessage copyWith(void Function(LoginResultMessage) updates) => super.copyWith((message) => updates(message as LoginResultMessage));
  $pb.BuilderInfo get info_ => _i;
  static LoginResultMessage create() => new LoginResultMessage();
  LoginResultMessage createEmptyInstance() => create();
  static $pb.PbList<LoginResultMessage> createRepeated() => new $pb.PbList<LoginResultMessage>();
  static LoginResultMessage getDefault() => _defaultInstance ??= create()..freeze();
  static LoginResultMessage _defaultInstance;
  static void $checkItem(LoginResultMessage v) {
    if (v is! LoginResultMessage) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get authorizationToken => $_getS(0, '');
  set authorizationToken(String v) { $_setString(0, v); }
  bool hasAuthorizationToken() => $_has(0);
  void clearAuthorizationToken() => clearField(1);

  $1.User get userData => $_getN(1);
  set userData($1.User v) { setField(2, v); }
  bool hasUserData() => $_has(1);
  void clearUserData() => clearField(2);
}

class InvitationCode extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('InvitationCode', package: const $pb.PackageName('api'))
    ..aOS(1, 'code')
    ..hasRequiredFields = false
  ;

  InvitationCode() : super();
  InvitationCode.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  InvitationCode.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  InvitationCode clone() => new InvitationCode()..mergeFromMessage(this);
  InvitationCode copyWith(void Function(InvitationCode) updates) => super.copyWith((message) => updates(message as InvitationCode));
  $pb.BuilderInfo get info_ => _i;
  static InvitationCode create() => new InvitationCode();
  InvitationCode createEmptyInstance() => create();
  static $pb.PbList<InvitationCode> createRepeated() => new $pb.PbList<InvitationCode>();
  static InvitationCode getDefault() => _defaultInstance ??= create()..freeze();
  static InvitationCode _defaultInstance;
  static void $checkItem(InvitationCode v) {
    if (v is! InvitationCode) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get code => $_getS(0, '');
  set code(String v) { $_setString(0, v); }
  bool hasCode() => $_has(0);
  void clearCode() => clearField(1);
}

class InvitationCodeState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('InvitationCodeState', package: const $pb.PackageName('api'))
    ..e<InvitationCodeStates>(1, 'state', $pb.PbFieldType.OE, InvitationCodeStates.valid, InvitationCodeStates.valueOf, InvitationCodeStates.values)
    ..hasRequiredFields = false
  ;

  InvitationCodeState() : super();
  InvitationCodeState.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  InvitationCodeState.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  InvitationCodeState clone() => new InvitationCodeState()..mergeFromMessage(this);
  InvitationCodeState copyWith(void Function(InvitationCodeState) updates) => super.copyWith((message) => updates(message as InvitationCodeState));
  $pb.BuilderInfo get info_ => _i;
  static InvitationCodeState create() => new InvitationCodeState();
  InvitationCodeState createEmptyInstance() => create();
  static $pb.PbList<InvitationCodeState> createRepeated() => new $pb.PbList<InvitationCodeState>();
  static InvitationCodeState getDefault() => _defaultInstance ??= create()..freeze();
  static InvitationCodeState _defaultInstance;
  static void $checkItem(InvitationCodeState v) {
    if (v is! InvitationCodeState) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  InvitationCodeStates get state => $_getN(0);
  set state(InvitationCodeStates v) { setField(1, v); }
  bool hasState() => $_has(0);
  void clearState() => clearField(1);
}

class CreateNewUserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CreateNewUserRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'oneTimeToken')
    ..a<$1.User>(2, 'userData', $pb.PbFieldType.OM, $1.User.getDefault, $1.User.create)
    ..aOS(3, 'deviceID')
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

  String get oneTimeToken => $_getS(0, '');
  set oneTimeToken(String v) { $_setString(0, v); }
  bool hasOneTimeToken() => $_has(0);
  void clearOneTimeToken() => clearField(1);

  $1.User get userData => $_getN(1);
  set userData($1.User v) { setField(2, v); }
  bool hasUserData() => $_has(1);
  void clearUserData() => clearField(2);

  String get deviceID => $_getS(2, '');
  set deviceID(String v) { $_setString(2, v); }
  bool hasDeviceID() => $_has(2);
  void clearDeviceID() => clearField(3);
}

class SocialMediaRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SocialMediaRequest', package: const $pb.PackageName('api'))
    ..a<int>(1, 'userId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  SocialMediaRequest() : super();
  SocialMediaRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SocialMediaRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SocialMediaRequest clone() => new SocialMediaRequest()..mergeFromMessage(this);
  SocialMediaRequest copyWith(void Function(SocialMediaRequest) updates) => super.copyWith((message) => updates(message as SocialMediaRequest));
  $pb.BuilderInfo get info_ => _i;
  static SocialMediaRequest create() => new SocialMediaRequest();
  SocialMediaRequest createEmptyInstance() => create();
  static $pb.PbList<SocialMediaRequest> createRepeated() => new $pb.PbList<SocialMediaRequest>();
  static SocialMediaRequest getDefault() => _defaultInstance ??= create()..freeze();
  static SocialMediaRequest _defaultInstance;
  static void $checkItem(SocialMediaRequest v) {
    if (v is! SocialMediaRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get userId => $_get(0, 0);
  set userId(int v) { $_setSignedInt32(0, v); }
  bool hasUserId() => $_has(0);
  void clearUserId() => clearField(1);
}

class SocialMediaAccounts extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SocialMediaAccounts', package: const $pb.PackageName('api'))
    ..a<int>(1, 'userId', $pb.PbFieldType.O3)
    ..pp<$3.SocialMediaAccount>(2, 'accounts', $pb.PbFieldType.PM, $3.SocialMediaAccount.$checkItem, $3.SocialMediaAccount.create)
    ..hasRequiredFields = false
  ;

  SocialMediaAccounts() : super();
  SocialMediaAccounts.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SocialMediaAccounts.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SocialMediaAccounts clone() => new SocialMediaAccounts()..mergeFromMessage(this);
  SocialMediaAccounts copyWith(void Function(SocialMediaAccounts) updates) => super.copyWith((message) => updates(message as SocialMediaAccounts));
  $pb.BuilderInfo get info_ => _i;
  static SocialMediaAccounts create() => new SocialMediaAccounts();
  SocialMediaAccounts createEmptyInstance() => create();
  static $pb.PbList<SocialMediaAccounts> createRepeated() => new $pb.PbList<SocialMediaAccounts>();
  static SocialMediaAccounts getDefault() => _defaultInstance ??= create()..freeze();
  static SocialMediaAccounts _defaultInstance;
  static void $checkItem(SocialMediaAccounts v) {
    if (v is! SocialMediaAccounts) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get userId => $_get(0, 0);
  set userId(int v) { $_setSignedInt32(0, v); }
  bool hasUserId() => $_has(0);
  void clearUserId() => clearField(1);

  List<$3.SocialMediaAccount> get accounts => $_getList(1);
}

class UpdateUserRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateUserRequest', package: const $pb.PackageName('api'))
    ..a<$1.User>(1, 'user', $pb.PbFieldType.OM, $1.User.getDefault, $1.User.create)
    ..pp<$3.SocialMediaAccount>(2, 'socialMediaAccountsToAdd', $pb.PbFieldType.PM, $3.SocialMediaAccount.$checkItem, $3.SocialMediaAccount.create)
    ..pp<$3.SocialMediaAccount>(3, 'socialMediaAccountsToRemove', $pb.PbFieldType.PM, $3.SocialMediaAccount.$checkItem, $3.SocialMediaAccount.create)
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

  $1.User get user => $_getN(0);
  set user($1.User v) { setField(1, v); }
  bool hasUser() => $_has(0);
  void clearUser() => clearField(1);

  List<$3.SocialMediaAccount> get socialMediaAccountsToAdd => $_getList(1);

  List<$3.SocialMediaAccount> get socialMediaAccountsToRemove => $_getList(2);
}

