///
//  Generated code. Do not modify.
//  source: backend_jwt.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ReqSign extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ReqSign',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'claim')
    ..hasRequiredFields = false;

  ReqSign._() : super();
  factory ReqSign() => create();
  factory ReqSign.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ReqSign.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ReqSign clone() => ReqSign()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ReqSign copyWith(void Function(ReqSign) updates) =>
      super.copyWith((message) =>
          updates(message as ReqSign)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReqSign create() => ReqSign._();
  ReqSign createEmptyInstance() => create();
  static $pb.PbList<ReqSign> createRepeated() => $pb.PbList<ReqSign>();
  @$core.pragma('dart2js:noInline')
  static ReqSign getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReqSign>(create);
  static ReqSign _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get claim => $_getSZ(0);
  @$pb.TagNumber(1)
  set claim($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasClaim() => $_has(0);
  @$pb.TagNumber(1)
  void clearClaim() => clearField(1);
}

class ResSign extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ResSign',
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
    ..hasRequiredFields = false;

  ResSign._() : super();
  factory ResSign() => create();
  factory ResSign.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ResSign.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ResSign clone() => ResSign()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ResSign copyWith(void Function(ResSign) updates) =>
      super.copyWith((message) =>
          updates(message as ResSign)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ResSign create() => ResSign._();
  ResSign createEmptyInstance() => create();
  static $pb.PbList<ResSign> createRepeated() => $pb.PbList<ResSign>();
  @$core.pragma('dart2js:noInline')
  static ResSign getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResSign>(create);
  static ResSign _defaultInstance;

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
}

class ReqGetKeyStore extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ReqGetKeyStore',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  ReqGetKeyStore._() : super();
  factory ReqGetKeyStore() => create();
  factory ReqGetKeyStore.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ReqGetKeyStore.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ReqGetKeyStore clone() => ReqGetKeyStore()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ReqGetKeyStore copyWith(void Function(ReqGetKeyStore) updates) =>
      super.copyWith((message) =>
          updates(message as ReqGetKeyStore)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReqGetKeyStore create() => ReqGetKeyStore._();
  ReqGetKeyStore createEmptyInstance() => create();
  static $pb.PbList<ReqGetKeyStore> createRepeated() =>
      $pb.PbList<ReqGetKeyStore>();
  @$core.pragma('dart2js:noInline')
  static ReqGetKeyStore getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReqGetKeyStore>(create);
  static ReqGetKeyStore _defaultInstance;
}

class ResGetKeyStore extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ResGetKeyStore',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'jwks')
    ..hasRequiredFields = false;

  ResGetKeyStore._() : super();
  factory ResGetKeyStore() => create();
  factory ResGetKeyStore.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ResGetKeyStore.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ResGetKeyStore clone() => ResGetKeyStore()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ResGetKeyStore copyWith(void Function(ResGetKeyStore) updates) =>
      super.copyWith((message) =>
          updates(message as ResGetKeyStore)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ResGetKeyStore create() => ResGetKeyStore._();
  ResGetKeyStore createEmptyInstance() => create();
  static $pb.PbList<ResGetKeyStore> createRepeated() =>
      $pb.PbList<ResGetKeyStore>();
  @$core.pragma('dart2js:noInline')
  static ResGetKeyStore getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResGetKeyStore>(create);
  static ResGetKeyStore _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jwks => $_getSZ(0);
  @$pb.TagNumber(1)
  set jwks($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasJwks() => $_has(0);
  @$pb.TagNumber(1)
  void clearJwks() => clearField(1);
}
