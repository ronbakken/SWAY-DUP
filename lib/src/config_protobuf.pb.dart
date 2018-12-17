///
//  Generated code. Do not modify.
//  source: config_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'enum_protobuf.pbenum.dart' as $0;

class ConfigSubCategories extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigSubCategories',
      package: const $pb.PackageName('inf_common'))
    ..pPS(1, 'labels')
    ..hasRequiredFields = false;

  ConfigSubCategories() : super();
  ConfigSubCategories.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConfigSubCategories.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ConfigSubCategories clone() =>
      new ConfigSubCategories()..mergeFromMessage(this);
  ConfigSubCategories copyWith(void Function(ConfigSubCategories) updates) =>
      super.copyWith((message) => updates(message as ConfigSubCategories));
  $pb.BuilderInfo get info_ => _i;
  static ConfigSubCategories create() => new ConfigSubCategories();
  static $pb.PbList<ConfigSubCategories> createRepeated() =>
      new $pb.PbList<ConfigSubCategories>();
  static ConfigSubCategories getDefault() =>
      _defaultInstance ??= create()..freeze();
  static ConfigSubCategories _defaultInstance;
  static void $checkItem(ConfigSubCategories v) {
    if (v is! ConfigSubCategories)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<String> get labels => $_getList(0);
}

