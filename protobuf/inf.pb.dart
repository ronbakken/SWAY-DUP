///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

import 'inf.pbenum.dart';

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
    ..a<int>(14, 'fontAwesomeBrand', PbFieldType.O3)
    ..e<OAuthMechanism>(15, 'mechanism', PbFieldType.OE, OAuthMechanism.OAM_NONE, OAuthMechanism.valueOf, OAuthMechanism.values)
    ..aOS(16, 'accessTokenUrl')
    ..aOS(17, 'clientSecret')
    ..pPS(18, 'whitelistHosts')
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

  int get fontAwesomeBrand => $_get(12, 0);
  set fontAwesomeBrand(int v) { $_setSignedInt32(12, v); }
  bool hasFontAwesomeBrand() => $_has(12);
  void clearFontAwesomeBrand() => clearField(14);

  OAuthMechanism get mechanism => $_getN(13);
  set mechanism(OAuthMechanism v) { setField(15, v); }
  bool hasMechanism() => $_has(13);
  void clearMechanism() => clearField(15);

  String get accessTokenUrl => $_getS(14, '');
  set accessTokenUrl(String v) { $_setString(14, v); }
  bool hasAccessTokenUrl() => $_has(14);
  void clearAccessTokenUrl() => clearField(16);

  String get clientSecret => $_getS(15, '');
  set clientSecret(String v) { $_setString(15, v); }
  bool hasClientSecret() => $_has(15);
  void clearClientSecret() => clearField(17);

  List<String> get whitelistHosts => $_getList(16);
}

class _ReadonlyConfigOAuthProvider extends ConfigOAuthProvider with ReadonlyMessageMixin {}

class ConfigOAuthProviders extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ConfigOAuthProviders')
    ..pp<ConfigOAuthProvider>(1, 'all', PbFieldType.PM, ConfigOAuthProvider.$checkItem, ConfigOAuthProvider.create)
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
}

class _ReadonlyConfigOAuthProviders extends ConfigOAuthProviders with ReadonlyMessageMixin {}

class ConfigData extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ConfigData')
    ..a<int>(1, 'clientVersion', PbFieldType.O3)
    ..a<ConfigCategories>(2, 'categories', PbFieldType.OM, ConfigCategories.getDefault, ConfigCategories.create)
    ..a<ConfigOAuthProviders>(3, 'oauthProviders', PbFieldType.OM, ConfigOAuthProviders.getDefault, ConfigOAuthProviders.create)
    ..pPS(4, 'downloadUrls')
    ..aInt64(5, 'timestamp')
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
  set clientVersion(int v) { $_setSignedInt32(0, v); }
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

  Int64 get timestamp => $_getI64(4);
  set timestamp(Int64 v) { $_setInt64(4, v); }
  bool hasTimestamp() => $_has(4);
  void clearTimestamp() => clearField(5);
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
  set main(int v) { $_setSignedInt32(0, v); }
  bool hasMain() => $_has(0);
  void clearMain() => clearField(1);

  int get sub => $_get(1, 0);
  set sub(int v) { $_setSignedInt32(1, v); }
  bool hasSub() => $_has(1);
  void clearSub() => clearField(2);
}

class _ReadonlyCategoryId extends CategoryId with ReadonlyMessageMixin {}

