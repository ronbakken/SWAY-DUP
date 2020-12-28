///
//  Generated code. Do not modify.
//  source: config_protobuf.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'enum_protobuf.pbenum.dart' as $12;

class ConfigSubCategories extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ConfigSubCategories',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..pPS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'labels')
    ..hasRequiredFields = false;

  ConfigSubCategories._() : super();
  factory ConfigSubCategories() => create();
  factory ConfigSubCategories.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ConfigSubCategories.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ConfigSubCategories clone() => ConfigSubCategories()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ConfigSubCategories copyWith(void Function(ConfigSubCategories) updates) =>
      super.copyWith((message) => updates(
          message as ConfigSubCategories)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConfigSubCategories create() => ConfigSubCategories._();
  ConfigSubCategories createEmptyInstance() => create();
  static $pb.PbList<ConfigSubCategories> createRepeated() =>
      $pb.PbList<ConfigSubCategories>();
  @$core.pragma('dart2js:noInline')
  static ConfigSubCategories getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigSubCategories>(create);
  static ConfigSubCategories _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get labels => $_getList(0);
}

class ConfigOAuthProvider extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ConfigOAuthProvider',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOB(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'visible')
    ..aOB(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'canAlwaysAuthenticate')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'label')
    ..aOS(
        4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'host')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'requestTokenUrl')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'authenticateUrl')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'authUrl')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'authQuery')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'callbackUrl', protoName: 'callbackUrl')
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'consumerKey')
    ..aOS(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'consumerSecret')
    ..aOS(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clientId')
    ..a<$core.int>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fontAwesomeBrand', $pb.PbFieldType.O3)
    ..e<$12.OAuthMechanism>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mechanism', $pb.PbFieldType.OE, defaultOrMaker: $12.OAuthMechanism.none, valueOf: $12.OAuthMechanism.valueOf, enumValues: $12.OAuthMechanism.values)
    ..aOS(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accessTokenUrl')
    ..aOS(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clientSecret')
    ..pPS(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'whitelistHosts')
    ..aOB(19, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'canConnect')
    ..aOB(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'showInProfile')
    ..aOB(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clientIdExposed')
    ..aOB(22, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'consumerKeyExposed')
    ..aOB(23, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'consumerSecretExposed')
    ..pPS(25, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'keywords')
    ..a<$core.int>(26, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'foregroundColor', $pb.PbFieldType.O3)
    ..a<$core.int>(27, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backgroundColor', $pb.PbFieldType.O3)
    ..a<$core.int>(28, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'foregroundImageId', $pb.PbFieldType.O3)
    ..a<$core.int>(29, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backgroundImageId', $pb.PbFieldType.O3)
    ..a<$core.int>(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'monochromeForegroundImageId', $pb.PbFieldType.O3)
    ..a<$core.int>(31, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'monochromeBackgroundImageId', $pb.PbFieldType.O3)
    ..a<$core.int>(32, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sorting', $pb.PbFieldType.O3)
    ..aOS(33, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..a<$core.int>(34, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'deliverablesChannel', $pb.PbFieldType.O3)
    ..a<$core.int>(35, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'providerId', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(36, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'foregroundImage', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(37, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backgroundImage', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(38, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'monochromeForegroundImage', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(39, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'monochromeBackgroundImage', $pb.PbFieldType.OY)
    ..aOS(40, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'authenticateQuery')
    ..hasRequiredFields = false;

  ConfigOAuthProvider._() : super();
  factory ConfigOAuthProvider() => create();
  factory ConfigOAuthProvider.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ConfigOAuthProvider.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ConfigOAuthProvider clone() => ConfigOAuthProvider()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ConfigOAuthProvider copyWith(void Function(ConfigOAuthProvider) updates) =>
      super.copyWith((message) => updates(
          message as ConfigOAuthProvider)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConfigOAuthProvider create() => ConfigOAuthProvider._();
  ConfigOAuthProvider createEmptyInstance() => create();
  static $pb.PbList<ConfigOAuthProvider> createRepeated() =>
      $pb.PbList<ConfigOAuthProvider>();
  @$core.pragma('dart2js:noInline')
  static ConfigOAuthProvider getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigOAuthProvider>(create);
  static ConfigOAuthProvider _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get visible => $_getBF(0);
  @$pb.TagNumber(1)
  set visible($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasVisible() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisible() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get canAlwaysAuthenticate => $_getBF(1);
  @$pb.TagNumber(2)
  set canAlwaysAuthenticate($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCanAlwaysAuthenticate() => $_has(1);
  @$pb.TagNumber(2)
  void clearCanAlwaysAuthenticate() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get label => $_getSZ(2);
  @$pb.TagNumber(3)
  set label($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasLabel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLabel() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get host => $_getSZ(3);
  @$pb.TagNumber(4)
  set host($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasHost() => $_has(3);
  @$pb.TagNumber(4)
  void clearHost() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get requestTokenUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set requestTokenUrl($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasRequestTokenUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearRequestTokenUrl() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get authenticateUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set authenticateUrl($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasAuthenticateUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearAuthenticateUrl() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get authUrl => $_getSZ(6);
  @$pb.TagNumber(7)
  set authUrl($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasAuthUrl() => $_has(6);
  @$pb.TagNumber(7)
  void clearAuthUrl() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get authQuery => $_getSZ(7);
  @$pb.TagNumber(8)
  set authQuery($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasAuthQuery() => $_has(7);
  @$pb.TagNumber(8)
  void clearAuthQuery() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get callbackUrl => $_getSZ(8);
  @$pb.TagNumber(9)
  set callbackUrl($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasCallbackUrl() => $_has(8);
  @$pb.TagNumber(9)
  void clearCallbackUrl() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get consumerKey => $_getSZ(9);
  @$pb.TagNumber(10)
  set consumerKey($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasConsumerKey() => $_has(9);
  @$pb.TagNumber(10)
  void clearConsumerKey() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get consumerSecret => $_getSZ(10);
  @$pb.TagNumber(11)
  set consumerSecret($core.String v) {
    $_setString(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasConsumerSecret() => $_has(10);
  @$pb.TagNumber(11)
  void clearConsumerSecret() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get clientId => $_getSZ(11);
  @$pb.TagNumber(12)
  set clientId($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasClientId() => $_has(11);
  @$pb.TagNumber(12)
  void clearClientId() => clearField(12);

  @$pb.TagNumber(14)
  $core.int get fontAwesomeBrand => $_getIZ(12);
  @$pb.TagNumber(14)
  set fontAwesomeBrand($core.int v) {
    $_setSignedInt32(12, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasFontAwesomeBrand() => $_has(12);
  @$pb.TagNumber(14)
  void clearFontAwesomeBrand() => clearField(14);

  @$pb.TagNumber(15)
  $12.OAuthMechanism get mechanism => $_getN(13);
  @$pb.TagNumber(15)
  set mechanism($12.OAuthMechanism v) {
    setField(15, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasMechanism() => $_has(13);
  @$pb.TagNumber(15)
  void clearMechanism() => clearField(15);

  @$pb.TagNumber(16)
  $core.String get accessTokenUrl => $_getSZ(14);
  @$pb.TagNumber(16)
  set accessTokenUrl($core.String v) {
    $_setString(14, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasAccessTokenUrl() => $_has(14);
  @$pb.TagNumber(16)
  void clearAccessTokenUrl() => clearField(16);

  @$pb.TagNumber(17)
  $core.String get clientSecret => $_getSZ(15);
  @$pb.TagNumber(17)
  set clientSecret($core.String v) {
    $_setString(15, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasClientSecret() => $_has(15);
  @$pb.TagNumber(17)
  void clearClientSecret() => clearField(17);

  @$pb.TagNumber(18)
  $core.List<$core.String> get whitelistHosts => $_getList(16);

  @$pb.TagNumber(19)
  $core.bool get canConnect => $_getBF(17);
  @$pb.TagNumber(19)
  set canConnect($core.bool v) {
    $_setBool(17, v);
  }

  @$pb.TagNumber(19)
  $core.bool hasCanConnect() => $_has(17);
  @$pb.TagNumber(19)
  void clearCanConnect() => clearField(19);

  @$pb.TagNumber(20)
  $core.bool get showInProfile => $_getBF(18);
  @$pb.TagNumber(20)
  set showInProfile($core.bool v) {
    $_setBool(18, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasShowInProfile() => $_has(18);
  @$pb.TagNumber(20)
  void clearShowInProfile() => clearField(20);

  @$pb.TagNumber(21)
  $core.bool get clientIdExposed => $_getBF(19);
  @$pb.TagNumber(21)
  set clientIdExposed($core.bool v) {
    $_setBool(19, v);
  }

  @$pb.TagNumber(21)
  $core.bool hasClientIdExposed() => $_has(19);
  @$pb.TagNumber(21)
  void clearClientIdExposed() => clearField(21);

  @$pb.TagNumber(22)
  $core.bool get consumerKeyExposed => $_getBF(20);
  @$pb.TagNumber(22)
  set consumerKeyExposed($core.bool v) {
    $_setBool(20, v);
  }

  @$pb.TagNumber(22)
  $core.bool hasConsumerKeyExposed() => $_has(20);
  @$pb.TagNumber(22)
  void clearConsumerKeyExposed() => clearField(22);

  @$pb.TagNumber(23)
  $core.bool get consumerSecretExposed => $_getBF(21);
  @$pb.TagNumber(23)
  set consumerSecretExposed($core.bool v) {
    $_setBool(21, v);
  }

  @$pb.TagNumber(23)
  $core.bool hasConsumerSecretExposed() => $_has(21);
  @$pb.TagNumber(23)
  void clearConsumerSecretExposed() => clearField(23);

  @$pb.TagNumber(25)
  $core.List<$core.String> get keywords => $_getList(22);

  @$pb.TagNumber(26)
  $core.int get foregroundColor => $_getIZ(23);
  @$pb.TagNumber(26)
  set foregroundColor($core.int v) {
    $_setSignedInt32(23, v);
  }

  @$pb.TagNumber(26)
  $core.bool hasForegroundColor() => $_has(23);
  @$pb.TagNumber(26)
  void clearForegroundColor() => clearField(26);

  @$pb.TagNumber(27)
  $core.int get backgroundColor => $_getIZ(24);
  @$pb.TagNumber(27)
  set backgroundColor($core.int v) {
    $_setSignedInt32(24, v);
  }

  @$pb.TagNumber(27)
  $core.bool hasBackgroundColor() => $_has(24);
  @$pb.TagNumber(27)
  void clearBackgroundColor() => clearField(27);

  @$pb.TagNumber(28)
  $core.int get foregroundImageId => $_getIZ(25);
  @$pb.TagNumber(28)
  set foregroundImageId($core.int v) {
    $_setSignedInt32(25, v);
  }

  @$pb.TagNumber(28)
  $core.bool hasForegroundImageId() => $_has(25);
  @$pb.TagNumber(28)
  void clearForegroundImageId() => clearField(28);

  @$pb.TagNumber(29)
  $core.int get backgroundImageId => $_getIZ(26);
  @$pb.TagNumber(29)
  set backgroundImageId($core.int v) {
    $_setSignedInt32(26, v);
  }

  @$pb.TagNumber(29)
  $core.bool hasBackgroundImageId() => $_has(26);
  @$pb.TagNumber(29)
  void clearBackgroundImageId() => clearField(29);

  @$pb.TagNumber(30)
  $core.int get monochromeForegroundImageId => $_getIZ(27);
  @$pb.TagNumber(30)
  set monochromeForegroundImageId($core.int v) {
    $_setSignedInt32(27, v);
  }

  @$pb.TagNumber(30)
  $core.bool hasMonochromeForegroundImageId() => $_has(27);
  @$pb.TagNumber(30)
  void clearMonochromeForegroundImageId() => clearField(30);

  @$pb.TagNumber(31)
  $core.int get monochromeBackgroundImageId => $_getIZ(28);
  @$pb.TagNumber(31)
  set monochromeBackgroundImageId($core.int v) {
    $_setSignedInt32(28, v);
  }

  @$pb.TagNumber(31)
  $core.bool hasMonochromeBackgroundImageId() => $_has(28);
  @$pb.TagNumber(31)
  void clearMonochromeBackgroundImageId() => clearField(31);

  @$pb.TagNumber(32)
  $core.int get sorting => $_getIZ(29);
  @$pb.TagNumber(32)
  set sorting($core.int v) {
    $_setSignedInt32(29, v);
  }

  @$pb.TagNumber(32)
  $core.bool hasSorting() => $_has(29);
  @$pb.TagNumber(32)
  void clearSorting() => clearField(32);

  @$pb.TagNumber(33)
  $core.String get key => $_getSZ(30);
  @$pb.TagNumber(33)
  set key($core.String v) {
    $_setString(30, v);
  }

  @$pb.TagNumber(33)
  $core.bool hasKey() => $_has(30);
  @$pb.TagNumber(33)
  void clearKey() => clearField(33);

  @$pb.TagNumber(34)
  $core.int get deliverablesChannel => $_getIZ(31);
  @$pb.TagNumber(34)
  set deliverablesChannel($core.int v) {
    $_setSignedInt32(31, v);
  }

  @$pb.TagNumber(34)
  $core.bool hasDeliverablesChannel() => $_has(31);
  @$pb.TagNumber(34)
  void clearDeliverablesChannel() => clearField(34);

  @$pb.TagNumber(35)
  $core.int get providerId => $_getIZ(32);
  @$pb.TagNumber(35)
  set providerId($core.int v) {
    $_setSignedInt32(32, v);
  }

  @$pb.TagNumber(35)
  $core.bool hasProviderId() => $_has(32);
  @$pb.TagNumber(35)
  void clearProviderId() => clearField(35);

  @$pb.TagNumber(36)
  $core.List<$core.int> get foregroundImage => $_getN(33);
  @$pb.TagNumber(36)
  set foregroundImage($core.List<$core.int> v) {
    $_setBytes(33, v);
  }

  @$pb.TagNumber(36)
  $core.bool hasForegroundImage() => $_has(33);
  @$pb.TagNumber(36)
  void clearForegroundImage() => clearField(36);

  @$pb.TagNumber(37)
  $core.List<$core.int> get backgroundImage => $_getN(34);
  @$pb.TagNumber(37)
  set backgroundImage($core.List<$core.int> v) {
    $_setBytes(34, v);
  }

  @$pb.TagNumber(37)
  $core.bool hasBackgroundImage() => $_has(34);
  @$pb.TagNumber(37)
  void clearBackgroundImage() => clearField(37);

  @$pb.TagNumber(38)
  $core.List<$core.int> get monochromeForegroundImage => $_getN(35);
  @$pb.TagNumber(38)
  set monochromeForegroundImage($core.List<$core.int> v) {
    $_setBytes(35, v);
  }

  @$pb.TagNumber(38)
  $core.bool hasMonochromeForegroundImage() => $_has(35);
  @$pb.TagNumber(38)
  void clearMonochromeForegroundImage() => clearField(38);

  @$pb.TagNumber(39)
  $core.List<$core.int> get monochromeBackgroundImage => $_getN(36);
  @$pb.TagNumber(39)
  set monochromeBackgroundImage($core.List<$core.int> v) {
    $_setBytes(36, v);
  }

  @$pb.TagNumber(39)
  $core.bool hasMonochromeBackgroundImage() => $_has(36);
  @$pb.TagNumber(39)
  void clearMonochromeBackgroundImage() => clearField(39);

  @$pb.TagNumber(40)
  $core.String get authenticateQuery => $_getSZ(37);
  @$pb.TagNumber(40)
  set authenticateQuery($core.String v) {
    $_setString(37, v);
  }

  @$pb.TagNumber(40)
  $core.bool hasAuthenticateQuery() => $_has(37);
  @$pb.TagNumber(40)
  void clearAuthenticateQuery() => clearField(40);
}

class ConfigContentFormat extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ConfigContentFormat',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..pPS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'keywords')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'label')
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'sorting',
        $pb.PbFieldType.O3)
    ..a<$core.int>(
        4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fontAwesomeIcon', $pb.PbFieldType.O3)
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'foregroundColor', $pb.PbFieldType.O3)
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backgroundColor', $pb.PbFieldType.O3)
    ..a<$core.int>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'foregroundImageId', $pb.PbFieldType.O3)
    ..a<$core.int>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backgroundImageId', $pb.PbFieldType.O3)
    ..a<$core.int>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'monochromeForegroundImageId', $pb.PbFieldType.O3)
    ..a<$core.int>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'monochromeBackgroundImageId', $pb.PbFieldType.O3)
    ..a<$core.int>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'formatId', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'foregroundImage', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backgroundImage', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'monochromeForegroundImage', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'monochromeBackgroundImage', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  ConfigContentFormat._() : super();
  factory ConfigContentFormat() => create();
  factory ConfigContentFormat.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ConfigContentFormat.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ConfigContentFormat clone() => ConfigContentFormat()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ConfigContentFormat copyWith(void Function(ConfigContentFormat) updates) =>
      super.copyWith((message) => updates(
          message as ConfigContentFormat)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConfigContentFormat create() => ConfigContentFormat._();
  ConfigContentFormat createEmptyInstance() => create();
  static $pb.PbList<ConfigContentFormat> createRepeated() =>
      $pb.PbList<ConfigContentFormat>();
  @$core.pragma('dart2js:noInline')
  static ConfigContentFormat getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigContentFormat>(create);
  static ConfigContentFormat _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get keywords => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get sorting => $_getIZ(2);
  @$pb.TagNumber(3)
  set sorting($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSorting() => $_has(2);
  @$pb.TagNumber(3)
  void clearSorting() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get fontAwesomeIcon => $_getIZ(3);
  @$pb.TagNumber(4)
  set fontAwesomeIcon($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasFontAwesomeIcon() => $_has(3);
  @$pb.TagNumber(4)
  void clearFontAwesomeIcon() => clearField(4);

  @$pb.TagNumber(6)
  $core.int get foregroundColor => $_getIZ(4);
  @$pb.TagNumber(6)
  set foregroundColor($core.int v) {
    $_setSignedInt32(4, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasForegroundColor() => $_has(4);
  @$pb.TagNumber(6)
  void clearForegroundColor() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get backgroundColor => $_getIZ(5);
  @$pb.TagNumber(7)
  set backgroundColor($core.int v) {
    $_setSignedInt32(5, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasBackgroundColor() => $_has(5);
  @$pb.TagNumber(7)
  void clearBackgroundColor() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get foregroundImageId => $_getIZ(6);
  @$pb.TagNumber(8)
  set foregroundImageId($core.int v) {
    $_setSignedInt32(6, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasForegroundImageId() => $_has(6);
  @$pb.TagNumber(8)
  void clearForegroundImageId() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get backgroundImageId => $_getIZ(7);
  @$pb.TagNumber(9)
  set backgroundImageId($core.int v) {
    $_setSignedInt32(7, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasBackgroundImageId() => $_has(7);
  @$pb.TagNumber(9)
  void clearBackgroundImageId() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get monochromeForegroundImageId => $_getIZ(8);
  @$pb.TagNumber(10)
  set monochromeForegroundImageId($core.int v) {
    $_setSignedInt32(8, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasMonochromeForegroundImageId() => $_has(8);
  @$pb.TagNumber(10)
  void clearMonochromeForegroundImageId() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get monochromeBackgroundImageId => $_getIZ(9);
  @$pb.TagNumber(11)
  set monochromeBackgroundImageId($core.int v) {
    $_setSignedInt32(9, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasMonochromeBackgroundImageId() => $_has(9);
  @$pb.TagNumber(11)
  void clearMonochromeBackgroundImageId() => clearField(11);

  @$pb.TagNumber(12)
  $core.int get formatId => $_getIZ(10);
  @$pb.TagNumber(12)
  set formatId($core.int v) {
    $_setSignedInt32(10, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasFormatId() => $_has(10);
  @$pb.TagNumber(12)
  void clearFormatId() => clearField(12);

  @$pb.TagNumber(14)
  $core.List<$core.int> get foregroundImage => $_getN(11);
  @$pb.TagNumber(14)
  set foregroundImage($core.List<$core.int> v) {
    $_setBytes(11, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasForegroundImage() => $_has(11);
  @$pb.TagNumber(14)
  void clearForegroundImage() => clearField(14);

  @$pb.TagNumber(15)
  $core.List<$core.int> get backgroundImage => $_getN(12);
  @$pb.TagNumber(15)
  set backgroundImage($core.List<$core.int> v) {
    $_setBytes(12, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasBackgroundImage() => $_has(12);
  @$pb.TagNumber(15)
  void clearBackgroundImage() => clearField(15);

  @$pb.TagNumber(16)
  $core.List<$core.int> get monochromeForegroundImage => $_getN(13);
  @$pb.TagNumber(16)
  set monochromeForegroundImage($core.List<$core.int> v) {
    $_setBytes(13, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasMonochromeForegroundImage() => $_has(13);
  @$pb.TagNumber(16)
  void clearMonochromeForegroundImage() => clearField(16);

  @$pb.TagNumber(17)
  $core.List<$core.int> get monochromeBackgroundImage => $_getN(14);
  @$pb.TagNumber(17)
  set monochromeBackgroundImage($core.List<$core.int> v) {
    $_setBytes(14, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasMonochromeBackgroundImage() => $_has(14);
  @$pb.TagNumber(17)
  void clearMonochromeBackgroundImage() => clearField(17);
}

class ConfigCategory extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ConfigCategory',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..pPS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'keywords')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'label')
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'sorting',
        $pb.PbFieldType.O3)
    ..a<$core.int>(
        4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fontAwesomeIcon', $pb.PbFieldType.O3)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'parentId', $pb.PbFieldType.O3)
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'foregroundColor', $pb.PbFieldType.O3)
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backgroundColor', $pb.PbFieldType.O3)
    ..a<$core.int>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'foregroundImageId', $pb.PbFieldType.O3)
    ..a<$core.int>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backgroundImageId', $pb.PbFieldType.O3)
    ..a<$core.int>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'monochromeForegroundImageId', $pb.PbFieldType.O3)
    ..a<$core.int>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'monochromeBackgroundImageId', $pb.PbFieldType.O3)
    ..p<$core.int>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'childIds', $pb.PbFieldType.P3)
    ..a<$core.int>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'categoryId', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'foregroundImage', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backgroundImage', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'monochromeForegroundImage', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'monochromeBackgroundImage', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  ConfigCategory._() : super();
  factory ConfigCategory() => create();
  factory ConfigCategory.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ConfigCategory.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ConfigCategory clone() => ConfigCategory()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ConfigCategory copyWith(void Function(ConfigCategory) updates) =>
      super.copyWith((message) =>
          updates(message as ConfigCategory)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConfigCategory create() => ConfigCategory._();
  ConfigCategory createEmptyInstance() => create();
  static $pb.PbList<ConfigCategory> createRepeated() =>
      $pb.PbList<ConfigCategory>();
  @$core.pragma('dart2js:noInline')
  static ConfigCategory getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigCategory>(create);
  static ConfigCategory _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get keywords => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get sorting => $_getIZ(2);
  @$pb.TagNumber(3)
  set sorting($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSorting() => $_has(2);
  @$pb.TagNumber(3)
  void clearSorting() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get fontAwesomeIcon => $_getIZ(3);
  @$pb.TagNumber(4)
  set fontAwesomeIcon($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasFontAwesomeIcon() => $_has(3);
  @$pb.TagNumber(4)
  void clearFontAwesomeIcon() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get parentId => $_getIZ(4);
  @$pb.TagNumber(5)
  set parentId($core.int v) {
    $_setSignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasParentId() => $_has(4);
  @$pb.TagNumber(5)
  void clearParentId() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get foregroundColor => $_getIZ(5);
  @$pb.TagNumber(6)
  set foregroundColor($core.int v) {
    $_setSignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasForegroundColor() => $_has(5);
  @$pb.TagNumber(6)
  void clearForegroundColor() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get backgroundColor => $_getIZ(6);
  @$pb.TagNumber(7)
  set backgroundColor($core.int v) {
    $_setSignedInt32(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasBackgroundColor() => $_has(6);
  @$pb.TagNumber(7)
  void clearBackgroundColor() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get foregroundImageId => $_getIZ(7);
  @$pb.TagNumber(8)
  set foregroundImageId($core.int v) {
    $_setSignedInt32(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasForegroundImageId() => $_has(7);
  @$pb.TagNumber(8)
  void clearForegroundImageId() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get backgroundImageId => $_getIZ(8);
  @$pb.TagNumber(9)
  set backgroundImageId($core.int v) {
    $_setSignedInt32(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasBackgroundImageId() => $_has(8);
  @$pb.TagNumber(9)
  void clearBackgroundImageId() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get monochromeForegroundImageId => $_getIZ(9);
  @$pb.TagNumber(10)
  set monochromeForegroundImageId($core.int v) {
    $_setSignedInt32(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasMonochromeForegroundImageId() => $_has(9);
  @$pb.TagNumber(10)
  void clearMonochromeForegroundImageId() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get monochromeBackgroundImageId => $_getIZ(10);
  @$pb.TagNumber(11)
  set monochromeBackgroundImageId($core.int v) {
    $_setSignedInt32(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasMonochromeBackgroundImageId() => $_has(10);
  @$pb.TagNumber(11)
  void clearMonochromeBackgroundImageId() => clearField(11);

  @$pb.TagNumber(12)
  $core.List<$core.int> get childIds => $_getList(11);

  @$pb.TagNumber(13)
  $core.int get categoryId => $_getIZ(12);
  @$pb.TagNumber(13)
  set categoryId($core.int v) {
    $_setSignedInt32(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasCategoryId() => $_has(12);
  @$pb.TagNumber(13)
  void clearCategoryId() => clearField(13);

  @$pb.TagNumber(14)
  $core.List<$core.int> get foregroundImage => $_getN(13);
  @$pb.TagNumber(14)
  set foregroundImage($core.List<$core.int> v) {
    $_setBytes(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasForegroundImage() => $_has(13);
  @$pb.TagNumber(14)
  void clearForegroundImage() => clearField(14);

  @$pb.TagNumber(15)
  $core.List<$core.int> get backgroundImage => $_getN(14);
  @$pb.TagNumber(15)
  set backgroundImage($core.List<$core.int> v) {
    $_setBytes(14, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasBackgroundImage() => $_has(14);
  @$pb.TagNumber(15)
  void clearBackgroundImage() => clearField(15);

  @$pb.TagNumber(16)
  $core.List<$core.int> get monochromeForegroundImage => $_getN(15);
  @$pb.TagNumber(16)
  set monochromeForegroundImage($core.List<$core.int> v) {
    $_setBytes(15, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasMonochromeForegroundImage() => $_has(15);
  @$pb.TagNumber(16)
  void clearMonochromeForegroundImage() => clearField(16);

  @$pb.TagNumber(17)
  $core.List<$core.int> get monochromeBackgroundImage => $_getN(16);
  @$pb.TagNumber(17)
  set monochromeBackgroundImage($core.List<$core.int> v) {
    $_setBytes(16, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasMonochromeBackgroundImage() => $_has(16);
  @$pb.TagNumber(17)
  void clearMonochromeBackgroundImage() => clearField(17);
}

class ConfigServices extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ConfigServices',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOS(
        1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mapboxApi',
        protoName: 'mapboxApi')
    ..aOS(
        2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mapboxUrlTemplateDark',
        protoName: 'mapboxUrlTemplateDark')
    ..aOS(
        3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mapboxToken',
        protoName: 'mapboxToken')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'spacesRegion')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'spacesKey')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'spacesSecret')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'spacesBucket')
    ..pPS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'endPoints')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'configUrl')
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'termsOfServiceUrl')
    ..aOS(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'privacyPolicyUrl')
    ..aOS(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ipstackKey')
    ..aOS(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ipstackApi')
    ..aOS(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountDbHost')
    ..a<$core.int>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountDbPort', $pb.PbFieldType.O3)
    ..aOS(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountDbUser')
    ..aOS(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountDbPassword')
    ..aOS(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountDbDatabase')
    ..aOS(19, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'galleryUrl', protoName: 'galleryUrl')
    ..aOS(20, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'galleryThumbnailUrl', protoName: 'galleryThumbnailUrl')
    ..aOS(21, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'galleryCoverUrl', protoName: 'galleryCoverUrl')
    ..aOS(22, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'freshdeskApi')
    ..aOS(23, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'freshdeskKey')
    ..aOS(24, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'domain')
    ..aOS(25, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'firebaseServerKey', protoName: 'firebaseServerKey')
    ..aOS(26, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'firebaseSenderId', protoName: 'firebaseSenderId')
    ..aOS(27, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'firebaseLegacyApi', protoName: 'firebaseLegacyApi')
    ..aOS(28, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'firebaseLegacyServerKey', protoName: 'firebaseLegacyServerKey')
    ..aOS(29, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'connectionFailedUrl')
    ..aOS(30, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mapboxUrlTemplateLight', protoName: 'mapboxUrlTemplateLight')
    ..aOS(31, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'galleryThumbnailBlurredUrl', protoName: 'galleryThumbnailBlurredUrl')
    ..aOS(32, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'galleryCoverBlurredUrl', protoName: 'galleryCoverBlurredUrl')
    ..a<$core.List<$core.int>>(35, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'salt', $pb.PbFieldType.OY)
    ..aOS(36, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'elasticsearchApi')
    ..aOS(37, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'elasticsearchBasicAuth')
    ..aOS(38, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'oneSignalAppId')
    ..aOS(39, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'oneSignalApiKey')
    ..aOS(40, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'oneSignalApi')
    ..aOS(41, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'galleryPictureUrl', protoName: 'galleryPictureUrl')
    ..aOS(42, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'galleryPictureBlurredUrl', protoName: 'galleryPictureBlurredUrl')
    ..aOS(43, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'proposalDbHost')
    ..a<$core.int>(44, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'proposalDbPort', $pb.PbFieldType.O3)
    ..aOS(45, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'proposalDbUser')
    ..aOS(46, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'proposalDbPassword')
    ..aOS(47, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'proposalDbDatabase')
    ..aOS(48, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'generalDbHost')
    ..a<$core.int>(49, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'generalDbPort', $pb.PbFieldType.O3)
    ..aOS(50, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'generalDbUser')
    ..aOS(51, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'generalDbPassword')
    ..aOS(52, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'generalDbDatabase')
    ..aOS(53, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backendPush')
    ..aOS(54, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backendJwt')
    ..aOS(55, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'applicationToken')
    ..aOS(56, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pexelsApi')
    ..aOS(57, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pexelsKey')
    ..aOS(58, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backendExplore')
    ..hasRequiredFields = false;

  ConfigServices._() : super();
  factory ConfigServices() => create();
  factory ConfigServices.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ConfigServices.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ConfigServices clone() => ConfigServices()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ConfigServices copyWith(void Function(ConfigServices) updates) =>
      super.copyWith((message) =>
          updates(message as ConfigServices)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConfigServices create() => ConfigServices._();
  ConfigServices createEmptyInstance() => create();
  static $pb.PbList<ConfigServices> createRepeated() =>
      $pb.PbList<ConfigServices>();
  @$core.pragma('dart2js:noInline')
  static ConfigServices getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigServices>(create);
  static ConfigServices _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mapboxApi => $_getSZ(0);
  @$pb.TagNumber(1)
  set mapboxApi($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMapboxApi() => $_has(0);
  @$pb.TagNumber(1)
  void clearMapboxApi() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get mapboxUrlTemplateDark => $_getSZ(1);
  @$pb.TagNumber(2)
  set mapboxUrlTemplateDark($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMapboxUrlTemplateDark() => $_has(1);
  @$pb.TagNumber(2)
  void clearMapboxUrlTemplateDark() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get mapboxToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set mapboxToken($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasMapboxToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearMapboxToken() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get spacesRegion => $_getSZ(3);
  @$pb.TagNumber(4)
  set spacesRegion($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSpacesRegion() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpacesRegion() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get spacesKey => $_getSZ(4);
  @$pb.TagNumber(5)
  set spacesKey($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasSpacesKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearSpacesKey() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get spacesSecret => $_getSZ(5);
  @$pb.TagNumber(6)
  set spacesSecret($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasSpacesSecret() => $_has(5);
  @$pb.TagNumber(6)
  void clearSpacesSecret() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get spacesBucket => $_getSZ(6);
  @$pb.TagNumber(7)
  set spacesBucket($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasSpacesBucket() => $_has(6);
  @$pb.TagNumber(7)
  void clearSpacesBucket() => clearField(7);

  @$pb.TagNumber(8)
  $core.List<$core.String> get endPoints => $_getList(7);

  @$pb.TagNumber(9)
  $core.String get configUrl => $_getSZ(8);
  @$pb.TagNumber(9)
  set configUrl($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasConfigUrl() => $_has(8);
  @$pb.TagNumber(9)
  void clearConfigUrl() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get termsOfServiceUrl => $_getSZ(9);
  @$pb.TagNumber(10)
  set termsOfServiceUrl($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasTermsOfServiceUrl() => $_has(9);
  @$pb.TagNumber(10)
  void clearTermsOfServiceUrl() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get privacyPolicyUrl => $_getSZ(10);
  @$pb.TagNumber(11)
  set privacyPolicyUrl($core.String v) {
    $_setString(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasPrivacyPolicyUrl() => $_has(10);
  @$pb.TagNumber(11)
  void clearPrivacyPolicyUrl() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get ipstackKey => $_getSZ(11);
  @$pb.TagNumber(12)
  set ipstackKey($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasIpstackKey() => $_has(11);
  @$pb.TagNumber(12)
  void clearIpstackKey() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get ipstackApi => $_getSZ(12);
  @$pb.TagNumber(13)
  set ipstackApi($core.String v) {
    $_setString(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasIpstackApi() => $_has(12);
  @$pb.TagNumber(13)
  void clearIpstackApi() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get accountDbHost => $_getSZ(13);
  @$pb.TagNumber(14)
  set accountDbHost($core.String v) {
    $_setString(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasAccountDbHost() => $_has(13);
  @$pb.TagNumber(14)
  void clearAccountDbHost() => clearField(14);

  @$pb.TagNumber(15)
  $core.int get accountDbPort => $_getIZ(14);
  @$pb.TagNumber(15)
  set accountDbPort($core.int v) {
    $_setSignedInt32(14, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasAccountDbPort() => $_has(14);
  @$pb.TagNumber(15)
  void clearAccountDbPort() => clearField(15);

  @$pb.TagNumber(16)
  $core.String get accountDbUser => $_getSZ(15);
  @$pb.TagNumber(16)
  set accountDbUser($core.String v) {
    $_setString(15, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasAccountDbUser() => $_has(15);
  @$pb.TagNumber(16)
  void clearAccountDbUser() => clearField(16);

  @$pb.TagNumber(17)
  $core.String get accountDbPassword => $_getSZ(16);
  @$pb.TagNumber(17)
  set accountDbPassword($core.String v) {
    $_setString(16, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasAccountDbPassword() => $_has(16);
  @$pb.TagNumber(17)
  void clearAccountDbPassword() => clearField(17);

  @$pb.TagNumber(18)
  $core.String get accountDbDatabase => $_getSZ(17);
  @$pb.TagNumber(18)
  set accountDbDatabase($core.String v) {
    $_setString(17, v);
  }

  @$pb.TagNumber(18)
  $core.bool hasAccountDbDatabase() => $_has(17);
  @$pb.TagNumber(18)
  void clearAccountDbDatabase() => clearField(18);

  @$pb.TagNumber(19)
  $core.String get galleryUrl => $_getSZ(18);
  @$pb.TagNumber(19)
  set galleryUrl($core.String v) {
    $_setString(18, v);
  }

  @$pb.TagNumber(19)
  $core.bool hasGalleryUrl() => $_has(18);
  @$pb.TagNumber(19)
  void clearGalleryUrl() => clearField(19);

  @$pb.TagNumber(20)
  $core.String get galleryThumbnailUrl => $_getSZ(19);
  @$pb.TagNumber(20)
  set galleryThumbnailUrl($core.String v) {
    $_setString(19, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasGalleryThumbnailUrl() => $_has(19);
  @$pb.TagNumber(20)
  void clearGalleryThumbnailUrl() => clearField(20);

  @$pb.TagNumber(21)
  $core.String get galleryCoverUrl => $_getSZ(20);
  @$pb.TagNumber(21)
  set galleryCoverUrl($core.String v) {
    $_setString(20, v);
  }

  @$pb.TagNumber(21)
  $core.bool hasGalleryCoverUrl() => $_has(20);
  @$pb.TagNumber(21)
  void clearGalleryCoverUrl() => clearField(21);

  @$pb.TagNumber(22)
  $core.String get freshdeskApi => $_getSZ(21);
  @$pb.TagNumber(22)
  set freshdeskApi($core.String v) {
    $_setString(21, v);
  }

  @$pb.TagNumber(22)
  $core.bool hasFreshdeskApi() => $_has(21);
  @$pb.TagNumber(22)
  void clearFreshdeskApi() => clearField(22);

  @$pb.TagNumber(23)
  $core.String get freshdeskKey => $_getSZ(22);
  @$pb.TagNumber(23)
  set freshdeskKey($core.String v) {
    $_setString(22, v);
  }

  @$pb.TagNumber(23)
  $core.bool hasFreshdeskKey() => $_has(22);
  @$pb.TagNumber(23)
  void clearFreshdeskKey() => clearField(23);

  @$pb.TagNumber(24)
  $core.String get domain => $_getSZ(23);
  @$pb.TagNumber(24)
  set domain($core.String v) {
    $_setString(23, v);
  }

  @$pb.TagNumber(24)
  $core.bool hasDomain() => $_has(23);
  @$pb.TagNumber(24)
  void clearDomain() => clearField(24);

  @$pb.TagNumber(25)
  $core.String get firebaseServerKey => $_getSZ(24);
  @$pb.TagNumber(25)
  set firebaseServerKey($core.String v) {
    $_setString(24, v);
  }

  @$pb.TagNumber(25)
  $core.bool hasFirebaseServerKey() => $_has(24);
  @$pb.TagNumber(25)
  void clearFirebaseServerKey() => clearField(25);

  @$pb.TagNumber(26)
  $core.String get firebaseSenderId => $_getSZ(25);
  @$pb.TagNumber(26)
  set firebaseSenderId($core.String v) {
    $_setString(25, v);
  }

  @$pb.TagNumber(26)
  $core.bool hasFirebaseSenderId() => $_has(25);
  @$pb.TagNumber(26)
  void clearFirebaseSenderId() => clearField(26);

  @$pb.TagNumber(27)
  $core.String get firebaseLegacyApi => $_getSZ(26);
  @$pb.TagNumber(27)
  set firebaseLegacyApi($core.String v) {
    $_setString(26, v);
  }

  @$pb.TagNumber(27)
  $core.bool hasFirebaseLegacyApi() => $_has(26);
  @$pb.TagNumber(27)
  void clearFirebaseLegacyApi() => clearField(27);

  @$pb.TagNumber(28)
  $core.String get firebaseLegacyServerKey => $_getSZ(27);
  @$pb.TagNumber(28)
  set firebaseLegacyServerKey($core.String v) {
    $_setString(27, v);
  }

  @$pb.TagNumber(28)
  $core.bool hasFirebaseLegacyServerKey() => $_has(27);
  @$pb.TagNumber(28)
  void clearFirebaseLegacyServerKey() => clearField(28);

  @$pb.TagNumber(29)
  $core.String get connectionFailedUrl => $_getSZ(28);
  @$pb.TagNumber(29)
  set connectionFailedUrl($core.String v) {
    $_setString(28, v);
  }

  @$pb.TagNumber(29)
  $core.bool hasConnectionFailedUrl() => $_has(28);
  @$pb.TagNumber(29)
  void clearConnectionFailedUrl() => clearField(29);

  @$pb.TagNumber(30)
  $core.String get mapboxUrlTemplateLight => $_getSZ(29);
  @$pb.TagNumber(30)
  set mapboxUrlTemplateLight($core.String v) {
    $_setString(29, v);
  }

  @$pb.TagNumber(30)
  $core.bool hasMapboxUrlTemplateLight() => $_has(29);
  @$pb.TagNumber(30)
  void clearMapboxUrlTemplateLight() => clearField(30);

  @$pb.TagNumber(31)
  $core.String get galleryThumbnailBlurredUrl => $_getSZ(30);
  @$pb.TagNumber(31)
  set galleryThumbnailBlurredUrl($core.String v) {
    $_setString(30, v);
  }

  @$pb.TagNumber(31)
  $core.bool hasGalleryThumbnailBlurredUrl() => $_has(30);
  @$pb.TagNumber(31)
  void clearGalleryThumbnailBlurredUrl() => clearField(31);

  @$pb.TagNumber(32)
  $core.String get galleryCoverBlurredUrl => $_getSZ(31);
  @$pb.TagNumber(32)
  set galleryCoverBlurredUrl($core.String v) {
    $_setString(31, v);
  }

  @$pb.TagNumber(32)
  $core.bool hasGalleryCoverBlurredUrl() => $_has(31);
  @$pb.TagNumber(32)
  void clearGalleryCoverBlurredUrl() => clearField(32);

  @$pb.TagNumber(35)
  $core.List<$core.int> get salt => $_getN(32);
  @$pb.TagNumber(35)
  set salt($core.List<$core.int> v) {
    $_setBytes(32, v);
  }

  @$pb.TagNumber(35)
  $core.bool hasSalt() => $_has(32);
  @$pb.TagNumber(35)
  void clearSalt() => clearField(35);

  @$pb.TagNumber(36)
  $core.String get elasticsearchApi => $_getSZ(33);
  @$pb.TagNumber(36)
  set elasticsearchApi($core.String v) {
    $_setString(33, v);
  }

  @$pb.TagNumber(36)
  $core.bool hasElasticsearchApi() => $_has(33);
  @$pb.TagNumber(36)
  void clearElasticsearchApi() => clearField(36);

  @$pb.TagNumber(37)
  $core.String get elasticsearchBasicAuth => $_getSZ(34);
  @$pb.TagNumber(37)
  set elasticsearchBasicAuth($core.String v) {
    $_setString(34, v);
  }

  @$pb.TagNumber(37)
  $core.bool hasElasticsearchBasicAuth() => $_has(34);
  @$pb.TagNumber(37)
  void clearElasticsearchBasicAuth() => clearField(37);

  @$pb.TagNumber(38)
  $core.String get oneSignalAppId => $_getSZ(35);
  @$pb.TagNumber(38)
  set oneSignalAppId($core.String v) {
    $_setString(35, v);
  }

  @$pb.TagNumber(38)
  $core.bool hasOneSignalAppId() => $_has(35);
  @$pb.TagNumber(38)
  void clearOneSignalAppId() => clearField(38);

  @$pb.TagNumber(39)
  $core.String get oneSignalApiKey => $_getSZ(36);
  @$pb.TagNumber(39)
  set oneSignalApiKey($core.String v) {
    $_setString(36, v);
  }

  @$pb.TagNumber(39)
  $core.bool hasOneSignalApiKey() => $_has(36);
  @$pb.TagNumber(39)
  void clearOneSignalApiKey() => clearField(39);

  @$pb.TagNumber(40)
  $core.String get oneSignalApi => $_getSZ(37);
  @$pb.TagNumber(40)
  set oneSignalApi($core.String v) {
    $_setString(37, v);
  }

  @$pb.TagNumber(40)
  $core.bool hasOneSignalApi() => $_has(37);
  @$pb.TagNumber(40)
  void clearOneSignalApi() => clearField(40);

  @$pb.TagNumber(41)
  $core.String get galleryPictureUrl => $_getSZ(38);
  @$pb.TagNumber(41)
  set galleryPictureUrl($core.String v) {
    $_setString(38, v);
  }

  @$pb.TagNumber(41)
  $core.bool hasGalleryPictureUrl() => $_has(38);
  @$pb.TagNumber(41)
  void clearGalleryPictureUrl() => clearField(41);

  @$pb.TagNumber(42)
  $core.String get galleryPictureBlurredUrl => $_getSZ(39);
  @$pb.TagNumber(42)
  set galleryPictureBlurredUrl($core.String v) {
    $_setString(39, v);
  }

  @$pb.TagNumber(42)
  $core.bool hasGalleryPictureBlurredUrl() => $_has(39);
  @$pb.TagNumber(42)
  void clearGalleryPictureBlurredUrl() => clearField(42);

  @$pb.TagNumber(43)
  $core.String get proposalDbHost => $_getSZ(40);
  @$pb.TagNumber(43)
  set proposalDbHost($core.String v) {
    $_setString(40, v);
  }

  @$pb.TagNumber(43)
  $core.bool hasProposalDbHost() => $_has(40);
  @$pb.TagNumber(43)
  void clearProposalDbHost() => clearField(43);

  @$pb.TagNumber(44)
  $core.int get proposalDbPort => $_getIZ(41);
  @$pb.TagNumber(44)
  set proposalDbPort($core.int v) {
    $_setSignedInt32(41, v);
  }

  @$pb.TagNumber(44)
  $core.bool hasProposalDbPort() => $_has(41);
  @$pb.TagNumber(44)
  void clearProposalDbPort() => clearField(44);

  @$pb.TagNumber(45)
  $core.String get proposalDbUser => $_getSZ(42);
  @$pb.TagNumber(45)
  set proposalDbUser($core.String v) {
    $_setString(42, v);
  }

  @$pb.TagNumber(45)
  $core.bool hasProposalDbUser() => $_has(42);
  @$pb.TagNumber(45)
  void clearProposalDbUser() => clearField(45);

  @$pb.TagNumber(46)
  $core.String get proposalDbPassword => $_getSZ(43);
  @$pb.TagNumber(46)
  set proposalDbPassword($core.String v) {
    $_setString(43, v);
  }

  @$pb.TagNumber(46)
  $core.bool hasProposalDbPassword() => $_has(43);
  @$pb.TagNumber(46)
  void clearProposalDbPassword() => clearField(46);

  @$pb.TagNumber(47)
  $core.String get proposalDbDatabase => $_getSZ(44);
  @$pb.TagNumber(47)
  set proposalDbDatabase($core.String v) {
    $_setString(44, v);
  }

  @$pb.TagNumber(47)
  $core.bool hasProposalDbDatabase() => $_has(44);
  @$pb.TagNumber(47)
  void clearProposalDbDatabase() => clearField(47);

  @$pb.TagNumber(48)
  $core.String get generalDbHost => $_getSZ(45);
  @$pb.TagNumber(48)
  set generalDbHost($core.String v) {
    $_setString(45, v);
  }

  @$pb.TagNumber(48)
  $core.bool hasGeneralDbHost() => $_has(45);
  @$pb.TagNumber(48)
  void clearGeneralDbHost() => clearField(48);

  @$pb.TagNumber(49)
  $core.int get generalDbPort => $_getIZ(46);
  @$pb.TagNumber(49)
  set generalDbPort($core.int v) {
    $_setSignedInt32(46, v);
  }

  @$pb.TagNumber(49)
  $core.bool hasGeneralDbPort() => $_has(46);
  @$pb.TagNumber(49)
  void clearGeneralDbPort() => clearField(49);

  @$pb.TagNumber(50)
  $core.String get generalDbUser => $_getSZ(47);
  @$pb.TagNumber(50)
  set generalDbUser($core.String v) {
    $_setString(47, v);
  }

  @$pb.TagNumber(50)
  $core.bool hasGeneralDbUser() => $_has(47);
  @$pb.TagNumber(50)
  void clearGeneralDbUser() => clearField(50);

  @$pb.TagNumber(51)
  $core.String get generalDbPassword => $_getSZ(48);
  @$pb.TagNumber(51)
  set generalDbPassword($core.String v) {
    $_setString(48, v);
  }

  @$pb.TagNumber(51)
  $core.bool hasGeneralDbPassword() => $_has(48);
  @$pb.TagNumber(51)
  void clearGeneralDbPassword() => clearField(51);

  @$pb.TagNumber(52)
  $core.String get generalDbDatabase => $_getSZ(49);
  @$pb.TagNumber(52)
  set generalDbDatabase($core.String v) {
    $_setString(49, v);
  }

  @$pb.TagNumber(52)
  $core.bool hasGeneralDbDatabase() => $_has(49);
  @$pb.TagNumber(52)
  void clearGeneralDbDatabase() => clearField(52);

  @$pb.TagNumber(53)
  $core.String get backendPush => $_getSZ(50);
  @$pb.TagNumber(53)
  set backendPush($core.String v) {
    $_setString(50, v);
  }

  @$pb.TagNumber(53)
  $core.bool hasBackendPush() => $_has(50);
  @$pb.TagNumber(53)
  void clearBackendPush() => clearField(53);

  @$pb.TagNumber(54)
  $core.String get backendJwt => $_getSZ(51);
  @$pb.TagNumber(54)
  set backendJwt($core.String v) {
    $_setString(51, v);
  }

  @$pb.TagNumber(54)
  $core.bool hasBackendJwt() => $_has(51);
  @$pb.TagNumber(54)
  void clearBackendJwt() => clearField(54);

  @$pb.TagNumber(55)
  $core.String get applicationToken => $_getSZ(52);
  @$pb.TagNumber(55)
  set applicationToken($core.String v) {
    $_setString(52, v);
  }

  @$pb.TagNumber(55)
  $core.bool hasApplicationToken() => $_has(52);
  @$pb.TagNumber(55)
  void clearApplicationToken() => clearField(55);

  @$pb.TagNumber(56)
  $core.String get pexelsApi => $_getSZ(53);
  @$pb.TagNumber(56)
  set pexelsApi($core.String v) {
    $_setString(53, v);
  }

  @$pb.TagNumber(56)
  $core.bool hasPexelsApi() => $_has(53);
  @$pb.TagNumber(56)
  void clearPexelsApi() => clearField(56);

  @$pb.TagNumber(57)
  $core.String get pexelsKey => $_getSZ(54);
  @$pb.TagNumber(57)
  set pexelsKey($core.String v) {
    $_setString(54, v);
  }

  @$pb.TagNumber(57)
  $core.bool hasPexelsKey() => $_has(54);
  @$pb.TagNumber(57)
  void clearPexelsKey() => clearField(57);

  @$pb.TagNumber(58)
  $core.String get backendExplore => $_getSZ(55);
  @$pb.TagNumber(58)
  set backendExplore($core.String v) {
    $_setString(55, v);
  }

  @$pb.TagNumber(58)
  $core.bool hasBackendExplore() => $_has(55);
  @$pb.TagNumber(58)
  void clearBackendExplore() => clearField(58);
}

class ConfigFeatureSwitches extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ConfigFeatureSwitches',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createProposal',
        protoName: 'createProposal')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createSession',
        protoName: 'createSession')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createAccount',
        protoName: 'createAccount')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'removeAccount',
        protoName: 'removeAccount')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'removeSession', protoName: 'removeSession')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'connectSocialMedia', protoName: 'connectSocialMedia')
    ..aOB(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'removeSocialMedia', protoName: 'removeSocialMedia')
    ..aOB(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updateProfile', protoName: 'updateProfile')
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createOffer', protoName: 'createOffer')
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updateOffer', protoName: 'updateOffer')
    ..aOB(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'closeOffer', protoName: 'closeOffer')
    ..aOB(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'archiveOffer', protoName: 'archiveOffer')
    ..aOB(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendChat', protoName: 'sendChat')
    ..aOB(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'makeDeal', protoName: 'makeDeal')
    ..aOB(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'reportProposal', protoName: 'reportProposal')
    ..aOB(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'disputeDeal', protoName: 'disputeDeal')
    ..aOB(17, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uploadImage', protoName: 'uploadImage')
    ..aOB(18, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'makeImagePublic', protoName: 'makeImagePublic')
    ..aOB(19, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'listImages', protoName: 'listImages')
    ..hasRequiredFields = false;

  ConfigFeatureSwitches._() : super();
  factory ConfigFeatureSwitches() => create();
  factory ConfigFeatureSwitches.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ConfigFeatureSwitches.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ConfigFeatureSwitches clone() =>
      ConfigFeatureSwitches()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ConfigFeatureSwitches copyWith(
          void Function(ConfigFeatureSwitches) updates) =>
      super.copyWith((message) => updates(
          message as ConfigFeatureSwitches)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConfigFeatureSwitches create() => ConfigFeatureSwitches._();
  ConfigFeatureSwitches createEmptyInstance() => create();
  static $pb.PbList<ConfigFeatureSwitches> createRepeated() =>
      $pb.PbList<ConfigFeatureSwitches>();
  @$core.pragma('dart2js:noInline')
  static ConfigFeatureSwitches getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigFeatureSwitches>(create);
  static ConfigFeatureSwitches _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get createProposal => $_getBF(0);
  @$pb.TagNumber(1)
  set createProposal($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCreateProposal() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreateProposal() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get createSession => $_getBF(1);
  @$pb.TagNumber(2)
  set createSession($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCreateSession() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreateSession() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get createAccount => $_getBF(2);
  @$pb.TagNumber(3)
  set createAccount($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCreateAccount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreateAccount() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get removeAccount => $_getBF(3);
  @$pb.TagNumber(4)
  set removeAccount($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasRemoveAccount() => $_has(3);
  @$pb.TagNumber(4)
  void clearRemoveAccount() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get removeSession => $_getBF(4);
  @$pb.TagNumber(5)
  set removeSession($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasRemoveSession() => $_has(4);
  @$pb.TagNumber(5)
  void clearRemoveSession() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get connectSocialMedia => $_getBF(5);
  @$pb.TagNumber(6)
  set connectSocialMedia($core.bool v) {
    $_setBool(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasConnectSocialMedia() => $_has(5);
  @$pb.TagNumber(6)
  void clearConnectSocialMedia() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get removeSocialMedia => $_getBF(6);
  @$pb.TagNumber(7)
  set removeSocialMedia($core.bool v) {
    $_setBool(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasRemoveSocialMedia() => $_has(6);
  @$pb.TagNumber(7)
  void clearRemoveSocialMedia() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get updateProfile => $_getBF(7);
  @$pb.TagNumber(8)
  set updateProfile($core.bool v) {
    $_setBool(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasUpdateProfile() => $_has(7);
  @$pb.TagNumber(8)
  void clearUpdateProfile() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get createOffer => $_getBF(8);
  @$pb.TagNumber(9)
  set createOffer($core.bool v) {
    $_setBool(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasCreateOffer() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreateOffer() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get updateOffer => $_getBF(9);
  @$pb.TagNumber(10)
  set updateOffer($core.bool v) {
    $_setBool(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasUpdateOffer() => $_has(9);
  @$pb.TagNumber(10)
  void clearUpdateOffer() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get closeOffer => $_getBF(10);
  @$pb.TagNumber(11)
  set closeOffer($core.bool v) {
    $_setBool(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasCloseOffer() => $_has(10);
  @$pb.TagNumber(11)
  void clearCloseOffer() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get archiveOffer => $_getBF(11);
  @$pb.TagNumber(12)
  set archiveOffer($core.bool v) {
    $_setBool(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasArchiveOffer() => $_has(11);
  @$pb.TagNumber(12)
  void clearArchiveOffer() => clearField(12);

  @$pb.TagNumber(13)
  $core.bool get sendChat => $_getBF(12);
  @$pb.TagNumber(13)
  set sendChat($core.bool v) {
    $_setBool(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasSendChat() => $_has(12);
  @$pb.TagNumber(13)
  void clearSendChat() => clearField(13);

  @$pb.TagNumber(14)
  $core.bool get makeDeal => $_getBF(13);
  @$pb.TagNumber(14)
  set makeDeal($core.bool v) {
    $_setBool(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasMakeDeal() => $_has(13);
  @$pb.TagNumber(14)
  void clearMakeDeal() => clearField(14);

  @$pb.TagNumber(15)
  $core.bool get reportProposal => $_getBF(14);
  @$pb.TagNumber(15)
  set reportProposal($core.bool v) {
    $_setBool(14, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasReportProposal() => $_has(14);
  @$pb.TagNumber(15)
  void clearReportProposal() => clearField(15);

  @$pb.TagNumber(16)
  $core.bool get disputeDeal => $_getBF(15);
  @$pb.TagNumber(16)
  set disputeDeal($core.bool v) {
    $_setBool(15, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasDisputeDeal() => $_has(15);
  @$pb.TagNumber(16)
  void clearDisputeDeal() => clearField(16);

  @$pb.TagNumber(17)
  $core.bool get uploadImage => $_getBF(16);
  @$pb.TagNumber(17)
  set uploadImage($core.bool v) {
    $_setBool(16, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasUploadImage() => $_has(16);
  @$pb.TagNumber(17)
  void clearUploadImage() => clearField(17);

  @$pb.TagNumber(18)
  $core.bool get makeImagePublic => $_getBF(17);
  @$pb.TagNumber(18)
  set makeImagePublic($core.bool v) {
    $_setBool(17, v);
  }

  @$pb.TagNumber(18)
  $core.bool hasMakeImagePublic() => $_has(17);
  @$pb.TagNumber(18)
  void clearMakeImagePublic() => clearField(18);

  @$pb.TagNumber(19)
  $core.bool get listImages => $_getBF(18);
  @$pb.TagNumber(19)
  set listImages($core.bool v) {
    $_setBool(18, v);
  }

  @$pb.TagNumber(19)
  $core.bool hasListImages() => $_has(18);
  @$pb.TagNumber(19)
  void clearListImages() => clearField(19);
}

class ConfigAsset extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ConfigAsset',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'name')
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'data',
        $pb.PbFieldType.OY)
    ..aOB(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'svg')
    ..hasRequiredFields = false;

  ConfigAsset._() : super();
  factory ConfigAsset() => create();
  factory ConfigAsset.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ConfigAsset.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ConfigAsset clone() => ConfigAsset()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ConfigAsset copyWith(void Function(ConfigAsset) updates) =>
      super.copyWith((message) =>
          updates(message as ConfigAsset)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConfigAsset create() => ConfigAsset._();
  ConfigAsset createEmptyInstance() => create();
  static $pb.PbList<ConfigAsset> createRepeated() => $pb.PbList<ConfigAsset>();
  @$core.pragma('dart2js:noInline')
  static ConfigAsset getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigAsset>(create);
  static ConfigAsset _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get svg => $_getBF(2);
  @$pb.TagNumber(3)
  set svg($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSvg() => $_has(2);
  @$pb.TagNumber(3)
  void clearSvg() => clearField(3);
}

class ConfigContent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ConfigContent',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..pPS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'welcomeImageUrls')
    ..hasRequiredFields = false;

  ConfigContent._() : super();
  factory ConfigContent() => create();
  factory ConfigContent.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ConfigContent.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ConfigContent clone() => ConfigContent()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ConfigContent copyWith(void Function(ConfigContent) updates) =>
      super.copyWith((message) =>
          updates(message as ConfigContent)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConfigContent create() => ConfigContent._();
  ConfigContent createEmptyInstance() => create();
  static $pb.PbList<ConfigContent> createRepeated() =>
      $pb.PbList<ConfigContent>();
  @$core.pragma('dart2js:noInline')
  static ConfigContent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigContent>(create);
  static ConfigContent _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get welcomeImageUrls => $_getList(0);
}

class ConfigData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ConfigData',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'clientVersion',
        $pb.PbFieldType.O3)
    ..aInt64(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'timestamp')
    ..aOM<ConfigServices>(
        6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'services',
        subBuilder: ConfigServices.create)
    ..aOM<ConfigContent>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'content', subBuilder: ConfigContent.create)
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'region')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'language')
    ..pc<ConfigOAuthProvider>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'oauthProviders', $pb.PbFieldType.PM, subBuilder: ConfigOAuthProvider.create)
    ..pc<ConfigContentFormat>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'contentFormats', $pb.PbFieldType.PM, subBuilder: ConfigContentFormat.create)
    ..pc<ConfigCategory>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'categories', $pb.PbFieldType.PM, subBuilder: ConfigCategory.create)
    ..pc<ConfigAsset>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'assets', $pb.PbFieldType.PM, subBuilder: ConfigAsset.create)
    ..aOM<ConfigFeatureSwitches>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'featureSwitches', protoName: 'featureSwitches', subBuilder: ConfigFeatureSwitches.create)
    ..hasRequiredFields = false;

  ConfigData._() : super();
  factory ConfigData() => create();
  factory ConfigData.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ConfigData.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ConfigData clone() => ConfigData()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ConfigData copyWith(void Function(ConfigData) updates) =>
      super.copyWith((message) =>
          updates(message as ConfigData)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConfigData create() => ConfigData._();
  ConfigData createEmptyInstance() => create();
  static $pb.PbList<ConfigData> createRepeated() => $pb.PbList<ConfigData>();
  @$core.pragma('dart2js:noInline')
  static ConfigData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigData>(create);
  static ConfigData _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get clientVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set clientVersion($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasClientVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientVersion() => clearField(1);

  @$pb.TagNumber(5)
  $fixnum.Int64 get timestamp => $_getI64(1);
  @$pb.TagNumber(5)
  set timestamp($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(5)
  void clearTimestamp() => clearField(5);

  @$pb.TagNumber(6)
  ConfigServices get services => $_getN(2);
  @$pb.TagNumber(6)
  set services(ConfigServices v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasServices() => $_has(2);
  @$pb.TagNumber(6)
  void clearServices() => clearField(6);
  @$pb.TagNumber(6)
  ConfigServices ensureServices() => $_ensure(2);

  @$pb.TagNumber(7)
  ConfigContent get content => $_getN(3);
  @$pb.TagNumber(7)
  set content(ConfigContent v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasContent() => $_has(3);
  @$pb.TagNumber(7)
  void clearContent() => clearField(7);
  @$pb.TagNumber(7)
  ConfigContent ensureContent() => $_ensure(3);

  @$pb.TagNumber(8)
  $core.String get region => $_getSZ(4);
  @$pb.TagNumber(8)
  set region($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasRegion() => $_has(4);
  @$pb.TagNumber(8)
  void clearRegion() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get language => $_getSZ(5);
  @$pb.TagNumber(9)
  set language($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasLanguage() => $_has(5);
  @$pb.TagNumber(9)
  void clearLanguage() => clearField(9);

  @$pb.TagNumber(11)
  $core.List<ConfigOAuthProvider> get oauthProviders => $_getList(6);

  @$pb.TagNumber(12)
  $core.List<ConfigContentFormat> get contentFormats => $_getList(7);

  @$pb.TagNumber(13)
  $core.List<ConfigCategory> get categories => $_getList(8);

  @$pb.TagNumber(14)
  $core.List<ConfigAsset> get assets => $_getList(9);

  @$pb.TagNumber(15)
  ConfigFeatureSwitches get featureSwitches => $_getN(10);
  @$pb.TagNumber(15)
  set featureSwitches(ConfigFeatureSwitches v) {
    setField(15, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasFeatureSwitches() => $_has(10);
  @$pb.TagNumber(15)
  void clearFeatureSwitches() => clearField(15);
  @$pb.TagNumber(15)
  ConfigFeatureSwitches ensureFeatureSwitches() => $_ensure(10);
}
