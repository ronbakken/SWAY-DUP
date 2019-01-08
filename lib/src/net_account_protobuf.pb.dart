///
//  Generated code. Do not modify.
//  source: net_account_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $10;

import 'enum_protobuf.pbenum.dart' as $9;

class NetAccount extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetAccount',
      package: const $pb.PackageName('inf_common'))
    ..a<$10.DataAccount>(1, 'account', $pb.PbFieldType.OM,
        $10.DataAccount.getDefault, $10.DataAccount.create)
    ..hasRequiredFields = false;

  NetAccount() : super();
  NetAccount.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetAccount.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetAccount clone() => new NetAccount()..mergeFromMessage(this);
  NetAccount copyWith(void Function(NetAccount) updates) =>
      super.copyWith((message) => updates(message as NetAccount));
  $pb.BuilderInfo get info_ => _i;
  static NetAccount create() => new NetAccount();
  static $pb.PbList<NetAccount> createRepeated() =>
      new $pb.PbList<NetAccount>();
  static NetAccount getDefault() => _defaultInstance ??= create()..freeze();
  static NetAccount _defaultInstance;
  static void $checkItem(NetAccount v) {
    if (v is! NetAccount) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $10.DataAccount get account => $_getN(0);
  set account($10.DataAccount v) {
    setField(1, v);
  }

  bool hasAccount() => $_has(0);
  void clearAccount() => clearField(1);
}

