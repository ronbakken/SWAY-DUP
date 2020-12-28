///
//  Generated code. Do not modify.
//  source: net_offer_protobuf.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $13;

class NetOffer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetOffer',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<$13.DataOffer>(1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'offer',
        subBuilder: $13.DataOffer.create)
    ..aOB(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'state')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'summary')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'detail')
    ..hasRequiredFields = false;

  NetOffer._() : super();
  factory NetOffer() => create();
  factory NetOffer.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetOffer.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetOffer clone() => NetOffer()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetOffer copyWith(void Function(NetOffer) updates) =>
      super.copyWith((message) =>
          updates(message as NetOffer)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetOffer create() => NetOffer._();
  NetOffer createEmptyInstance() => create();
  static $pb.PbList<NetOffer> createRepeated() => $pb.PbList<NetOffer>();
  @$core.pragma('dart2js:noInline')
  static NetOffer getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NetOffer>(create);
  static NetOffer _defaultInstance;

  @$pb.TagNumber(1)
  $13.DataOffer get offer => $_getN(0);
  @$pb.TagNumber(1)
  set offer($13.DataOffer v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffer() => clearField(1);
  @$pb.TagNumber(1)
  $13.DataOffer ensureOffer() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get state => $_getBF(1);
  @$pb.TagNumber(2)
  set state($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get summary => $_getBF(2);
  @$pb.TagNumber(3)
  set summary($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSummary() => $_has(2);
  @$pb.TagNumber(3)
  void clearSummary() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get detail => $_getBF(3);
  @$pb.TagNumber(4)
  set detail($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasDetail() => $_has(3);
  @$pb.TagNumber(4)
  void clearDetail() => clearField(4);
}

class NetCreateOffer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetCreateOffer',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<$13.DataOffer>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'offer',
        subBuilder: $13.DataOffer.create)
    ..hasRequiredFields = false;

  NetCreateOffer._() : super();
  factory NetCreateOffer() => create();
  factory NetCreateOffer.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetCreateOffer.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetCreateOffer clone() => NetCreateOffer()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetCreateOffer copyWith(void Function(NetCreateOffer) updates) =>
      super.copyWith((message) =>
          updates(message as NetCreateOffer)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetCreateOffer create() => NetCreateOffer._();
  NetCreateOffer createEmptyInstance() => create();
  static $pb.PbList<NetCreateOffer> createRepeated() =>
      $pb.PbList<NetCreateOffer>();
  @$core.pragma('dart2js:noInline')
  static NetCreateOffer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetCreateOffer>(create);
  static NetCreateOffer _defaultInstance;

  @$pb.TagNumber(1)
  $13.DataOffer get offer => $_getN(0);
  @$pb.TagNumber(1)
  set offer($13.DataOffer v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffer() => clearField(1);
  @$pb.TagNumber(1)
  $13.DataOffer ensureOffer() => $_ensure(0);
}

class NetListOffers extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetListOffers',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  NetListOffers._() : super();
  factory NetListOffers() => create();
  factory NetListOffers.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetListOffers.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetListOffers clone() => NetListOffers()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetListOffers copyWith(void Function(NetListOffers) updates) =>
      super.copyWith((message) =>
          updates(message as NetListOffers)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetListOffers create() => NetListOffers._();
  NetListOffers createEmptyInstance() => create();
  static $pb.PbList<NetListOffers> createRepeated() =>
      $pb.PbList<NetListOffers>();
  @$core.pragma('dart2js:noInline')
  static NetListOffers getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetListOffers>(create);
  static NetListOffers _defaultInstance;
}

class NetGetOffer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetGetOffer',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'offerId',
        protoName: 'offerId')
    ..hasRequiredFields = false;

  NetGetOffer._() : super();
  factory NetGetOffer() => create();
  factory NetGetOffer.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetGetOffer.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetGetOffer clone() => NetGetOffer()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetGetOffer copyWith(void Function(NetGetOffer) updates) =>
      super.copyWith((message) =>
          updates(message as NetGetOffer)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetGetOffer create() => NetGetOffer._();
  NetGetOffer createEmptyInstance() => create();
  static $pb.PbList<NetGetOffer> createRepeated() => $pb.PbList<NetGetOffer>();
  @$core.pragma('dart2js:noInline')
  static NetGetOffer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetGetOffer>(create);
  static NetGetOffer _defaultInstance;

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
}
