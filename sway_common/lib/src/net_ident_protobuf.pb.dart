///
//  Generated code. Do not modify.
//  source: net_ident_protobuf.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $13;

class NetSessionOpen extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetSessionOpen',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOS(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'domain')
    ..a<$core.int>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'clientVersion',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetSessionOpen._() : super();
  factory NetSessionOpen() => create();
  factory NetSessionOpen.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetSessionOpen.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetSessionOpen clone() => NetSessionOpen()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetSessionOpen copyWith(void Function(NetSessionOpen) updates) =>
      super.copyWith((message) =>
          updates(message as NetSessionOpen)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetSessionOpen create() => NetSessionOpen._();
  NetSessionOpen createEmptyInstance() => create();
  static $pb.PbList<NetSessionOpen> createRepeated() =>
      $pb.PbList<NetSessionOpen>();
  @$core.pragma('dart2js:noInline')
  static NetSessionOpen getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetSessionOpen>(create);
  static NetSessionOpen _defaultInstance;

  @$pb.TagNumber(7)
  $core.String get domain => $_getSZ(0);
  @$pb.TagNumber(7)
  set domain($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasDomain() => $_has(0);
  @$pb.TagNumber(7)
  void clearDomain() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get clientVersion => $_getIZ(1);
  @$pb.TagNumber(8)
  set clientVersion($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasClientVersion() => $_has(1);
  @$pb.TagNumber(8)
  void clearClientVersion() => clearField(8);
}

class NetSessionCreate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetSessionCreate',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'deviceToken',
        $pb.PbFieldType.OY)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'deviceName')
    ..aOS(
        3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'deviceInfo')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'domain')
    ..a<$core.int>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clientVersion', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetSessionCreate._() : super();
  factory NetSessionCreate() => create();
  factory NetSessionCreate.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetSessionCreate.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetSessionCreate clone() => NetSessionCreate()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetSessionCreate copyWith(void Function(NetSessionCreate) updates) =>
      super.copyWith((message) => updates(
          message as NetSessionCreate)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetSessionCreate create() => NetSessionCreate._();
  NetSessionCreate createEmptyInstance() => create();
  static $pb.PbList<NetSessionCreate> createRepeated() =>
      $pb.PbList<NetSessionCreate>();
  @$core.pragma('dart2js:noInline')
  static NetSessionCreate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetSessionCreate>(create);
  static NetSessionCreate _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get deviceToken => $_getN(0);
  @$pb.TagNumber(1)
  set deviceToken($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasDeviceToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceName($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasDeviceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get deviceInfo => $_getSZ(2);
  @$pb.TagNumber(3)
  set deviceInfo($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasDeviceInfo() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeviceInfo() => clearField(3);

  @$pb.TagNumber(7)
  $core.String get domain => $_getSZ(3);
  @$pb.TagNumber(7)
  set domain($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasDomain() => $_has(3);
  @$pb.TagNumber(7)
  void clearDomain() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get clientVersion => $_getIZ(4);
  @$pb.TagNumber(8)
  set clientVersion($core.int v) {
    $_setSignedInt32(4, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasClientVersion() => $_has(4);
  @$pb.TagNumber(8)
  void clearClientVersion() => clearField(8);
}

class NetSession extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetSession',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<$13.DataAccount>(2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'account',
        subBuilder: $13.DataAccount.create)
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'refreshToken')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accessToken')
    ..hasRequiredFields = false;

  NetSession._() : super();
  factory NetSession() => create();
  factory NetSession.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetSession.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetSession clone() => NetSession()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetSession copyWith(void Function(NetSession) updates) =>
      super.copyWith((message) =>
          updates(message as NetSession)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetSession create() => NetSession._();
  NetSession createEmptyInstance() => create();
  static $pb.PbList<NetSession> createRepeated() => $pb.PbList<NetSession>();
  @$core.pragma('dart2js:noInline')
  static NetSession getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetSession>(create);
  static NetSession _defaultInstance;

  @$pb.TagNumber(2)
  $13.DataAccount get account => $_getN(0);
  @$pb.TagNumber(2)
  set account($13.DataAccount v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(2)
  void clearAccount() => clearField(2);
  @$pb.TagNumber(2)
  $13.DataAccount ensureAccount() => $_ensure(0);

  @$pb.TagNumber(3)
  $core.String get refreshToken => $_getSZ(1);
  @$pb.TagNumber(3)
  set refreshToken($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRefreshToken() => $_has(1);
  @$pb.TagNumber(3)
  void clearRefreshToken() => clearField(3);

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
