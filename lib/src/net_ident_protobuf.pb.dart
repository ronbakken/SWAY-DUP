///
//  Generated code. Do not modify.
//  source: net_ident_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $10;

class NetSessionPayload extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetSessionPayload',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'sessionId')
    ..a<List<int>>(2, 'cookie', $pb.PbFieldType.OY)
    ..a<int>(3, 'clientVersion', $pb.PbFieldType.O3)
    ..aInt64(4, 'configTimestamp')
    ..aOS(5, 'configRegion')
    ..aOS(6, 'configLanguage')
    ..aOS(7, 'domain')
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

  int get clientVersion => $_get(2, 0);
  set clientVersion(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasClientVersion() => $_has(2);
  void clearClientVersion() => clearField(3);

  Int64 get configTimestamp => $_getI64(3);
  set configTimestamp(Int64 v) {
    $_setInt64(3, v);
  }

  bool hasConfigTimestamp() => $_has(3);
  void clearConfigTimestamp() => clearField(4);

  String get configRegion => $_getS(4, '');
  set configRegion(String v) {
    $_setString(4, v);
  }

  bool hasConfigRegion() => $_has(4);
  void clearConfigRegion() => clearField(5);

  String get configLanguage => $_getS(5, '');
  set configLanguage(String v) {
    $_setString(5, v);
  }

  bool hasConfigLanguage() => $_has(5);
  void clearConfigLanguage() => clearField(6);

  String get domain => $_getS(6, '');
  set domain(String v) {
    $_setString(6, v);
  }

  bool hasDomain() => $_has(6);
  void clearDomain() => clearField(7);
}

class NetSessionOpen extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetSessionOpen',
      package: const $pb.PackageName('inf_common'))
    ..aOS(7, 'domain')
    ..a<int>(8, 'clientVersion', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetSessionOpen() : super();
  NetSessionOpen.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetSessionOpen.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetSessionOpen clone() => new NetSessionOpen()..mergeFromMessage(this);
  NetSessionOpen copyWith(void Function(NetSessionOpen) updates) =>
      super.copyWith((message) => updates(message as NetSessionOpen));
  $pb.BuilderInfo get info_ => _i;
  static NetSessionOpen create() => new NetSessionOpen();
  static $pb.PbList<NetSessionOpen> createRepeated() =>
      new $pb.PbList<NetSessionOpen>();
  static NetSessionOpen getDefault() => _defaultInstance ??= create()..freeze();
  static NetSessionOpen _defaultInstance;
  static void $checkItem(NetSessionOpen v) {
    if (v is! NetSessionOpen) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get domain => $_getS(0, '');
  set domain(String v) {
    $_setString(0, v);
  }

  bool hasDomain() => $_has(0);
  void clearDomain() => clearField(7);

  int get clientVersion => $_get(1, 0);
  set clientVersion(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasClientVersion() => $_has(1);
  void clearClientVersion() => clearField(8);
}

class NetSessionCreate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetSessionCreate',
      package: const $pb.PackageName('inf_common'))
    ..a<List<int>>(1, 'deviceToken', $pb.PbFieldType.OY)
    ..aOS(2, 'deviceName')
    ..aOS(3, 'deviceInfo')
    ..aOS(7, 'domain')
    ..a<int>(8, 'clientVersion', $pb.PbFieldType.O3)
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

  String get domain => $_getS(3, '');
  set domain(String v) {
    $_setString(3, v);
  }

  bool hasDomain() => $_has(3);
  void clearDomain() => clearField(7);

  int get clientVersion => $_get(4, 0);
  set clientVersion(int v) {
    $_setSignedInt32(4, v);
  }

  bool hasClientVersion() => $_has(4);
  void clearClientVersion() => clearField(8);
}

class NetSessionRemove extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetSessionRemove',
      package: const $pb.PackageName('inf_common'))
    ..hasRequiredFields = false;

  NetSessionRemove() : super();
  NetSessionRemove.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetSessionRemove.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetSessionRemove clone() => new NetSessionRemove()..mergeFromMessage(this);
  NetSessionRemove copyWith(void Function(NetSessionRemove) updates) =>
      super.copyWith((message) => updates(message as NetSessionRemove));
  $pb.BuilderInfo get info_ => _i;
  static NetSessionRemove create() => new NetSessionRemove();
  static $pb.PbList<NetSessionRemove> createRepeated() =>
      new $pb.PbList<NetSessionRemove>();
  static NetSessionRemove getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetSessionRemove _defaultInstance;
  static void $checkItem(NetSessionRemove v) {
    if (v is! NetSessionRemove) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

class NetSession extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetSession',
      package: const $pb.PackageName('inf_common'))
    ..a<$10.DataAccount>(2, 'account', $pb.PbFieldType.OM,
        $10.DataAccount.getDefault, $10.DataAccount.create)
    ..aOS(3, 'bearerToken')
    ..aOS(4, 'accessToken')
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

  $10.DataAccount get account => $_getN(0);
  set account($10.DataAccount v) {
    setField(2, v);
  }

  bool hasAccount() => $_has(0);
  void clearAccount() => clearField(2);

  String get bearerToken => $_getS(1, '');
  set bearerToken(String v) {
    $_setString(1, v);
  }

  bool hasBearerToken() => $_has(1);
  void clearBearerToken() => clearField(3);

  String get accessToken => $_getS(2, '');
  set accessToken(String v) {
    $_setString(2, v);
  }

  bool hasAccessToken() => $_has(2);
  void clearAccessToken() => clearField(4);
}
