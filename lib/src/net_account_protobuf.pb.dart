///
//  Generated code. Do not modify.
//  source: net_account_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $1;

import 'enum_protobuf.pbenum.dart' as $0;

class NetAccountUpdate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetAccountUpdate',
      package: const $pb.PackageName('inf_common'))
    ..a<$1.DataAccount>(1, 'account', $pb.PbFieldType.OM,
        $1.DataAccount.getDefault, $1.DataAccount.create)
    ..hasRequiredFields = false;

  NetAccountUpdate() : super();
  NetAccountUpdate.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetAccountUpdate.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetAccountUpdate clone() => new NetAccountUpdate()..mergeFromMessage(this);
  NetAccountUpdate copyWith(void Function(NetAccountUpdate) updates) =>
      super.copyWith((message) => updates(message as NetAccountUpdate));
  $pb.BuilderInfo get info_ => _i;
  static NetAccountUpdate create() => new NetAccountUpdate();
  static $pb.PbList<NetAccountUpdate> createRepeated() =>
      new $pb.PbList<NetAccountUpdate>();
  static NetAccountUpdate getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetAccountUpdate _defaultInstance;
  static void $checkItem(NetAccountUpdate v) {
    if (v is! NetAccountUpdate) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $1.DataAccount get account => $_getN(0);
  set account($1.DataAccount v) {
    setField(1, v);
  }

  bool hasAccount() => $_has(0);
  void clearAccount() => clearField(1);
}

class NetSetAccountType extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetSetAccountType',
      package: const $pb.PackageName('inf_common'))
    ..e<$0.AccountType>(1, 'accountType', $pb.PbFieldType.OE,
        $0.AccountType.unknown, $0.AccountType.valueOf, $0.AccountType.values)
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
      package: const $pb.PackageName('inf_common'))
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

class NetOAuthGetUrl extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetOAuthGetUrl',
      package: const $pb.PackageName('inf_common'))
    ..a<int>(1, 'oauthProvider', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetOAuthGetUrl() : super();
  NetOAuthGetUrl.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetOAuthGetUrl.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetOAuthGetUrl clone() => new NetOAuthGetUrl()..mergeFromMessage(this);
  NetOAuthGetUrl copyWith(void Function(NetOAuthGetUrl) updates) =>
      super.copyWith((message) => updates(message as NetOAuthGetUrl));
  $pb.BuilderInfo get info_ => _i;
  static NetOAuthGetUrl create() => new NetOAuthGetUrl();
  static $pb.PbList<NetOAuthGetUrl> createRepeated() =>
      new $pb.PbList<NetOAuthGetUrl>();
  static NetOAuthGetUrl getDefault() => _defaultInstance ??= create()..freeze();
  static NetOAuthGetUrl _defaultInstance;
  static void $checkItem(NetOAuthGetUrl v) {
    if (v is! NetOAuthGetUrl) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get oauthProvider => $_get(0, 0);
  set oauthProvider(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasOauthProvider() => $_has(0);
  void clearOauthProvider() => clearField(1);
}

class NetOAuthUrl extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetOAuthUrl',
      package: const $pb.PackageName('inf_common'))
    ..aOS(1, 'authUrl')
    ..aOS(2, 'callbackUrl')
    ..hasRequiredFields = false;

  NetOAuthUrl() : super();
  NetOAuthUrl.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetOAuthUrl.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetOAuthUrl clone() => new NetOAuthUrl()..mergeFromMessage(this);
  NetOAuthUrl copyWith(void Function(NetOAuthUrl) updates) =>
      super.copyWith((message) => updates(message as NetOAuthUrl));
  $pb.BuilderInfo get info_ => _i;
  static NetOAuthUrl create() => new NetOAuthUrl();
  static $pb.PbList<NetOAuthUrl> createRepeated() =>
      new $pb.PbList<NetOAuthUrl>();
  static NetOAuthUrl getDefault() => _defaultInstance ??= create()..freeze();
  static NetOAuthUrl _defaultInstance;
  static void $checkItem(NetOAuthUrl v) {
    if (v is! NetOAuthUrl) $pb.checkItemFailed(v, _i.qualifiedMessageName);
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

class NetOAuthConnect extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetOAuthConnect',
      package: const $pb.PackageName('inf_common'))
    ..a<int>(1, 'oauthProvider', $pb.PbFieldType.O3)
    ..aOS(2, 'callbackQuery')
    ..hasRequiredFields = false;

  NetOAuthConnect() : super();
  NetOAuthConnect.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetOAuthConnect.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetOAuthConnect clone() => new NetOAuthConnect()..mergeFromMessage(this);
  NetOAuthConnect copyWith(void Function(NetOAuthConnect) updates) =>
      super.copyWith((message) => updates(message as NetOAuthConnect));
  $pb.BuilderInfo get info_ => _i;
  static NetOAuthConnect create() => new NetOAuthConnect();
  static $pb.PbList<NetOAuthConnect> createRepeated() =>
      new $pb.PbList<NetOAuthConnect>();
  static NetOAuthConnect getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetOAuthConnect _defaultInstance;
  static void $checkItem(NetOAuthConnect v) {
    if (v is! NetOAuthConnect) $pb.checkItemFailed(v, _i.qualifiedMessageName);
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

class NetOAuthConnection extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetOAuthConnection',
      package: const $pb.PackageName('inf_common'))
    ..a<$1.DataSocialMedia>(1, 'socialMedia', $pb.PbFieldType.OM,
        $1.DataSocialMedia.getDefault, $1.DataSocialMedia.create)
    ..hasRequiredFields = false;

  NetOAuthConnection() : super();
  NetOAuthConnection.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetOAuthConnection.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetOAuthConnection clone() =>
      new NetOAuthConnection()..mergeFromMessage(this);
  NetOAuthConnection copyWith(void Function(NetOAuthConnection) updates) =>
      super.copyWith((message) => updates(message as NetOAuthConnection));
  $pb.BuilderInfo get info_ => _i;
  static NetOAuthConnection create() => new NetOAuthConnection();
  static $pb.PbList<NetOAuthConnection> createRepeated() =>
      new $pb.PbList<NetOAuthConnection>();
  static NetOAuthConnection getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetOAuthConnection _defaultInstance;
  static void $checkItem(NetOAuthConnection v) {
    if (v is! NetOAuthConnection)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $1.DataSocialMedia get socialMedia => $_getN(0);
  set socialMedia($1.DataSocialMedia v) {
    setField(1, v);
  }

  bool hasSocialMedia() => $_has(0);
  void clearSocialMedia() => clearField(1);
}

class NetAccountCreate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetAccountCreate',
      package: const $pb.PackageName('inf_common'))
    ..a<double>(2, 'latitude', $pb.PbFieldType.OD)
    ..a<double>(3, 'longitude', $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  NetAccountCreate() : super();
  NetAccountCreate.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetAccountCreate.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetAccountCreate clone() => new NetAccountCreate()..mergeFromMessage(this);
  NetAccountCreate copyWith(void Function(NetAccountCreate) updates) =>
      super.copyWith((message) => updates(message as NetAccountCreate));
  $pb.BuilderInfo get info_ => _i;
  static NetAccountCreate create() => new NetAccountCreate();
  static $pb.PbList<NetAccountCreate> createRepeated() =>
      new $pb.PbList<NetAccountCreate>();
  static NetAccountCreate getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetAccountCreate _defaultInstance;
  static void $checkItem(NetAccountCreate v) {
    if (v is! NetAccountCreate) $pb.checkItemFailed(v, _i.qualifiedMessageName);
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