class DataSocialMedia extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataSocialMedia')
    ..aOB(1, 'connected')
    ..a<int>(2, 'followersCount', PbFieldType.O3)
    ..a<int>(3, 'followingCount', PbFieldType.O3)
    ..aOS(4, 'screenName')
    ..aOS(5, 'displayName')
    ..aOS(6, 'description')
    ..aOS(7, 'location')
    ..aOS(8, 'url')
    ..a<int>(9, 'friendsCount', PbFieldType.O3)
    ..a<int>(10, 'postsCount', PbFieldType.O3)
    ..aOB(11, 'verified')
    ..aOS(12, 'email')
    ..aOS(13, 'profileUrl')
    ..hasRequiredFields = false
  ;

  DataSocialMedia() : super();
  DataSocialMedia.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DataSocialMedia.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DataSocialMedia clone() => new DataSocialMedia()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataSocialMedia create() => new DataSocialMedia();
  static PbList<DataSocialMedia> createRepeated() => new PbList<DataSocialMedia>();
  static DataSocialMedia getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDataSocialMedia();
    return _defaultInstance;
  }
  static DataSocialMedia _defaultInstance;
  static void $checkItem(DataSocialMedia v) {
    if (v is! DataSocialMedia) checkItemFailed(v, 'DataSocialMedia');
  }

  bool get connected => $_get(0, false);
  set connected(bool v) { $_setBool(0, v); }
  bool hasConnected() => $_has(0);
  void clearConnected() => clearField(1);

  int get followersCount => $_get(1, 0);
  set followersCount(int v) { $_setSignedInt32(1, v); }
  bool hasFollowersCount() => $_has(1);
  void clearFollowersCount() => clearField(2);

  int get followingCount => $_get(2, 0);
  set followingCount(int v) { $_setSignedInt32(2, v); }
  bool hasFollowingCount() => $_has(2);
  void clearFollowingCount() => clearField(3);

  String get screenName => $_getS(3, '');
  set screenName(String v) { $_setString(3, v); }
  bool hasScreenName() => $_has(3);
  void clearScreenName() => clearField(4);

  String get displayName => $_getS(4, '');
  set displayName(String v) { $_setString(4, v); }
  bool hasDisplayName() => $_has(4);
  void clearDisplayName() => clearField(5);

  String get description => $_getS(5, '');
  set description(String v) { $_setString(5, v); }
  bool hasDescription() => $_has(5);
  void clearDescription() => clearField(6);

  String get location => $_getS(6, '');
  set location(String v) { $_setString(6, v); }
  bool hasLocation() => $_has(6);
  void clearLocation() => clearField(7);

  String get url => $_getS(7, '');
  set url(String v) { $_setString(7, v); }
  bool hasUrl() => $_has(7);
  void clearUrl() => clearField(8);

  int get friendsCount => $_get(8, 0);
  set friendsCount(int v) { $_setSignedInt32(8, v); }
  bool hasFriendsCount() => $_has(8);
  void clearFriendsCount() => clearField(9);

  int get postsCount => $_get(9, 0);
  set postsCount(int v) { $_setSignedInt32(9, v); }
  bool hasPostsCount() => $_has(9);
  void clearPostsCount() => clearField(10);

  bool get verified => $_get(10, false);
  set verified(bool v) { $_setBool(10, v); }
  bool hasVerified() => $_has(10);
  void clearVerified() => clearField(11);

  String get email => $_getS(11, '');
  set email(String v) { $_setString(11, v); }
  bool hasEmail() => $_has(11);
  void clearEmail() => clearField(12);

  String get profileUrl => $_getS(12, '');
  set profileUrl(String v) { $_setString(12, v); }
  bool hasProfileUrl() => $_has(12);
  void clearProfileUrl() => clearField(13);
}

class _ReadonlyDataSocialMedia extends DataSocialMedia with ReadonlyMessageMixin {}

class DataOAuthCredentials extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataOAuthCredentials')
    ..aOS(1, 'oauthToken')
    ..aOS(2, 'oauthTokenSecret')
    ..a<int>(3, 'oauthTokenExpires', PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  DataOAuthCredentials() : super();
  DataOAuthCredentials.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DataOAuthCredentials.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DataOAuthCredentials clone() => new DataOAuthCredentials()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataOAuthCredentials create() => new DataOAuthCredentials();
  static PbList<DataOAuthCredentials> createRepeated() => new PbList<DataOAuthCredentials>();
  static DataOAuthCredentials getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDataOAuthCredentials();
    return _defaultInstance;
  }
  static DataOAuthCredentials _defaultInstance;
  static void $checkItem(DataOAuthCredentials v) {
    if (v is! DataOAuthCredentials) checkItemFailed(v, 'DataOAuthCredentials');
  }

  String get oauthToken => $_getS(0, '');
  set oauthToken(String v) { $_setString(0, v); }
  bool hasOauthToken() => $_has(0);
  void clearOauthToken() => clearField(1);

  String get oauthTokenSecret => $_getS(1, '');
  set oauthTokenSecret(String v) { $_setString(1, v); }
  bool hasOauthTokenSecret() => $_has(1);
  void clearOauthTokenSecret() => clearField(2);

  int get oauthTokenExpires => $_get(2, 0);
  set oauthTokenExpires(int v) { $_setSignedInt32(2, v); }
  bool hasOauthTokenExpires() => $_has(2);
  void clearOauthTokenExpires() => clearField(3);
}

class _ReadonlyDataOAuthCredentials extends DataOAuthCredentials with ReadonlyMessageMixin {}

