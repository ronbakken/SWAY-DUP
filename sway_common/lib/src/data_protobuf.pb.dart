///
//  Generated code. Do not modify.
//  source: data_protobuf.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'enum_protobuf.pbenum.dart' as $12;

class DataSocialMedia extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DataSocialMedia',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'connected')
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'followersCount',
        $pb.PbFieldType.O3)
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'followingCount',
        $pb.PbFieldType.O3)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'screenName')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'displayName')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'location')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'url')
    ..a<$core.int>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'friendsCount', $pb.PbFieldType.O3)
    ..a<$core.int>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'postsCount', $pb.PbFieldType.O3)
    ..aOB(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'verified')
    ..aOS(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'email')
    ..aOS(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'profileUrl')
    ..aOS(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'avatarUrl')
    ..aOB(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'expired')
    ..aOS(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blurredAvatarUrl', protoName: 'blurredAvatar_url')
    ..aOB(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'published')
    ..aOB(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'allowLogIn')
    ..aOB(19, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canAuthenticate')
    ..aOB(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canSignUp')
    ..a<$core.int>(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'providerId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  DataSocialMedia._() : super();
  factory DataSocialMedia() => create();
  factory DataSocialMedia.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DataSocialMedia.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DataSocialMedia clone() => DataSocialMedia()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DataSocialMedia copyWith(void Function(DataSocialMedia) updates) =>
      super.copyWith((message) =>
          updates(message as DataSocialMedia)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DataSocialMedia create() => DataSocialMedia._();
  DataSocialMedia createEmptyInstance() => create();
  static $pb.PbList<DataSocialMedia> createRepeated() =>
      $pb.PbList<DataSocialMedia>();
  @$core.pragma('dart2js:noInline')
  static DataSocialMedia getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DataSocialMedia>(create);
  static DataSocialMedia _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get connected => $_getBF(0);
  @$pb.TagNumber(1)
  set connected($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasConnected() => $_has(0);
  @$pb.TagNumber(1)
  void clearConnected() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get followersCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set followersCount($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasFollowersCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearFollowersCount() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get followingCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set followingCount($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasFollowingCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearFollowingCount() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get screenName => $_getSZ(3);
  @$pb.TagNumber(4)
  set screenName($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasScreenName() => $_has(3);
  @$pb.TagNumber(4)
  void clearScreenName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get displayName => $_getSZ(4);
  @$pb.TagNumber(5)
  set displayName($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasDisplayName() => $_has(4);
  @$pb.TagNumber(5)
  void clearDisplayName() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get description => $_getSZ(5);
  @$pb.TagNumber(6)
  set description($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasDescription() => $_has(5);
  @$pb.TagNumber(6)
  void clearDescription() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get location => $_getSZ(6);
  @$pb.TagNumber(7)
  set location($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasLocation() => $_has(6);
  @$pb.TagNumber(7)
  void clearLocation() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get url => $_getSZ(7);
  @$pb.TagNumber(8)
  set url($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasUrl() => $_has(7);
  @$pb.TagNumber(8)
  void clearUrl() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get friendsCount => $_getIZ(8);
  @$pb.TagNumber(9)
  set friendsCount($core.int v) {
    $_setSignedInt32(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasFriendsCount() => $_has(8);
  @$pb.TagNumber(9)
  void clearFriendsCount() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get postsCount => $_getIZ(9);
  @$pb.TagNumber(10)
  set postsCount($core.int v) {
    $_setSignedInt32(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasPostsCount() => $_has(9);
  @$pb.TagNumber(10)
  void clearPostsCount() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get verified => $_getBF(10);
  @$pb.TagNumber(11)
  set verified($core.bool v) {
    $_setBool(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasVerified() => $_has(10);
  @$pb.TagNumber(11)
  void clearVerified() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get email => $_getSZ(11);
  @$pb.TagNumber(12)
  set email($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasEmail() => $_has(11);
  @$pb.TagNumber(12)
  void clearEmail() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get profileUrl => $_getSZ(12);
  @$pb.TagNumber(13)
  set profileUrl($core.String v) {
    $_setString(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasProfileUrl() => $_has(12);
  @$pb.TagNumber(13)
  void clearProfileUrl() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get avatarUrl => $_getSZ(13);
  @$pb.TagNumber(14)
  set avatarUrl($core.String v) {
    $_setString(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasAvatarUrl() => $_has(13);
  @$pb.TagNumber(14)
  void clearAvatarUrl() => clearField(14);

  @$pb.TagNumber(15)
  $core.bool get expired => $_getBF(14);
  @$pb.TagNumber(15)
  set expired($core.bool v) {
    $_setBool(14, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasExpired() => $_has(14);
  @$pb.TagNumber(15)
  void clearExpired() => clearField(15);

  @$pb.TagNumber(16)
  $core.String get blurredAvatarUrl => $_getSZ(15);
  @$pb.TagNumber(16)
  set blurredAvatarUrl($core.String v) {
    $_setString(15, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasBlurredAvatarUrl() => $_has(15);
  @$pb.TagNumber(16)
  void clearBlurredAvatarUrl() => clearField(16);

  @$pb.TagNumber(17)
  $core.bool get published => $_getBF(16);
  @$pb.TagNumber(17)
  set published($core.bool v) {
    $_setBool(16, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasPublished() => $_has(16);
  @$pb.TagNumber(17)
  void clearPublished() => clearField(17);

  @$pb.TagNumber(18)
  $core.bool get allowLogIn => $_getBF(17);
  @$pb.TagNumber(18)
  set allowLogIn($core.bool v) {
    $_setBool(17, v);
  }

  @$pb.TagNumber(18)
  $core.bool hasAllowLogIn() => $_has(17);
  @$pb.TagNumber(18)
  void clearAllowLogIn() => clearField(18);

  @$pb.TagNumber(19)
  $core.bool get canAuthenticate => $_getBF(18);
  @$pb.TagNumber(19)
  set canAuthenticate($core.bool v) {
    $_setBool(18, v);
  }

  @$pb.TagNumber(19)
  $core.bool hasCanAuthenticate() => $_has(18);
  @$pb.TagNumber(19)
  void clearCanAuthenticate() => clearField(19);

  @$pb.TagNumber(20)
  $core.bool get canSignUp => $_getBF(19);
  @$pb.TagNumber(20)
  set canSignUp($core.bool v) {
    $_setBool(19, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasCanSignUp() => $_has(19);
  @$pb.TagNumber(20)
  void clearCanSignUp() => clearField(20);

  @$pb.TagNumber(21)
  $core.int get providerId => $_getIZ(20);
  @$pb.TagNumber(21)
  set providerId($core.int v) {
    $_setSignedInt32(20, v);
  }

  @$pb.TagNumber(21)
  $core.bool hasProviderId() => $_has(20);
  @$pb.TagNumber(21)
  void clearProviderId() => clearField(21);
}

class DataOAuthCredentials extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DataOAuthCredentials',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'token')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'tokenSecret')
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'tokenExpires',
        $pb.PbFieldType.O3)
    ..aOS(
        4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..hasRequiredFields = false;

  DataOAuthCredentials._() : super();
  factory DataOAuthCredentials() => create();
  factory DataOAuthCredentials.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DataOAuthCredentials.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DataOAuthCredentials clone() =>
      DataOAuthCredentials()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DataOAuthCredentials copyWith(void Function(DataOAuthCredentials) updates) =>
      super.copyWith((message) => updates(
          message as DataOAuthCredentials)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DataOAuthCredentials create() => DataOAuthCredentials._();
  DataOAuthCredentials createEmptyInstance() => create();
  static $pb.PbList<DataOAuthCredentials> createRepeated() =>
      $pb.PbList<DataOAuthCredentials>();
  @$core.pragma('dart2js:noInline')
  static DataOAuthCredentials getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DataOAuthCredentials>(create);
  static DataOAuthCredentials _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get tokenSecret => $_getSZ(1);
  @$pb.TagNumber(2)
  set tokenSecret($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTokenSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearTokenSecret() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get tokenExpires => $_getIZ(2);
  @$pb.TagNumber(3)
  set tokenExpires($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTokenExpires() => $_has(2);
  @$pb.TagNumber(3)
  void clearTokenExpires() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get userId => $_getSZ(3);
  @$pb.TagNumber(4)
  set userId($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserId() => clearField(4);
}

class DataAuth extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DataAuth',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'inf'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'cookie',
        $pb.PbFieldType.OY)
    ..aInt64(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'sessionId')
    ..aInt64(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'accountId')
    ..e<$12.AccountType>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountType', $pb.PbFieldType.OE,
        defaultOrMaker: $12.AccountType.unknown,
        valueOf: $12.AccountType.valueOf,
        enumValues: $12.AccountType.values)
    ..e<$12.GlobalAccountState>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'globalAccountState', $pb.PbFieldType.OE, defaultOrMaker: $12.GlobalAccountState.initialize, valueOf: $12.GlobalAccountState.valueOf, enumValues: $12.GlobalAccountState.values)
    ..e<$12.AccountLevel>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountLevel', $pb.PbFieldType.OE, defaultOrMaker: $12.AccountLevel.free, valueOf: $12.AccountLevel.valueOf, enumValues: $12.AccountLevel.values)
    ..hasRequiredFields = false;

  DataAuth._() : super();
  factory DataAuth() => create();
  factory DataAuth.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DataAuth.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DataAuth clone() => DataAuth()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DataAuth copyWith(void Function(DataAuth) updates) =>
      super.copyWith((message) =>
          updates(message as DataAuth)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DataAuth create() => DataAuth._();
  DataAuth createEmptyInstance() => create();
  static $pb.PbList<DataAuth> createRepeated() => $pb.PbList<DataAuth>();
  @$core.pragma('dart2js:noInline')
  static DataAuth getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataAuth>(create);
  static DataAuth _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get cookie => $_getN(0);
  @$pb.TagNumber(1)
  set cookie($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCookie() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookie() => clearField(1);

  @$pb.TagNumber(4)
  $fixnum.Int64 get sessionId => $_getI64(1);
  @$pb.TagNumber(4)
  set sessionId($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(4)
  void clearSessionId() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get accountId => $_getI64(2);
  @$pb.TagNumber(5)
  set accountId($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasAccountId() => $_has(2);
  @$pb.TagNumber(5)
  void clearAccountId() => clearField(5);

  @$pb.TagNumber(6)
  $12.AccountType get accountType => $_getN(3);
  @$pb.TagNumber(6)
  set accountType($12.AccountType v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasAccountType() => $_has(3);
  @$pb.TagNumber(6)
  void clearAccountType() => clearField(6);

  @$pb.TagNumber(7)
  $12.GlobalAccountState get globalAccountState => $_getN(4);
  @$pb.TagNumber(7)
  set globalAccountState($12.GlobalAccountState v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasGlobalAccountState() => $_has(4);
  @$pb.TagNumber(7)
  void clearGlobalAccountState() => clearField(7);

  @$pb.TagNumber(9)
  $12.AccountLevel get accountLevel => $_getN(5);
  @$pb.TagNumber(9)
  set accountLevel($12.AccountLevel v) {
    setField(9, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasAccountLevel() => $_has(5);
  @$pb.TagNumber(9)
  void clearAccountLevel() => clearField(9);
}

class DataTerms extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DataTerms',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..p<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'deliverableSocialPlatforms',
        $pb.PbFieldType.P3)
    ..p<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'deliverableContentFormats',
        $pb.PbFieldType.P3)
    ..aOS(3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'deliverablesDescription')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rewardCashValue', $pb.PbFieldType.O3)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rewardItemOrServiceValue', $pb.PbFieldType.O3)
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rewardItemOrServiceDescription')
    ..hasRequiredFields = false;

  DataTerms._() : super();
  factory DataTerms() => create();
  factory DataTerms.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DataTerms.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DataTerms clone() => DataTerms()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DataTerms copyWith(void Function(DataTerms) updates) =>
      super.copyWith((message) =>
          updates(message as DataTerms)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DataTerms create() => DataTerms._();
  DataTerms createEmptyInstance() => create();
  static $pb.PbList<DataTerms> createRepeated() => $pb.PbList<DataTerms>();
  @$core.pragma('dart2js:noInline')
  static DataTerms getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataTerms>(create);
  static DataTerms _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get deliverableSocialPlatforms => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get deliverableContentFormats => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get deliverablesDescription => $_getSZ(2);
  @$pb.TagNumber(3)
  set deliverablesDescription($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasDeliverablesDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeliverablesDescription() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get rewardCashValue => $_getIZ(3);
  @$pb.TagNumber(4)
  set rewardCashValue($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasRewardCashValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearRewardCashValue() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get rewardItemOrServiceValue => $_getIZ(4);
  @$pb.TagNumber(5)
  set rewardItemOrServiceValue($core.int v) {
    $_setSignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasRewardItemOrServiceValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearRewardItemOrServiceValue() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get rewardItemOrServiceDescription => $_getSZ(5);
  @$pb.TagNumber(6)
  set rewardItemOrServiceDescription($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasRewardItemOrServiceDescription() => $_has(5);
  @$pb.TagNumber(6)
  void clearRewardItemOrServiceDescription() => clearField(6);
}

class DataOffer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DataOffer',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'offerId')
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'senderAccountId')
    ..aInt64(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'locationId')
    ..aOS(
        4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'thumbnailUrl')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'locationAddress')
    ..pPS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coverUrls')
    ..e<$12.OfferState>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: $12.OfferState.draft, valueOf: $12.OfferState.valueOf, enumValues: $12.OfferState.values)
    ..e<$12.OfferStateReason>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stateReason', $pb.PbFieldType.OE, defaultOrMaker: $12.OfferStateReason.newOffer, valueOf: $12.OfferStateReason.valueOf, enumValues: $12.OfferStateReason.values)
    ..a<$core.double>(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(19, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'longitude', $pb.PbFieldType.OD)
    ..aOS(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderName')
    ..aInt64(22, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'proposalId')
    ..p<$core.int>(23, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'categories', $pb.PbFieldType.P3)
    ..aOB(26, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'archived')
    ..aOM<DataTerms>(27, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'terms', subBuilder: DataTerms.create)
    ..a<$core.List<$core.int>>(28, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'thumbnailBlurred', $pb.PbFieldType.OY)
    ..p<$core.List<$core.int>>(29, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coversBlurred', $pb.PbFieldType.PY)
    ..aOB(32, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'direct')
    ..p<$core.int>(33, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'primaryCategories', $pb.PbFieldType.P3)
    ..pPS(34, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coverKeys')
    ..aOS(35, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderAvatarUrl')
    ..a<$core.List<$core.int>>(36, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderAvatarBlurred', $pb.PbFieldType.OY)
    ..aOS(37, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'thumbnailKey')
    ..a<$core.int>(38, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'proposalsProposing', $pb.PbFieldType.O3)
    ..a<$core.int>(39, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'proposalsNegotiating', $pb.PbFieldType.O3)
    ..a<$core.int>(40, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'proposalsDeal', $pb.PbFieldType.O3)
    ..a<$core.int>(41, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'proposalsRejected', $pb.PbFieldType.O3)
    ..a<$core.int>(42, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'proposalsDispute', $pb.PbFieldType.O3)
    ..a<$core.int>(43, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'proposalsResolved', $pb.PbFieldType.O3)
    ..a<$core.int>(44, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'proposalsComplete', $pb.PbFieldType.O3)
    ..e<$12.AccountType>(45, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderAccountType', $pb.PbFieldType.OE, defaultOrMaker: $12.AccountType.unknown, valueOf: $12.AccountType.valueOf, enumValues: $12.AccountType.values)
    ..aOB(46, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'acceptMatchingProposals')
    ..aOB(47, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'allowNegotiatingProposals')
    ..a<$core.int>(48, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amountOffered', $pb.PbFieldType.O3)
    ..a<$core.int>(49, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amountRemaining', $pb.PbFieldType.O3)
    ..aInt64(50, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scheduledOpen')
    ..aInt64(51, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scheduledClose')
    ..hasRequiredFields = false;

  DataOffer._() : super();
  factory DataOffer() => create();
  factory DataOffer.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DataOffer.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DataOffer clone() => DataOffer()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DataOffer copyWith(void Function(DataOffer) updates) =>
      super.copyWith((message) =>
          updates(message as DataOffer)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DataOffer create() => DataOffer._();
  DataOffer createEmptyInstance() => create();
  static $pb.PbList<DataOffer> createRepeated() => $pb.PbList<DataOffer>();
  @$core.pragma('dart2js:noInline')
  static DataOffer getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataOffer>(create);
  static DataOffer _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get offerId => $_getI64(0);
  @$pb.TagNumber(1)
  set offerId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOfferId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOfferId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get senderAccountId => $_getI64(1);
  @$pb.TagNumber(2)
  set senderAccountId($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSenderAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSenderAccountId() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get locationId => $_getI64(2);
  @$pb.TagNumber(3)
  set locationId($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasLocationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocationId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get thumbnailUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set thumbnailUrl($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasThumbnailUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearThumbnailUrl() => clearField(6);

  @$pb.TagNumber(9)
  $core.String get locationAddress => $_getSZ(6);
  @$pb.TagNumber(9)
  set locationAddress($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasLocationAddress() => $_has(6);
  @$pb.TagNumber(9)
  void clearLocationAddress() => clearField(9);

  @$pb.TagNumber(10)
  $core.List<$core.String> get coverUrls => $_getList(7);

  @$pb.TagNumber(12)
  $12.OfferState get state => $_getN(8);
  @$pb.TagNumber(12)
  set state($12.OfferState v) {
    setField(12, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasState() => $_has(8);
  @$pb.TagNumber(12)
  void clearState() => clearField(12);

  @$pb.TagNumber(13)
  $12.OfferStateReason get stateReason => $_getN(9);
  @$pb.TagNumber(13)
  set stateReason($12.OfferStateReason v) {
    setField(13, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasStateReason() => $_has(9);
  @$pb.TagNumber(13)
  void clearStateReason() => clearField(13);

  @$pb.TagNumber(18)
  $core.double get latitude => $_getN(10);
  @$pb.TagNumber(18)
  set latitude($core.double v) {
    $_setDouble(10, v);
  }

  @$pb.TagNumber(18)
  $core.bool hasLatitude() => $_has(10);
  @$pb.TagNumber(18)
  void clearLatitude() => clearField(18);

  @$pb.TagNumber(19)
  $core.double get longitude => $_getN(11);
  @$pb.TagNumber(19)
  set longitude($core.double v) {
    $_setDouble(11, v);
  }

  @$pb.TagNumber(19)
  $core.bool hasLongitude() => $_has(11);
  @$pb.TagNumber(19)
  void clearLongitude() => clearField(19);

  @$pb.TagNumber(21)
  $core.String get senderName => $_getSZ(12);
  @$pb.TagNumber(21)
  set senderName($core.String v) {
    $_setString(12, v);
  }

  @$pb.TagNumber(21)
  $core.bool hasSenderName() => $_has(12);
  @$pb.TagNumber(21)
  void clearSenderName() => clearField(21);

  @$pb.TagNumber(22)
  $fixnum.Int64 get proposalId => $_getI64(13);
  @$pb.TagNumber(22)
  set proposalId($fixnum.Int64 v) {
    $_setInt64(13, v);
  }

  @$pb.TagNumber(22)
  $core.bool hasProposalId() => $_has(13);
  @$pb.TagNumber(22)
  void clearProposalId() => clearField(22);

  @$pb.TagNumber(23)
  $core.List<$core.int> get categories => $_getList(14);

  @$pb.TagNumber(26)
  $core.bool get archived => $_getBF(15);
  @$pb.TagNumber(26)
  set archived($core.bool v) {
    $_setBool(15, v);
  }

  @$pb.TagNumber(26)
  $core.bool hasArchived() => $_has(15);
  @$pb.TagNumber(26)
  void clearArchived() => clearField(26);

  @$pb.TagNumber(27)
  DataTerms get terms => $_getN(16);
  @$pb.TagNumber(27)
  set terms(DataTerms v) {
    setField(27, v);
  }

  @$pb.TagNumber(27)
  $core.bool hasTerms() => $_has(16);
  @$pb.TagNumber(27)
  void clearTerms() => clearField(27);
  @$pb.TagNumber(27)
  DataTerms ensureTerms() => $_ensure(16);

  @$pb.TagNumber(28)
  $core.List<$core.int> get thumbnailBlurred => $_getN(17);
  @$pb.TagNumber(28)
  set thumbnailBlurred($core.List<$core.int> v) {
    $_setBytes(17, v);
  }

  @$pb.TagNumber(28)
  $core.bool hasThumbnailBlurred() => $_has(17);
  @$pb.TagNumber(28)
  void clearThumbnailBlurred() => clearField(28);

  @$pb.TagNumber(29)
  $core.List<$core.List<$core.int>> get coversBlurred => $_getList(18);

  @$pb.TagNumber(32)
  $core.bool get direct => $_getBF(19);
  @$pb.TagNumber(32)
  set direct($core.bool v) {
    $_setBool(19, v);
  }

  @$pb.TagNumber(32)
  $core.bool hasDirect() => $_has(19);
  @$pb.TagNumber(32)
  void clearDirect() => clearField(32);

  @$pb.TagNumber(33)
  $core.List<$core.int> get primaryCategories => $_getList(20);

  @$pb.TagNumber(34)
  $core.List<$core.String> get coverKeys => $_getList(21);

  @$pb.TagNumber(35)
  $core.String get senderAvatarUrl => $_getSZ(22);
  @$pb.TagNumber(35)
  set senderAvatarUrl($core.String v) {
    $_setString(22, v);
  }

  @$pb.TagNumber(35)
  $core.bool hasSenderAvatarUrl() => $_has(22);
  @$pb.TagNumber(35)
  void clearSenderAvatarUrl() => clearField(35);

  @$pb.TagNumber(36)
  $core.List<$core.int> get senderAvatarBlurred => $_getN(23);
  @$pb.TagNumber(36)
  set senderAvatarBlurred($core.List<$core.int> v) {
    $_setBytes(23, v);
  }

  @$pb.TagNumber(36)
  $core.bool hasSenderAvatarBlurred() => $_has(23);
  @$pb.TagNumber(36)
  void clearSenderAvatarBlurred() => clearField(36);

  @$pb.TagNumber(37)
  $core.String get thumbnailKey => $_getSZ(24);
  @$pb.TagNumber(37)
  set thumbnailKey($core.String v) {
    $_setString(24, v);
  }

  @$pb.TagNumber(37)
  $core.bool hasThumbnailKey() => $_has(24);
  @$pb.TagNumber(37)
  void clearThumbnailKey() => clearField(37);

  @$pb.TagNumber(38)
  $core.int get proposalsProposing => $_getIZ(25);
  @$pb.TagNumber(38)
  set proposalsProposing($core.int v) {
    $_setSignedInt32(25, v);
  }

  @$pb.TagNumber(38)
  $core.bool hasProposalsProposing() => $_has(25);
  @$pb.TagNumber(38)
  void clearProposalsProposing() => clearField(38);

  @$pb.TagNumber(39)
  $core.int get proposalsNegotiating => $_getIZ(26);
  @$pb.TagNumber(39)
  set proposalsNegotiating($core.int v) {
    $_setSignedInt32(26, v);
  }

  @$pb.TagNumber(39)
  $core.bool hasProposalsNegotiating() => $_has(26);
  @$pb.TagNumber(39)
  void clearProposalsNegotiating() => clearField(39);

  @$pb.TagNumber(40)
  $core.int get proposalsDeal => $_getIZ(27);
  @$pb.TagNumber(40)
  set proposalsDeal($core.int v) {
    $_setSignedInt32(27, v);
  }

  @$pb.TagNumber(40)
  $core.bool hasProposalsDeal() => $_has(27);
  @$pb.TagNumber(40)
  void clearProposalsDeal() => clearField(40);

  @$pb.TagNumber(41)
  $core.int get proposalsRejected => $_getIZ(28);
  @$pb.TagNumber(41)
  set proposalsRejected($core.int v) {
    $_setSignedInt32(28, v);
  }

  @$pb.TagNumber(41)
  $core.bool hasProposalsRejected() => $_has(28);
  @$pb.TagNumber(41)
  void clearProposalsRejected() => clearField(41);

  @$pb.TagNumber(42)
  $core.int get proposalsDispute => $_getIZ(29);
  @$pb.TagNumber(42)
  set proposalsDispute($core.int v) {
    $_setSignedInt32(29, v);
  }

  @$pb.TagNumber(42)
  $core.bool hasProposalsDispute() => $_has(29);
  @$pb.TagNumber(42)
  void clearProposalsDispute() => clearField(42);

  @$pb.TagNumber(43)
  $core.int get proposalsResolved => $_getIZ(30);
  @$pb.TagNumber(43)
  set proposalsResolved($core.int v) {
    $_setSignedInt32(30, v);
  }

  @$pb.TagNumber(43)
  $core.bool hasProposalsResolved() => $_has(30);
  @$pb.TagNumber(43)
  void clearProposalsResolved() => clearField(43);

  @$pb.TagNumber(44)
  $core.int get proposalsComplete => $_getIZ(31);
  @$pb.TagNumber(44)
  set proposalsComplete($core.int v) {
    $_setSignedInt32(31, v);
  }

  @$pb.TagNumber(44)
  $core.bool hasProposalsComplete() => $_has(31);
  @$pb.TagNumber(44)
  void clearProposalsComplete() => clearField(44);

  @$pb.TagNumber(45)
  $12.AccountType get senderAccountType => $_getN(32);
  @$pb.TagNumber(45)
  set senderAccountType($12.AccountType v) {
    setField(45, v);
  }

  @$pb.TagNumber(45)
  $core.bool hasSenderAccountType() => $_has(32);
  @$pb.TagNumber(45)
  void clearSenderAccountType() => clearField(45);

  @$pb.TagNumber(46)
  $core.bool get acceptMatchingProposals => $_getBF(33);
  @$pb.TagNumber(46)
  set acceptMatchingProposals($core.bool v) {
    $_setBool(33, v);
  }

  @$pb.TagNumber(46)
  $core.bool hasAcceptMatchingProposals() => $_has(33);
  @$pb.TagNumber(46)
  void clearAcceptMatchingProposals() => clearField(46);

  @$pb.TagNumber(47)
  $core.bool get allowNegotiatingProposals => $_getBF(34);
  @$pb.TagNumber(47)
  set allowNegotiatingProposals($core.bool v) {
    $_setBool(34, v);
  }

  @$pb.TagNumber(47)
  $core.bool hasAllowNegotiatingProposals() => $_has(34);
  @$pb.TagNumber(47)
  void clearAllowNegotiatingProposals() => clearField(47);

  @$pb.TagNumber(48)
  $core.int get amountOffered => $_getIZ(35);
  @$pb.TagNumber(48)
  set amountOffered($core.int v) {
    $_setSignedInt32(35, v);
  }

  @$pb.TagNumber(48)
  $core.bool hasAmountOffered() => $_has(35);
  @$pb.TagNumber(48)
  void clearAmountOffered() => clearField(48);

  @$pb.TagNumber(49)
  $core.int get amountRemaining => $_getIZ(36);
  @$pb.TagNumber(49)
  set amountRemaining($core.int v) {
    $_setSignedInt32(36, v);
  }

  @$pb.TagNumber(49)
  $core.bool hasAmountRemaining() => $_has(36);
  @$pb.TagNumber(49)
  void clearAmountRemaining() => clearField(49);

  @$pb.TagNumber(50)
  $fixnum.Int64 get scheduledOpen => $_getI64(37);
  @$pb.TagNumber(50)
  set scheduledOpen($fixnum.Int64 v) {
    $_setInt64(37, v);
  }

  @$pb.TagNumber(50)
  $core.bool hasScheduledOpen() => $_has(37);
  @$pb.TagNumber(50)
  void clearScheduledOpen() => clearField(50);

  @$pb.TagNumber(51)
  $fixnum.Int64 get scheduledClose => $_getI64(38);
  @$pb.TagNumber(51)
  set scheduledClose($fixnum.Int64 v) {
    $_setInt64(38, v);
  }

  @$pb.TagNumber(51)
  $core.bool hasScheduledClose() => $_has(38);
  @$pb.TagNumber(51)
  void clearScheduledClose() => clearField(51);
}

class DataLocation extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DataLocation',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'locationId')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'name')
    ..a<$core.double>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'latitude',
        $pb.PbFieldType.OD)
    ..a<$core.double>(
        5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'longitude', $pb.PbFieldType.OD)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'approximate')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'detail')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'postcode')
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'regionCode')
    ..aOS(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'countryCode')
    ..aInt64(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 's2cellId')
    ..aInt64(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'geohashInt')
    ..aOS(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'geohash')
    ..hasRequiredFields = false;

  DataLocation._() : super();
  factory DataLocation() => create();
  factory DataLocation.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DataLocation.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DataLocation clone() => DataLocation()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DataLocation copyWith(void Function(DataLocation) updates) =>
      super.copyWith((message) =>
          updates(message as DataLocation)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DataLocation create() => DataLocation._();
  DataLocation createEmptyInstance() => create();
  static $pb.PbList<DataLocation> createRepeated() =>
      $pb.PbList<DataLocation>();
  @$core.pragma('dart2js:noInline')
  static DataLocation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DataLocation>(create);
  static DataLocation _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get locationId => $_getI64(0);
  @$pb.TagNumber(1)
  set locationId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(4)
  $core.double get latitude => $_getN(2);
  @$pb.TagNumber(4)
  set latitude($core.double v) {
    $_setDouble(2, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasLatitude() => $_has(2);
  @$pb.TagNumber(4)
  void clearLatitude() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get longitude => $_getN(3);
  @$pb.TagNumber(5)
  set longitude($core.double v) {
    $_setDouble(3, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasLongitude() => $_has(3);
  @$pb.TagNumber(5)
  void clearLongitude() => clearField(5);

  @$pb.TagNumber(7)
  $core.String get approximate => $_getSZ(4);
  @$pb.TagNumber(7)
  set approximate($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasApproximate() => $_has(4);
  @$pb.TagNumber(7)
  void clearApproximate() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get detail => $_getSZ(5);
  @$pb.TagNumber(8)
  set detail($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasDetail() => $_has(5);
  @$pb.TagNumber(8)
  void clearDetail() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get postcode => $_getSZ(6);
  @$pb.TagNumber(9)
  set postcode($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasPostcode() => $_has(6);
  @$pb.TagNumber(9)
  void clearPostcode() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get regionCode => $_getSZ(7);
  @$pb.TagNumber(10)
  set regionCode($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasRegionCode() => $_has(7);
  @$pb.TagNumber(10)
  void clearRegionCode() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get countryCode => $_getSZ(8);
  @$pb.TagNumber(11)
  set countryCode($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasCountryCode() => $_has(8);
  @$pb.TagNumber(11)
  void clearCountryCode() => clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get s2cellId => $_getI64(9);
  @$pb.TagNumber(12)
  set s2cellId($fixnum.Int64 v) {
    $_setInt64(9, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasS2cellId() => $_has(9);
  @$pb.TagNumber(12)
  void clearS2cellId() => clearField(12);

  @$pb.TagNumber(14)
  $fixnum.Int64 get geohashInt => $_getI64(10);
  @$pb.TagNumber(14)
  set geohashInt($fixnum.Int64 v) {
    $_setInt64(10, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasGeohashInt() => $_has(10);
  @$pb.TagNumber(14)
  void clearGeohashInt() => clearField(14);

  @$pb.TagNumber(15)
  $core.String get geohash => $_getSZ(11);
  @$pb.TagNumber(15)
  set geohash($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasGeohash() => $_has(11);
  @$pb.TagNumber(15)
  void clearGeohash() => clearField(15);
}

class DataAccount extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DataAccount',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'sessionId')
    ..aInt64(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'accountId')
    ..e<$12.AccountType>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountType', $pb.PbFieldType.OE,
        defaultOrMaker: $12.AccountType.unknown,
        valueOf: $12.AccountType.valueOf,
        enumValues: $12.AccountType.values)
    ..e<$12.GlobalAccountState>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'globalAccountState', $pb.PbFieldType.OE,
        defaultOrMaker: $12.GlobalAccountState.initialize,
        valueOf: $12.GlobalAccountState.valueOf,
        enumValues: $12.GlobalAccountState.values)
    ..e<$12.GlobalAccountStateReason>(
        8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'globalAccountStateReason', $pb.PbFieldType.OE,
        defaultOrMaker: $12.GlobalAccountStateReason.newAccount,
        valueOf: $12.GlobalAccountStateReason.valueOf,
        enumValues: $12.GlobalAccountStateReason.values)
    ..e<$12.AccountLevel>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountLevel', $pb.PbFieldType.OE,
        defaultOrMaker: $12.AccountLevel.free,
        valueOf: $12.AccountLevel.valueOf,
        enumValues: $12.AccountLevel.values)
    ..aOS(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'firebaseToken')
    ..aOS(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'description')
    ..aOS(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'location')
    ..aOS(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'avatarUrl')
    ..aOS(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blurredAvatarUrl')
    ..p<$core.int>(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'categories', $pb.PbFieldType.P3)
    ..m<$core.int, DataSocialMedia>(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'socialMedia', entryClassName: 'DataAccount.SocialMediaEntry', keyFieldType: $pb.PbFieldType.O3, valueFieldType: $pb.PbFieldType.OM, valueCreator: DataSocialMedia.create, packageName: const $pb.PackageName('inf'))
    ..pPS(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coverUrls')
    ..pPS(22, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blurredCoverUrls')
    ..aOS(24, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'website')
    ..aOS(25, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'email')
    ..aOS(27, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'locationName')
    ..aOS(28, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'locationAddress')
    ..a<$core.double>(29, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'longitude', $pb.PbFieldType.OD)
    ..aInt64(31, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'locationId')
    ..aOB(32, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'acceptDirectProposals')
    ..aOB(33, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publishGpsLocation')
    ..a<$core.int>(34, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  DataAccount._() : super();
  factory DataAccount() => create();
  factory DataAccount.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DataAccount.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DataAccount clone() => DataAccount()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DataAccount copyWith(void Function(DataAccount) updates) =>
      super.copyWith((message) =>
          updates(message as DataAccount)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DataAccount create() => DataAccount._();
  DataAccount createEmptyInstance() => create();
  static $pb.PbList<DataAccount> createRepeated() => $pb.PbList<DataAccount>();
  @$core.pragma('dart2js:noInline')
  static DataAccount getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DataAccount>(create);
  static DataAccount _defaultInstance;

  @$pb.TagNumber(4)
  $fixnum.Int64 get sessionId => $_getI64(0);
  @$pb.TagNumber(4)
  set sessionId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(4)
  void clearSessionId() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get accountId => $_getI64(1);
  @$pb.TagNumber(5)
  set accountId($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasAccountId() => $_has(1);
  @$pb.TagNumber(5)
  void clearAccountId() => clearField(5);

  @$pb.TagNumber(6)
  $12.AccountType get accountType => $_getN(2);
  @$pb.TagNumber(6)
  set accountType($12.AccountType v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasAccountType() => $_has(2);
  @$pb.TagNumber(6)
  void clearAccountType() => clearField(6);

  @$pb.TagNumber(7)
  $12.GlobalAccountState get globalAccountState => $_getN(3);
  @$pb.TagNumber(7)
  set globalAccountState($12.GlobalAccountState v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasGlobalAccountState() => $_has(3);
  @$pb.TagNumber(7)
  void clearGlobalAccountState() => clearField(7);

  @$pb.TagNumber(8)
  $12.GlobalAccountStateReason get globalAccountStateReason => $_getN(4);
  @$pb.TagNumber(8)
  set globalAccountStateReason($12.GlobalAccountStateReason v) {
    setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasGlobalAccountStateReason() => $_has(4);
  @$pb.TagNumber(8)
  void clearGlobalAccountStateReason() => clearField(8);

  @$pb.TagNumber(9)
  $12.AccountLevel get accountLevel => $_getN(5);
  @$pb.TagNumber(9)
  set accountLevel($12.AccountLevel v) {
    setField(9, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasAccountLevel() => $_has(5);
  @$pb.TagNumber(9)
  void clearAccountLevel() => clearField(9);

  @$pb.TagNumber(11)
  $core.String get firebaseToken => $_getSZ(6);
  @$pb.TagNumber(11)
  set firebaseToken($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasFirebaseToken() => $_has(6);
  @$pb.TagNumber(11)
  void clearFirebaseToken() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get name => $_getSZ(7);
  @$pb.TagNumber(12)
  set name($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasName() => $_has(7);
  @$pb.TagNumber(12)
  void clearName() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get description => $_getSZ(8);
  @$pb.TagNumber(13)
  set description($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasDescription() => $_has(8);
  @$pb.TagNumber(13)
  void clearDescription() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get location => $_getSZ(9);
  @$pb.TagNumber(14)
  set location($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasLocation() => $_has(9);
  @$pb.TagNumber(14)
  void clearLocation() => clearField(14);

  @$pb.TagNumber(15)
  $core.String get avatarUrl => $_getSZ(10);
  @$pb.TagNumber(15)
  set avatarUrl($core.String v) {
    $_setString(10, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasAvatarUrl() => $_has(10);
  @$pb.TagNumber(15)
  void clearAvatarUrl() => clearField(15);

  @$pb.TagNumber(16)
  $core.String get blurredAvatarUrl => $_getSZ(11);
  @$pb.TagNumber(16)
  set blurredAvatarUrl($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasBlurredAvatarUrl() => $_has(11);
  @$pb.TagNumber(16)
  void clearBlurredAvatarUrl() => clearField(16);

  @$pb.TagNumber(18)
  $core.List<$core.int> get categories => $_getList(12);

  @$pb.TagNumber(20)
  $core.Map<$core.int, DataSocialMedia> get socialMedia => $_getMap(13);

  @$pb.TagNumber(21)
  $core.List<$core.String> get coverUrls => $_getList(14);

  @$pb.TagNumber(22)
  $core.List<$core.String> get blurredCoverUrls => $_getList(15);

  @$pb.TagNumber(24)
  $core.String get website => $_getSZ(16);
  @$pb.TagNumber(24)
  set website($core.String v) {
    $_setString(16, v);
  }

  @$pb.TagNumber(24)
  $core.bool hasWebsite() => $_has(16);
  @$pb.TagNumber(24)
  void clearWebsite() => clearField(24);

  @$pb.TagNumber(25)
  $core.String get email => $_getSZ(17);
  @$pb.TagNumber(25)
  set email($core.String v) {
    $_setString(17, v);
  }

  @$pb.TagNumber(25)
  $core.bool hasEmail() => $_has(17);
  @$pb.TagNumber(25)
  void clearEmail() => clearField(25);

  @$pb.TagNumber(27)
  $core.String get locationName => $_getSZ(18);
  @$pb.TagNumber(27)
  set locationName($core.String v) {
    $_setString(18, v);
  }

  @$pb.TagNumber(27)
  $core.bool hasLocationName() => $_has(18);
  @$pb.TagNumber(27)
  void clearLocationName() => clearField(27);

  @$pb.TagNumber(28)
  $core.String get locationAddress => $_getSZ(19);
  @$pb.TagNumber(28)
  set locationAddress($core.String v) {
    $_setString(19, v);
  }

  @$pb.TagNumber(28)
  $core.bool hasLocationAddress() => $_has(19);
  @$pb.TagNumber(28)
  void clearLocationAddress() => clearField(28);

  @$pb.TagNumber(29)
  $core.double get latitude => $_getN(20);
  @$pb.TagNumber(29)
  set latitude($core.double v) {
    $_setDouble(20, v);
  }

  @$pb.TagNumber(29)
  $core.bool hasLatitude() => $_has(20);
  @$pb.TagNumber(29)
  void clearLatitude() => clearField(29);

  @$pb.TagNumber(30)
  $core.double get longitude => $_getN(21);
  @$pb.TagNumber(30)
  set longitude($core.double v) {
    $_setDouble(21, v);
  }

  @$pb.TagNumber(30)
  $core.bool hasLongitude() => $_has(21);
  @$pb.TagNumber(30)
  void clearLongitude() => clearField(30);

  @$pb.TagNumber(31)
  $fixnum.Int64 get locationId => $_getI64(22);
  @$pb.TagNumber(31)
  set locationId($fixnum.Int64 v) {
    $_setInt64(22, v);
  }

  @$pb.TagNumber(31)
  $core.bool hasLocationId() => $_has(22);
  @$pb.TagNumber(31)
  void clearLocationId() => clearField(31);

  @$pb.TagNumber(32)
  $core.bool get acceptDirectProposals => $_getBF(23);
  @$pb.TagNumber(32)
  set acceptDirectProposals($core.bool v) {
    $_setBool(23, v);
  }

  @$pb.TagNumber(32)
  $core.bool hasAcceptDirectProposals() => $_has(23);
  @$pb.TagNumber(32)
  void clearAcceptDirectProposals() => clearField(32);

  @$pb.TagNumber(33)
  $core.bool get publishGpsLocation => $_getBF(24);
  @$pb.TagNumber(33)
  set publishGpsLocation($core.bool v) {
    $_setBool(24, v);
  }

  @$pb.TagNumber(33)
  $core.bool hasPublishGpsLocation() => $_has(24);
  @$pb.TagNumber(33)
  void clearPublishGpsLocation() => clearField(33);

  @$pb.TagNumber(34)
  $core.int get version => $_getIZ(25);
  @$pb.TagNumber(34)
  set version($core.int v) {
    $_setSignedInt32(25, v);
  }

  @$pb.TagNumber(34)
  $core.bool hasVersion() => $_has(25);
  @$pb.TagNumber(34)
  void clearVersion() => clearField(34);
}

class DataExploreFilter extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DataExploreFilter',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'keywords')
    ..p<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'socialPlatforms', $pb.PbFieldType.P3,
        protoName: 'socialPlatforms')
    ..p<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'contentFormats',
        $pb.PbFieldType.P3,
        protoName: 'contentFormats')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'minimumTotalValue', $pb.PbFieldType.O3, protoName: 'minimumTotalValue')
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cashValueRequired', $pb.PbFieldType.O3, protoName: 'cashValueRequired')
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'longitude', $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  DataExploreFilter._() : super();
  factory DataExploreFilter() => create();
  factory DataExploreFilter.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DataExploreFilter.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DataExploreFilter clone() => DataExploreFilter()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DataExploreFilter copyWith(void Function(DataExploreFilter) updates) =>
      super.copyWith((message) => updates(
          message as DataExploreFilter)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DataExploreFilter create() => DataExploreFilter._();
  DataExploreFilter createEmptyInstance() => create();
  static $pb.PbList<DataExploreFilter> createRepeated() =>
      $pb.PbList<DataExploreFilter>();
  @$core.pragma('dart2js:noInline')
  static DataExploreFilter getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DataExploreFilter>(create);
  static DataExploreFilter _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keywords => $_getSZ(0);
  @$pb.TagNumber(1)
  set keywords($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasKeywords() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeywords() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get socialPlatforms => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$core.int> get contentFormats => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get minimumTotalValue => $_getIZ(3);
  @$pb.TagNumber(4)
  set minimumTotalValue($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasMinimumTotalValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinimumTotalValue() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get cashValueRequired => $_getIZ(4);
  @$pb.TagNumber(5)
  set cashValueRequired($core.int v) {
    $_setSignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasCashValueRequired() => $_has(4);
  @$pb.TagNumber(5)
  void clearCashValueRequired() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get latitude => $_getN(5);
  @$pb.TagNumber(6)
  set latitude($core.double v) {
    $_setDouble(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasLatitude() => $_has(5);
  @$pb.TagNumber(6)
  void clearLatitude() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get longitude => $_getN(6);
  @$pb.TagNumber(7)
  set longitude($core.double v) {
    $_setDouble(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasLongitude() => $_has(6);
  @$pb.TagNumber(7)
  void clearLongitude() => clearField(7);
}

class DataExploreEntry extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DataExploreEntry',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<DataOffer>(
        3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'offer',
        subBuilder: DataOffer.create)
    ..aOM<DataAccount>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'account',
        subBuilder: DataAccount.create)
    ..hasRequiredFields = false;

  DataExploreEntry._() : super();
  factory DataExploreEntry() => create();
  factory DataExploreEntry.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DataExploreEntry.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DataExploreEntry clone() => DataExploreEntry()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DataExploreEntry copyWith(void Function(DataExploreEntry) updates) =>
      super.copyWith((message) => updates(
          message as DataExploreEntry)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DataExploreEntry create() => DataExploreEntry._();
  DataExploreEntry createEmptyInstance() => create();
  static $pb.PbList<DataExploreEntry> createRepeated() =>
      $pb.PbList<DataExploreEntry>();
  @$core.pragma('dart2js:noInline')
  static DataExploreEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DataExploreEntry>(create);
  static DataExploreEntry _defaultInstance;

  @$pb.TagNumber(3)
  DataOffer get offer => $_getN(0);
  @$pb.TagNumber(3)
  set offer(DataOffer v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasOffer() => $_has(0);
  @$pb.TagNumber(3)
  void clearOffer() => clearField(3);
  @$pb.TagNumber(3)
  DataOffer ensureOffer() => $_ensure(0);

  @$pb.TagNumber(4)
  DataAccount get account => $_getN(1);
  @$pb.TagNumber(4)
  set account(DataAccount v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasAccount() => $_has(1);
  @$pb.TagNumber(4)
  void clearAccount() => clearField(4);
  @$pb.TagNumber(4)
  DataAccount ensureAccount() => $_ensure(1);
}

class DataExploreMarker extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DataExploreMarker',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<DataOffer>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'offer',
        subBuilder: DataOffer.create)
    ..aOM<DataAccount>(
        4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'account',
        subBuilder: DataAccount.create)
    ..aOM<DataLocation>(
        5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'location',
        subBuilder: DataLocation.create)
    ..aInt64(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clusterId', protoName: 'clusterId')
    ..aInt64(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'parentClusterIds', protoName: 'parentClusterIds')
    ..a<$core.int>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hiddenMarkers', $pb.PbFieldType.O3, protoName: 'hiddenMarkers')
    ..hasRequiredFields = false;

  DataExploreMarker._() : super();
  factory DataExploreMarker() => create();
  factory DataExploreMarker.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DataExploreMarker.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DataExploreMarker clone() => DataExploreMarker()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DataExploreMarker copyWith(void Function(DataExploreMarker) updates) =>
      super.copyWith((message) => updates(
          message as DataExploreMarker)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DataExploreMarker create() => DataExploreMarker._();
  DataExploreMarker createEmptyInstance() => create();
  static $pb.PbList<DataExploreMarker> createRepeated() =>
      $pb.PbList<DataExploreMarker>();
  @$core.pragma('dart2js:noInline')
  static DataExploreMarker getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DataExploreMarker>(create);
  static DataExploreMarker _defaultInstance;

  @$pb.TagNumber(3)
  DataOffer get offer => $_getN(0);
  @$pb.TagNumber(3)
  set offer(DataOffer v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasOffer() => $_has(0);
  @$pb.TagNumber(3)
  void clearOffer() => clearField(3);
  @$pb.TagNumber(3)
  DataOffer ensureOffer() => $_ensure(0);

  @$pb.TagNumber(4)
  DataAccount get account => $_getN(1);
  @$pb.TagNumber(4)
  set account(DataAccount v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasAccount() => $_has(1);
  @$pb.TagNumber(4)
  void clearAccount() => clearField(4);
  @$pb.TagNumber(4)
  DataAccount ensureAccount() => $_ensure(1);

  @$pb.TagNumber(5)
  DataLocation get location => $_getN(2);
  @$pb.TagNumber(5)
  set location(DataLocation v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasLocation() => $_has(2);
  @$pb.TagNumber(5)
  void clearLocation() => clearField(5);
  @$pb.TagNumber(5)
  DataLocation ensureLocation() => $_ensure(2);

  @$pb.TagNumber(8)
  $fixnum.Int64 get clusterId => $_getI64(3);
  @$pb.TagNumber(8)
  set clusterId($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasClusterId() => $_has(3);
  @$pb.TagNumber(8)
  void clearClusterId() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get parentClusterIds => $_getI64(4);
  @$pb.TagNumber(9)
  set parentClusterIds($fixnum.Int64 v) {
    $_setInt64(4, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasParentClusterIds() => $_has(4);
  @$pb.TagNumber(9)
  void clearParentClusterIds() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get hiddenMarkers => $_getIZ(5);
  @$pb.TagNumber(10)
  set hiddenMarkers($core.int v) {
    $_setSignedInt32(5, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasHiddenMarkers() => $_has(5);
  @$pb.TagNumber(10)
  void clearHiddenMarkers() => clearField(10);
}

class DataProposal extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DataProposal',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'proposalId')
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'offerId')
    ..aInt64(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'influencerAccountId')
    ..aInt64(
        4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'termsChatId')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'businessWantsDeal')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'influencerWantsDeal')
    ..aOB(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'influencerMarkedDelivered')
    ..aOB(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'influencerMarkedRewarded')
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'businessMarkedDelivered')
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'businessMarkedRewarded')
    ..a<$core.int>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'businessGaveRating', $pb.PbFieldType.O3)
    ..a<$core.int>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'influencerGaveRating', $pb.PbFieldType.O3)
    ..e<$12.ProposalState>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: $12.ProposalState.proposing, valueOf: $12.ProposalState.valueOf, enumValues: $12.ProposalState.values)
    ..aOB(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'businessDisputed')
    ..aOB(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'influencerDisputed')
    ..aInt64(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'businessAccountId')
    ..aOS(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'influencerName')
    ..aOS(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'businessName')
    ..aOS(19, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'offerTitle')
    ..aInt64(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderAccountId')
    ..aInt64(22, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lastChatId')
    ..aInt64(23, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'influencerSeenChatId')
    ..aInt64(24, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'influencerSeenTime')
    ..aInt64(25, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'businessSeenChatId')
    ..aInt64(26, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'businessSeenTime')
    ..aInt64(27, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'offerAccountId')
    ..aOB(28, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'influencerArchived')
    ..aOB(29, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'businessArchived')
    ..aInt64(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rejectingAccountId')
    ..hasRequiredFields = false;

  DataProposal._() : super();
  factory DataProposal() => create();
  factory DataProposal.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DataProposal.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DataProposal clone() => DataProposal()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DataProposal copyWith(void Function(DataProposal) updates) =>
      super.copyWith((message) =>
          updates(message as DataProposal)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DataProposal create() => DataProposal._();
  DataProposal createEmptyInstance() => create();
  static $pb.PbList<DataProposal> createRepeated() =>
      $pb.PbList<DataProposal>();
  @$core.pragma('dart2js:noInline')
  static DataProposal getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DataProposal>(create);
  static DataProposal _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get proposalId => $_getI64(0);
  @$pb.TagNumber(1)
  set proposalId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProposalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposalId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get offerId => $_getI64(1);
  @$pb.TagNumber(2)
  set offerId($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasOfferId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOfferId() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get influencerAccountId => $_getI64(2);
  @$pb.TagNumber(3)
  set influencerAccountId($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasInfluencerAccountId() => $_has(2);
  @$pb.TagNumber(3)
  void clearInfluencerAccountId() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get termsChatId => $_getI64(3);
  @$pb.TagNumber(4)
  set termsChatId($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasTermsChatId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTermsChatId() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get businessWantsDeal => $_getBF(4);
  @$pb.TagNumber(5)
  set businessWantsDeal($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasBusinessWantsDeal() => $_has(4);
  @$pb.TagNumber(5)
  void clearBusinessWantsDeal() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get influencerWantsDeal => $_getBF(5);
  @$pb.TagNumber(6)
  set influencerWantsDeal($core.bool v) {
    $_setBool(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasInfluencerWantsDeal() => $_has(5);
  @$pb.TagNumber(6)
  void clearInfluencerWantsDeal() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get influencerMarkedDelivered => $_getBF(6);
  @$pb.TagNumber(7)
  set influencerMarkedDelivered($core.bool v) {
    $_setBool(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasInfluencerMarkedDelivered() => $_has(6);
  @$pb.TagNumber(7)
  void clearInfluencerMarkedDelivered() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get influencerMarkedRewarded => $_getBF(7);
  @$pb.TagNumber(8)
  set influencerMarkedRewarded($core.bool v) {
    $_setBool(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasInfluencerMarkedRewarded() => $_has(7);
  @$pb.TagNumber(8)
  void clearInfluencerMarkedRewarded() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get businessMarkedDelivered => $_getBF(8);
  @$pb.TagNumber(9)
  set businessMarkedDelivered($core.bool v) {
    $_setBool(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasBusinessMarkedDelivered() => $_has(8);
  @$pb.TagNumber(9)
  void clearBusinessMarkedDelivered() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get businessMarkedRewarded => $_getBF(9);
  @$pb.TagNumber(10)
  set businessMarkedRewarded($core.bool v) {
    $_setBool(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasBusinessMarkedRewarded() => $_has(9);
  @$pb.TagNumber(10)
  void clearBusinessMarkedRewarded() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get businessGaveRating => $_getIZ(10);
  @$pb.TagNumber(11)
  set businessGaveRating($core.int v) {
    $_setSignedInt32(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasBusinessGaveRating() => $_has(10);
  @$pb.TagNumber(11)
  void clearBusinessGaveRating() => clearField(11);

  @$pb.TagNumber(12)
  $core.int get influencerGaveRating => $_getIZ(11);
  @$pb.TagNumber(12)
  set influencerGaveRating($core.int v) {
    $_setSignedInt32(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasInfluencerGaveRating() => $_has(11);
  @$pb.TagNumber(12)
  void clearInfluencerGaveRating() => clearField(12);

  @$pb.TagNumber(13)
  $12.ProposalState get state => $_getN(12);
  @$pb.TagNumber(13)
  set state($12.ProposalState v) {
    setField(13, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasState() => $_has(12);
  @$pb.TagNumber(13)
  void clearState() => clearField(13);

  @$pb.TagNumber(14)
  $core.bool get businessDisputed => $_getBF(13);
  @$pb.TagNumber(14)
  set businessDisputed($core.bool v) {
    $_setBool(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasBusinessDisputed() => $_has(13);
  @$pb.TagNumber(14)
  void clearBusinessDisputed() => clearField(14);

  @$pb.TagNumber(15)
  $core.bool get influencerDisputed => $_getBF(14);
  @$pb.TagNumber(15)
  set influencerDisputed($core.bool v) {
    $_setBool(14, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasInfluencerDisputed() => $_has(14);
  @$pb.TagNumber(15)
  void clearInfluencerDisputed() => clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get businessAccountId => $_getI64(15);
  @$pb.TagNumber(16)
  set businessAccountId($fixnum.Int64 v) {
    $_setInt64(15, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasBusinessAccountId() => $_has(15);
  @$pb.TagNumber(16)
  void clearBusinessAccountId() => clearField(16);

  @$pb.TagNumber(17)
  $core.String get influencerName => $_getSZ(16);
  @$pb.TagNumber(17)
  set influencerName($core.String v) {
    $_setString(16, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasInfluencerName() => $_has(16);
  @$pb.TagNumber(17)
  void clearInfluencerName() => clearField(17);

  @$pb.TagNumber(18)
  $core.String get businessName => $_getSZ(17);
  @$pb.TagNumber(18)
  set businessName($core.String v) {
    $_setString(17, v);
  }

  @$pb.TagNumber(18)
  $core.bool hasBusinessName() => $_has(17);
  @$pb.TagNumber(18)
  void clearBusinessName() => clearField(18);

  @$pb.TagNumber(19)
  $core.String get offerTitle => $_getSZ(18);
  @$pb.TagNumber(19)
  set offerTitle($core.String v) {
    $_setString(18, v);
  }

  @$pb.TagNumber(19)
  $core.bool hasOfferTitle() => $_has(18);
  @$pb.TagNumber(19)
  void clearOfferTitle() => clearField(19);

  @$pb.TagNumber(20)
  $fixnum.Int64 get senderAccountId => $_getI64(19);
  @$pb.TagNumber(20)
  set senderAccountId($fixnum.Int64 v) {
    $_setInt64(19, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasSenderAccountId() => $_has(19);
  @$pb.TagNumber(20)
  void clearSenderAccountId() => clearField(20);

  @$pb.TagNumber(22)
  $fixnum.Int64 get lastChatId => $_getI64(20);
  @$pb.TagNumber(22)
  set lastChatId($fixnum.Int64 v) {
    $_setInt64(20, v);
  }

  @$pb.TagNumber(22)
  $core.bool hasLastChatId() => $_has(20);
  @$pb.TagNumber(22)
  void clearLastChatId() => clearField(22);

  @$pb.TagNumber(23)
  $fixnum.Int64 get influencerSeenChatId => $_getI64(21);
  @$pb.TagNumber(23)
  set influencerSeenChatId($fixnum.Int64 v) {
    $_setInt64(21, v);
  }

  @$pb.TagNumber(23)
  $core.bool hasInfluencerSeenChatId() => $_has(21);
  @$pb.TagNumber(23)
  void clearInfluencerSeenChatId() => clearField(23);

  @$pb.TagNumber(24)
  $fixnum.Int64 get influencerSeenTime => $_getI64(22);
  @$pb.TagNumber(24)
  set influencerSeenTime($fixnum.Int64 v) {
    $_setInt64(22, v);
  }

  @$pb.TagNumber(24)
  $core.bool hasInfluencerSeenTime() => $_has(22);
  @$pb.TagNumber(24)
  void clearInfluencerSeenTime() => clearField(24);

  @$pb.TagNumber(25)
  $fixnum.Int64 get businessSeenChatId => $_getI64(23);
  @$pb.TagNumber(25)
  set businessSeenChatId($fixnum.Int64 v) {
    $_setInt64(23, v);
  }

  @$pb.TagNumber(25)
  $core.bool hasBusinessSeenChatId() => $_has(23);
  @$pb.TagNumber(25)
  void clearBusinessSeenChatId() => clearField(25);

  @$pb.TagNumber(26)
  $fixnum.Int64 get businessSeenTime => $_getI64(24);
  @$pb.TagNumber(26)
  set businessSeenTime($fixnum.Int64 v) {
    $_setInt64(24, v);
  }

  @$pb.TagNumber(26)
  $core.bool hasBusinessSeenTime() => $_has(24);
  @$pb.TagNumber(26)
  void clearBusinessSeenTime() => clearField(26);

  @$pb.TagNumber(27)
  $fixnum.Int64 get offerAccountId => $_getI64(25);
  @$pb.TagNumber(27)
  set offerAccountId($fixnum.Int64 v) {
    $_setInt64(25, v);
  }

  @$pb.TagNumber(27)
  $core.bool hasOfferAccountId() => $_has(25);
  @$pb.TagNumber(27)
  void clearOfferAccountId() => clearField(27);

  @$pb.TagNumber(28)
  $core.bool get influencerArchived => $_getBF(26);
  @$pb.TagNumber(28)
  set influencerArchived($core.bool v) {
    $_setBool(26, v);
  }

  @$pb.TagNumber(28)
  $core.bool hasInfluencerArchived() => $_has(26);
  @$pb.TagNumber(28)
  void clearInfluencerArchived() => clearField(28);

  @$pb.TagNumber(29)
  $core.bool get businessArchived => $_getBF(27);
  @$pb.TagNumber(29)
  set businessArchived($core.bool v) {
    $_setBool(27, v);
  }

  @$pb.TagNumber(29)
  $core.bool hasBusinessArchived() => $_has(27);
  @$pb.TagNumber(29)
  void clearBusinessArchived() => clearField(29);

  @$pb.TagNumber(30)
  $fixnum.Int64 get rejectingAccountId => $_getI64(28);
  @$pb.TagNumber(30)
  set rejectingAccountId($fixnum.Int64 v) {
    $_setInt64(28, v);
  }

  @$pb.TagNumber(30)
  $core.bool hasRejectingAccountId() => $_has(28);
  @$pb.TagNumber(30)
  void clearRejectingAccountId() => clearField(30);
}

class DataProposalChat extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DataProposalChat',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'proposalId')
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'senderAccountId')
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'plainText')
    ..a<$core.int>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderSessionGhostId',
        $pb.PbFieldType.O3)
    ..aInt64(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chatId')
    ..e<$12.ProposalChatType>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: $12.ProposalChatType.plain, valueOf: $12.ProposalChatType.valueOf, enumValues: $12.ProposalChatType.values)
    ..aInt64(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sent')
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderSessionId')
    ..aOM<DataTerms>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'terms', subBuilder: DataTerms.create)
    ..aOS(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'imageKey')
    ..aOS(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'imageUrl')
    ..a<$core.List<$core.int>>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'imageBlurred', $pb.PbFieldType.OY)
    ..e<$12.ProposalChatMarker>(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'marker', $pb.PbFieldType.OE, defaultOrMaker: $12.ProposalChatMarker.applied, valueOf: $12.ProposalChatMarker.valueOf, enumValues: $12.ProposalChatMarker.values)
    ..hasRequiredFields = false;

  DataProposalChat._() : super();
  factory DataProposalChat() => create();
  factory DataProposalChat.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DataProposalChat.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DataProposalChat clone() => DataProposalChat()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DataProposalChat copyWith(void Function(DataProposalChat) updates) =>
      super.copyWith((message) => updates(
          message as DataProposalChat)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DataProposalChat create() => DataProposalChat._();
  DataProposalChat createEmptyInstance() => create();
  static $pb.PbList<DataProposalChat> createRepeated() =>
      $pb.PbList<DataProposalChat>();
  @$core.pragma('dart2js:noInline')
  static DataProposalChat getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DataProposalChat>(create);
  static DataProposalChat _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get proposalId => $_getI64(0);
  @$pb.TagNumber(1)
  set proposalId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProposalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposalId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get senderAccountId => $_getI64(1);
  @$pb.TagNumber(2)
  set senderAccountId($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSenderAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSenderAccountId() => clearField(2);

  @$pb.TagNumber(5)
  $core.String get plainText => $_getSZ(2);
  @$pb.TagNumber(5)
  set plainText($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPlainText() => $_has(2);
  @$pb.TagNumber(5)
  void clearPlainText() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get senderSessionGhostId => $_getIZ(3);
  @$pb.TagNumber(6)
  set senderSessionGhostId($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasSenderSessionGhostId() => $_has(3);
  @$pb.TagNumber(6)
  void clearSenderSessionGhostId() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get chatId => $_getI64(4);
  @$pb.TagNumber(7)
  set chatId($fixnum.Int64 v) {
    $_setInt64(4, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasChatId() => $_has(4);
  @$pb.TagNumber(7)
  void clearChatId() => clearField(7);

  @$pb.TagNumber(8)
  $12.ProposalChatType get type => $_getN(5);
  @$pb.TagNumber(8)
  set type($12.ProposalChatType v) {
    setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasType() => $_has(5);
  @$pb.TagNumber(8)
  void clearType() => clearField(8);

  @$pb.TagNumber(10)
  $fixnum.Int64 get sent => $_getI64(6);
  @$pb.TagNumber(10)
  set sent($fixnum.Int64 v) {
    $_setInt64(6, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasSent() => $_has(6);
  @$pb.TagNumber(10)
  void clearSent() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get senderSessionId => $_getI64(7);
  @$pb.TagNumber(11)
  set senderSessionId($fixnum.Int64 v) {
    $_setInt64(7, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasSenderSessionId() => $_has(7);
  @$pb.TagNumber(11)
  void clearSenderSessionId() => clearField(11);

  @$pb.TagNumber(12)
  DataTerms get terms => $_getN(8);
  @$pb.TagNumber(12)
  set terms(DataTerms v) {
    setField(12, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasTerms() => $_has(8);
  @$pb.TagNumber(12)
  void clearTerms() => clearField(12);
  @$pb.TagNumber(12)
  DataTerms ensureTerms() => $_ensure(8);

  @$pb.TagNumber(13)
  $core.String get imageKey => $_getSZ(9);
  @$pb.TagNumber(13)
  set imageKey($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasImageKey() => $_has(9);
  @$pb.TagNumber(13)
  void clearImageKey() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get imageUrl => $_getSZ(10);
  @$pb.TagNumber(14)
  set imageUrl($core.String v) {
    $_setString(10, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasImageUrl() => $_has(10);
  @$pb.TagNumber(14)
  void clearImageUrl() => clearField(14);

  @$pb.TagNumber(15)
  $core.List<$core.int> get imageBlurred => $_getN(11);
  @$pb.TagNumber(15)
  set imageBlurred($core.List<$core.int> v) {
    $_setBytes(11, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasImageBlurred() => $_has(11);
  @$pb.TagNumber(15)
  void clearImageBlurred() => clearField(15);

  @$pb.TagNumber(16)
  $12.ProposalChatMarker get marker => $_getN(12);
  @$pb.TagNumber(16)
  set marker($12.ProposalChatMarker v) {
    setField(16, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasMarker() => $_has(12);
  @$pb.TagNumber(16)
  void clearMarker() => clearField(16);
}
