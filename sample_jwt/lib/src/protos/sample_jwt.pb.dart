///
//  Generated code. Do not modify.
//  source: protos/sample_jwt.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

class ReqGenerate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ReqGenerate', package: const $pb.PackageName('sample_jwt'))
    ..aOS(1, 'payload')
    ..hasRequiredFields = false
  ;

  ReqGenerate() : super();
  ReqGenerate.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ReqGenerate.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ReqGenerate clone() => new ReqGenerate()..mergeFromMessage(this);
  ReqGenerate copyWith(void Function(ReqGenerate) updates) => super.copyWith((message) => updates(message as ReqGenerate));
  $pb.BuilderInfo get info_ => _i;
  static ReqGenerate create() => new ReqGenerate();
  ReqGenerate createEmptyInstance() => create();
  static $pb.PbList<ReqGenerate> createRepeated() => new $pb.PbList<ReqGenerate>();
  static ReqGenerate getDefault() => _defaultInstance ??= create()..freeze();
  static ReqGenerate _defaultInstance;
  static void $checkItem(ReqGenerate v) {
    if (v is! ReqGenerate) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get payload => $_getS(0, '');
  set payload(String v) { $_setString(0, v); }
  bool hasPayload() => $_has(0);
  void clearPayload() => clearField(1);
}

class ResGenerate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ResGenerate', package: const $pb.PackageName('sample_jwt'))
    ..aOS(1, 'token')
    ..hasRequiredFields = false
  ;

  ResGenerate() : super();
  ResGenerate.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ResGenerate.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ResGenerate clone() => new ResGenerate()..mergeFromMessage(this);
  ResGenerate copyWith(void Function(ResGenerate) updates) => super.copyWith((message) => updates(message as ResGenerate));
  $pb.BuilderInfo get info_ => _i;
  static ResGenerate create() => new ResGenerate();
  ResGenerate createEmptyInstance() => create();
  static $pb.PbList<ResGenerate> createRepeated() => new $pb.PbList<ResGenerate>();
  static ResGenerate getDefault() => _defaultInstance ??= create()..freeze();
  static ResGenerate _defaultInstance;
  static void $checkItem(ResGenerate v) {
    if (v is! ResGenerate) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get token => $_getS(0, '');
  set token(String v) { $_setString(0, v); }
  bool hasToken() => $_has(0);
  void clearToken() => clearField(1);
}

class ReqValidate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ReqValidate', package: const $pb.PackageName('sample_jwt'))
    ..hasRequiredFields = false
  ;

  ReqValidate() : super();
  ReqValidate.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ReqValidate.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ReqValidate clone() => new ReqValidate()..mergeFromMessage(this);
  ReqValidate copyWith(void Function(ReqValidate) updates) => super.copyWith((message) => updates(message as ReqValidate));
  $pb.BuilderInfo get info_ => _i;
  static ReqValidate create() => new ReqValidate();
  ReqValidate createEmptyInstance() => create();
  static $pb.PbList<ReqValidate> createRepeated() => new $pb.PbList<ReqValidate>();
  static ReqValidate getDefault() => _defaultInstance ??= create()..freeze();
  static ReqValidate _defaultInstance;
  static void $checkItem(ReqValidate v) {
    if (v is! ReqValidate) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

class ResValidate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ResValidate', package: const $pb.PackageName('sample_jwt'))
    ..aOS(1, 'payload')
    ..hasRequiredFields = false
  ;

  ResValidate() : super();
  ResValidate.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ResValidate.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ResValidate clone() => new ResValidate()..mergeFromMessage(this);
  ResValidate copyWith(void Function(ResValidate) updates) => super.copyWith((message) => updates(message as ResValidate));
  $pb.BuilderInfo get info_ => _i;
  static ResValidate create() => new ResValidate();
  ResValidate createEmptyInstance() => create();
  static $pb.PbList<ResValidate> createRepeated() => new $pb.PbList<ResValidate>();
  static ResValidate getDefault() => _defaultInstance ??= create()..freeze();
  static ResValidate _defaultInstance;
  static void $checkItem(ResValidate v) {
    if (v is! ResValidate) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get payload => $_getS(0, '');
  set payload(String v) { $_setString(0, v); }
  bool hasPayload() => $_has(0);
  void clearPayload() => clearField(1);
}