class DataInfluencer extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataInfluencer')
    ..aInt64(1, 'id')
    ..aOS(2, 'name')
    ..aOS(3, 'location')
    ..aOS(4, 'avatarUrl')
    ..pp<CategoryId>(5, 'categories', PbFieldType.PM, CategoryId.$checkItem, CategoryId.create)
    ..a<double>(6, 'lat', PbFieldType.OD)
    ..a<double>(7, 'lng', PbFieldType.OD)
    ..pp<DataSocialMedia>(8, 'socialMedia', PbFieldType.PM, DataSocialMedia.$checkItem, DataSocialMedia.create)
    ..hasRequiredFields = false
  ;

  DataInfluencer() : super();
  DataInfluencer.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DataInfluencer.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DataInfluencer clone() => new DataInfluencer()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataInfluencer create() => new DataInfluencer();
  static PbList<DataInfluencer> createRepeated() => new PbList<DataInfluencer>();
  static DataInfluencer getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDataInfluencer();
    return _defaultInstance;
  }
  static DataInfluencer _defaultInstance;
  static void $checkItem(DataInfluencer v) {
    if (v is! DataInfluencer) checkItemFailed(v, 'DataInfluencer');
  }

  Int64 get id => $_getI64(0);
  set id(Int64 v) { $_setInt64(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  String get name => $_getS(1, '');
  set name(String v) { $_setString(1, v); }
  bool hasName() => $_has(1);
  void clearName() => clearField(2);

  String get location => $_getS(2, '');
  set location(String v) { $_setString(2, v); }
  bool hasLocation() => $_has(2);
  void clearLocation() => clearField(3);

  String get avatarUrl => $_getS(3, '');
  set avatarUrl(String v) { $_setString(3, v); }
  bool hasAvatarUrl() => $_has(3);
  void clearAvatarUrl() => clearField(4);

  List<CategoryId> get categories => $_getList(4);

  double get lat => $_getN(5);
  set lat(double v) { $_setDouble(5, v); }
  bool hasLat() => $_has(5);
  void clearLat() => clearField(6);

  double get lng => $_getN(6);
  set lng(double v) { $_setDouble(6, v); }
  bool hasLng() => $_has(6);
  void clearLng() => clearField(7);

  List<DataSocialMedia> get socialMedia => $_getList(7);
}

class _ReadonlyDataInfluencer extends DataInfluencer with ReadonlyMessageMixin {}

class DataBusiness extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataBusiness')
    ..aInt64(1, 'id')
    ..aOS(2, 'name')
    ..aOS(3, 'location')
    ..aOS(4, 'avatarUrl')
    ..pp<CategoryId>(5, 'categories', PbFieldType.PM, CategoryId.$checkItem, CategoryId.create)
    ..a<double>(6, 'lat', PbFieldType.OD)
    ..a<double>(7, 'lng', PbFieldType.OD)
    ..pp<DataSocialMedia>(8, 'socialMedia', PbFieldType.PM, DataSocialMedia.$checkItem, DataSocialMedia.create)
    ..hasRequiredFields = false
  ;

  DataBusiness() : super();
  DataBusiness.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DataBusiness.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DataBusiness clone() => new DataBusiness()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataBusiness create() => new DataBusiness();
  static PbList<DataBusiness> createRepeated() => new PbList<DataBusiness>();
  static DataBusiness getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDataBusiness();
    return _defaultInstance;
  }
  static DataBusiness _defaultInstance;
  static void $checkItem(DataBusiness v) {
    if (v is! DataBusiness) checkItemFailed(v, 'DataBusiness');
  }

  Int64 get id => $_getI64(0);
  set id(Int64 v) { $_setInt64(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  String get name => $_getS(1, '');
  set name(String v) { $_setString(1, v); }
  bool hasName() => $_has(1);
  void clearName() => clearField(2);

  String get location => $_getS(2, '');
  set location(String v) { $_setString(2, v); }
  bool hasLocation() => $_has(2);
  void clearLocation() => clearField(3);

  String get avatarUrl => $_getS(3, '');
  set avatarUrl(String v) { $_setString(3, v); }
  bool hasAvatarUrl() => $_has(3);
  void clearAvatarUrl() => clearField(4);

  List<CategoryId> get categories => $_getList(4);

  double get lat => $_getN(5);
  set lat(double v) { $_setDouble(5, v); }
  bool hasLat() => $_has(5);
  void clearLat() => clearField(6);

  double get lng => $_getN(6);
  set lng(double v) { $_setDouble(6, v); }
  bool hasLng() => $_has(6);
  void clearLng() => clearField(7);

  List<DataSocialMedia> get socialMedia => $_getList(7);
}

class _ReadonlyDataBusiness extends DataBusiness with ReadonlyMessageMixin {}

class DataOffer extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataOffer')
    ..aInt64(1, 'id')
    ..a<DataBusiness>(2, 'business', PbFieldType.OM, DataBusiness.getDefault, DataBusiness.create)
    ..aOS(3, 'title')
    ..pPS(4, 'imageUrls')
    ..pp<CategoryId>(5, 'categories', PbFieldType.PM, CategoryId.$checkItem, CategoryId.create)
    ..a<double>(6, 'lat', PbFieldType.OD)
    ..a<double>(7, 'lng', PbFieldType.OD)
    ..aOS(8, 'description')
    ..aOS(9, 'deliverables')
    ..aOS(10, 'reward')
    ..hasRequiredFields = false
  ;

  DataOffer() : super();
  DataOffer.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DataOffer.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DataOffer clone() => new DataOffer()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataOffer create() => new DataOffer();
  static PbList<DataOffer> createRepeated() => new PbList<DataOffer>();
  static DataOffer getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDataOffer();
    return _defaultInstance;
  }
  static DataOffer _defaultInstance;
  static void $checkItem(DataOffer v) {
    if (v is! DataOffer) checkItemFailed(v, 'DataOffer');
  }

  Int64 get id => $_getI64(0);
  set id(Int64 v) { $_setInt64(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  DataBusiness get business => $_getN(1);
  set business(DataBusiness v) { setField(2, v); }
  bool hasBusiness() => $_has(1);
  void clearBusiness() => clearField(2);

  String get title => $_getS(2, '');
  set title(String v) { $_setString(2, v); }
  bool hasTitle() => $_has(2);
  void clearTitle() => clearField(3);

  List<String> get imageUrls => $_getList(3);

  List<CategoryId> get categories => $_getList(4);

  double get lat => $_getN(5);
  set lat(double v) { $_setDouble(5, v); }
  bool hasLat() => $_has(5);
  void clearLat() => clearField(6);

  double get lng => $_getN(6);
  set lng(double v) { $_setDouble(6, v); }
  bool hasLng() => $_has(6);
  void clearLng() => clearField(7);

  String get description => $_getS(7, '');
  set description(String v) { $_setString(7, v); }
  bool hasDescription() => $_has(7);
  void clearDescription() => clearField(8);

  String get deliverables => $_getS(8, '');
  set deliverables(String v) { $_setString(8, v); }
  bool hasDeliverables() => $_has(8);
  void clearDeliverables() => clearField(9);

  String get reward => $_getS(9, '');
  set reward(String v) { $_setString(9, v); }
  bool hasReward() => $_has(9);
  void clearReward() => clearField(10);
}

class _ReadonlyDataOffer extends DataOffer with ReadonlyMessageMixin {}

class DataApplicant extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataApplicant')
    ..aInt64(1, 'id')
    ..a<DataOffer>(2, 'offer', PbFieldType.OM, DataOffer.getDefault, DataOffer.create)
    ..a<DataInfluencer>(3, 'influencer', PbFieldType.OM, DataInfluencer.getDefault, DataInfluencer.create)
    ..hasRequiredFields = false
  ;

  DataApplicant() : super();
  DataApplicant.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DataApplicant.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DataApplicant clone() => new DataApplicant()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataApplicant create() => new DataApplicant();
  static PbList<DataApplicant> createRepeated() => new PbList<DataApplicant>();
  static DataApplicant getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDataApplicant();
    return _defaultInstance;
  }
  static DataApplicant _defaultInstance;
  static void $checkItem(DataApplicant v) {
    if (v is! DataApplicant) checkItemFailed(v, 'DataApplicant');
  }

  Int64 get id => $_getI64(0);
  set id(Int64 v) { $_setInt64(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  DataOffer get offer => $_getN(1);
  set offer(DataOffer v) { setField(2, v); }
  bool hasOffer() => $_has(1);
  void clearOffer() => clearField(2);

  DataInfluencer get influencer => $_getN(2);
  set influencer(DataInfluencer v) { setField(3, v); }
  bool hasInfluencer() => $_has(2);
  void clearInfluencer() => clearField(3);
}

class _ReadonlyDataApplicant extends DataApplicant with ReadonlyMessageMixin {}

class DataChat extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataChat')
    ..aInt64(1, 'applicantId')
    ..aInt64(2, 'sequenceId')
    ..aInt64(3, 'keyId')
    ..aOB(4, 'outgoing')
    ..aOS(5, 'text')
    ..hasRequiredFields = false
  ;

  DataChat() : super();
  DataChat.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DataChat.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DataChat clone() => new DataChat()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataChat create() => new DataChat();
  static PbList<DataChat> createRepeated() => new PbList<DataChat>();
  static DataChat getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDataChat();
    return _defaultInstance;
  }
  static DataChat _defaultInstance;
  static void $checkItem(DataChat v) {
    if (v is! DataChat) checkItemFailed(v, 'DataChat');
  }

  Int64 get applicantId => $_getI64(0);
  set applicantId(Int64 v) { $_setInt64(0, v); }
  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);

  Int64 get sequenceId => $_getI64(1);
  set sequenceId(Int64 v) { $_setInt64(1, v); }
  bool hasSequenceId() => $_has(1);
  void clearSequenceId() => clearField(2);

  Int64 get keyId => $_getI64(2);
  set keyId(Int64 v) { $_setInt64(2, v); }
  bool hasKeyId() => $_has(2);
  void clearKeyId() => clearField(3);

  bool get outgoing => $_get(3, false);
  set outgoing(bool v) { $_setBool(3, v); }
  bool hasOutgoing() => $_has(3);
  void clearOutgoing() => clearField(4);

  String get text => $_getS(4, '');
  set text(String v) { $_setString(4, v); }
  bool hasText() => $_has(4);
  void clearText() => clearField(5);
}

