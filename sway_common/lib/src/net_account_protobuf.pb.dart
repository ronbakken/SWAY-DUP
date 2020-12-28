///
//  Generated code. Do not modify.
//  source: net_account_protobuf.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $13;

import 'enum_protobuf.pbenum.dart' as $12;

class NetAccount extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetAccount',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<$13.DataAccount>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'account',
        subBuilder: $13.DataAccount.create)
    ..hasRequiredFields = false;

  NetAccount._() : super();
  factory NetAccount() => create();
  factory NetAccount.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetAccount.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetAccount clone() => NetAccount()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetAccount copyWith(void Function(NetAccount) updates) =>
      super.copyWith((message) =>
          updates(message as NetAccount)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetAccount create() => NetAccount._();
  NetAccount createEmptyInstance() => create();
  static $pb.PbList<NetAccount> createRepeated() => $pb.PbList<NetAccount>();
  @$core.pragma('dart2js:noInline')
  static NetAccount getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetAccount>(create);
  static NetAccount _defaultInstance;

  @$pb.TagNumber(1)
  $13.DataAccount get account => $_getN(0);
  @$pb.TagNumber(1)
  set account($13.DataAccount v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => clearField(1);
  @$pb.TagNumber(1)
  $13.DataAccount ensureAccount() => $_ensure(0);
}

class NetSetAccountType extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetSetAccountType',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..e<$12.AccountType>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'accountType',
        $pb.PbFieldType.OE,
        defaultOrMaker: $12.AccountType.unknown,
        valueOf: $12.AccountType.valueOf,
        enumValues: $12.AccountType.values)
    ..hasRequiredFields = false;

  NetSetAccountType._() : super();
  factory NetSetAccountType() => create();
  factory NetSetAccountType.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetSetAccountType.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetSetAccountType clone() => NetSetAccountType()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetSetAccountType copyWith(void Function(NetSetAccountType) updates) =>
      super.copyWith((message) => updates(
          message as NetSetAccountType)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetSetAccountType create() => NetSetAccountType._();
  NetSetAccountType createEmptyInstance() => create();
  static $pb.PbList<NetSetAccountType> createRepeated() =>
      $pb.PbList<NetSetAccountType>();
  @$core.pragma('dart2js:noInline')
  static NetSetAccountType getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetSetAccountType>(create);
  static NetSetAccountType _defaultInstance;

  @$pb.TagNumber(1)
  $12.AccountType get accountType => $_getN(0);
  @$pb.TagNumber(1)
  set accountType($12.AccountType v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAccountType() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountType() => clearField(1);
}

class NetSetFirebaseToken extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetSetFirebaseToken',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'firebaseToken')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'oldFirebaseToken')
    ..hasRequiredFields = false;

  NetSetFirebaseToken._() : super();
  factory NetSetFirebaseToken() => create();
  factory NetSetFirebaseToken.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetSetFirebaseToken.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetSetFirebaseToken clone() => NetSetFirebaseToken()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetSetFirebaseToken copyWith(void Function(NetSetFirebaseToken) updates) =>
      super.copyWith((message) => updates(
          message as NetSetFirebaseToken)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetSetFirebaseToken create() => NetSetFirebaseToken._();
  NetSetFirebaseToken createEmptyInstance() => create();
  static $pb.PbList<NetSetFirebaseToken> createRepeated() =>
      $pb.PbList<NetSetFirebaseToken>();
  @$core.pragma('dart2js:noInline')
  static NetSetFirebaseToken getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetSetFirebaseToken>(create);
  static NetSetFirebaseToken _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get firebaseToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set firebaseToken($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasFirebaseToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearFirebaseToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get oldFirebaseToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set oldFirebaseToken($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasOldFirebaseToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearOldFirebaseToken() => clearField(2);
}

class NetOAuthGetUrl extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetOAuthGetUrl',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'oauthProvider',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetOAuthGetUrl._() : super();
  factory NetOAuthGetUrl() => create();
  factory NetOAuthGetUrl.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetOAuthGetUrl.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetOAuthGetUrl clone() => NetOAuthGetUrl()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetOAuthGetUrl copyWith(void Function(NetOAuthGetUrl) updates) =>
      super.copyWith((message) =>
          updates(message as NetOAuthGetUrl)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetOAuthGetUrl create() => NetOAuthGetUrl._();
  NetOAuthGetUrl createEmptyInstance() => create();
  static $pb.PbList<NetOAuthGetUrl> createRepeated() =>
      $pb.PbList<NetOAuthGetUrl>();
  @$core.pragma('dart2js:noInline')
  static NetOAuthGetUrl getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetOAuthGetUrl>(create);
  static NetOAuthGetUrl _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get oauthProvider => $_getIZ(0);
  @$pb.TagNumber(1)
  set oauthProvider($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOauthProvider() => $_has(0);
  @$pb.TagNumber(1)
  void clearOauthProvider() => clearField(1);
}

class NetOAuthUrl extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetOAuthUrl',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'authUrl')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'callbackUrl')
    ..hasRequiredFields = false;

  NetOAuthUrl._() : super();
  factory NetOAuthUrl() => create();
  factory NetOAuthUrl.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetOAuthUrl.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetOAuthUrl clone() => NetOAuthUrl()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetOAuthUrl copyWith(void Function(NetOAuthUrl) updates) =>
      super.copyWith((message) =>
          updates(message as NetOAuthUrl)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetOAuthUrl create() => NetOAuthUrl._();
  NetOAuthUrl createEmptyInstance() => create();
  static $pb.PbList<NetOAuthUrl> createRepeated() => $pb.PbList<NetOAuthUrl>();
  @$core.pragma('dart2js:noInline')
  static NetOAuthUrl getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetOAuthUrl>(create);
  static NetOAuthUrl _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get authUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set authUrl($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAuthUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthUrl() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get callbackUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set callbackUrl($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCallbackUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearCallbackUrl() => clearField(2);
}

class NetOAuthGetSecrets extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetOAuthGetSecrets',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'oauthProvider',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetOAuthGetSecrets._() : super();
  factory NetOAuthGetSecrets() => create();
  factory NetOAuthGetSecrets.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetOAuthGetSecrets.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetOAuthGetSecrets clone() => NetOAuthGetSecrets()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetOAuthGetSecrets copyWith(void Function(NetOAuthGetSecrets) updates) =>
      super.copyWith((message) => updates(
          message as NetOAuthGetSecrets)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetOAuthGetSecrets create() => NetOAuthGetSecrets._();
  NetOAuthGetSecrets createEmptyInstance() => create();
  static $pb.PbList<NetOAuthGetSecrets> createRepeated() =>
      $pb.PbList<NetOAuthGetSecrets>();
  @$core.pragma('dart2js:noInline')
  static NetOAuthGetSecrets getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetOAuthGetSecrets>(create);
  static NetOAuthGetSecrets _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get oauthProvider => $_getIZ(0);
  @$pb.TagNumber(1)
  set oauthProvider($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOauthProvider() => $_has(0);
  @$pb.TagNumber(1)
  void clearOauthProvider() => clearField(1);
}

class NetOAuthSecrets extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetOAuthSecrets',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOS(
        10,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'consumerKey')
    ..aOS(
        11,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'consumerSecret')
    ..aOS(
        12,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'clientId')
    ..hasRequiredFields = false;

  NetOAuthSecrets._() : super();
  factory NetOAuthSecrets() => create();
  factory NetOAuthSecrets.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetOAuthSecrets.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetOAuthSecrets clone() => NetOAuthSecrets()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetOAuthSecrets copyWith(void Function(NetOAuthSecrets) updates) =>
      super.copyWith((message) =>
          updates(message as NetOAuthSecrets)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetOAuthSecrets create() => NetOAuthSecrets._();
  NetOAuthSecrets createEmptyInstance() => create();
  static $pb.PbList<NetOAuthSecrets> createRepeated() =>
      $pb.PbList<NetOAuthSecrets>();
  @$core.pragma('dart2js:noInline')
  static NetOAuthSecrets getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetOAuthSecrets>(create);
  static NetOAuthSecrets _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get consumerKey => $_getSZ(0);
  @$pb.TagNumber(10)
  set consumerKey($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasConsumerKey() => $_has(0);
  @$pb.TagNumber(10)
  void clearConsumerKey() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get consumerSecret => $_getSZ(1);
  @$pb.TagNumber(11)
  set consumerSecret($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasConsumerSecret() => $_has(1);
  @$pb.TagNumber(11)
  void clearConsumerSecret() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get clientId => $_getSZ(2);
  @$pb.TagNumber(12)
  set clientId($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasClientId() => $_has(2);
  @$pb.TagNumber(12)
  void clearClientId() => clearField(12);
}

class NetOAuthConnect extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetOAuthConnect',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'oauthProvider',
        $pb.PbFieldType.O3)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'callbackQuery')
    ..hasRequiredFields = false;

  NetOAuthConnect._() : super();
  factory NetOAuthConnect() => create();
  factory NetOAuthConnect.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetOAuthConnect.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetOAuthConnect clone() => NetOAuthConnect()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetOAuthConnect copyWith(void Function(NetOAuthConnect) updates) =>
      super.copyWith((message) =>
          updates(message as NetOAuthConnect)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetOAuthConnect create() => NetOAuthConnect._();
  NetOAuthConnect createEmptyInstance() => create();
  static $pb.PbList<NetOAuthConnect> createRepeated() =>
      $pb.PbList<NetOAuthConnect>();
  @$core.pragma('dart2js:noInline')
  static NetOAuthConnect getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetOAuthConnect>(create);
  static NetOAuthConnect _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get oauthProvider => $_getIZ(0);
  @$pb.TagNumber(1)
  set oauthProvider($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOauthProvider() => $_has(0);
  @$pb.TagNumber(1)
  void clearOauthProvider() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get callbackQuery => $_getSZ(1);
  @$pb.TagNumber(2)
  set callbackQuery($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCallbackQuery() => $_has(1);
  @$pb.TagNumber(2)
  void clearCallbackQuery() => clearField(2);
}

class NetOAuthConnection extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetOAuthConnection',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<$13.DataSocialMedia>(
        1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'socialMedia',
        subBuilder: $13.DataSocialMedia.create)
    ..aOM<$13.DataAccount>(2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'account',
        subBuilder: $13.DataAccount.create)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accessToken')
    ..hasRequiredFields = false;

  NetOAuthConnection._() : super();
  factory NetOAuthConnection() => create();
  factory NetOAuthConnection.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetOAuthConnection.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetOAuthConnection clone() => NetOAuthConnection()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetOAuthConnection copyWith(void Function(NetOAuthConnection) updates) =>
      super.copyWith((message) => updates(
          message as NetOAuthConnection)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetOAuthConnection create() => NetOAuthConnection._();
  NetOAuthConnection createEmptyInstance() => create();
  static $pb.PbList<NetOAuthConnection> createRepeated() =>
      $pb.PbList<NetOAuthConnection>();
  @$core.pragma('dart2js:noInline')
  static NetOAuthConnection getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetOAuthConnection>(create);
  static NetOAuthConnection _defaultInstance;

  @$pb.TagNumber(1)
  $13.DataSocialMedia get socialMedia => $_getN(0);
  @$pb.TagNumber(1)
  set socialMedia($13.DataSocialMedia v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSocialMedia() => $_has(0);
  @$pb.TagNumber(1)
  void clearSocialMedia() => clearField(1);
  @$pb.TagNumber(1)
  $13.DataSocialMedia ensureSocialMedia() => $_ensure(0);

  @$pb.TagNumber(2)
  $13.DataAccount get account => $_getN(1);
  @$pb.TagNumber(2)
  set account($13.DataAccount v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasAccount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccount() => clearField(2);
  @$pb.TagNumber(2)
  $13.DataAccount ensureAccount() => $_ensure(1);

  @$pb.TagNumber(4)
  $core.String get accessToken => $_getSZ(2);
  @$pb.TagNumber(4)
  set accessToken($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasAccessToken() => $_has(2);
  @$pb.TagNumber(4)
  void clearAccessToken() => clearField(4);
}

class NetAccountCreate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetAccountCreate',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..a<$core.double>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'latitude',
        $pb.PbFieldType.OD)
    ..a<$core.double>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'longitude',
        $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  NetAccountCreate._() : super();
  factory NetAccountCreate() => create();
  factory NetAccountCreate.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetAccountCreate.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetAccountCreate clone() => NetAccountCreate()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetAccountCreate copyWith(void Function(NetAccountCreate) updates) =>
      super.copyWith((message) => updates(
          message as NetAccountCreate)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetAccountCreate create() => NetAccountCreate._();
  NetAccountCreate createEmptyInstance() => create();
  static $pb.PbList<NetAccountCreate> createRepeated() =>
      $pb.PbList<NetAccountCreate>();
  @$core.pragma('dart2js:noInline')
  static NetAccountCreate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetAccountCreate>(create);
  static NetAccountCreate _defaultInstance;

  @$pb.TagNumber(2)
  $core.double get latitude => $_getN(0);
  @$pb.TagNumber(2)
  set latitude($core.double v) {
    $_setDouble(0, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLatitude() => $_has(0);
  @$pb.TagNumber(2)
  void clearLatitude() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get longitude => $_getN(1);
  @$pb.TagNumber(3)
  set longitude($core.double v) {
    $_setDouble(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasLongitude() => $_has(1);
  @$pb.TagNumber(3)
  void clearLongitude() => clearField(3);
}

class NetAccountApplyPromo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetAccountApplyPromo',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'code')
    ..hasRequiredFields = false;

  NetAccountApplyPromo._() : super();
  factory NetAccountApplyPromo() => create();
  factory NetAccountApplyPromo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetAccountApplyPromo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetAccountApplyPromo clone() =>
      NetAccountApplyPromo()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetAccountApplyPromo copyWith(void Function(NetAccountApplyPromo) updates) =>
      super.copyWith((message) => updates(
          message as NetAccountApplyPromo)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetAccountApplyPromo create() => NetAccountApplyPromo._();
  NetAccountApplyPromo createEmptyInstance() => create();
  static $pb.PbList<NetAccountApplyPromo> createRepeated() =>
      $pb.PbList<NetAccountApplyPromo>();
  @$core.pragma('dart2js:noInline')
  static NetAccountApplyPromo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetAccountApplyPromo>(create);
  static NetAccountApplyPromo _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);
}

class NetAccountPromo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetAccountPromo',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<$13.DataAccount>(1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'account',
        subBuilder: $13.DataAccount.create)
    ..aOB(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'expired')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'used')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'applied')
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'quantity', $pb.PbFieldType.O3)
    ..e<$12.PromoCode>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: $12.PromoCode.unknown, valueOf: $12.PromoCode.valueOf, enumValues: $12.PromoCode.values)
    ..hasRequiredFields = false;

  NetAccountPromo._() : super();
  factory NetAccountPromo() => create();
  factory NetAccountPromo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetAccountPromo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetAccountPromo clone() => NetAccountPromo()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetAccountPromo copyWith(void Function(NetAccountPromo) updates) =>
      super.copyWith((message) =>
          updates(message as NetAccountPromo)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetAccountPromo create() => NetAccountPromo._();
  NetAccountPromo createEmptyInstance() => create();
  static $pb.PbList<NetAccountPromo> createRepeated() =>
      $pb.PbList<NetAccountPromo>();
  @$core.pragma('dart2js:noInline')
  static NetAccountPromo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetAccountPromo>(create);
  static NetAccountPromo _defaultInstance;

  @$pb.TagNumber(1)
  $13.DataAccount get account => $_getN(0);
  @$pb.TagNumber(1)
  set account($13.DataAccount v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => clearField(1);
  @$pb.TagNumber(1)
  $13.DataAccount ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get expired => $_getBF(1);
  @$pb.TagNumber(2)
  set expired($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasExpired() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpired() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get used => $_getBF(2);
  @$pb.TagNumber(3)
  set used($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasUsed() => $_has(2);
  @$pb.TagNumber(3)
  void clearUsed() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get applied => $_getBF(3);
  @$pb.TagNumber(4)
  set applied($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasApplied() => $_has(3);
  @$pb.TagNumber(4)
  void clearApplied() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get quantity => $_getIZ(4);
  @$pb.TagNumber(5)
  set quantity($core.int v) {
    $_setSignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasQuantity() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuantity() => clearField(5);

  @$pb.TagNumber(6)
  $12.PromoCode get type => $_getN(5);
  @$pb.TagNumber(6)
  set type($12.PromoCode v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasType() => $_has(5);
  @$pb.TagNumber(6)
  void clearType() => clearField(6);
}
