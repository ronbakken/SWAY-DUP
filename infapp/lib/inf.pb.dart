///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library inf;

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

export 'inf.pbenum.dart';

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
    ..a<int>(14, 'fontAwesomeBrand', PbFieldType.O3)
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

  int get fontAwesomeBrand => $_get(13, 0);
  set fontAwesomeBrand(int v) { $_setUnsignedInt32(13, v); }
  bool hasFontAwesomeBrand() => $_has(13);
  void clearFontAwesomeBrand() => clearField(14);
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

class ConfigData extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ConfigData')
    ..a<int>(1, 'clientVersion', PbFieldType.O3)
    ..a<ConfigCategories>(2, 'categories', PbFieldType.OM, ConfigCategories.getDefault, ConfigCategories.create)
    ..a<ConfigOAuthProviders>(3, 'oauthProviders', PbFieldType.OM, ConfigOAuthProviders.getDefault, ConfigOAuthProviders.create)
    ..pPS(4, 'downloadUrls')
    ..hasRequiredFields = false
  ;

  ConfigData() : super();
  ConfigData.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ConfigData.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ConfigData clone() => new ConfigData()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ConfigData create() => new ConfigData();
  static PbList<ConfigData> createRepeated() => new PbList<ConfigData>();
  static ConfigData getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyConfigData();
    return _defaultInstance;
  }
  static ConfigData _defaultInstance;
  static void $checkItem(ConfigData v) {
    if (v is! ConfigData) checkItemFailed(v, 'ConfigData');
  }

  int get clientVersion => $_get(0, 0);
  set clientVersion(int v) { $_setUnsignedInt32(0, v); }
  bool hasClientVersion() => $_has(0);
  void clearClientVersion() => clearField(1);

  ConfigCategories get categories => $_getN(1);
  set categories(ConfigCategories v) { setField(2, v); }
  bool hasCategories() => $_has(1);
  void clearCategories() => clearField(2);

  ConfigOAuthProviders get oauthProviders => $_getN(2);
  set oauthProviders(ConfigOAuthProviders v) { setField(3, v); }
  bool hasOauthProviders() => $_has(2);
  void clearOauthProviders() => clearField(3);

  List<String> get downloadUrls => $_getList(3);
}

class _ReadonlyConfigData extends ConfigData with ReadonlyMessageMixin {}

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

class NetResRejected extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetResRejected')
    ..aOS(1, 'rejectReason')
    ..hasRequiredFields = false
  ;

  NetResRejected() : super();
  NetResRejected.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NetResRejected.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NetResRejected clone() => new NetResRejected()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetResRejected create() => new NetResRejected();
  static PbList<NetResRejected> createRepeated() => new PbList<NetResRejected>();
  static NetResRejected getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyNetResRejected();
    return _defaultInstance;
  }
  static NetResRejected _defaultInstance;
  static void $checkItem(NetResRejected v) {
    if (v is! NetResRejected) checkItemFailed(v, 'NetResRejected');
  }

  String get rejectReason => $_getS(0, '');
  set rejectReason(String v) { $_setString(0, v); }
  bool hasRejectReason() => $_has(0);
  void clearRejectReason() => clearField(1);
}

class _ReadonlyNetResRejected extends NetResRejected with ReadonlyMessageMixin {}

class NetReqImageUpload extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetReqImageUpload')
    ..aOS(1, 'fileName')
    ..a<int>(2, 'fileSize', PbFieldType.O3)
    ..aOS(3, 'sha256')
    ..hasRequiredFields = false
  ;

  NetReqImageUpload() : super();
  NetReqImageUpload.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NetReqImageUpload.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NetReqImageUpload clone() => new NetReqImageUpload()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetReqImageUpload create() => new NetReqImageUpload();
  static PbList<NetReqImageUpload> createRepeated() => new PbList<NetReqImageUpload>();
  static NetReqImageUpload getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyNetReqImageUpload();
    return _defaultInstance;
  }
  static NetReqImageUpload _defaultInstance;
  static void $checkItem(NetReqImageUpload v) {
    if (v is! NetReqImageUpload) checkItemFailed(v, 'NetReqImageUpload');
  }

  String get fileName => $_getS(0, '');
  set fileName(String v) { $_setString(0, v); }
  bool hasFileName() => $_has(0);
  void clearFileName() => clearField(1);

  int get fileSize => $_get(1, 0);
  set fileSize(int v) { $_setUnsignedInt32(1, v); }
  bool hasFileSize() => $_has(1);
  void clearFileSize() => clearField(2);

  String get sha256 => $_getS(2, '');
  set sha256(String v) { $_setString(2, v); }
  bool hasSha256() => $_has(2);
  void clearSha256() => clearField(3);
}

class _ReadonlyNetReqImageUpload extends NetReqImageUpload with ReadonlyMessageMixin {}

