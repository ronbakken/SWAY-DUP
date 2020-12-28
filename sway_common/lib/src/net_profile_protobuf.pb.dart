///
//  Generated code. Do not modify.
//  source: net_profile_protobuf.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $13;

class NetGetProfile extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetGetProfile',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'accountId',
        protoName: 'accountId')
    ..hasRequiredFields = false;

  NetGetProfile._() : super();
  factory NetGetProfile() => create();
  factory NetGetProfile.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetGetProfile.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetGetProfile clone() => NetGetProfile()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetGetProfile copyWith(void Function(NetGetProfile) updates) =>
      super.copyWith((message) =>
          updates(message as NetGetProfile)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetGetProfile create() => NetGetProfile._();
  NetGetProfile createEmptyInstance() => create();
  static $pb.PbList<NetGetProfile> createRepeated() =>
      $pb.PbList<NetGetProfile>();
  @$core.pragma('dart2js:noInline')
  static NetGetProfile getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetGetProfile>(create);
  static NetGetProfile _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get accountId => $_getI64(0);
  @$pb.TagNumber(1)
  set accountId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => clearField(1);
}

class NetProfile extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetProfile',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<$13.DataAccount>(1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'account',
        subBuilder: $13.DataAccount.create)
    ..aOB(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'summary')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'detail')
    ..hasRequiredFields = false;

  NetProfile._() : super();
  factory NetProfile() => create();
  factory NetProfile.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetProfile.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetProfile clone() => NetProfile()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetProfile copyWith(void Function(NetProfile) updates) =>
      super.copyWith((message) =>
          updates(message as NetProfile)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetProfile create() => NetProfile._();
  NetProfile createEmptyInstance() => create();
  static $pb.PbList<NetProfile> createRepeated() => $pb.PbList<NetProfile>();
  @$core.pragma('dart2js:noInline')
  static NetProfile getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetProfile>(create);
  static NetProfile _defaultInstance;

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

  @$pb.TagNumber(3)
  $core.bool get summary => $_getBF(1);
  @$pb.TagNumber(3)
  set summary($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSummary() => $_has(1);
  @$pb.TagNumber(3)
  void clearSummary() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get detail => $_getBF(2);
  @$pb.TagNumber(4)
  set detail($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasDetail() => $_has(2);
  @$pb.TagNumber(4)
  void clearDetail() => clearField(4);
}