class ConfigOAuthProvider extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigOAuthProvider',
      package: const $pb.PackageName('inf_common'))
    ..aOB(1, 'visible')
    ..aOB(2, 'canAlwaysAuthenticate')
    ..aOS(3, 'label')
    ..aOS(4, 'host')
    ..aOS(5, 'requestTokenUrl')
    ..aOS(6, 'authenticateUrl')
    ..aOS(7, 'authUrl')
    ..aOS(8, 'authQuery')
    ..aOS(9, 'callbackUrl')
    ..aOS(10, 'consumerKey')
    ..aOS(11, 'consumerSecret')
    ..aOS(12, 'clientId')
    ..a<int>(14, 'fontAwesomeBrand', $pb.PbFieldType.O3)
    ..e<$0.OAuthMechanism>(
        15,
        'mechanism',
        $pb.PbFieldType.OE,
        $0.OAuthMechanism.none,
        $0.OAuthMechanism.valueOf,
        $0.OAuthMechanism.values)
    ..aOS(16, 'accessTokenUrl')
    ..aOS(17, 'clientSecret')
    ..pPS(18, 'whitelistHosts')
    ..aOB(19, 'canConnect')
    ..aOB(20, 'showInProfile')
    ..aOB(21, 'clientIdExposed')
    ..aOB(22, 'consumerKeyExposed')
    ..aOB(23, 'consumerSecretExposed')
    ..pPS(25, 'keywords')
    ..a<int>(26, 'foregroundColor', $pb.PbFieldType.O3)
    ..a<int>(27, 'backgroundColor', $pb.PbFieldType.O3)
    ..a<int>(28, 'foregroundImageId', $pb.PbFieldType.O3)
    ..a<int>(29, 'backgroundImageId', $pb.PbFieldType.O3)
    ..a<int>(30, 'monochromeForegroundImageId', $pb.PbFieldType.O3)
    ..a<int>(31, 'monochromeBackgroundImageId', $pb.PbFieldType.O3)
    ..a<int>(32, 'sorting', $pb.PbFieldType.O3)
    ..aOS(33, 'key')
    ..a<int>(34, 'deliverablesChannel', $pb.PbFieldType.O3)
    ..a<int>(35, 'providerId', $pb.PbFieldType.O3)
    ..a<List<int>>(36, 'foregroundImage', $pb.PbFieldType.OY)
    ..a<List<int>>(37, 'backgroundImage', $pb.PbFieldType.OY)
    ..a<List<int>>(38, 'monochromeForegroundImage', $pb.PbFieldType.OY)
    ..a<List<int>>(39, 'monochromeBackgroundImage', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  ConfigOAuthProvider() : super();
  ConfigOAuthProvider.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConfigOAuthProvider.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ConfigOAuthProvider clone() =>
      new ConfigOAuthProvider()..mergeFromMessage(this);
  ConfigOAuthProvider copyWith(void Function(ConfigOAuthProvider) updates) =>
      super.copyWith((message) => updates(message as ConfigOAuthProvider));
  $pb.BuilderInfo get info_ => _i;
  static ConfigOAuthProvider create() => new ConfigOAuthProvider();
  static $pb.PbList<ConfigOAuthProvider> createRepeated() =>
      new $pb.PbList<ConfigOAuthProvider>();
  static ConfigOAuthProvider getDefault() =>
      _defaultInstance ??= create()..freeze();
  static ConfigOAuthProvider _defaultInstance;
  static void $checkItem(ConfigOAuthProvider v) {
    if (v is! ConfigOAuthProvider)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  bool get visible => $_get(0, false);
  set visible(bool v) {
    $_setBool(0, v);
  }

  bool hasVisible() => $_has(0);
  void clearVisible() => clearField(1);

  bool get canAlwaysAuthenticate => $_get(1, false);
  set canAlwaysAuthenticate(bool v) {
    $_setBool(1, v);
  }

  bool hasCanAlwaysAuthenticate() => $_has(1);
  void clearCanAlwaysAuthenticate() => clearField(2);

  String get label => $_getS(2, '');
  set label(String v) {
    $_setString(2, v);
  }

  bool hasLabel() => $_has(2);
  void clearLabel() => clearField(3);

  String get host => $_getS(3, '');
  set host(String v) {
    $_setString(3, v);
  }

  bool hasHost() => $_has(3);
  void clearHost() => clearField(4);

  String get requestTokenUrl => $_getS(4, '');
  set requestTokenUrl(String v) {
    $_setString(4, v);
  }

  bool hasRequestTokenUrl() => $_has(4);
  void clearRequestTokenUrl() => clearField(5);

  String get authenticateUrl => $_getS(5, '');
  set authenticateUrl(String v) {
    $_setString(5, v);
  }

  bool hasAuthenticateUrl() => $_has(5);
  void clearAuthenticateUrl() => clearField(6);

  String get authUrl => $_getS(6, '');
  set authUrl(String v) {
    $_setString(6, v);
  }

  bool hasAuthUrl() => $_has(6);
  void clearAuthUrl() => clearField(7);

  String get authQuery => $_getS(7, '');
  set authQuery(String v) {
    $_setString(7, v);
  }

  bool hasAuthQuery() => $_has(7);
  void clearAuthQuery() => clearField(8);

  String get callbackUrl => $_getS(8, '');
  set callbackUrl(String v) {
    $_setString(8, v);
  }

  bool hasCallbackUrl() => $_has(8);
  void clearCallbackUrl() => clearField(9);

  String get consumerKey => $_getS(9, '');
  set consumerKey(String v) {
    $_setString(9, v);
  }

  bool hasConsumerKey() => $_has(9);
  void clearConsumerKey() => clearField(10);

  String get consumerSecret => $_getS(10, '');
  set consumerSecret(String v) {
    $_setString(10, v);
  }

  bool hasConsumerSecret() => $_has(10);
  void clearConsumerSecret() => clearField(11);

  String get clientId => $_getS(11, '');
  set clientId(String v) {
    $_setString(11, v);
  }

  bool hasClientId() => $_has(11);
  void clearClientId() => clearField(12);

  int get fontAwesomeBrand => $_get(12, 0);
  set fontAwesomeBrand(int v) {
    $_setSignedInt32(12, v);
  }

  bool hasFontAwesomeBrand() => $_has(12);
  void clearFontAwesomeBrand() => clearField(14);

  $0.OAuthMechanism get mechanism => $_getN(13);
  set mechanism($0.OAuthMechanism v) {
    setField(15, v);
  }

  bool hasMechanism() => $_has(13);
  void clearMechanism() => clearField(15);

  String get accessTokenUrl => $_getS(14, '');
  set accessTokenUrl(String v) {
    $_setString(14, v);
  }

  bool hasAccessTokenUrl() => $_has(14);
  void clearAccessTokenUrl() => clearField(16);

  String get clientSecret => $_getS(15, '');
  set clientSecret(String v) {
    $_setString(15, v);
  }

  bool hasClientSecret() => $_has(15);
  void clearClientSecret() => clearField(17);

  List<String> get whitelistHosts => $_getList(16);

  bool get canConnect => $_get(17, false);
  set canConnect(bool v) {
    $_setBool(17, v);
  }

  bool hasCanConnect() => $_has(17);
  void clearCanConnect() => clearField(19);

  bool get showInProfile => $_get(18, false);
  set showInProfile(bool v) {
    $_setBool(18, v);
  }

  bool hasShowInProfile() => $_has(18);
  void clearShowInProfile() => clearField(20);

  bool get clientIdExposed => $_get(19, false);
  set clientIdExposed(bool v) {
    $_setBool(19, v);
  }

  bool hasClientIdExposed() => $_has(19);
  void clearClientIdExposed() => clearField(21);

  bool get consumerKeyExposed => $_get(20, false);
  set consumerKeyExposed(bool v) {
    $_setBool(20, v);
  }

  bool hasConsumerKeyExposed() => $_has(20);
  void clearConsumerKeyExposed() => clearField(22);

  bool get consumerSecretExposed => $_get(21, false);
  set consumerSecretExposed(bool v) {
    $_setBool(21, v);
  }

  bool hasConsumerSecretExposed() => $_has(21);
  void clearConsumerSecretExposed() => clearField(23);

  List<String> get keywords => $_getList(22);

  int get foregroundColor => $_get(23, 0);
  set foregroundColor(int v) {
    $_setSignedInt32(23, v);
  }

  bool hasForegroundColor() => $_has(23);
  void clearForegroundColor() => clearField(26);

  int get backgroundColor => $_get(24, 0);
  set backgroundColor(int v) {
    $_setSignedInt32(24, v);
  }

  bool hasBackgroundColor() => $_has(24);
  void clearBackgroundColor() => clearField(27);

  int get foregroundImageId => $_get(25, 0);
  set foregroundImageId(int v) {
    $_setSignedInt32(25, v);
  }

  bool hasForegroundImageId() => $_has(25);
  void clearForegroundImageId() => clearField(28);

  int get backgroundImageId => $_get(26, 0);
  set backgroundImageId(int v) {
    $_setSignedInt32(26, v);
  }

  bool hasBackgroundImageId() => $_has(26);
  void clearBackgroundImageId() => clearField(29);

  int get monochromeForegroundImageId => $_get(27, 0);
  set monochromeForegroundImageId(int v) {
    $_setSignedInt32(27, v);
  }

  bool hasMonochromeForegroundImageId() => $_has(27);
  void clearMonochromeForegroundImageId() => clearField(30);

  int get monochromeBackgroundImageId => $_get(28, 0);
  set monochromeBackgroundImageId(int v) {
    $_setSignedInt32(28, v);
  }

  bool hasMonochromeBackgroundImageId() => $_has(28);
  void clearMonochromeBackgroundImageId() => clearField(31);

  int get sorting => $_get(29, 0);
  set sorting(int v) {
    $_setSignedInt32(29, v);
  }

  bool hasSorting() => $_has(29);
  void clearSorting() => clearField(32);

  String get key => $_getS(30, '');
  set key(String v) {
    $_setString(30, v);
  }

  bool hasKey() => $_has(30);
  void clearKey() => clearField(33);

  int get deliverablesChannel => $_get(31, 0);
  set deliverablesChannel(int v) {
    $_setSignedInt32(31, v);
  }

  bool hasDeliverablesChannel() => $_has(31);
  void clearDeliverablesChannel() => clearField(34);

  int get providerId => $_get(32, 0);
  set providerId(int v) {
    $_setSignedInt32(32, v);
  }

  bool hasProviderId() => $_has(32);
  void clearProviderId() => clearField(35);

  List<int> get foregroundImage => $_getN(33);
  set foregroundImage(List<int> v) {
    $_setBytes(33, v);
  }

  bool hasForegroundImage() => $_has(33);
  void clearForegroundImage() => clearField(36);

  List<int> get backgroundImage => $_getN(34);
  set backgroundImage(List<int> v) {
    $_setBytes(34, v);
  }

  bool hasBackgroundImage() => $_has(34);
  void clearBackgroundImage() => clearField(37);

  List<int> get monochromeForegroundImage => $_getN(35);
  set monochromeForegroundImage(List<int> v) {
    $_setBytes(35, v);
  }

  bool hasMonochromeForegroundImage() => $_has(35);
  void clearMonochromeForegroundImage() => clearField(38);

  List<int> get monochromeBackgroundImage => $_getN(36);
  set monochromeBackgroundImage(List<int> v) {
    $_setBytes(36, v);
  }

  bool hasMonochromeBackgroundImage() => $_has(36);
  void clearMonochromeBackgroundImage() => clearField(39);
}

class ConfigContentFormat extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigContentFormat',
      package: const $pb.PackageName('inf_common'))
    ..pPS(1, 'keywords')
    ..aOS(2, 'label')
    ..a<int>(3, 'sorting', $pb.PbFieldType.O3)
    ..a<int>(4, 'fontAwesomeIcon', $pb.PbFieldType.O3)
    ..a<int>(6, 'foregroundColor', $pb.PbFieldType.O3)
    ..a<int>(7, 'backgroundColor', $pb.PbFieldType.O3)
    ..a<int>(8, 'foregroundImageId', $pb.PbFieldType.O3)
    ..a<int>(9, 'backgroundImageId', $pb.PbFieldType.O3)
    ..a<int>(10, 'monochromeForegroundImageId', $pb.PbFieldType.O3)
    ..a<int>(11, 'monochromeBackgroundImageId', $pb.PbFieldType.O3)
    ..a<int>(12, 'formatId', $pb.PbFieldType.O3)
    ..a<List<int>>(14, 'foregroundImage', $pb.PbFieldType.OY)
    ..a<List<int>>(15, 'backgroundImage', $pb.PbFieldType.OY)
    ..a<List<int>>(16, 'monochromeForegroundImage', $pb.PbFieldType.OY)
    ..a<List<int>>(17, 'monochromeBackgroundImage', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  ConfigContentFormat() : super();
  ConfigContentFormat.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConfigContentFormat.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ConfigContentFormat clone() =>
      new ConfigContentFormat()..mergeFromMessage(this);
  ConfigContentFormat copyWith(void Function(ConfigContentFormat) updates) =>
      super.copyWith((message) => updates(message as ConfigContentFormat));
  $pb.BuilderInfo get info_ => _i;
  static ConfigContentFormat create() => new ConfigContentFormat();
  static $pb.PbList<ConfigContentFormat> createRepeated() =>
      new $pb.PbList<ConfigContentFormat>();
  static ConfigContentFormat getDefault() =>
      _defaultInstance ??= create()..freeze();
  static ConfigContentFormat _defaultInstance;
  static void $checkItem(ConfigContentFormat v) {
    if (v is! ConfigContentFormat)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<String> get keywords => $_getList(0);

  String get label => $_getS(1, '');
  set label(String v) {
    $_setString(1, v);
  }

  bool hasLabel() => $_has(1);
  void clearLabel() => clearField(2);

  int get sorting => $_get(2, 0);
  set sorting(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasSorting() => $_has(2);
  void clearSorting() => clearField(3);

  int get fontAwesomeIcon => $_get(3, 0);
  set fontAwesomeIcon(int v) {
    $_setSignedInt32(3, v);
  }

  bool hasFontAwesomeIcon() => $_has(3);
  void clearFontAwesomeIcon() => clearField(4);

  int get foregroundColor => $_get(4, 0);
  set foregroundColor(int v) {
    $_setSignedInt32(4, v);
  }

  bool hasForegroundColor() => $_has(4);
  void clearForegroundColor() => clearField(6);

  int get backgroundColor => $_get(5, 0);
  set backgroundColor(int v) {
    $_setSignedInt32(5, v);
  }

  bool hasBackgroundColor() => $_has(5);
  void clearBackgroundColor() => clearField(7);

  int get foregroundImageId => $_get(6, 0);
  set foregroundImageId(int v) {
    $_setSignedInt32(6, v);
  }

  bool hasForegroundImageId() => $_has(6);
  void clearForegroundImageId() => clearField(8);

  int get backgroundImageId => $_get(7, 0);
  set backgroundImageId(int v) {
    $_setSignedInt32(7, v);
  }

  bool hasBackgroundImageId() => $_has(7);
  void clearBackgroundImageId() => clearField(9);

  int get monochromeForegroundImageId => $_get(8, 0);
  set monochromeForegroundImageId(int v) {
    $_setSignedInt32(8, v);
  }

  bool hasMonochromeForegroundImageId() => $_has(8);
  void clearMonochromeForegroundImageId() => clearField(10);

  int get monochromeBackgroundImageId => $_get(9, 0);
  set monochromeBackgroundImageId(int v) {
    $_setSignedInt32(9, v);
  }

  bool hasMonochromeBackgroundImageId() => $_has(9);
  void clearMonochromeBackgroundImageId() => clearField(11);

  int get formatId => $_get(10, 0);
  set formatId(int v) {
    $_setSignedInt32(10, v);
  }

  bool hasFormatId() => $_has(10);
  void clearFormatId() => clearField(12);

  List<int> get foregroundImage => $_getN(11);
  set foregroundImage(List<int> v) {
    $_setBytes(11, v);
  }

  bool hasForegroundImage() => $_has(11);
  void clearForegroundImage() => clearField(14);

  List<int> get backgroundImage => $_getN(12);
  set backgroundImage(List<int> v) {
    $_setBytes(12, v);
  }

  bool hasBackgroundImage() => $_has(12);
  void clearBackgroundImage() => clearField(15);

  List<int> get monochromeForegroundImage => $_getN(13);
  set monochromeForegroundImage(List<int> v) {
    $_setBytes(13, v);
  }

  bool hasMonochromeForegroundImage() => $_has(13);
  void clearMonochromeForegroundImage() => clearField(16);

  List<int> get monochromeBackgroundImage => $_getN(14);
  set monochromeBackgroundImage(List<int> v) {
    $_setBytes(14, v);
  }

  bool hasMonochromeBackgroundImage() => $_has(14);
  void clearMonochromeBackgroundImage() => clearField(17);
}

class ConfigCategory extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigCategory',
      package: const $pb.PackageName('inf_common'))
    ..pPS(1, 'keywords')
    ..aOS(2, 'label')
    ..a<int>(3, 'sorting', $pb.PbFieldType.O3)
    ..a<int>(4, 'fontAwesomeIcon', $pb.PbFieldType.O3)
    ..a<int>(5, 'parentId', $pb.PbFieldType.O3)
    ..a<int>(6, 'foregroundColor', $pb.PbFieldType.O3)
    ..a<int>(7, 'backgroundColor', $pb.PbFieldType.O3)
    ..a<int>(8, 'foregroundImageId', $pb.PbFieldType.O3)
    ..a<int>(9, 'backgroundImageId', $pb.PbFieldType.O3)
    ..a<int>(10, 'monochromeForegroundImageId', $pb.PbFieldType.O3)
    ..a<int>(11, 'monochromeBackgroundImageId', $pb.PbFieldType.O3)
    ..p<int>(12, 'childIds', $pb.PbFieldType.P3)
    ..a<int>(13, 'categoryId', $pb.PbFieldType.O3)
    ..a<List<int>>(14, 'foregroundImage', $pb.PbFieldType.OY)
    ..a<List<int>>(15, 'backgroundImage', $pb.PbFieldType.OY)
    ..a<List<int>>(16, 'monochromeForegroundImage', $pb.PbFieldType.OY)
    ..a<List<int>>(17, 'monochromeBackgroundImage', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  ConfigCategory() : super();
  ConfigCategory.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConfigCategory.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ConfigCategory clone() => new ConfigCategory()..mergeFromMessage(this);
  ConfigCategory copyWith(void Function(ConfigCategory) updates) =>
      super.copyWith((message) => updates(message as ConfigCategory));
  $pb.BuilderInfo get info_ => _i;
  static ConfigCategory create() => new ConfigCategory();
  static $pb.PbList<ConfigCategory> createRepeated() =>
      new $pb.PbList<ConfigCategory>();
  static ConfigCategory getDefault() => _defaultInstance ??= create()..freeze();
  static ConfigCategory _defaultInstance;
  static void $checkItem(ConfigCategory v) {
    if (v is! ConfigCategory) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<String> get keywords => $_getList(0);

  String get label => $_getS(1, '');
  set label(String v) {
    $_setString(1, v);
  }

  bool hasLabel() => $_has(1);
  void clearLabel() => clearField(2);

  int get sorting => $_get(2, 0);
  set sorting(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasSorting() => $_has(2);
  void clearSorting() => clearField(3);

  int get fontAwesomeIcon => $_get(3, 0);
  set fontAwesomeIcon(int v) {
    $_setSignedInt32(3, v);
  }

  bool hasFontAwesomeIcon() => $_has(3);
  void clearFontAwesomeIcon() => clearField(4);

  int get parentId => $_get(4, 0);
  set parentId(int v) {
    $_setSignedInt32(4, v);
  }

  bool hasParentId() => $_has(4);
  void clearParentId() => clearField(5);

  int get foregroundColor => $_get(5, 0);
  set foregroundColor(int v) {
    $_setSignedInt32(5, v);
  }

  bool hasForegroundColor() => $_has(5);
  void clearForegroundColor() => clearField(6);

  int get backgroundColor => $_get(6, 0);
  set backgroundColor(int v) {
    $_setSignedInt32(6, v);
  }

  bool hasBackgroundColor() => $_has(6);
  void clearBackgroundColor() => clearField(7);

  int get foregroundImageId => $_get(7, 0);
  set foregroundImageId(int v) {
    $_setSignedInt32(7, v);
  }

  bool hasForegroundImageId() => $_has(7);
  void clearForegroundImageId() => clearField(8);

  int get backgroundImageId => $_get(8, 0);
  set backgroundImageId(int v) {
    $_setSignedInt32(8, v);
  }

  bool hasBackgroundImageId() => $_has(8);
  void clearBackgroundImageId() => clearField(9);

  int get monochromeForegroundImageId => $_get(9, 0);
  set monochromeForegroundImageId(int v) {
    $_setSignedInt32(9, v);
  }

  bool hasMonochromeForegroundImageId() => $_has(9);
  void clearMonochromeForegroundImageId() => clearField(10);

  int get monochromeBackgroundImageId => $_get(10, 0);
  set monochromeBackgroundImageId(int v) {
    $_setSignedInt32(10, v);
  }

  bool hasMonochromeBackgroundImageId() => $_has(10);
  void clearMonochromeBackgroundImageId() => clearField(11);

  List<int> get childIds => $_getList(11);

  int get categoryId => $_get(12, 0);
  set categoryId(int v) {
    $_setSignedInt32(12, v);
  }

  bool hasCategoryId() => $_has(12);
  void clearCategoryId() => clearField(13);

  List<int> get foregroundImage => $_getN(13);
  set foregroundImage(List<int> v) {
    $_setBytes(13, v);
  }

  bool hasForegroundImage() => $_has(13);
  void clearForegroundImage() => clearField(14);

  List<int> get backgroundImage => $_getN(14);
  set backgroundImage(List<int> v) {
    $_setBytes(14, v);
  }

  bool hasBackgroundImage() => $_has(14);
  void clearBackgroundImage() => clearField(15);

  List<int> get monochromeForegroundImage => $_getN(15);
  set monochromeForegroundImage(List<int> v) {
    $_setBytes(15, v);
  }

  bool hasMonochromeForegroundImage() => $_has(15);
  void clearMonochromeForegroundImage() => clearField(16);

  List<int> get monochromeBackgroundImage => $_getN(16);
  set monochromeBackgroundImage(List<int> v) {
    $_setBytes(16, v);
  }

  bool hasMonochromeBackgroundImage() => $_has(16);
  void clearMonochromeBackgroundImage() => clearField(17);
}

class ConfigServices extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigServices',
      package: const $pb.PackageName('inf_common'))
    ..aOS(1, 'mapboxApi')
    ..aOS(2, 'mapboxUrlTemplateDark')
    ..aOS(3, 'mapboxToken')
    ..aOS(4, 'spacesRegion')
    ..aOS(5, 'spacesKey')
    ..aOS(6, 'spacesSecret')
    ..aOS(7, 'spacesBucket')
    ..pPS(8, 'endPoints')
    ..aOS(9, 'configUrl')
    ..aOS(10, 'termsOfServiceUrl')
    ..aOS(11, 'privacyPolicyUrl')
    ..aOS(12, 'ipstackKey')
    ..aOS(13, 'ipstackApi')
    ..aOS(14, 'accountDbHost')
    ..a<int>(15, 'accountDbPort', $pb.PbFieldType.O3)
    ..aOS(16, 'accountDbUser')
    ..aOS(17, 'accountDbPassword')
    ..aOS(18, 'accountDbDatabase')
    ..aOS(19, 'galleryUrl')
    ..aOS(20, 'galleryThumbnailUrl')
    ..aOS(21, 'galleryCoverUrl')
    ..aOS(22, 'freshdeskApi')
    ..aOS(23, 'freshdeskKey')
    ..aOS(24, 'domain')
    ..aOS(25, 'firebaseServerKey')
    ..aOS(26, 'firebaseSenderId')
    ..aOS(27, 'firebaseLegacyApi')
    ..aOS(28, 'firebaseLegacyServerKey')
    ..aOS(29, 'connectionFailedUrl')
    ..aOS(30, 'mapboxUrlTemplateLight')
    ..aOS(31, 'galleryThumbnailBlurredUrl')
    ..aOS(32, 'galleryCoverBlurredUrl')
    ..aOS(33, 'service')
    ..a<List<int>>(35, 'salt', $pb.PbFieldType.OY)
    ..aOS(36, 'elasticsearchApi')
    ..aOS(37, 'elasticsearchBasicAuth')
    ..aOS(38, 'oneSignalAppId')
    ..aOS(39, 'oneSignalApiKey')
    ..aOS(40, 'oneSignalApi')
    ..aOS(41, 'galleryPictureUrl')
    ..aOS(42, 'galleryPictureBlurredUrl')
    ..aOS(43, 'proposalDbHost')
    ..a<int>(44, 'proposalDbPort', $pb.PbFieldType.O3)
    ..aOS(45, 'proposalDbUser')
    ..aOS(46, 'proposalDbPassword')
    ..aOS(47, 'proposalDbDatabase')
    ..hasRequiredFields = false;

  ConfigServices() : super();
  ConfigServices.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConfigServices.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ConfigServices clone() => new ConfigServices()..mergeFromMessage(this);
  ConfigServices copyWith(void Function(ConfigServices) updates) =>
      super.copyWith((message) => updates(message as ConfigServices));
  $pb.BuilderInfo get info_ => _i;
  static ConfigServices create() => new ConfigServices();
  static $pb.PbList<ConfigServices> createRepeated() =>
      new $pb.PbList<ConfigServices>();
  static ConfigServices getDefault() => _defaultInstance ??= create()..freeze();
  static ConfigServices _defaultInstance;
  static void $checkItem(ConfigServices v) {
    if (v is! ConfigServices) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get mapboxApi => $_getS(0, '');
  set mapboxApi(String v) {
    $_setString(0, v);
  }

  bool hasMapboxApi() => $_has(0);
  void clearMapboxApi() => clearField(1);

  String get mapboxUrlTemplateDark => $_getS(1, '');
  set mapboxUrlTemplateDark(String v) {
    $_setString(1, v);
  }

  bool hasMapboxUrlTemplateDark() => $_has(1);
  void clearMapboxUrlTemplateDark() => clearField(2);

  String get mapboxToken => $_getS(2, '');
  set mapboxToken(String v) {
    $_setString(2, v);
  }

  bool hasMapboxToken() => $_has(2);
  void clearMapboxToken() => clearField(3);

  String get spacesRegion => $_getS(3, '');
  set spacesRegion(String v) {
    $_setString(3, v);
  }

  bool hasSpacesRegion() => $_has(3);
  void clearSpacesRegion() => clearField(4);

  String get spacesKey => $_getS(4, '');
  set spacesKey(String v) {
    $_setString(4, v);
  }

  bool hasSpacesKey() => $_has(4);
  void clearSpacesKey() => clearField(5);

  String get spacesSecret => $_getS(5, '');
  set spacesSecret(String v) {
    $_setString(5, v);
  }

  bool hasSpacesSecret() => $_has(5);
  void clearSpacesSecret() => clearField(6);

  String get spacesBucket => $_getS(6, '');
  set spacesBucket(String v) {
    $_setString(6, v);
  }

  bool hasSpacesBucket() => $_has(6);
  void clearSpacesBucket() => clearField(7);

  List<String> get endPoints => $_getList(7);

  String get configUrl => $_getS(8, '');
  set configUrl(String v) {
    $_setString(8, v);
  }

  bool hasConfigUrl() => $_has(8);
  void clearConfigUrl() => clearField(9);

  String get termsOfServiceUrl => $_getS(9, '');
  set termsOfServiceUrl(String v) {
    $_setString(9, v);
  }

  bool hasTermsOfServiceUrl() => $_has(9);
  void clearTermsOfServiceUrl() => clearField(10);

  String get privacyPolicyUrl => $_getS(10, '');
  set privacyPolicyUrl(String v) {
    $_setString(10, v);
  }

  bool hasPrivacyPolicyUrl() => $_has(10);
  void clearPrivacyPolicyUrl() => clearField(11);

  String get ipstackKey => $_getS(11, '');
  set ipstackKey(String v) {
    $_setString(11, v);
  }

  bool hasIpstackKey() => $_has(11);
  void clearIpstackKey() => clearField(12);

  String get ipstackApi => $_getS(12, '');
  set ipstackApi(String v) {
    $_setString(12, v);
  }

  bool hasIpstackApi() => $_has(12);
  void clearIpstackApi() => clearField(13);

  String get accountDbHost => $_getS(13, '');
  set accountDbHost(String v) {
    $_setString(13, v);
  }

  bool hasAccountDbHost() => $_has(13);
  void clearAccountDbHost() => clearField(14);

  int get accountDbPort => $_get(14, 0);
  set accountDbPort(int v) {
    $_setSignedInt32(14, v);
  }

  bool hasAccountDbPort() => $_has(14);
  void clearAccountDbPort() => clearField(15);

  String get accountDbUser => $_getS(15, '');
  set accountDbUser(String v) {
    $_setString(15, v);
  }

  bool hasAccountDbUser() => $_has(15);
  void clearAccountDbUser() => clearField(16);

  String get accountDbPassword => $_getS(16, '');
  set accountDbPassword(String v) {
    $_setString(16, v);
  }

  bool hasAccountDbPassword() => $_has(16);
  void clearAccountDbPassword() => clearField(17);

  String get accountDbDatabase => $_getS(17, '');
  set accountDbDatabase(String v) {
    $_setString(17, v);
  }

  bool hasAccountDbDatabase() => $_has(17);
  void clearAccountDbDatabase() => clearField(18);

  String get galleryUrl => $_getS(18, '');
  set galleryUrl(String v) {
    $_setString(18, v);
  }

  bool hasGalleryUrl() => $_has(18);
  void clearGalleryUrl() => clearField(19);

  String get galleryThumbnailUrl => $_getS(19, '');
  set galleryThumbnailUrl(String v) {
    $_setString(19, v);
  }

  bool hasGalleryThumbnailUrl() => $_has(19);
  void clearGalleryThumbnailUrl() => clearField(20);

  String get galleryCoverUrl => $_getS(20, '');
  set galleryCoverUrl(String v) {
    $_setString(20, v);
  }

  bool hasGalleryCoverUrl() => $_has(20);
  void clearGalleryCoverUrl() => clearField(21);

  String get freshdeskApi => $_getS(21, '');
  set freshdeskApi(String v) {
    $_setString(21, v);
  }

  bool hasFreshdeskApi() => $_has(21);
  void clearFreshdeskApi() => clearField(22);

  String get freshdeskKey => $_getS(22, '');
  set freshdeskKey(String v) {
    $_setString(22, v);
  }

  bool hasFreshdeskKey() => $_has(22);
  void clearFreshdeskKey() => clearField(23);

  String get domain => $_getS(23, '');
  set domain(String v) {
    $_setString(23, v);
  }

  bool hasDomain() => $_has(23);
  void clearDomain() => clearField(24);

  String get firebaseServerKey => $_getS(24, '');
  set firebaseServerKey(String v) {
    $_setString(24, v);
  }

  bool hasFirebaseServerKey() => $_has(24);
  void clearFirebaseServerKey() => clearField(25);

  String get firebaseSenderId => $_getS(25, '');
  set firebaseSenderId(String v) {
    $_setString(25, v);
  }

  bool hasFirebaseSenderId() => $_has(25);
  void clearFirebaseSenderId() => clearField(26);

  String get firebaseLegacyApi => $_getS(26, '');
  set firebaseLegacyApi(String v) {
    $_setString(26, v);
  }

  bool hasFirebaseLegacyApi() => $_has(26);
  void clearFirebaseLegacyApi() => clearField(27);

  String get firebaseLegacyServerKey => $_getS(27, '');
  set firebaseLegacyServerKey(String v) {
    $_setString(27, v);
  }

  bool hasFirebaseLegacyServerKey() => $_has(27);
  void clearFirebaseLegacyServerKey() => clearField(28);

  String get connectionFailedUrl => $_getS(28, '');
  set connectionFailedUrl(String v) {
    $_setString(28, v);
  }

  bool hasConnectionFailedUrl() => $_has(28);
  void clearConnectionFailedUrl() => clearField(29);

  String get mapboxUrlTemplateLight => $_getS(29, '');
  set mapboxUrlTemplateLight(String v) {
    $_setString(29, v);
  }

  bool hasMapboxUrlTemplateLight() => $_has(29);
  void clearMapboxUrlTemplateLight() => clearField(30);

  String get galleryThumbnailBlurredUrl => $_getS(30, '');
  set galleryThumbnailBlurredUrl(String v) {
    $_setString(30, v);
  }

  bool hasGalleryThumbnailBlurredUrl() => $_has(30);
  void clearGalleryThumbnailBlurredUrl() => clearField(31);

  String get galleryCoverBlurredUrl => $_getS(31, '');
  set galleryCoverBlurredUrl(String v) {
    $_setString(31, v);
  }

  bool hasGalleryCoverBlurredUrl() => $_has(31);
  void clearGalleryCoverBlurredUrl() => clearField(32);

  String get service => $_getS(32, '');
  set service(String v) {
    $_setString(32, v);
  }

  bool hasService() => $_has(32);
  void clearService() => clearField(33);

  List<int> get salt => $_getN(33);
  set salt(List<int> v) {
    $_setBytes(33, v);
  }

  bool hasSalt() => $_has(33);
  void clearSalt() => clearField(35);

  String get elasticsearchApi => $_getS(34, '');
  set elasticsearchApi(String v) {
    $_setString(34, v);
  }

  bool hasElasticsearchApi() => $_has(34);
  void clearElasticsearchApi() => clearField(36);

  String get elasticsearchBasicAuth => $_getS(35, '');
  set elasticsearchBasicAuth(String v) {
    $_setString(35, v);
  }

  bool hasElasticsearchBasicAuth() => $_has(35);
  void clearElasticsearchBasicAuth() => clearField(37);

  String get oneSignalAppId => $_getS(36, '');
  set oneSignalAppId(String v) {
    $_setString(36, v);
  }

  bool hasOneSignalAppId() => $_has(36);
  void clearOneSignalAppId() => clearField(38);

  String get oneSignalApiKey => $_getS(37, '');
  set oneSignalApiKey(String v) {
    $_setString(37, v);
  }

  bool hasOneSignalApiKey() => $_has(37);
  void clearOneSignalApiKey() => clearField(39);

  String get oneSignalApi => $_getS(38, '');
  set oneSignalApi(String v) {
    $_setString(38, v);
  }

  bool hasOneSignalApi() => $_has(38);
  void clearOneSignalApi() => clearField(40);

  String get galleryPictureUrl => $_getS(39, '');
  set galleryPictureUrl(String v) {
    $_setString(39, v);
  }

  bool hasGalleryPictureUrl() => $_has(39);
  void clearGalleryPictureUrl() => clearField(41);

  String get galleryPictureBlurredUrl => $_getS(40, '');
  set galleryPictureBlurredUrl(String v) {
    $_setString(40, v);
  }

  bool hasGalleryPictureBlurredUrl() => $_has(40);
  void clearGalleryPictureBlurredUrl() => clearField(42);

  String get proposalDbHost => $_getS(41, '');
  set proposalDbHost(String v) {
    $_setString(41, v);
  }

  bool hasProposalDbHost() => $_has(41);
  void clearProposalDbHost() => clearField(43);

  int get proposalDbPort => $_get(42, 0);
  set proposalDbPort(int v) {
    $_setSignedInt32(42, v);
  }

  bool hasProposalDbPort() => $_has(42);
  void clearProposalDbPort() => clearField(44);

  String get proposalDbUser => $_getS(43, '');
  set proposalDbUser(String v) {
    $_setString(43, v);
  }

  bool hasProposalDbUser() => $_has(43);
  void clearProposalDbUser() => clearField(45);

  String get proposalDbPassword => $_getS(44, '');
  set proposalDbPassword(String v) {
    $_setString(44, v);
  }

  bool hasProposalDbPassword() => $_has(44);
  void clearProposalDbPassword() => clearField(46);

  String get proposalDbDatabase => $_getS(45, '');
  set proposalDbDatabase(String v) {
    $_setString(45, v);
  }

  bool hasProposalDbDatabase() => $_has(45);
  void clearProposalDbDatabase() => clearField(47);
}

class ConfigFeatureSwitches extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigFeatureSwitches',
      package: const $pb.PackageName('inf_common'))
    ..aOB(1, 'createProposal')
    ..aOB(2, 'createSession')
    ..aOB(3, 'createAccount')
    ..aOB(4, 'removeAccount')
    ..aOB(5, 'removeSession')
    ..aOB(6, 'connectSocialMedia')
    ..aOB(7, 'removeSocialMedia')
    ..aOB(8, 'updateProfile')
    ..aOB(9, 'createOffer')
    ..aOB(10, 'updateOffer')
    ..aOB(11, 'closeOffer')
    ..aOB(12, 'archiveOffer')
    ..aOB(13, 'sendChat')
    ..aOB(14, 'makeDeal')
    ..aOB(15, 'reportProposal')
    ..aOB(16, 'disputeDeal')
    ..aOB(17, 'uploadImage')
    ..aOB(18, 'makeImagePublic')
    ..aOB(19, 'listImages')
    ..hasRequiredFields = false;

  ConfigFeatureSwitches() : super();
  ConfigFeatureSwitches.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConfigFeatureSwitches.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ConfigFeatureSwitches clone() =>
      new ConfigFeatureSwitches()..mergeFromMessage(this);
  ConfigFeatureSwitches copyWith(
          void Function(ConfigFeatureSwitches) updates) =>
      super.copyWith((message) => updates(message as ConfigFeatureSwitches));
  $pb.BuilderInfo get info_ => _i;
  static ConfigFeatureSwitches create() => new ConfigFeatureSwitches();
  static $pb.PbList<ConfigFeatureSwitches> createRepeated() =>
      new $pb.PbList<ConfigFeatureSwitches>();
  static ConfigFeatureSwitches getDefault() =>
      _defaultInstance ??= create()..freeze();
  static ConfigFeatureSwitches _defaultInstance;
  static void $checkItem(ConfigFeatureSwitches v) {
    if (v is! ConfigFeatureSwitches)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  bool get createProposal => $_get(0, false);
  set createProposal(bool v) {
    $_setBool(0, v);
  }

  bool hasCreateProposal() => $_has(0);
  void clearCreateProposal() => clearField(1);

  bool get createSession => $_get(1, false);
  set createSession(bool v) {
    $_setBool(1, v);
  }

  bool hasCreateSession() => $_has(1);
  void clearCreateSession() => clearField(2);

  bool get createAccount => $_get(2, false);
  set createAccount(bool v) {
    $_setBool(2, v);
  }

  bool hasCreateAccount() => $_has(2);
  void clearCreateAccount() => clearField(3);

  bool get removeAccount => $_get(3, false);
  set removeAccount(bool v) {
    $_setBool(3, v);
  }

  bool hasRemoveAccount() => $_has(3);
  void clearRemoveAccount() => clearField(4);

  bool get removeSession => $_get(4, false);
  set removeSession(bool v) {
    $_setBool(4, v);
  }

  bool hasRemoveSession() => $_has(4);
  void clearRemoveSession() => clearField(5);

  bool get connectSocialMedia => $_get(5, false);
  set connectSocialMedia(bool v) {
    $_setBool(5, v);
  }

  bool hasConnectSocialMedia() => $_has(5);
  void clearConnectSocialMedia() => clearField(6);

  bool get removeSocialMedia => $_get(6, false);
  set removeSocialMedia(bool v) {
    $_setBool(6, v);
  }

  bool hasRemoveSocialMedia() => $_has(6);
  void clearRemoveSocialMedia() => clearField(7);

  bool get updateProfile => $_get(7, false);
  set updateProfile(bool v) {
    $_setBool(7, v);
  }

  bool hasUpdateProfile() => $_has(7);
  void clearUpdateProfile() => clearField(8);

  bool get createOffer => $_get(8, false);
  set createOffer(bool v) {
    $_setBool(8, v);
  }

  bool hasCreateOffer() => $_has(8);
  void clearCreateOffer() => clearField(9);

  bool get updateOffer => $_get(9, false);
  set updateOffer(bool v) {
    $_setBool(9, v);
  }

  bool hasUpdateOffer() => $_has(9);
  void clearUpdateOffer() => clearField(10);

  bool get closeOffer => $_get(10, false);
  set closeOffer(bool v) {
    $_setBool(10, v);
  }

  bool hasCloseOffer() => $_has(10);
  void clearCloseOffer() => clearField(11);

  bool get archiveOffer => $_get(11, false);
  set archiveOffer(bool v) {
    $_setBool(11, v);
  }

  bool hasArchiveOffer() => $_has(11);
  void clearArchiveOffer() => clearField(12);

  bool get sendChat => $_get(12, false);
  set sendChat(bool v) {
    $_setBool(12, v);
  }

  bool hasSendChat() => $_has(12);
  void clearSendChat() => clearField(13);

  bool get makeDeal => $_get(13, false);
  set makeDeal(bool v) {
    $_setBool(13, v);
  }

  bool hasMakeDeal() => $_has(13);
  void clearMakeDeal() => clearField(14);

  bool get reportProposal => $_get(14, false);
  set reportProposal(bool v) {
    $_setBool(14, v);
  }

  bool hasReportProposal() => $_has(14);
  void clearReportProposal() => clearField(15);

  bool get disputeDeal => $_get(15, false);
  set disputeDeal(bool v) {
    $_setBool(15, v);
  }

  bool hasDisputeDeal() => $_has(15);
  void clearDisputeDeal() => clearField(16);

  bool get uploadImage => $_get(16, false);
  set uploadImage(bool v) {
    $_setBool(16, v);
  }

  bool hasUploadImage() => $_has(16);
  void clearUploadImage() => clearField(17);

  bool get makeImagePublic => $_get(17, false);
  set makeImagePublic(bool v) {
    $_setBool(17, v);
  }

  bool hasMakeImagePublic() => $_has(17);
  void clearMakeImagePublic() => clearField(18);

  bool get listImages => $_get(18, false);
  set listImages(bool v) {
    $_setBool(18, v);
  }

  bool hasListImages() => $_has(18);
  void clearListImages() => clearField(19);
}

class ConfigAsset extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigAsset',
      package: const $pb.PackageName('inf_common'))
    ..aOS(1, 'name')
    ..a<List<int>>(2, 'data', $pb.PbFieldType.OY)
    ..aOB(3, 'svg')
    ..hasRequiredFields = false;

  ConfigAsset() : super();
  ConfigAsset.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConfigAsset.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ConfigAsset clone() => new ConfigAsset()..mergeFromMessage(this);
  ConfigAsset copyWith(void Function(ConfigAsset) updates) =>
      super.copyWith((message) => updates(message as ConfigAsset));
  $pb.BuilderInfo get info_ => _i;
  static ConfigAsset create() => new ConfigAsset();
  static $pb.PbList<ConfigAsset> createRepeated() =>
      new $pb.PbList<ConfigAsset>();
  static ConfigAsset getDefault() => _defaultInstance ??= create()..freeze();
  static ConfigAsset _defaultInstance;
  static void $checkItem(ConfigAsset v) {
    if (v is! ConfigAsset) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get name => $_getS(0, '');
  set name(String v) {
    $_setString(0, v);
  }

  bool hasName() => $_has(0);
  void clearName() => clearField(1);

  List<int> get data => $_getN(1);
  set data(List<int> v) {
    $_setBytes(1, v);
  }

  bool hasData() => $_has(1);
  void clearData() => clearField(2);

  bool get svg => $_get(2, false);
  set svg(bool v) {
    $_setBool(2, v);
  }

  bool hasSvg() => $_has(2);
  void clearSvg() => clearField(3);
}