class _ReadonlyDataChat extends DataChat with ReadonlyMessageMixin {}

class DataAccountState extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataAccountState')
    ..a<int>(1, 'deviceId', PbFieldType.O3)
    ..a<int>(2, 'accountId', PbFieldType.O3)
    ..e<AccountType>(3, 'accountType', PbFieldType.OE, AccountType.AT_UNKNOWN, AccountType.valueOf, AccountType.values)
    ..e<GlobalAccountState>(4, 'globalAccountState', PbFieldType.OE, GlobalAccountState.GAS_INITIALIZE, GlobalAccountState.valueOf, GlobalAccountState.values)
    ..e<GlobalAccountStateReason>(5, 'globalAccountStateReason', PbFieldType.OE, GlobalAccountStateReason.GASR_NEW_ACCOUNT, GlobalAccountStateReason.valueOf, GlobalAccountStateReason.values)
    ..hasRequiredFields = false
  ;

  DataAccountState() : super();
  DataAccountState.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DataAccountState.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DataAccountState clone() => new DataAccountState()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataAccountState create() => new DataAccountState();
  static PbList<DataAccountState> createRepeated() => new PbList<DataAccountState>();
  static DataAccountState getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDataAccountState();
    return _defaultInstance;
  }
  static DataAccountState _defaultInstance;
  static void $checkItem(DataAccountState v) {
    if (v is! DataAccountState) checkItemFailed(v, 'DataAccountState');
  }

  int get deviceId => $_get(0, 0);
  set deviceId(int v) { $_setSignedInt32(0, v); }
  bool hasDeviceId() => $_has(0);
  void clearDeviceId() => clearField(1);

  int get accountId => $_get(1, 0);
  set accountId(int v) { $_setSignedInt32(1, v); }
  bool hasAccountId() => $_has(1);
  void clearAccountId() => clearField(2);

  AccountType get accountType => $_getN(2);
  set accountType(AccountType v) { setField(3, v); }
  bool hasAccountType() => $_has(2);
  void clearAccountType() => clearField(3);

  GlobalAccountState get globalAccountState => $_getN(3);
  set globalAccountState(GlobalAccountState v) { setField(4, v); }
  bool hasGlobalAccountState() => $_has(3);
  void clearGlobalAccountState() => clearField(4);

  GlobalAccountStateReason get globalAccountStateReason => $_getN(4);
  set globalAccountStateReason(GlobalAccountStateReason v) { setField(5, v); }
  bool hasGlobalAccountStateReason() => $_has(4);
  void clearGlobalAccountStateReason() => clearField(5);
}

