///
//  Generated code. Do not modify.
//  source: net_ident_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

class NetSessionPayload extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetSessionPayload',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'sessionId')
    ..a<List<int>>(2, 'cookie', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  NetSessionPayload() : super();
  NetSessionPayload.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetSessionPayload.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetSessionPayload clone() => new NetSessionPayload()..mergeFromMessage(this);
  NetSessionPayload copyWith(void Function(NetSessionPayload) updates) =>
      super.copyWith((message) => updates(message as NetSessionPayload));
  $pb.BuilderInfo get info_ => _i;
  static NetSessionPayload create() => new NetSessionPayload();
  static $pb.PbList<NetSessionPayload> createRepeated() =>
      new $pb.PbList<NetSessionPayload>();
  static NetSessionPayload getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetSessionPayload _defaultInstance;
  static void $checkItem(NetSessionPayload v) {
    if (v is! NetSessionPayload)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get sessionId => $_getI64(0);
  set sessionId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasSessionId() => $_has(0);
  void clearSessionId() => clearField(1);

  List<int> get cookie => $_getN(1);
  set cookie(List<int> v) {
    $_setBytes(1, v);
  }

  bool hasCookie() => $_has(1);
  void clearCookie() => clearField(2);
}

class NetSessionCreate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetSessionCreate',
      package: const $pb.PackageName('inf_common'))
    ..a<List<int>>(1, 'deviceToken', $pb.PbFieldType.OY)
    ..aOS(2, 'deviceName')
    ..aOS(3, 'deviceInfo')
    ..hasRequiredFields = false;

  NetSessionCreate() : super();
  NetSessionCreate.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetSessionCreate.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetSessionCreate clone() => new NetSessionCreate()..mergeFromMessage(this);
  NetSessionCreate copyWith(void Function(NetSessionCreate) updates) =>
      super.copyWith((message) => updates(message as NetSessionCreate));
  $pb.BuilderInfo get info_ => _i;
  static NetSessionCreate create() => new NetSessionCreate();
  static $pb.PbList<NetSessionCreate> createRepeated() =>
      new $pb.PbList<NetSessionCreate>();
  static NetSessionCreate getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetSessionCreate _defaultInstance;
  static void $checkItem(NetSessionCreate v) {
    if (v is! NetSessionCreate) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<int> get deviceToken => $_getN(0);
  set deviceToken(List<int> v) {
    $_setBytes(0, v);
  }

  bool hasDeviceToken() => $_has(0);
  void clearDeviceToken() => clearField(1);

  String get deviceName => $_getS(1, '');
  set deviceName(String v) {
    $_setString(1, v);
  }

  bool hasDeviceName() => $_has(1);
  void clearDeviceName() => clearField(2);

  String get deviceInfo => $_getS(2, '');
  set deviceInfo(String v) {
    $_setString(2, v);
  }

  bool hasDeviceInfo() => $_has(2);
  void clearDeviceInfo() => clearField(3);
}

class NetSession extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetSession',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'sessionId')
    ..hasRequiredFields = false;

  NetSession() : super();
  NetSession.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetSession.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetSession clone() => new NetSession()..mergeFromMessage(this);
  NetSession copyWith(void Function(NetSession) updates) =>
      super.copyWith((message) => updates(message as NetSession));
  $pb.BuilderInfo get info_ => _i;
  static NetSession create() => new NetSession();
  static $pb.PbList<NetSession> createRepeated() =>
      new $pb.PbList<NetSession>();
  static NetSession getDefault() => _defaultInstance ??= create()..freeze();
  static NetSession _defaultInstance;
  static void $checkItem(NetSession v) {
    if (v is! NetSession) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get sessionId => $_getI64(0);
  set sessionId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasSessionId() => $_has(0);
  void clearSessionId() => clearField(1);
}