class ConfigContent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigContent',
      package: const $pb.PackageName('inf_common'))
    ..pPS(1, 'welcomeImageUrls')
    ..hasRequiredFields = false;

  ConfigContent() : super();
  ConfigContent.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConfigContent.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ConfigContent clone() => new ConfigContent()..mergeFromMessage(this);
  ConfigContent copyWith(void Function(ConfigContent) updates) =>
      super.copyWith((message) => updates(message as ConfigContent));
  $pb.BuilderInfo get info_ => _i;
  static ConfigContent create() => new ConfigContent();
  static $pb.PbList<ConfigContent> createRepeated() =>
      new $pb.PbList<ConfigContent>();
  static ConfigContent getDefault() => _defaultInstance ??= create()..freeze();
  static ConfigContent _defaultInstance;
  static void $checkItem(ConfigContent v) {
    if (v is! ConfigContent) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<String> get welcomeImageUrls => $_getList(0);
}

class ConfigData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigData',
      package: const $pb.PackageName('inf_common'))
    ..a<int>(1, 'clientVersion', $pb.PbFieldType.O3)
    ..aInt64(5, 'timestamp')
    ..a<ConfigServices>(6, 'services', $pb.PbFieldType.OM,
        ConfigServices.getDefault, ConfigServices.create)
    ..a<ConfigContent>(7, 'content', $pb.PbFieldType.OM,
        ConfigContent.getDefault, ConfigContent.create)
    ..aOS(8, 'region')
    ..aOS(9, 'language')
    ..pp<ConfigOAuthProvider>(11, 'oauthProviders', $pb.PbFieldType.PM,
        ConfigOAuthProvider.$checkItem, ConfigOAuthProvider.create)
    ..pp<ConfigContentFormat>(12, 'contentFormats', $pb.PbFieldType.PM,
        ConfigContentFormat.$checkItem, ConfigContentFormat.create)
    ..pp<ConfigCategory>(13, 'categories', $pb.PbFieldType.PM,
        ConfigCategory.$checkItem, ConfigCategory.create)
    ..pp<ConfigAsset>(14, 'assets', $pb.PbFieldType.PM, ConfigAsset.$checkItem,
        ConfigAsset.create)
    ..a<ConfigFeatureSwitches>(15, 'featureSwitches', $pb.PbFieldType.OM,
        ConfigFeatureSwitches.getDefault, ConfigFeatureSwitches.create)
    ..hasRequiredFields = false;

  ConfigData() : super();
  ConfigData.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConfigData.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ConfigData clone() => new ConfigData()..mergeFromMessage(this);
  ConfigData copyWith(void Function(ConfigData) updates) =>
      super.copyWith((message) => updates(message as ConfigData));
  $pb.BuilderInfo get info_ => _i;
  static ConfigData create() => new ConfigData();
  static $pb.PbList<ConfigData> createRepeated() =>
      new $pb.PbList<ConfigData>();
  static ConfigData getDefault() => _defaultInstance ??= create()..freeze();
  static ConfigData _defaultInstance;
  static void $checkItem(ConfigData v) {
    if (v is! ConfigData) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get clientVersion => $_get(0, 0);
  set clientVersion(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasClientVersion() => $_has(0);
  void clearClientVersion() => clearField(1);

  Int64 get timestamp => $_getI64(1);
  set timestamp(Int64 v) {
    $_setInt64(1, v);
  }

  bool hasTimestamp() => $_has(1);
  void clearTimestamp() => clearField(5);

  ConfigServices get services => $_getN(2);
  set services(ConfigServices v) {
    setField(6, v);
  }

  bool hasServices() => $_has(2);
  void clearServices() => clearField(6);

  ConfigContent get content => $_getN(3);
  set content(ConfigContent v) {
    setField(7, v);
  }

  bool hasContent() => $_has(3);
  void clearContent() => clearField(7);

  String get region => $_getS(4, '');
  set region(String v) {
    $_setString(4, v);
  }

  bool hasRegion() => $_has(4);
  void clearRegion() => clearField(8);

  String get language => $_getS(5, '');
  set language(String v) {
    $_setString(5, v);
  }

  bool hasLanguage() => $_has(5);
  void clearLanguage() => clearField(9);

  List<ConfigOAuthProvider> get oauthProviders => $_getList(6);

  List<ConfigContentFormat> get contentFormats => $_getList(7);

  List<ConfigCategory> get categories => $_getList(8);

  List<ConfigAsset> get assets => $_getList(9);

  ConfigFeatureSwitches get featureSwitches => $_getN(10);
  set featureSwitches(ConfigFeatureSwitches v) {
    setField(15, v);
  }

  bool hasFeatureSwitches() => $_has(10);
  void clearFeatureSwitches() => clearField(15);
}