class _ReadonlyDataAccountState extends DataAccountState with ReadonlyMessageMixin {}

class NetDeviceAuthCreateReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetDeviceAuthCreateReq')
    ..a<List<int>>(1, 'aesKey', PbFieldType.OY)
    ..aOS(2, 'name')
    ..aOS(3, 'info')
    ..hasRequiredFields = false
  ;

  NetDeviceAuthCreateReq() : super();
  NetDeviceAuthCreateReq.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NetDeviceAuthCreateReq.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NetDeviceAuthCreateReq clone() => new NetDeviceAuthCreateReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetDeviceAuthCreateReq create() => new NetDeviceAuthCreateReq();
  static PbList<NetDeviceAuthCreateReq> createRepeated() => new PbList<NetDeviceAuthCreateReq>();
  static NetDeviceAuthCreateReq getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyNetDeviceAuthCreateReq();
    return _defaultInstance;
  }
  static NetDeviceAuthCreateReq _defaultInstance;
  static void $checkItem(NetDeviceAuthCreateReq v) {
    if (v is! NetDeviceAuthCreateReq) checkItemFailed(v, 'NetDeviceAuthCreateReq');
  }

  List<int> get aesKey => $_getN(0);
  set aesKey(List<int> v) { $_setBytes(0, v); }
  bool hasAesKey() => $_has(0);
  void clearAesKey() => clearField(1);

  String get name => $_getS(1, '');
  set name(String v) { $_setString(1, v); }
  bool hasName() => $_has(1);
  void clearName() => clearField(2);

  String get info => $_getS(2, '');
  set info(String v) { $_setString(2, v); }
  bool hasInfo() => $_has(2);
  void clearInfo() => clearField(3);
}

