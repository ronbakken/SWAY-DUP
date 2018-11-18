///
//  Generated code. Do not modify.
//  source: net_ident_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $1;

import 'enum_protobuf.pbenum.dart' as $0;

class NetDeviceAuthCreateReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'NetDeviceAuthCreateReq',
      package: const $pb.PackageName('inf'))
    ..a<List<int>>(1, 'aesKey', $pb.PbFieldType.OY)
    ..aOS(2, 'name')
    ..aOS(3, 'info')
    ..a<List<int>>(4, 'commonDeviceId', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  NetDeviceAuthCreateReq() : super();
  NetDeviceAuthCreateReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetDeviceAuthCreateReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetDeviceAuthCreateReq clone() =>
      new NetDeviceAuthCreateReq()..mergeFromMessage(this);
  NetDeviceAuthCreateReq copyWith(
          void Function(NetDeviceAuthCreateReq) updates) =>
      super.copyWith((message) => updates(message as NetDeviceAuthCreateReq));
  $pb.BuilderInfo get info_ => _i;
  static NetDeviceAuthCreateReq create() => new NetDeviceAuthCreateReq();
  static $pb.PbList<NetDeviceAuthCreateReq> createRepeated() =>
      new $pb.PbList<NetDeviceAuthCreateReq>();
  static NetDeviceAuthCreateReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetDeviceAuthCreateReq _defaultInstance;
  static void $checkItem(NetDeviceAuthCreateReq v) {
    if (v is! NetDeviceAuthCreateReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<int> get aesKey => $_getN(0);
  set aesKey(List<int> v) {
    $_setBytes(0, v);
  }

  bool hasAesKey() => $_has(0);
  void clearAesKey() => clearField(1);

  String get name => $_getS(1, '');
  set name(String v) {
    $_setString(1, v);
  }

  bool hasName() => $_has(1);
  void clearName() => clearField(2);

  String get info => $_getS(2, '');
  set info(String v) {
    $_setString(2, v);
  }

  bool hasInfo() => $_has(2);
  void clearInfo() => clearField(3);

  List<int> get commonDeviceId => $_getN(3);
  set commonDeviceId(List<int> v) {
    $_setBytes(3, v);
  }

  bool hasCommonDeviceId() => $_has(3);
  void clearCommonDeviceId() => clearField(4);
}

class NetDeviceAuthChallengeReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'NetDeviceAuthChallengeReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'deviceId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetDeviceAuthChallengeReq() : super();
  NetDeviceAuthChallengeReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetDeviceAuthChallengeReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetDeviceAuthChallengeReq clone() =>
      new NetDeviceAuthChallengeReq()..mergeFromMessage(this);
  NetDeviceAuthChallengeReq copyWith(
          void Function(NetDeviceAuthChallengeReq) updates) =>
      super
          .copyWith((message) => updates(message as NetDeviceAuthChallengeReq));
  $pb.BuilderInfo get info_ => _i;
  static NetDeviceAuthChallengeReq create() => new NetDeviceAuthChallengeReq();
  static $pb.PbList<NetDeviceAuthChallengeReq> createRepeated() =>
      new $pb.PbList<NetDeviceAuthChallengeReq>();
  static NetDeviceAuthChallengeReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetDeviceAuthChallengeReq _defaultInstance;
  static void $checkItem(NetDeviceAuthChallengeReq v) {
    if (v is! NetDeviceAuthChallengeReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get deviceId => $_get(0, 0);
  set deviceId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasDeviceId() => $_has(0);
  void clearDeviceId() => clearField(1);
}

class NetDeviceAuthChallengeResReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'NetDeviceAuthChallengeResReq',
      package: const $pb.PackageName('inf'))
    ..a<List<int>>(1, 'challenge', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  NetDeviceAuthChallengeResReq() : super();
  NetDeviceAuthChallengeResReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetDeviceAuthChallengeResReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetDeviceAuthChallengeResReq clone() =>
      new NetDeviceAuthChallengeResReq()..mergeFromMessage(this);
  NetDeviceAuthChallengeResReq copyWith(
          void Function(NetDeviceAuthChallengeResReq) updates) =>
      super.copyWith(
          (message) => updates(message as NetDeviceAuthChallengeResReq));
  $pb.BuilderInfo get info_ => _i;
  static NetDeviceAuthChallengeResReq create() =>
      new NetDeviceAuthChallengeResReq();
  static $pb.PbList<NetDeviceAuthChallengeResReq> createRepeated() =>
      new $pb.PbList<NetDeviceAuthChallengeResReq>();
  static NetDeviceAuthChallengeResReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetDeviceAuthChallengeResReq _defaultInstance;
  static void $checkItem(NetDeviceAuthChallengeResReq v) {
    if (v is! NetDeviceAuthChallengeResReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<int> get challenge => $_getN(0);
  set challenge(List<int> v) {
    $_setBytes(0, v);
  }

  bool hasChallenge() => $_has(0);
  void clearChallenge() => clearField(1);
}

class NetDeviceAuthSignatureResReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'NetDeviceAuthSignatureResReq',
      package: const $pb.PackageName('inf'))
    ..a<List<int>>(1, 'signature', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  NetDeviceAuthSignatureResReq() : super();
  NetDeviceAuthSignatureResReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetDeviceAuthSignatureResReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetDeviceAuthSignatureResReq clone() =>
      new NetDeviceAuthSignatureResReq()..mergeFromMessage(this);
  NetDeviceAuthSignatureResReq copyWith(
          void Function(NetDeviceAuthSignatureResReq) updates) =>
      super.copyWith(
          (message) => updates(message as NetDeviceAuthSignatureResReq));
  $pb.BuilderInfo get info_ => _i;
  static NetDeviceAuthSignatureResReq create() =>
      new NetDeviceAuthSignatureResReq();
  static $pb.PbList<NetDeviceAuthSignatureResReq> createRepeated() =>
      new $pb.PbList<NetDeviceAuthSignatureResReq>();
  static NetDeviceAuthSignatureResReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetDeviceAuthSignatureResReq _defaultInstance;
  static void $checkItem(NetDeviceAuthSignatureResReq v) {
    if (v is! NetDeviceAuthSignatureResReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<int> get signature => $_getN(0);
  set signature(List<int> v) {
    $_setBytes(0, v);
  }

  bool hasSignature() => $_has(0);
  void clearSignature() => clearField(1);
}

class NetDeviceAuthState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetDeviceAuthState',
      package: const $pb.PackageName('inf'))
    ..a<$1.DataAccount>(8, 'data', $pb.PbFieldType.OM,
        $1.DataAccount.getDefault, $1.DataAccount.create)
    ..hasRequiredFields = false;

  NetDeviceAuthState() : super();
  NetDeviceAuthState.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetDeviceAuthState.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetDeviceAuthState clone() =>
      new NetDeviceAuthState()..mergeFromMessage(this);
  NetDeviceAuthState copyWith(void Function(NetDeviceAuthState) updates) =>
      super.copyWith((message) => updates(message as NetDeviceAuthState));
  $pb.BuilderInfo get info_ => _i;
  static NetDeviceAuthState create() => new NetDeviceAuthState();
  static $pb.PbList<NetDeviceAuthState> createRepeated() =>
      new $pb.PbList<NetDeviceAuthState>();
  static NetDeviceAuthState getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetDeviceAuthState _defaultInstance;
  static void $checkItem(NetDeviceAuthState v) {
    if (v is! NetDeviceAuthState)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $1.DataAccount get data => $_getN(0);
  set data($1.DataAccount v) {
    setField(8, v);
  }

  bool hasData() => $_has(0);
  void clearData() => clearField(8);
}

class NetSetAccountType extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetSetAccountType',
      package: const $pb.PackageName('inf'))
    ..e<$0.AccountType>(
        1,
        'accountType',
        $pb.PbFieldType.OE,
        $0.AccountType.unknown,
        $0.AccountType.valueOf,
        $0.AccountType.values)
    ..hasRequiredFields = false;

  NetSetAccountType() : super();
  NetSetAccountType.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetSetAccountType.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetSetAccountType clone() => new NetSetAccountType()..mergeFromMessage(this);
  NetSetAccountType copyWith(void Function(NetSetAccountType) updates) =>
      super.copyWith((message) => updates(message as NetSetAccountType));
  $pb.BuilderInfo get info_ => _i;
  static NetSetAccountType create() => new NetSetAccountType();
  static $pb.PbList<NetSetAccountType> createRepeated() =>
      new $pb.PbList<NetSetAccountType>();
  static NetSetAccountType getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetSetAccountType _defaultInstance;
  static void $checkItem(NetSetAccountType v) {
    if (v is! NetSetAccountType)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $0.AccountType get accountType => $_getN(0);
  set accountType($0.AccountType v) {
    setField(1, v);
  }

  bool hasAccountType() => $_has(0);
  void clearAccountType() => clearField(1);
}

class NetSetFirebaseToken extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetSetFirebaseToken',
      package: const $pb.PackageName('inf'))
    ..aOS(1, 'firebaseToken')
    ..aOS(2, 'oldFirebaseToken')
    ..hasRequiredFields = false;

  NetSetFirebaseToken() : super();
  NetSetFirebaseToken.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetSetFirebaseToken.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetSetFirebaseToken clone() =>
      new NetSetFirebaseToken()..mergeFromMessage(this);
  NetSetFirebaseToken copyWith(void Function(NetSetFirebaseToken) updates) =>
      super.copyWith((message) => updates(message as NetSetFirebaseToken));
  $pb.BuilderInfo get info_ => _i;
  static NetSetFirebaseToken create() => new NetSetFirebaseToken();
  static $pb.PbList<NetSetFirebaseToken> createRepeated() =>
      new $pb.PbList<NetSetFirebaseToken>();
  static NetSetFirebaseToken getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetSetFirebaseToken _defaultInstance;
  static void $checkItem(NetSetFirebaseToken v) {
    if (v is! NetSetFirebaseToken)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get firebaseToken => $_getS(0, '');
  set firebaseToken(String v) {
    $_setString(0, v);
  }

  bool hasFirebaseToken() => $_has(0);
  void clearFirebaseToken() => clearField(1);

  String get oldFirebaseToken => $_getS(1, '');
  set oldFirebaseToken(String v) {
    $_setString(1, v);
  }

  bool hasOldFirebaseToken() => $_has(1);
  void clearOldFirebaseToken() => clearField(2);
}

class NetOAuthUrlReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetOAuthUrlReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'oauthProvider', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetOAuthUrlReq() : super();
  NetOAuthUrlReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetOAuthUrlReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetOAuthUrlReq clone() => new NetOAuthUrlReq()..mergeFromMessage(this);
  NetOAuthUrlReq copyWith(void Function(NetOAuthUrlReq) updates) =>
      super.copyWith((message) => updates(message as NetOAuthUrlReq));
  $pb.BuilderInfo get info_ => _i;
  static NetOAuthUrlReq create() => new NetOAuthUrlReq();
  static $pb.PbList<NetOAuthUrlReq> createRepeated() =>
      new $pb.PbList<NetOAuthUrlReq>();
  static NetOAuthUrlReq getDefault() => _defaultInstance ??= create()..freeze();
  static NetOAuthUrlReq _defaultInstance;
  static void $checkItem(NetOAuthUrlReq v) {
    if (v is! NetOAuthUrlReq) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get oauthProvider => $_get(0, 0);
  set oauthProvider(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasOauthProvider() => $_has(0);
  void clearOauthProvider() => clearField(1);
}

class NetOAuthUrlRes extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetOAuthUrlRes',
      package: const $pb.PackageName('inf'))
    ..aOS(1, 'authUrl')
    ..aOS(2, 'callbackUrl')
    ..hasRequiredFields = false;

  NetOAuthUrlRes() : super();
  NetOAuthUrlRes.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetOAuthUrlRes.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetOAuthUrlRes clone() => new NetOAuthUrlRes()..mergeFromMessage(this);
  NetOAuthUrlRes copyWith(void Function(NetOAuthUrlRes) updates) =>
      super.copyWith((message) => updates(message as NetOAuthUrlRes));
  $pb.BuilderInfo get info_ => _i;
  static NetOAuthUrlRes create() => new NetOAuthUrlRes();
  static $pb.PbList<NetOAuthUrlRes> createRepeated() =>
      new $pb.PbList<NetOAuthUrlRes>();
  static NetOAuthUrlRes getDefault() => _defaultInstance ??= create()..freeze();
  static NetOAuthUrlRes _defaultInstance;
  static void $checkItem(NetOAuthUrlRes v) {
    if (v is! NetOAuthUrlRes) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get authUrl => $_getS(0, '');
  set authUrl(String v) {
    $_setString(0, v);
  }

  bool hasAuthUrl() => $_has(0);
  void clearAuthUrl() => clearField(1);

  String get callbackUrl => $_getS(1, '');
  set callbackUrl(String v) {
    $_setString(1, v);
  }

  bool hasCallbackUrl() => $_has(1);
  void clearCallbackUrl() => clearField(2);
}

class NetOAuthConnectReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetOAuthConnectReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'oauthProvider', $pb.PbFieldType.O3)
    ..aOS(2, 'callbackQuery')
    ..hasRequiredFields = false;

  NetOAuthConnectReq() : super();
  NetOAuthConnectReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetOAuthConnectReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetOAuthConnectReq clone() =>
      new NetOAuthConnectReq()..mergeFromMessage(this);
  NetOAuthConnectReq copyWith(void Function(NetOAuthConnectReq) updates) =>
      super.copyWith((message) => updates(message as NetOAuthConnectReq));
  $pb.BuilderInfo get info_ => _i;
  static NetOAuthConnectReq create() => new NetOAuthConnectReq();
  static $pb.PbList<NetOAuthConnectReq> createRepeated() =>
      new $pb.PbList<NetOAuthConnectReq>();
  static NetOAuthConnectReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetOAuthConnectReq _defaultInstance;
  static void $checkItem(NetOAuthConnectReq v) {
    if (v is! NetOAuthConnectReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get oauthProvider => $_get(0, 0);
  set oauthProvider(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasOauthProvider() => $_has(0);
  void clearOauthProvider() => clearField(1);

  String get callbackQuery => $_getS(1, '');
  set callbackQuery(String v) {
    $_setString(1, v);
  }

  bool hasCallbackQuery() => $_has(1);
  void clearCallbackQuery() => clearField(2);
}

class NetOAuthConnectRes extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetOAuthConnectRes',
      package: const $pb.PackageName('inf'))
    ..a<$1.DataSocialMedia>(1, 'socialMedia', $pb.PbFieldType.OM,
        $1.DataSocialMedia.getDefault, $1.DataSocialMedia.create)
    ..hasRequiredFields = false;

  NetOAuthConnectRes() : super();
  NetOAuthConnectRes.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetOAuthConnectRes.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetOAuthConnectRes clone() =>
      new NetOAuthConnectRes()..mergeFromMessage(this);
  NetOAuthConnectRes copyWith(void Function(NetOAuthConnectRes) updates) =>
      super.copyWith((message) => updates(message as NetOAuthConnectRes));
  $pb.BuilderInfo get info_ => _i;
  static NetOAuthConnectRes create() => new NetOAuthConnectRes();
  static $pb.PbList<NetOAuthConnectRes> createRepeated() =>
      new $pb.PbList<NetOAuthConnectRes>();
  static NetOAuthConnectRes getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetOAuthConnectRes _defaultInstance;
  static void $checkItem(NetOAuthConnectRes v) {
    if (v is! NetOAuthConnectRes)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $1.DataSocialMedia get socialMedia => $_getN(0);
  set socialMedia($1.DataSocialMedia v) {
    setField(1, v);
  }

  bool hasSocialMedia() => $_has(0);
  void clearSocialMedia() => clearField(1);
}

class NetAccountCreateReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetAccountCreateReq',
      package: const $pb.PackageName('inf'))
    ..a<double>(2, 'latitude', $pb.PbFieldType.OD)
    ..a<double>(3, 'longitude', $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  NetAccountCreateReq() : super();
  NetAccountCreateReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetAccountCreateReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetAccountCreateReq clone() =>
      new NetAccountCreateReq()..mergeFromMessage(this);
  NetAccountCreateReq copyWith(void Function(NetAccountCreateReq) updates) =>
      super.copyWith((message) => updates(message as NetAccountCreateReq));
  $pb.BuilderInfo get info_ => _i;
  static NetAccountCreateReq create() => new NetAccountCreateReq();
  static $pb.PbList<NetAccountCreateReq> createRepeated() =>
      new $pb.PbList<NetAccountCreateReq>();
  static NetAccountCreateReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetAccountCreateReq _defaultInstance;
  static void $checkItem(NetAccountCreateReq v) {
    if (v is! NetAccountCreateReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  double get latitude => $_getN(0);
  set latitude(double v) {
    $_setDouble(0, v);
  }

  bool hasLatitude() => $_has(0);
  void clearLatitude() => clearField(2);

  double get longitude => $_getN(1);
  set longitude(double v) {
    $_setDouble(1, v);
  }

  bool hasLongitude() => $_has(1);
  void clearLongitude() => clearField(3);
}
