///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library inf;

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart';

class ConfigSubCategories extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ConfigSubCategories')
    ..pPS(1, 'labels')
    ..hasRequiredFields = false
  ;

  ConfigSubCategories() : super();
  ConfigSubCategories.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ConfigSubCategories.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ConfigSubCategories clone() => new ConfigSubCategories()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ConfigSubCategories create() => new ConfigSubCategories();
  static PbList<ConfigSubCategories> createRepeated() => new PbList<ConfigSubCategories>();
  static ConfigSubCategories getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyConfigSubCategories();
    return _defaultInstance;
  }
  static ConfigSubCategories _defaultInstance;
  static void $checkItem(ConfigSubCategories v) {
    if (v is! ConfigSubCategories) checkItemFailed(v, 'ConfigSubCategories');
  }

  List<String> get labels => $_getList(0);
}

class _ReadonlyConfigSubCategories extends ConfigSubCategories with ReadonlyMessageMixin {}

class ConfigCategories extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ConfigCategories')
    ..pp<ConfigSubCategories>(1, 'sub', PbFieldType.PM, ConfigSubCategories.$checkItem, ConfigSubCategories.create)
    ..hasRequiredFields = false
  ;

  ConfigCategories() : super();
  ConfigCategories.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ConfigCategories.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ConfigCategories clone() => new ConfigCategories()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ConfigCategories create() => new ConfigCategories();
  static PbList<ConfigCategories> createRepeated() => new PbList<ConfigCategories>();
  static ConfigCategories getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyConfigCategories();
    return _defaultInstance;
  }
  static ConfigCategories _defaultInstance;
  static void $checkItem(ConfigCategories v) {
    if (v is! ConfigCategories) checkItemFailed(v, 'ConfigCategories');
  }

  List<ConfigSubCategories> get sub => $_getList(0);
}

class _ReadonlyConfigCategories extends ConfigCategories with ReadonlyMessageMixin {}

class ConfigOAuthProvider extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ConfigOAuthProvider')
    ..aOB(1, 'visible')
    ..aOB(2, 'enabled')
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
    ..aOS(13, 'native')
    ..hasRequiredFields = false
  ;

  ConfigOAuthProvider() : super();
  ConfigOAuthProvider.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ConfigOAuthProvider.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ConfigOAuthProvider clone() => new ConfigOAuthProvider()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ConfigOAuthProvider create() => new ConfigOAuthProvider();
  static PbList<ConfigOAuthProvider> createRepeated() => new PbList<ConfigOAuthProvider>();
  static ConfigOAuthProvider getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyConfigOAuthProvider();
    return _defaultInstance;
  }
  static ConfigOAuthProvider _defaultInstance;
  static void $checkItem(ConfigOAuthProvider v) {
    if (v is! ConfigOAuthProvider) checkItemFailed(v, 'ConfigOAuthProvider');
  }

  bool get visible => $_get(0, false);
  set visible(bool v) { $_setBool(0, v); }
  bool hasVisible() => $_has(0);
  void clearVisible() => clearField(1);

  bool get enabled => $_get(1, false);
  set enabled(bool v) { $_setBool(1, v); }
  bool hasEnabled() => $_has(1);
  void clearEnabled() => clearField(2);

  String get label => $_getS(2, '');
  set label(String v) { $_setString(2, v); }
  bool hasLabel() => $_has(2);
  void clearLabel() => clearField(3);

  String get host => $_getS(3, '');
  set host(String v) { $_setString(3, v); }
  bool hasHost() => $_has(3);
  void clearHost() => clearField(4);

  String get requestTokenUrl => $_getS(4, '');
  set requestTokenUrl(String v) { $_setString(4, v); }
  bool hasRequestTokenUrl() => $_has(4);
  void clearRequestTokenUrl() => clearField(5);

  String get authenticateUrl => $_getS(5, '');
  set authenticateUrl(String v) { $_setString(5, v); }
  bool hasAuthenticateUrl() => $_has(5);
  void clearAuthenticateUrl() => clearField(6);

  String get authUrl => $_getS(6, '');
  set authUrl(String v) { $_setString(6, v); }
  bool hasAuthUrl() => $_has(6);
  void clearAuthUrl() => clearField(7);

  String get authQuery => $_getS(7, '');
  set authQuery(String v) { $_setString(7, v); }
  bool hasAuthQuery() => $_has(7);
  void clearAuthQuery() => clearField(8);

  String get callbackUrl => $_getS(8, '');
  set callbackUrl(String v) { $_setString(8, v); }
  bool hasCallbackUrl() => $_has(8);
  void clearCallbackUrl() => clearField(9);

  String get consumerKey => $_getS(9, '');
  set consumerKey(String v) { $_setString(9, v); }
  bool hasConsumerKey() => $_has(9);
  void clearConsumerKey() => clearField(10);

  String get consumerSecret => $_getS(10, '');
  set consumerSecret(String v) { $_setString(10, v); }
  bool hasConsumerSecret() => $_has(10);
  void clearConsumerSecret() => clearField(11);

  String get clientId => $_getS(11, '');
  set clientId(String v) { $_setString(11, v); }
  bool hasClientId() => $_has(11);
  void clearClientId() => clearField(12);

  String get native => $_getS(12, '');
  set native(String v) { $_setString(12, v); }
  bool hasNative() => $_has(12);
  void clearNative() => clearField(13);
}