class _ReadonlyNetDeviceAuthCreateReq extends NetDeviceAuthCreateReq with ReadonlyMessageMixin {}

class NetDeviceAuthChallengeReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetDeviceAuthChallengeReq')
    ..a<int>(1, 'deviceId', PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  NetDeviceAuthChallengeReq() : super();
  NetDeviceAuthChallengeReq.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NetDeviceAuthChallengeReq.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NetDeviceAuthChallengeReq clone() => new NetDeviceAuthChallengeReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetDeviceAuthChallengeReq create() => new NetDeviceAuthChallengeReq();
  static PbList<NetDeviceAuthChallengeReq> createRepeated() => new PbList<NetDeviceAuthChallengeReq>();
  static NetDeviceAuthChallengeReq getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyNetDeviceAuthChallengeReq();
    return _defaultInstance;
  }
  static NetDeviceAuthChallengeReq _defaultInstance;
  static void $checkItem(NetDeviceAuthChallengeReq v) {
    if (v is! NetDeviceAuthChallengeReq) checkItemFailed(v, 'NetDeviceAuthChallengeReq');
  }

  int get deviceId => $_get(0, 0);
  set deviceId(int v) { $_setSignedInt32(0, v); }
  bool hasDeviceId() => $_has(0);
  void clearDeviceId() => clearField(1);
}

class _ReadonlyNetDeviceAuthChallengeReq extends NetDeviceAuthChallengeReq with ReadonlyMessageMixin {}

class NetDeviceAuthChallengeResReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetDeviceAuthChallengeResReq')
    ..a<List<int>>(1, 'challenge', PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  NetDeviceAuthChallengeResReq() : super();
  NetDeviceAuthChallengeResReq.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NetDeviceAuthChallengeResReq.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NetDeviceAuthChallengeResReq clone() => new NetDeviceAuthChallengeResReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetDeviceAuthChallengeResReq create() => new NetDeviceAuthChallengeResReq();
  static PbList<NetDeviceAuthChallengeResReq> createRepeated() => new PbList<NetDeviceAuthChallengeResReq>();
  static NetDeviceAuthChallengeResReq getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyNetDeviceAuthChallengeResReq();
    return _defaultInstance;
  }
  static NetDeviceAuthChallengeResReq _defaultInstance;
  static void $checkItem(NetDeviceAuthChallengeResReq v) {
    if (v is! NetDeviceAuthChallengeResReq) checkItemFailed(v, 'NetDeviceAuthChallengeResReq');
  }

  List<int> get challenge => $_getN(0);
  set challenge(List<int> v) { $_setBytes(0, v); }
  bool hasChallenge() => $_has(0);
  void clearChallenge() => clearField(1);
}

class _ReadonlyNetDeviceAuthChallengeResReq extends NetDeviceAuthChallengeResReq with ReadonlyMessageMixin {}

class NetDeviceAuthSignatureResReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetDeviceAuthSignatureResReq')
    ..a<List<int>>(1, 'signature', PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  NetDeviceAuthSignatureResReq() : super();
  NetDeviceAuthSignatureResReq.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NetDeviceAuthSignatureResReq.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NetDeviceAuthSignatureResReq clone() => new NetDeviceAuthSignatureResReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetDeviceAuthSignatureResReq create() => new NetDeviceAuthSignatureResReq();
  static PbList<NetDeviceAuthSignatureResReq> createRepeated() => new PbList<NetDeviceAuthSignatureResReq>();
  static NetDeviceAuthSignatureResReq getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyNetDeviceAuthSignatureResReq();
    return _defaultInstance;
  }
  static NetDeviceAuthSignatureResReq _defaultInstance;
  static void $checkItem(NetDeviceAuthSignatureResReq v) {
    if (v is! NetDeviceAuthSignatureResReq) checkItemFailed(v, 'NetDeviceAuthSignatureResReq');
  }

  List<int> get signature => $_getN(0);
  set signature(List<int> v) { $_setBytes(0, v); }
  bool hasSignature() => $_has(0);
  void clearSignature() => clearField(1);
}

class _ReadonlyNetDeviceAuthSignatureResReq extends NetDeviceAuthSignatureResReq with ReadonlyMessageMixin {}

