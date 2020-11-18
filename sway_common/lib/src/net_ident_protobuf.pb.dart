///
//  Generated code. Do not modify.
//  source: net_ident_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $10;

class NetSessionOpen extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetSessionOpen',
      package: const $pb.PackageName('inf'))
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
  NetSessionOpen createEmptyInstance() => create();
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
      package: const $pb.PackageName('inf'))
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
  NetSessionCreate createEmptyInstance() => create();
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

class NetSession extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('NetSession', package: const $pb.PackageName('inf'))
        ..a<$10.DataAccount>(2, 'account', $pb.PbFieldType.OM,
            $10.DataAccount.getDefault, $10.DataAccount.create)
        ..aOS(3, 'refreshToken')
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
  NetSession createEmptyInstance() => create();
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

  String get refreshToken => $_getS(1, '');
  set refreshToken(String v) {
    $_setString(1, v);
  }

  bool hasRefreshToken() => $_has(1);
  void clearRefreshToken() => clearField(3);

  String get accessToken => $_getS(2, '');
  set accessToken(String v) {
    $_setString(2, v);
  }

  bool hasAccessToken() => $_has(2);
  void clearAccessToken() => clearField(4);
}