class _ReadonlyConfigOAuthProvider extends ConfigOAuthProvider with ReadonlyMessageMixin {}

class ConfigOAuthProviders extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ConfigOAuthProviders')
    ..pp<ConfigOAuthProvider>(1, 'all', PbFieldType.PM, ConfigOAuthProvider.$checkItem, ConfigOAuthProvider.create)
    ..aOS(2, 'key')
    ..hasRequiredFields = false
  ;

  ConfigOAuthProviders() : super();
  ConfigOAuthProviders.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ConfigOAuthProviders.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ConfigOAuthProviders clone() => new ConfigOAuthProviders()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ConfigOAuthProviders create() => new ConfigOAuthProviders();
  static PbList<ConfigOAuthProviders> createRepeated() => new PbList<ConfigOAuthProviders>();
  static ConfigOAuthProviders getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyConfigOAuthProviders();
    return _defaultInstance;
  }
  static ConfigOAuthProviders _defaultInstance;
  static void $checkItem(ConfigOAuthProviders v) {
    if (v is! ConfigOAuthProviders) checkItemFailed(v, 'ConfigOAuthProviders');
  }

  List<ConfigOAuthProvider> get all => $_getList(0);

  String get key => $_getS(1, '');
  set key(String v) { $_setString(1, v); }
  bool hasKey() => $_has(1);
  void clearKey() => clearField(2);
}

class _ReadonlyConfigOAuthProviders extends ConfigOAuthProviders with ReadonlyMessageMixin {}

class Config extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Config')
    ..a<int>(1, 'version', PbFieldType.O3)
    ..a<ConfigCategories>(2, 'categories', PbFieldType.OM, ConfigCategories.getDefault, ConfigCategories.create)
    ..a<ConfigOAuthProviders>(3, 'oauthProviders', PbFieldType.OM, ConfigOAuthProviders.getDefault, ConfigOAuthProviders.create)
    ..hasRequiredFields = false
  ;

  Config() : super();
  Config.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Config.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Config clone() => new Config()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Config create() => new Config();
  static PbList<Config> createRepeated() => new PbList<Config>();
  static Config getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyConfig();
    return _defaultInstance;
  }
  static Config _defaultInstance;
  static void $checkItem(Config v) {
    if (v is! Config) checkItemFailed(v, 'Config');
  }

  int get version => $_get(0, 0);
  set version(int v) { $_setUnsignedInt32(0, v); }
  bool hasVersion() => $_has(0);
  void clearVersion() => clearField(1);

  ConfigCategories get categories => $_getN(1);
  set categories(ConfigCategories v) { setField(2, v); }
  bool hasCategories() => $_has(1);
  void clearCategories() => clearField(2);

  ConfigOAuthProviders get oauthProviders => $_getN(2);
  set oauthProviders(ConfigOAuthProviders v) { setField(3, v); }
  bool hasOauthProviders() => $_has(2);
  void clearOauthProviders() => clearField(3);
}

class _ReadonlyConfig extends Config with ReadonlyMessageMixin {}

class CategoryId extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CategoryId')
    ..a<int>(1, 'main', PbFieldType.O3)
    ..a<int>(2, 'sub', PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  CategoryId() : super();
  CategoryId.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CategoryId.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CategoryId clone() => new CategoryId()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CategoryId create() => new CategoryId();
  static PbList<CategoryId> createRepeated() => new PbList<CategoryId>();
  static CategoryId getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyCategoryId();
    return _defaultInstance;
  }
  static CategoryId _defaultInstance;
  static void $checkItem(CategoryId v) {
    if (v is! CategoryId) checkItemFailed(v, 'CategoryId');
  }

  int get main => $_get(0, 0);
  set main(int v) { $_setUnsignedInt32(0, v); }
  bool hasMain() => $_has(0);
  void clearMain() => clearField(1);

  int get sub => $_get(1, 0);
  set sub(int v) { $_setUnsignedInt32(1, v); }
  bool hasSub() => $_has(1);
  void clearSub() => clearField(2);
}

class _ReadonlyCategoryId extends CategoryId with ReadonlyMessageMixin {}

class CategoryIdSet extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CategoryIdSet')
    ..pp<CategoryId>(1, 'ids', PbFieldType.PM, CategoryId.$checkItem, CategoryId.create)
    ..hasRequiredFields = false
  ;

  CategoryIdSet() : super();
  CategoryIdSet.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CategoryIdSet.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CategoryIdSet clone() => new CategoryIdSet()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CategoryIdSet create() => new CategoryIdSet();
  static PbList<CategoryIdSet> createRepeated() => new PbList<CategoryIdSet>();
  static CategoryIdSet getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyCategoryIdSet();
    return _defaultInstance;
  }
  static CategoryIdSet _defaultInstance;
  static void $checkItem(CategoryIdSet v) {
    if (v is! CategoryIdSet) checkItemFailed(v, 'CategoryIdSet');
  }

  List<CategoryId> get ids => $_getList(0);
}

class _ReadonlyCategoryIdSet extends CategoryIdSet with ReadonlyMessageMixin {}

