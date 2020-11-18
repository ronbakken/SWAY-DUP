///
//  Generated code. Do not modify.
//  source: backend_jwt.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

class ReqSign extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('ReqSign', package: const $pb.PackageName('inf'))
        ..aOS(1, 'claim')
        ..hasRequiredFields = false;

  ReqSign() : super();
  ReqSign.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ReqSign.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ReqSign clone() => new ReqSign()..mergeFromMessage(this);
  ReqSign copyWith(void Function(ReqSign) updates) =>
      super.copyWith((message) => updates(message as ReqSign));
  $pb.BuilderInfo get info_ => _i;
  static ReqSign create() => new ReqSign();
  ReqSign createEmptyInstance() => create();
  static $pb.PbList<ReqSign> createRepeated() => new $pb.PbList<ReqSign>();
  static ReqSign getDefault() => _defaultInstance ??= create()..freeze();
  static ReqSign _defaultInstance;
  static void $checkItem(ReqSign v) {
    if (v is! ReqSign) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get claim => $_getS(0, '');
  set claim(String v) {
    $_setString(0, v);
  }

  bool hasClaim() => $_has(0);
  void clearClaim() => clearField(1);
}

class ResSign extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('ResSign', package: const $pb.PackageName('inf'))
        ..aOS(1, 'token')
        ..hasRequiredFields = false;

  ResSign() : super();
  ResSign.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ResSign.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ResSign clone() => new ResSign()..mergeFromMessage(this);
  ResSign copyWith(void Function(ResSign) updates) =>
      super.copyWith((message) => updates(message as ResSign));
  $pb.BuilderInfo get info_ => _i;
  static ResSign create() => new ResSign();
  ResSign createEmptyInstance() => create();
  static $pb.PbList<ResSign> createRepeated() => new $pb.PbList<ResSign>();
  static ResSign getDefault() => _defaultInstance ??= create()..freeze();
  static ResSign _defaultInstance;
  static void $checkItem(ResSign v) {
    if (v is! ResSign) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get token => $_getS(0, '');
  set token(String v) {
    $_setString(0, v);
  }

  bool hasToken() => $_has(0);
  void clearToken() => clearField(1);
}

class ReqGetKeyStore extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ReqGetKeyStore',
      package: const $pb.PackageName('inf'))
    ..hasRequiredFields = false;

  ReqGetKeyStore() : super();
  ReqGetKeyStore.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ReqGetKeyStore.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ReqGetKeyStore clone() => new ReqGetKeyStore()..mergeFromMessage(this);
  ReqGetKeyStore copyWith(void Function(ReqGetKeyStore) updates) =>
      super.copyWith((message) => updates(message as ReqGetKeyStore));
  $pb.BuilderInfo get info_ => _i;
  static ReqGetKeyStore create() => new ReqGetKeyStore();
  ReqGetKeyStore createEmptyInstance() => create();
  static $pb.PbList<ReqGetKeyStore> createRepeated() =>
      new $pb.PbList<ReqGetKeyStore>();
  static ReqGetKeyStore getDefault() => _defaultInstance ??= create()..freeze();
  static ReqGetKeyStore _defaultInstance;
  static void $checkItem(ReqGetKeyStore v) {
    if (v is! ReqGetKeyStore) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

class ResGetKeyStore extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ResGetKeyStore',
      package: const $pb.PackageName('inf'))
    ..aOS(1, 'jwks')
    ..hasRequiredFields = false;

  ResGetKeyStore() : super();
  ResGetKeyStore.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ResGetKeyStore.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ResGetKeyStore clone() => new ResGetKeyStore()..mergeFromMessage(this);
  ResGetKeyStore copyWith(void Function(ResGetKeyStore) updates) =>
      super.copyWith((message) => updates(message as ResGetKeyStore));
  $pb.BuilderInfo get info_ => _i;
  static ResGetKeyStore create() => new ResGetKeyStore();
  ResGetKeyStore createEmptyInstance() => create();
  static $pb.PbList<ResGetKeyStore> createRepeated() =>
      new $pb.PbList<ResGetKeyStore>();
  static ResGetKeyStore getDefault() => _defaultInstance ??= create()..freeze();
  static ResGetKeyStore _defaultInstance;
  static void $checkItem(ResGetKeyStore v) {
    if (v is! ResGetKeyStore) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get jwks => $_getS(0, '');
  set jwks(String v) {
    $_setString(0, v);
  }

  bool hasJwks() => $_has(0);
  void clearJwks() => clearField(1);
}
