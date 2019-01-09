///
//  Generated code. Do not modify.
//  source: net_report_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

class NetReportOffer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetReportOffer',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'offerId')
    ..aOS(2, 'text')
    ..hasRequiredFields = false;

  NetReportOffer() : super();
  NetReportOffer.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetReportOffer.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetReportOffer clone() => new NetReportOffer()..mergeFromMessage(this);
  NetReportOffer copyWith(void Function(NetReportOffer) updates) =>
      super.copyWith((message) => updates(message as NetReportOffer));
  $pb.BuilderInfo get info_ => _i;
  static NetReportOffer create() => new NetReportOffer();
  NetReportOffer createEmptyInstance() => create();
  static $pb.PbList<NetReportOffer> createRepeated() =>
      new $pb.PbList<NetReportOffer>();
  static NetReportOffer getDefault() => _defaultInstance ??= create()..freeze();
  static NetReportOffer _defaultInstance;
  static void $checkItem(NetReportOffer v) {
    if (v is! NetReportOffer) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get offerId => $_getI64(0);
  set offerId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasOfferId() => $_has(0);
  void clearOfferId() => clearField(1);

  String get text => $_getS(1, '');
  set text(String v) {
    $_setString(1, v);
  }

  bool hasText() => $_has(1);
  void clearText() => clearField(2);
}

class NetReport extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetReport',
      package: const $pb.PackageName('inf_common'))
    ..aOS(1, 'supportTicket')
    ..hasRequiredFields = false;

  NetReport() : super();
  NetReport.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetReport.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetReport clone() => new NetReport()..mergeFromMessage(this);
  NetReport copyWith(void Function(NetReport) updates) =>
      super.copyWith((message) => updates(message as NetReport));
  $pb.BuilderInfo get info_ => _i;
  static NetReport create() => new NetReport();
  NetReport createEmptyInstance() => create();
  static $pb.PbList<NetReport> createRepeated() => new $pb.PbList<NetReport>();
  static NetReport getDefault() => _defaultInstance ??= create()..freeze();
  static NetReport _defaultInstance;
  static void $checkItem(NetReport v) {
    if (v is! NetReport) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get supportTicket => $_getS(0, '');
  set supportTicket(String v) {
    $_setString(0, v);
  }

  bool hasSupportTicket() => $_has(0);
  void clearSupportTicket() => clearField(1);
}
