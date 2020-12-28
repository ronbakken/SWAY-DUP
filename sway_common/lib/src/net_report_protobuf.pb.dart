///
//  Generated code. Do not modify.
//  source: net_report_protobuf.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class NetReportOffer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetReportOffer',
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
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'text')
    ..hasRequiredFields = false;

  NetReportOffer._() : super();
  factory NetReportOffer() => create();
  factory NetReportOffer.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetReportOffer.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetReportOffer clone() => NetReportOffer()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetReportOffer copyWith(void Function(NetReportOffer) updates) =>
      super.copyWith((message) =>
          updates(message as NetReportOffer)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetReportOffer create() => NetReportOffer._();
  NetReportOffer createEmptyInstance() => create();
  static $pb.PbList<NetReportOffer> createRepeated() =>
      $pb.PbList<NetReportOffer>();
  @$core.pragma('dart2js:noInline')
  static NetReportOffer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetReportOffer>(create);
  static NetReportOffer _defaultInstance;

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
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => clearField(2);
}

class NetReport extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetReport',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'supportTicket')
    ..hasRequiredFields = false;

  NetReport._() : super();
  factory NetReport() => create();
  factory NetReport.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetReport.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetReport clone() => NetReport()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetReport copyWith(void Function(NetReport) updates) =>
      super.copyWith((message) =>
          updates(message as NetReport)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetReport create() => NetReport._();
  NetReport createEmptyInstance() => create();
  static $pb.PbList<NetReport> createRepeated() => $pb.PbList<NetReport>();
  @$core.pragma('dart2js:noInline')
  static NetReport getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NetReport>(create);
  static NetReport _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get supportTicket => $_getSZ(0);
  @$pb.TagNumber(1)
  set supportTicket($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSupportTicket() => $_has(0);
  @$pb.TagNumber(1)
  void clearSupportTicket() => clearField(1);
}