class NetSetAccountType extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetSetAccountType',
      package: const $pb.PackageName('inf_common'))
    ..e<$9.AccountType>(1, 'accountType', $pb.PbFieldType.OE,
        $9.AccountType.unknown, $9.AccountType.valueOf, $9.AccountType.values)
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

  $9.AccountType get accountType => $_getN(0);
  set accountType($9.AccountType v) {
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

class NetOAuthGetSecrets extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetOAuthGetSecrets',
      package: const $pb.PackageName('inf_common'))
    ..a<int>(1, 'oauthProvider', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetOAuthGetSecrets() : super();
  NetOAuthGetSecrets.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetOAuthGetSecrets.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetOAuthGetSecrets clone() =>
      new NetOAuthGetSecrets()..mergeFromMessage(this);
  NetOAuthGetSecrets copyWith(void Function(NetOAuthGetSecrets) updates) =>
      super.copyWith((message) => updates(message as NetOAuthGetSecrets));
  $pb.BuilderInfo get info_ => _i;
  static NetOAuthGetSecrets create() => new NetOAuthGetSecrets();
  static $pb.PbList<NetOAuthGetSecrets> createRepeated() =>
      new $pb.PbList<NetOAuthGetSecrets>();
  static NetOAuthGetSecrets getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetOAuthGetSecrets _defaultInstance;
  static void $checkItem(NetOAuthGetSecrets v) {
    if (v is! NetOAuthGetSecrets)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get oauthProvider => $_get(0, 0);
  set oauthProvider(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasOauthProvider() => $_has(0);
  void clearOauthProvider() => clearField(1);
}

class NetOAuthSecrets extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetOAuthSecrets',
      package: const $pb.PackageName('inf_common'))
    ..aOS(10, 'consumerKey')
    ..aOS(11, 'consumerSecret')
    ..aOS(12, 'clientId')
    ..hasRequiredFields = false;

  NetOAuthSecrets() : super();
  NetOAuthSecrets.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetOAuthSecrets.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetOAuthSecrets clone() => new NetOAuthSecrets()..mergeFromMessage(this);
  NetOAuthSecrets copyWith(void Function(NetOAuthSecrets) updates) =>
      super.copyWith((message) => updates(message as NetOAuthSecrets));
  $pb.BuilderInfo get info_ => _i;
  static NetOAuthSecrets create() => new NetOAuthSecrets();
  static $pb.PbList<NetOAuthSecrets> createRepeated() =>
      new $pb.PbList<NetOAuthSecrets>();
  static NetOAuthSecrets getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetOAuthSecrets _defaultInstance;
  static void $checkItem(NetOAuthSecrets v) {
    if (v is! NetOAuthSecrets) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get consumerKey => $_getS(0, '');
  set consumerKey(String v) {
    $_setString(0, v);
  }

  bool hasConsumerKey() => $_has(0);
  void clearConsumerKey() => clearField(10);

  String get consumerSecret => $_getS(1, '');
  set consumerSecret(String v) {
    $_setString(1, v);
  }

  bool hasConsumerSecret() => $_has(1);
  void clearConsumerSecret() => clearField(11);

  String get clientId => $_getS(2, '');
  set clientId(String v) {
    $_setString(2, v);
  }

  bool hasClientId() => $_has(2);
  void clearClientId() => clearField(12);
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
    ..a<$10.DataSocialMedia>(1, 'socialMedia', $pb.PbFieldType.OM,
        $10.DataSocialMedia.getDefault, $10.DataSocialMedia.create)
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

  $10.DataSocialMedia get socialMedia => $_getN(0);
  set socialMedia($10.DataSocialMedia v) {
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

class NetAccountApplyPromo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetAccountApplyPromo',
      package: const $pb.PackageName('inf_common'))
    ..aOS(1, 'code')
    ..hasRequiredFields = false;

  NetAccountApplyPromo() : super();
  NetAccountApplyPromo.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetAccountApplyPromo.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetAccountApplyPromo clone() =>
      new NetAccountApplyPromo()..mergeFromMessage(this);
  NetAccountApplyPromo copyWith(void Function(NetAccountApplyPromo) updates) =>
      super.copyWith((message) => updates(message as NetAccountApplyPromo));
  $pb.BuilderInfo get info_ => _i;
  static NetAccountApplyPromo create() => new NetAccountApplyPromo();
  static $pb.PbList<NetAccountApplyPromo> createRepeated() =>
      new $pb.PbList<NetAccountApplyPromo>();
  static NetAccountApplyPromo getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetAccountApplyPromo _defaultInstance;
  static void $checkItem(NetAccountApplyPromo v) {
    if (v is! NetAccountApplyPromo)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get code => $_getS(0, '');
  set code(String v) {
    $_setString(0, v);
  }

  bool hasCode() => $_has(0);
  void clearCode() => clearField(1);
}

class NetAccountPromo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetAccountPromo',
      package: const $pb.PackageName('inf_common'))
    ..a<$10.DataAccount>(1, 'account', $pb.PbFieldType.OM,
        $10.DataAccount.getDefault, $10.DataAccount.create)
    ..aOB(2, 'expired')
    ..aOB(3, 'used')
    ..aOB(4, 'applied')
    ..a<int>(5, 'quantity', $pb.PbFieldType.O3)
    ..e<$9.PromoCode>(6, 'type', $pb.PbFieldType.OE, $9.PromoCode.unknown,
        $9.PromoCode.valueOf, $9.PromoCode.values)
    ..hasRequiredFields = false;

  NetAccountPromo() : super();
  NetAccountPromo.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetAccountPromo.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetAccountPromo clone() => new NetAccountPromo()..mergeFromMessage(this);
  NetAccountPromo copyWith(void Function(NetAccountPromo) updates) =>
      super.copyWith((message) => updates(message as NetAccountPromo));
  $pb.BuilderInfo get info_ => _i;
  static NetAccountPromo create() => new NetAccountPromo();
  static $pb.PbList<NetAccountPromo> createRepeated() =>
      new $pb.PbList<NetAccountPromo>();
  static NetAccountPromo getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetAccountPromo _defaultInstance;
  static void $checkItem(NetAccountPromo v) {
    if (v is! NetAccountPromo) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $10.DataAccount get account => $_getN(0);
  set account($10.DataAccount v) {
    setField(1, v);
  }

  bool hasAccount() => $_has(0);
  void clearAccount() => clearField(1);

  bool get expired => $_get(1, false);
  set expired(bool v) {
    $_setBool(1, v);
  }

  bool hasExpired() => $_has(1);
  void clearExpired() => clearField(2);

  bool get used => $_get(2, false);
  set used(bool v) {
    $_setBool(2, v);
  }

  bool hasUsed() => $_has(2);
  void clearUsed() => clearField(3);

  bool get applied => $_get(3, false);
  set applied(bool v) {
    $_setBool(3, v);
  }

  bool hasApplied() => $_has(3);
  void clearApplied() => clearField(4);

  int get quantity => $_get(4, 0);
  set quantity(int v) {
    $_setSignedInt32(4, v);
  }

  bool hasQuantity() => $_has(4);
  void clearQuantity() => clearField(5);

  $9.PromoCode get type => $_getN(5);
  set type($9.PromoCode v) {
    setField(6, v);
  }

  bool hasType() => $_has(5);
  void clearType() => clearField(6);
}