class NetDeviceAuthState extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetDeviceAuthState')
    ..pp<DataSocialMedia>(6, 'socialMedia', PbFieldType.PM, DataSocialMedia.$checkItem, DataSocialMedia.create)
    ..a<DataAccountState>(7, 'accountState', PbFieldType.OM, DataAccountState.getDefault, DataAccountState.create)
    ..hasRequiredFields = false
  ;

  NetDeviceAuthState() : super();
  NetDeviceAuthState.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NetDeviceAuthState.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NetDeviceAuthState clone() => new NetDeviceAuthState()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetDeviceAuthState create() => new NetDeviceAuthState();
  static PbList<NetDeviceAuthState> createRepeated() => new PbList<NetDeviceAuthState>();
  static NetDeviceAuthState getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyNetDeviceAuthState();
    return _defaultInstance;
  }
  static NetDeviceAuthState _defaultInstance;
  static void $checkItem(NetDeviceAuthState v) {
    if (v is! NetDeviceAuthState) checkItemFailed(v, 'NetDeviceAuthState');
  }

  List<DataSocialMedia> get socialMedia => $_getList(0);

  DataAccountState get accountState => $_getN(1);
  set accountState(DataAccountState v) { setField(7, v); }
  bool hasAccountState() => $_has(1);
  void clearAccountState() => clearField(7);
}

class _ReadonlyNetDeviceAuthState extends NetDeviceAuthState with ReadonlyMessageMixin {}

class NetSetAccountType extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetSetAccountType')
    ..e<AccountType>(1, 'accountType', PbFieldType.OE, AccountType.AT_UNKNOWN, AccountType.valueOf, AccountType.values)
    ..hasRequiredFields = false
  ;

  NetSetAccountType() : super();
  NetSetAccountType.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NetSetAccountType.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NetSetAccountType clone() => new NetSetAccountType()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetSetAccountType create() => new NetSetAccountType();
  static PbList<NetSetAccountType> createRepeated() => new PbList<NetSetAccountType>();
  static NetSetAccountType getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyNetSetAccountType();
    return _defaultInstance;
  }
  static NetSetAccountType _defaultInstance;
  static void $checkItem(NetSetAccountType v) {
    if (v is! NetSetAccountType) checkItemFailed(v, 'NetSetAccountType');
  }

  AccountType get accountType => $_getN(0);
  set accountType(AccountType v) { setField(1, v); }
  bool hasAccountType() => $_has(0);
  void clearAccountType() => clearField(1);
}

class _ReadonlyNetSetAccountType extends NetSetAccountType with ReadonlyMessageMixin {}

class NetOAuthUrlReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetOAuthUrlReq')
    ..a<int>(1, 'oauthProvider', PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  NetOAuthUrlReq() : super();
  NetOAuthUrlReq.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NetOAuthUrlReq.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NetOAuthUrlReq clone() => new NetOAuthUrlReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetOAuthUrlReq create() => new NetOAuthUrlReq();
  static PbList<NetOAuthUrlReq> createRepeated() => new PbList<NetOAuthUrlReq>();
  static NetOAuthUrlReq getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyNetOAuthUrlReq();
    return _defaultInstance;
  }
  static NetOAuthUrlReq _defaultInstance;
  static void $checkItem(NetOAuthUrlReq v) {
    if (v is! NetOAuthUrlReq) checkItemFailed(v, 'NetOAuthUrlReq');
  }

  int get oauthProvider => $_get(0, 0);
  set oauthProvider(int v) { $_setSignedInt32(0, v); }
  bool hasOauthProvider() => $_has(0);
  void clearOauthProvider() => clearField(1);
}

class _ReadonlyNetOAuthUrlReq extends NetOAuthUrlReq with ReadonlyMessageMixin {}

class NetOAuthUrlRes extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetOAuthUrlRes')
    ..aOS(1, 'authUrl')
    ..aOS(2, 'callbackUrl')
    ..hasRequiredFields = false
  ;

  NetOAuthUrlRes() : super();
  NetOAuthUrlRes.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NetOAuthUrlRes.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NetOAuthUrlRes clone() => new NetOAuthUrlRes()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetOAuthUrlRes create() => new NetOAuthUrlRes();
  static PbList<NetOAuthUrlRes> createRepeated() => new PbList<NetOAuthUrlRes>();
  static NetOAuthUrlRes getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyNetOAuthUrlRes();
    return _defaultInstance;
  }
  static NetOAuthUrlRes _defaultInstance;
  static void $checkItem(NetOAuthUrlRes v) {
    if (v is! NetOAuthUrlRes) checkItemFailed(v, 'NetOAuthUrlRes');
  }

  String get authUrl => $_getS(0, '');
  set authUrl(String v) { $_setString(0, v); }
  bool hasAuthUrl() => $_has(0);
  void clearAuthUrl() => clearField(1);

  String get callbackUrl => $_getS(1, '');
  set callbackUrl(String v) { $_setString(1, v); }
  bool hasCallbackUrl() => $_has(1);
  void clearCallbackUrl() => clearField(2);
}

class _ReadonlyNetOAuthUrlRes extends NetOAuthUrlRes with ReadonlyMessageMixin {}

class NetOAuthConnectReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetOAuthConnectReq')
    ..a<int>(1, 'oauthProvider', PbFieldType.O3)
    ..aOS(2, 'callbackQuery')
    ..hasRequiredFields = false
  ;

  NetOAuthConnectReq() : super();
  NetOAuthConnectReq.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NetOAuthConnectReq.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NetOAuthConnectReq clone() => new NetOAuthConnectReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetOAuthConnectReq create() => new NetOAuthConnectReq();
  static PbList<NetOAuthConnectReq> createRepeated() => new PbList<NetOAuthConnectReq>();
  static NetOAuthConnectReq getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyNetOAuthConnectReq();
    return _defaultInstance;
  }
  static NetOAuthConnectReq _defaultInstance;
  static void $checkItem(NetOAuthConnectReq v) {
    if (v is! NetOAuthConnectReq) checkItemFailed(v, 'NetOAuthConnectReq');
  }

  int get oauthProvider => $_get(0, 0);
  set oauthProvider(int v) { $_setSignedInt32(0, v); }
  bool hasOauthProvider() => $_has(0);
  void clearOauthProvider() => clearField(1);

  String get callbackQuery => $_getS(1, '');
  set callbackQuery(String v) { $_setString(1, v); }
  bool hasCallbackQuery() => $_has(1);
  void clearCallbackQuery() => clearField(2);
}

class _ReadonlyNetOAuthConnectReq extends NetOAuthConnectReq with ReadonlyMessageMixin {}

class NetOAuthConnectRes extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetOAuthConnectRes')
    ..a<DataSocialMedia>(1, 'socialMedia', PbFieldType.OM, DataSocialMedia.getDefault, DataSocialMedia.create)
    ..hasRequiredFields = false
  ;

  NetOAuthConnectRes() : super();
  NetOAuthConnectRes.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NetOAuthConnectRes.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NetOAuthConnectRes clone() => new NetOAuthConnectRes()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetOAuthConnectRes create() => new NetOAuthConnectRes();
  static PbList<NetOAuthConnectRes> createRepeated() => new PbList<NetOAuthConnectRes>();
  static NetOAuthConnectRes getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyNetOAuthConnectRes();
    return _defaultInstance;
  }
  static NetOAuthConnectRes _defaultInstance;
  static void $checkItem(NetOAuthConnectRes v) {
    if (v is! NetOAuthConnectRes) checkItemFailed(v, 'NetOAuthConnectRes');
  }

  DataSocialMedia get socialMedia => $_getN(0);
  set socialMedia(DataSocialMedia v) { setField(1, v); }
  bool hasSocialMedia() => $_has(0);
  void clearSocialMedia() => clearField(1);
}

class _ReadonlyNetOAuthConnectRes extends NetOAuthConnectRes with ReadonlyMessageMixin {}

class NetAccountCreateReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetAccountCreateReq')
    ..aOS(1, 'name')
    ..a<double>(2, 'lat', PbFieldType.OF)
    ..a<double>(3, 'lng', PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  NetAccountCreateReq() : super();
  NetAccountCreateReq.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  NetAccountCreateReq.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  NetAccountCreateReq clone() => new NetAccountCreateReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetAccountCreateReq create() => new NetAccountCreateReq();
  static PbList<NetAccountCreateReq> createRepeated() => new PbList<NetAccountCreateReq>();
  static NetAccountCreateReq getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyNetAccountCreateReq();
    return _defaultInstance;
  }
  static NetAccountCreateReq _defaultInstance;
  static void $checkItem(NetAccountCreateReq v) {
    if (v is! NetAccountCreateReq) checkItemFailed(v, 'NetAccountCreateReq');
  }

  String get name => $_getS(0, '');
  set name(String v) { $_setString(0, v); }
  bool hasName() => $_has(0);
  void clearName() => clearField(1);

  double get lat => $_getN(1);
  set lat(double v) { $_setFloat(1, v); }
  bool hasLat() => $_has(1);
  void clearLat() => clearField(2);

  double get lng => $_getN(2);
  set lng(double v) { $_setFloat(2, v); }
  bool hasLng() => $_has(2);
  void clearLng() => clearField(3);
}

class _ReadonlyNetAccountCreateReq extends NetAccountCreateReq with ReadonlyMessageMixin {}

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
  set fileSize(int v) { $_setSignedInt32(1, v); }
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
    ..a<DataOffer>(1, 'offer', PbFieldType.OM, DataOffer.getDefault, DataOffer.create)
    ..pPS(2, 'imageIds')
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

  DataOffer get offer => $_getN(0);
  set offer(DataOffer v) { setField(1, v); }
  bool hasOffer() => $_has(0);
  void clearOffer() => clearField(1);

  List<String> get imageIds => $_getList(1);
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