class NetResImageUpload extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetResImageUpload')
    ..aOS(1, 'requestMethod')
    ..aOS(2, 'requestUrl')
    ..aOS(3, 'headerContentType')
    ..aOS(4, 'headerContentLength')
    ..aOS(5, 'headerHost')
    ..aOS(6, 'headerXAmzDate')
    ..aOS(7, 'headerXAmzStorageClass')
    ..aOS(8, 'headerAuthorization')
    ..hasRequiredFields = false
  ;

  NetResImageUpload() : super();
  NetResImageUpload.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NetResImageUpload.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NetResImageUpload clone() => new NetResImageUpload()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetResImageUpload create() => new NetResImageUpload();
  static PbList<NetResImageUpload> createRepeated() => new PbList<NetResImageUpload>();
  static NetResImageUpload getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyNetResImageUpload();
    return _defaultInstance;
  }
  static NetResImageUpload _defaultInstance;
  static void $checkItem(NetResImageUpload v) {
    if (v is! NetResImageUpload) checkItemFailed(v, 'NetResImageUpload');
  }

  String get requestMethod => $_getS(0, '');
  set requestMethod(String v) { $_setString(0, v); }
  bool hasRequestMethod() => $_has(0);
  void clearRequestMethod() => clearField(1);

  String get requestUrl => $_getS(1, '');
  set requestUrl(String v) { $_setString(1, v); }
  bool hasRequestUrl() => $_has(1);
  void clearRequestUrl() => clearField(2);

  String get headerContentType => $_getS(2, '');
  set headerContentType(String v) { $_setString(2, v); }
  bool hasHeaderContentType() => $_has(2);
  void clearHeaderContentType() => clearField(3);

  String get headerContentLength => $_getS(3, '');
  set headerContentLength(String v) { $_setString(3, v); }
  bool hasHeaderContentLength() => $_has(3);
  void clearHeaderContentLength() => clearField(4);

  String get headerHost => $_getS(4, '');
  set headerHost(String v) { $_setString(4, v); }
  bool hasHeaderHost() => $_has(4);
  void clearHeaderHost() => clearField(5);

  String get headerXAmzDate => $_getS(5, '');
  set headerXAmzDate(String v) { $_setString(5, v); }
  bool hasHeaderXAmzDate() => $_has(5);
  void clearHeaderXAmzDate() => clearField(6);

  String get headerXAmzStorageClass => $_getS(6, '');
  set headerXAmzStorageClass(String v) { $_setString(6, v); }
  bool hasHeaderXAmzStorageClass() => $_has(6);
  void clearHeaderXAmzStorageClass() => clearField(7);

  String get headerAuthorization => $_getS(7, '');
  set headerAuthorization(String v) { $_setString(7, v); }
  bool hasHeaderAuthorization() => $_has(7);
  void clearHeaderAuthorization() => clearField(8);
}

class _ReadonlyNetResImageUpload extends NetResImageUpload with ReadonlyMessageMixin {}

class NetReqCreateOffer extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetReqCreateOffer')
    ..aOS(1, 'title')
    ..pPS(2, 'imageIds')
    ..aOS(3, 'description')
    ..aOS(4, 'deliverables')
    ..aOS(5, 'reward')
    ..hasRequiredFields = false
  ;

  NetReqCreateOffer() : super();
  NetReqCreateOffer.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NetReqCreateOffer.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NetReqCreateOffer clone() => new NetReqCreateOffer()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetReqCreateOffer create() => new NetReqCreateOffer();
  static PbList<NetReqCreateOffer> createRepeated() => new PbList<NetReqCreateOffer>();
  static NetReqCreateOffer getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyNetReqCreateOffer();
    return _defaultInstance;
  }
  static NetReqCreateOffer _defaultInstance;
  static void $checkItem(NetReqCreateOffer v) {
    if (v is! NetReqCreateOffer) checkItemFailed(v, 'NetReqCreateOffer');
  }

  String get title => $_getS(0, '');
  set title(String v) { $_setString(0, v); }
  bool hasTitle() => $_has(0);
  void clearTitle() => clearField(1);

  List<String> get imageIds => $_getList(1);

  String get description => $_getS(2, '');
  set description(String v) { $_setString(2, v); }
  bool hasDescription() => $_has(2);
  void clearDescription() => clearField(3);

  String get deliverables => $_getS(3, '');
  set deliverables(String v) { $_setString(3, v); }
  bool hasDeliverables() => $_has(3);
  void clearDeliverables() => clearField(4);

  String get reward => $_getS(4, '');
  set reward(String v) { $_setString(4, v); }
  bool hasReward() => $_has(4);
  void clearReward() => clearField(5);
}

class _ReadonlyNetReqCreateOffer extends NetReqCreateOffer with ReadonlyMessageMixin {}

class NetResCreateOffer extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetResCreateOffer')
    ..aInt64(1, 'id')
    ..hasRequiredFields = false
  ;

  NetResCreateOffer() : super();
  NetResCreateOffer.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NetResCreateOffer.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NetResCreateOffer clone() => new NetResCreateOffer()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetResCreateOffer create() => new NetResCreateOffer();
  static PbList<NetResCreateOffer> createRepeated() => new PbList<NetResCreateOffer>();
  static NetResCreateOffer getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyNetResCreateOffer();
    return _defaultInstance;
  }
  static NetResCreateOffer _defaultInstance;
  static void $checkItem(NetResCreateOffer v) {
    if (v is! NetResCreateOffer) checkItemFailed(v, 'NetResCreateOffer');
  }

  Int64 get id => $_getI64(0);
  set id(Int64 v) { $_setInt64(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);
}

class _ReadonlyNetResCreateOffer extends NetResCreateOffer with ReadonlyMessageMixin {}

