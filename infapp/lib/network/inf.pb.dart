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
    ..hasRequiredFields = false;

  ConfigSubCategories() : super();
  ConfigSubCategories.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConfigSubCategories.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ConfigSubCategories clone() =>
      new ConfigSubCategories()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ConfigSubCategories create() => new ConfigSubCategories();
  static PbList<ConfigSubCategories> createRepeated() =>
      new PbList<ConfigSubCategories>();
  static ConfigSubCategories getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyConfigSubCategories();
    return _defaultInstance;
  }

  static ConfigSubCategories _defaultInstance;
  static void $checkItem(ConfigSubCategories v) {
    if (v is! ConfigSubCategories) checkItemFailed(v, 'ConfigSubCategories');
  }

  List<String> get labels => $_getList(0);
}

class _ReadonlyConfigSubCategories extends ConfigSubCategories
    with ReadonlyMessageMixin {}

class ConfigCategories extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ConfigCategories')
    ..pp<ConfigSubCategories>(1, 'sub', PbFieldType.PM,
        ConfigSubCategories.$checkItem, ConfigSubCategories.create)
    ..hasRequiredFields = false;

  ConfigCategories() : super();
  ConfigCategories.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConfigCategories.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ConfigCategories clone() => new ConfigCategories()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ConfigCategories create() => new ConfigCategories();
  static PbList<ConfigCategories> createRepeated() =>
      new PbList<ConfigCategories>();
  static ConfigCategories getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyConfigCategories();
    return _defaultInstance;
  }

  static ConfigCategories _defaultInstance;
  static void $checkItem(ConfigCategories v) {
    if (v is! ConfigCategories) checkItemFailed(v, 'ConfigCategories');
  }

  List<ConfigSubCategories> get sub => $_getList(0);
}

class _ReadonlyConfigCategories extends ConfigCategories
    with ReadonlyMessageMixin {}

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
    ..e<OAuthMechanism>(15, 'mechanism', PbFieldType.OE,
        OAuthMechanism.OAM_NONE, OAuthMechanism.valueOf, OAuthMechanism.values)
    ..aOS(16, 'accessTokenUrl')
    ..aOS(17, 'clientSecret')
    ..pPS(18, 'whitelistHosts')
    ..hasRequiredFields = false;

  ConfigOAuthProvider() : super();
  ConfigOAuthProvider.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConfigOAuthProvider.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ConfigOAuthProvider clone() =>
      new ConfigOAuthProvider()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ConfigOAuthProvider create() => new ConfigOAuthProvider();
  static PbList<ConfigOAuthProvider> createRepeated() =>
      new PbList<ConfigOAuthProvider>();
  static ConfigOAuthProvider getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyConfigOAuthProvider();
    return _defaultInstance;
  }

  static ConfigOAuthProvider _defaultInstance;
  static void $checkItem(ConfigOAuthProvider v) {
    if (v is! ConfigOAuthProvider) checkItemFailed(v, 'ConfigOAuthProvider');
  }

  bool get visible => $_get(0, false);
  set visible(bool v) {
    $_setBool(0, v);
  }

  bool hasVisible() => $_has(0);
  void clearVisible() => clearField(1);

  bool get enabled => $_get(1, false);
  set enabled(bool v) {
    $_setBool(1, v);
  }

  bool hasEnabled() => $_has(1);
  void clearEnabled() => clearField(2);

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

  OAuthMechanism get mechanism => $_getN(13);
  set mechanism(OAuthMechanism v) {
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
}

class _ReadonlyConfigOAuthProvider extends ConfigOAuthProvider
    with ReadonlyMessageMixin {}

class ConfigOAuthProviders extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ConfigOAuthProviders')
    ..pp<ConfigOAuthProvider>(1, 'all', PbFieldType.PM,
        ConfigOAuthProvider.$checkItem, ConfigOAuthProvider.create)
    ..hasRequiredFields = false;

  ConfigOAuthProviders() : super();
  ConfigOAuthProviders.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConfigOAuthProviders.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ConfigOAuthProviders clone() =>
      new ConfigOAuthProviders()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ConfigOAuthProviders create() => new ConfigOAuthProviders();
  static PbList<ConfigOAuthProviders> createRepeated() =>
      new PbList<ConfigOAuthProviders>();
  static ConfigOAuthProviders getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyConfigOAuthProviders();
    return _defaultInstance;
  }

  static ConfigOAuthProviders _defaultInstance;
  static void $checkItem(ConfigOAuthProviders v) {
    if (v is! ConfigOAuthProviders) checkItemFailed(v, 'ConfigOAuthProviders');
  }

  List<ConfigOAuthProvider> get all => $_getList(0);
}

class _ReadonlyConfigOAuthProviders extends ConfigOAuthProviders
    with ReadonlyMessageMixin {}

class ConfigServices extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ConfigServices')
    ..aOS(1, 'mapboxApi')
    ..aOS(2, 'mapboxUrlTemplate')
    ..aOS(3, 'mapboxToken')
    ..aOS(4, 'spacesRegion')
    ..aOS(5, 'spacesKey')
    ..aOS(6, 'spacesSecret')
    ..aOS(7, 'spacesBucket')
    ..pPS(8, 'apiHosts')
    ..aOS(9, 'configUrl')
    ..aOS(10, 'termsOfServiceUrl')
    ..aOS(11, 'privacyPolicyUrl')
    ..aOS(12, 'ipstackKey')
    ..aOS(13, 'ipstackApi')
    ..aOS(14, 'mariadbHost')
    ..a<int>(15, 'mariadbPort', PbFieldType.O3)
    ..aOS(16, 'mariadbUser')
    ..aOS(17, 'mariadbPassword')
    ..aOS(18, 'mariadbDatabase')
    ..aOS(19, 'cloudinaryUrl')
    ..aOS(20, 'cloudinaryThumbnailUrl')
    ..aOS(21, 'cloudinaryCoverUrl')
    ..aOS(22, 'freshdeskApi')
    ..aOS(23, 'freshdeskKey')
    ..hasRequiredFields = false;

  ConfigServices() : super();
  ConfigServices.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConfigServices.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ConfigServices clone() => new ConfigServices()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ConfigServices create() => new ConfigServices();
  static PbList<ConfigServices> createRepeated() =>
      new PbList<ConfigServices>();
  static ConfigServices getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyConfigServices();
    return _defaultInstance;
  }

  static ConfigServices _defaultInstance;
  static void $checkItem(ConfigServices v) {
    if (v is! ConfigServices) checkItemFailed(v, 'ConfigServices');
  }

  String get mapboxApi => $_getS(0, '');
  set mapboxApi(String v) {
    $_setString(0, v);
  }

  bool hasMapboxApi() => $_has(0);
  void clearMapboxApi() => clearField(1);

  String get mapboxUrlTemplate => $_getS(1, '');
  set mapboxUrlTemplate(String v) {
    $_setString(1, v);
  }

  bool hasMapboxUrlTemplate() => $_has(1);
  void clearMapboxUrlTemplate() => clearField(2);

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

  List<String> get apiHosts => $_getList(7);

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

  String get mariadbHost => $_getS(13, '');
  set mariadbHost(String v) {
    $_setString(13, v);
  }

  bool hasMariadbHost() => $_has(13);
  void clearMariadbHost() => clearField(14);

  int get mariadbPort => $_get(14, 0);
  set mariadbPort(int v) {
    $_setSignedInt32(14, v);
  }

  bool hasMariadbPort() => $_has(14);
  void clearMariadbPort() => clearField(15);

  String get mariadbUser => $_getS(15, '');
  set mariadbUser(String v) {
    $_setString(15, v);
  }

  bool hasMariadbUser() => $_has(15);
  void clearMariadbUser() => clearField(16);

  String get mariadbPassword => $_getS(16, '');
  set mariadbPassword(String v) {
    $_setString(16, v);
  }

  bool hasMariadbPassword() => $_has(16);
  void clearMariadbPassword() => clearField(17);

  String get mariadbDatabase => $_getS(17, '');
  set mariadbDatabase(String v) {
    $_setString(17, v);
  }

  bool hasMariadbDatabase() => $_has(17);
  void clearMariadbDatabase() => clearField(18);

  String get cloudinaryUrl => $_getS(18, '');
  set cloudinaryUrl(String v) {
    $_setString(18, v);
  }

  bool hasCloudinaryUrl() => $_has(18);
  void clearCloudinaryUrl() => clearField(19);

  String get cloudinaryThumbnailUrl => $_getS(19, '');
  set cloudinaryThumbnailUrl(String v) {
    $_setString(19, v);
  }

  bool hasCloudinaryThumbnailUrl() => $_has(19);
  void clearCloudinaryThumbnailUrl() => clearField(20);

  String get cloudinaryCoverUrl => $_getS(20, '');
  set cloudinaryCoverUrl(String v) {
    $_setString(20, v);
  }

  bool hasCloudinaryCoverUrl() => $_has(20);
  void clearCloudinaryCoverUrl() => clearField(21);

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
}

class _ReadonlyConfigServices extends ConfigServices with ReadonlyMessageMixin {
}

class ConfigData extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ConfigData')
    ..a<int>(1, 'clientVersion', PbFieldType.O3)
    ..a<ConfigCategories>(2, 'categories', PbFieldType.OM,
        ConfigCategories.getDefault, ConfigCategories.create)
    ..a<ConfigOAuthProviders>(3, 'oauthProviders', PbFieldType.OM,
        ConfigOAuthProviders.getDefault, ConfigOAuthProviders.create)
    ..aInt64(5, 'timestamp')
    ..a<ConfigServices>(6, 'services', PbFieldType.OM,
        ConfigServices.getDefault, ConfigServices.create)
    ..hasRequiredFields = false;

  ConfigData() : super();
  ConfigData.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConfigData.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
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
  set clientVersion(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasClientVersion() => $_has(0);
  void clearClientVersion() => clearField(1);

  ConfigCategories get categories => $_getN(1);
  set categories(ConfigCategories v) {
    setField(2, v);
  }

  bool hasCategories() => $_has(1);
  void clearCategories() => clearField(2);

  ConfigOAuthProviders get oauthProviders => $_getN(2);
  set oauthProviders(ConfigOAuthProviders v) {
    setField(3, v);
  }

  bool hasOauthProviders() => $_has(2);
  void clearOauthProviders() => clearField(3);

  Int64 get timestamp => $_getI64(3);
  set timestamp(Int64 v) {
    $_setInt64(3, v);
  }

  bool hasTimestamp() => $_has(3);
  void clearTimestamp() => clearField(5);

  ConfigServices get services => $_getN(4);
  set services(ConfigServices v) {
    setField(6, v);
  }

  bool hasServices() => $_has(4);
  void clearServices() => clearField(6);
}

class _ReadonlyConfigData extends ConfigData with ReadonlyMessageMixin {}

class CategoryId extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CategoryId')
    ..a<int>(1, 'main', PbFieldType.O3)
    ..a<int>(2, 'sub', PbFieldType.O3)
    ..hasRequiredFields = false;

  CategoryId() : super();
  CategoryId.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  CategoryId.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
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
  set main(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasMain() => $_has(0);
  void clearMain() => clearField(1);

  int get sub => $_get(1, 0);
  set sub(int v) {
    $_setSignedInt32(1, v);
  }

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
    ..aOS(14, 'avatarUrl')
    ..aOB(15, 'expired')
    ..hasRequiredFields = false;

  DataSocialMedia() : super();
  DataSocialMedia.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataSocialMedia.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataSocialMedia clone() => new DataSocialMedia()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataSocialMedia create() => new DataSocialMedia();
  static PbList<DataSocialMedia> createRepeated() =>
      new PbList<DataSocialMedia>();
  static DataSocialMedia getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyDataSocialMedia();
    return _defaultInstance;
  }

  static DataSocialMedia _defaultInstance;
  static void $checkItem(DataSocialMedia v) {
    if (v is! DataSocialMedia) checkItemFailed(v, 'DataSocialMedia');
  }

  bool get connected => $_get(0, false);
  set connected(bool v) {
    $_setBool(0, v);
  }

  bool hasConnected() => $_has(0);
  void clearConnected() => clearField(1);

  int get followersCount => $_get(1, 0);
  set followersCount(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasFollowersCount() => $_has(1);
  void clearFollowersCount() => clearField(2);

  int get followingCount => $_get(2, 0);
  set followingCount(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasFollowingCount() => $_has(2);
  void clearFollowingCount() => clearField(3);

  String get screenName => $_getS(3, '');
  set screenName(String v) {
    $_setString(3, v);
  }

  bool hasScreenName() => $_has(3);
  void clearScreenName() => clearField(4);

  String get displayName => $_getS(4, '');
  set displayName(String v) {
    $_setString(4, v);
  }

  bool hasDisplayName() => $_has(4);
  void clearDisplayName() => clearField(5);

  String get description => $_getS(5, '');
  set description(String v) {
    $_setString(5, v);
  }

  bool hasDescription() => $_has(5);
  void clearDescription() => clearField(6);

  String get location => $_getS(6, '');
  set location(String v) {
    $_setString(6, v);
  }

  bool hasLocation() => $_has(6);
  void clearLocation() => clearField(7);

  String get url => $_getS(7, '');
  set url(String v) {
    $_setString(7, v);
  }

  bool hasUrl() => $_has(7);
  void clearUrl() => clearField(8);

  int get friendsCount => $_get(8, 0);
  set friendsCount(int v) {
    $_setSignedInt32(8, v);
  }

  bool hasFriendsCount() => $_has(8);
  void clearFriendsCount() => clearField(9);

  int get postsCount => $_get(9, 0);
  set postsCount(int v) {
    $_setSignedInt32(9, v);
  }

  bool hasPostsCount() => $_has(9);
  void clearPostsCount() => clearField(10);

  bool get verified => $_get(10, false);
  set verified(bool v) {
    $_setBool(10, v);
  }

  bool hasVerified() => $_has(10);
  void clearVerified() => clearField(11);

  String get email => $_getS(11, '');
  set email(String v) {
    $_setString(11, v);
  }

  bool hasEmail() => $_has(11);
  void clearEmail() => clearField(12);

  String get profileUrl => $_getS(12, '');
  set profileUrl(String v) {
    $_setString(12, v);
  }

  bool hasProfileUrl() => $_has(12);
  void clearProfileUrl() => clearField(13);

  String get avatarUrl => $_getS(13, '');
  set avatarUrl(String v) {
    $_setString(13, v);
  }

  bool hasAvatarUrl() => $_has(13);
  void clearAvatarUrl() => clearField(14);

  bool get expired => $_get(14, false);
  set expired(bool v) {
    $_setBool(14, v);
  }

  bool hasExpired() => $_has(14);
  void clearExpired() => clearField(15);
}

class _ReadonlyDataSocialMedia extends DataSocialMedia
    with ReadonlyMessageMixin {}

class DataOAuthCredentials extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataOAuthCredentials')
    ..aOS(1, 'token')
    ..aOS(2, 'tokenSecret')
    ..a<int>(3, 'tokenExpires', PbFieldType.O3)
    ..aOS(4, 'userId')
    ..hasRequiredFields = false;

  DataOAuthCredentials() : super();
  DataOAuthCredentials.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataOAuthCredentials.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataOAuthCredentials clone() =>
      new DataOAuthCredentials()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataOAuthCredentials create() => new DataOAuthCredentials();
  static PbList<DataOAuthCredentials> createRepeated() =>
      new PbList<DataOAuthCredentials>();
  static DataOAuthCredentials getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyDataOAuthCredentials();
    return _defaultInstance;
  }

  static DataOAuthCredentials _defaultInstance;
  static void $checkItem(DataOAuthCredentials v) {
    if (v is! DataOAuthCredentials) checkItemFailed(v, 'DataOAuthCredentials');
  }

  String get token => $_getS(0, '');
  set token(String v) {
    $_setString(0, v);
  }

  bool hasToken() => $_has(0);
  void clearToken() => clearField(1);

  String get tokenSecret => $_getS(1, '');
  set tokenSecret(String v) {
    $_setString(1, v);
  }

  bool hasTokenSecret() => $_has(1);
  void clearTokenSecret() => clearField(2);

  int get tokenExpires => $_get(2, 0);
  set tokenExpires(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasTokenExpires() => $_has(2);
  void clearTokenExpires() => clearField(3);

  String get userId => $_getS(3, '');
  set userId(String v) {
    $_setString(3, v);
  }

  bool hasUserId() => $_has(3);
  void clearUserId() => clearField(4);
}

class _ReadonlyDataOAuthCredentials extends DataOAuthCredentials
    with ReadonlyMessageMixin {}

class DataBusinessOffer extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataBusinessOffer')
    ..a<int>(1, 'offerId', PbFieldType.O3)
    ..a<int>(2, 'accountId', PbFieldType.O3)
    ..a<int>(3, 'locationId', PbFieldType.O3)
    ..aOS(4, 'title')
    ..aOS(5, 'description')
    ..aOS(6, 'thumbnailUrl')
    ..aOS(7, 'deliverables')
    ..aOS(8, 'reward')
    ..aOS(9, 'location')
    ..pPS(10, 'coverUrls')
    ..pp<CategoryId>(11, 'categories', PbFieldType.PM, CategoryId.$checkItem,
        CategoryId.create)
    ..e<BusinessOfferState>(
        12,
        'state',
        PbFieldType.OE,
        BusinessOfferState.BOS_DRAFT,
        BusinessOfferState.valueOf,
        BusinessOfferState.values)
    ..e<BusinessOfferStateReason>(
        13,
        'stateReason',
        PbFieldType.OE,
        BusinessOfferStateReason.BOSR_NEW_OFFER,
        BusinessOfferStateReason.valueOf,
        BusinessOfferStateReason.values)
    ..a<int>(14, 'applicantsNew', PbFieldType.O3)
    ..a<int>(15, 'applicantsAccepted', PbFieldType.O3)
    ..a<int>(16, 'applicantsCompleted', PbFieldType.O3)
    ..a<int>(17, 'applicantsRefused', PbFieldType.O3)
    ..a<double>(18, 'latitude', PbFieldType.OD)
    ..a<double>(19, 'longitude', PbFieldType.OD)
    ..hasRequiredFields = false;

  DataBusinessOffer() : super();
  DataBusinessOffer.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataBusinessOffer.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataBusinessOffer clone() => new DataBusinessOffer()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataBusinessOffer create() => new DataBusinessOffer();
  static PbList<DataBusinessOffer> createRepeated() =>
      new PbList<DataBusinessOffer>();
  static DataBusinessOffer getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyDataBusinessOffer();
    return _defaultInstance;
  }

  static DataBusinessOffer _defaultInstance;
  static void $checkItem(DataBusinessOffer v) {
    if (v is! DataBusinessOffer) checkItemFailed(v, 'DataBusinessOffer');
  }

  int get offerId => $_get(0, 0);
  set offerId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasOfferId() => $_has(0);
  void clearOfferId() => clearField(1);

  int get accountId => $_get(1, 0);
  set accountId(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasAccountId() => $_has(1);
  void clearAccountId() => clearField(2);

  int get locationId => $_get(2, 0);
  set locationId(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasLocationId() => $_has(2);
  void clearLocationId() => clearField(3);

  String get title => $_getS(3, '');
  set title(String v) {
    $_setString(3, v);
  }

  bool hasTitle() => $_has(3);
  void clearTitle() => clearField(4);

  String get description => $_getS(4, '');
  set description(String v) {
    $_setString(4, v);
  }

  bool hasDescription() => $_has(4);
  void clearDescription() => clearField(5);

  String get thumbnailUrl => $_getS(5, '');
  set thumbnailUrl(String v) {
    $_setString(5, v);
  }

  bool hasThumbnailUrl() => $_has(5);
  void clearThumbnailUrl() => clearField(6);

  String get deliverables => $_getS(6, '');
  set deliverables(String v) {
    $_setString(6, v);
  }

  bool hasDeliverables() => $_has(6);
  void clearDeliverables() => clearField(7);

  String get reward => $_getS(7, '');
  set reward(String v) {
    $_setString(7, v);
  }

  bool hasReward() => $_has(7);
  void clearReward() => clearField(8);

  String get location => $_getS(8, '');
  set location(String v) {
    $_setString(8, v);
  }

  bool hasLocation() => $_has(8);
  void clearLocation() => clearField(9);

  List<String> get coverUrls => $_getList(9);

  List<CategoryId> get categories => $_getList(10);

  BusinessOfferState get state => $_getN(11);
  set state(BusinessOfferState v) {
    setField(12, v);
  }

  bool hasState() => $_has(11);
  void clearState() => clearField(12);

  BusinessOfferStateReason get stateReason => $_getN(12);
  set stateReason(BusinessOfferStateReason v) {
    setField(13, v);
  }

  bool hasStateReason() => $_has(12);
  void clearStateReason() => clearField(13);

  int get applicantsNew => $_get(13, 0);
  set applicantsNew(int v) {
    $_setSignedInt32(13, v);
  }

  bool hasApplicantsNew() => $_has(13);
  void clearApplicantsNew() => clearField(14);

  int get applicantsAccepted => $_get(14, 0);
  set applicantsAccepted(int v) {
    $_setSignedInt32(14, v);
  }

  bool hasApplicantsAccepted() => $_has(14);
  void clearApplicantsAccepted() => clearField(15);

  int get applicantsCompleted => $_get(15, 0);
  set applicantsCompleted(int v) {
    $_setSignedInt32(15, v);
  }

  bool hasApplicantsCompleted() => $_has(15);
  void clearApplicantsCompleted() => clearField(16);

  int get applicantsRefused => $_get(16, 0);
  set applicantsRefused(int v) {
    $_setSignedInt32(16, v);
  }

  bool hasApplicantsRefused() => $_has(16);
  void clearApplicantsRefused() => clearField(17);

  double get latitude => $_getN(17);
  set latitude(double v) {
    $_setDouble(17, v);
  }

  bool hasLatitude() => $_has(17);
  void clearLatitude() => clearField(18);

  double get longitude => $_getN(18);
  set longitude(double v) {
    $_setDouble(18, v);
  }

  bool hasLongitude() => $_has(18);
  void clearLongitude() => clearField(19);
}

class _ReadonlyDataBusinessOffer extends DataBusinessOffer
    with ReadonlyMessageMixin {}

class DataLocation extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataLocation')
    ..a<int>(1, 'locationId', PbFieldType.O3)
    ..aOS(2, 'name')
    ..a<double>(4, 'latitude', PbFieldType.OD)
    ..a<double>(5, 'longitude', PbFieldType.OD)
    ..aOS(6, 'avatarUrl')
    ..aOS(7, 'approximate')
    ..aOS(8, 'detail')
    ..aOS(9, 'postcode')
    ..aOS(10, 'regionCode')
    ..aOS(11, 'countryCode')
    ..hasRequiredFields = false;

  DataLocation() : super();
  DataLocation.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataLocation.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataLocation clone() => new DataLocation()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataLocation create() => new DataLocation();
  static PbList<DataLocation> createRepeated() => new PbList<DataLocation>();
  static DataLocation getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyDataLocation();
    return _defaultInstance;
  }

  static DataLocation _defaultInstance;
  static void $checkItem(DataLocation v) {
    if (v is! DataLocation) checkItemFailed(v, 'DataLocation');
  }

  int get locationId => $_get(0, 0);
  set locationId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasLocationId() => $_has(0);
  void clearLocationId() => clearField(1);

  String get name => $_getS(1, '');
  set name(String v) {
    $_setString(1, v);
  }

  bool hasName() => $_has(1);
  void clearName() => clearField(2);

  double get latitude => $_getN(2);
  set latitude(double v) {
    $_setDouble(2, v);
  }

  bool hasLatitude() => $_has(2);
  void clearLatitude() => clearField(4);

  double get longitude => $_getN(3);
  set longitude(double v) {
    $_setDouble(3, v);
  }

  bool hasLongitude() => $_has(3);
  void clearLongitude() => clearField(5);

  String get avatarUrl => $_getS(4, '');
  set avatarUrl(String v) {
    $_setString(4, v);
  }

  bool hasAvatarUrl() => $_has(4);
  void clearAvatarUrl() => clearField(6);

  String get approximate => $_getS(5, '');
  set approximate(String v) {
    $_setString(5, v);
  }

  bool hasApproximate() => $_has(5);
  void clearApproximate() => clearField(7);

  String get detail => $_getS(6, '');
  set detail(String v) {
    $_setString(6, v);
  }

  bool hasDetail() => $_has(6);
  void clearDetail() => clearField(8);

  String get postcode => $_getS(7, '');
  set postcode(String v) {
    $_setString(7, v);
  }

  bool hasPostcode() => $_has(7);
  void clearPostcode() => clearField(9);

  String get regionCode => $_getS(8, '');
  set regionCode(String v) {
    $_setString(8, v);
  }

  bool hasRegionCode() => $_has(8);
  void clearRegionCode() => clearField(10);

  String get countryCode => $_getS(9, '');
  set countryCode(String v) {
    $_setString(9, v);
  }

  bool hasCountryCode() => $_has(9);
  void clearCountryCode() => clearField(11);
}

class _ReadonlyDataLocation extends DataLocation with ReadonlyMessageMixin {}

class DataAccountState extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataAccountState')
    ..a<int>(1, 'deviceId', PbFieldType.O3)
    ..a<int>(2, 'accountId', PbFieldType.O3)
    ..e<AccountType>(3, 'accountType', PbFieldType.OE, AccountType.AT_UNKNOWN,
        AccountType.valueOf, AccountType.values)
    ..e<GlobalAccountState>(
        4,
        'globalAccountState',
        PbFieldType.OE,
        GlobalAccountState.GAS_INITIALIZE,
        GlobalAccountState.valueOf,
        GlobalAccountState.values)
    ..e<GlobalAccountStateReason>(
        5,
        'globalAccountStateReason',
        PbFieldType.OE,
        GlobalAccountStateReason.GASR_NEW_ACCOUNT,
        GlobalAccountStateReason.valueOf,
        GlobalAccountStateReason.values)
    ..e<NotificationFlags>(
        6,
        'notificationFlags',
        PbFieldType.OE,
        NotificationFlags.NF_ACCOUNT_STATE,
        NotificationFlags.valueOf,
        NotificationFlags.values)
    ..hasRequiredFields = false;

  DataAccountState() : super();
  DataAccountState.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataAccountState.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataAccountState clone() => new DataAccountState()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataAccountState create() => new DataAccountState();
  static PbList<DataAccountState> createRepeated() =>
      new PbList<DataAccountState>();
  static DataAccountState getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyDataAccountState();
    return _defaultInstance;
  }

  static DataAccountState _defaultInstance;
  static void $checkItem(DataAccountState v) {
    if (v is! DataAccountState) checkItemFailed(v, 'DataAccountState');
  }

  int get deviceId => $_get(0, 0);
  set deviceId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasDeviceId() => $_has(0);
  void clearDeviceId() => clearField(1);

  int get accountId => $_get(1, 0);
  set accountId(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasAccountId() => $_has(1);
  void clearAccountId() => clearField(2);

  AccountType get accountType => $_getN(2);
  set accountType(AccountType v) {
    setField(3, v);
  }

  bool hasAccountType() => $_has(2);
  void clearAccountType() => clearField(3);

  GlobalAccountState get globalAccountState => $_getN(3);
  set globalAccountState(GlobalAccountState v) {
    setField(4, v);
  }

  bool hasGlobalAccountState() => $_has(3);
  void clearGlobalAccountState() => clearField(4);

  GlobalAccountStateReason get globalAccountStateReason => $_getN(4);
  set globalAccountStateReason(GlobalAccountStateReason v) {
    setField(5, v);
  }

  bool hasGlobalAccountStateReason() => $_has(4);
  void clearGlobalAccountStateReason() => clearField(5);

  NotificationFlags get notificationFlags => $_getN(5);
  set notificationFlags(NotificationFlags v) {
    setField(6, v);
  }

  bool hasNotificationFlags() => $_has(5);
  void clearNotificationFlags() => clearField(6);
}

class _ReadonlyDataAccountState extends DataAccountState
    with ReadonlyMessageMixin {}

class DataAccountSummary extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataAccountSummary')
    ..aOS(1, 'name')
    ..aOS(2, 'description')
    ..aOS(3, 'location')
    ..aOS(4, 'avatarThumbnailUrl')
    ..hasRequiredFields = false;

  DataAccountSummary() : super();
  DataAccountSummary.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataAccountSummary.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataAccountSummary clone() =>
      new DataAccountSummary()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataAccountSummary create() => new DataAccountSummary();
  static PbList<DataAccountSummary> createRepeated() =>
      new PbList<DataAccountSummary>();
  static DataAccountSummary getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyDataAccountSummary();
    return _defaultInstance;
  }

  static DataAccountSummary _defaultInstance;
  static void $checkItem(DataAccountSummary v) {
    if (v is! DataAccountSummary) checkItemFailed(v, 'DataAccountSummary');
  }

  String get name => $_getS(0, '');
  set name(String v) {
    $_setString(0, v);
  }

  bool hasName() => $_has(0);
  void clearName() => clearField(1);

  String get description => $_getS(1, '');
  set description(String v) {
    $_setString(1, v);
  }

  bool hasDescription() => $_has(1);
  void clearDescription() => clearField(2);

  String get location => $_getS(2, '');
  set location(String v) {
    $_setString(2, v);
  }

  bool hasLocation() => $_has(2);
  void clearLocation() => clearField(3);

  String get avatarThumbnailUrl => $_getS(3, '');
  set avatarThumbnailUrl(String v) {
    $_setString(3, v);
  }

  bool hasAvatarThumbnailUrl() => $_has(3);
  void clearAvatarThumbnailUrl() => clearField(4);
}

class _ReadonlyDataAccountSummary extends DataAccountSummary
    with ReadonlyMessageMixin {}

class DataAccountDetail extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataAccountDetail')
    ..pp<CategoryId>(2, 'categories', PbFieldType.PM, CategoryId.$checkItem,
        CategoryId.create)
    ..pp<DataSocialMedia>(3, 'socialMedia', PbFieldType.PM,
        DataSocialMedia.$checkItem, DataSocialMedia.create)
    ..a<double>(4, 'latitude', PbFieldType.OD)
    ..a<double>(5, 'longitude', PbFieldType.OD)
    ..aOS(6, 'url')
    ..aOS(7, 'avatarCoverUrl')
    ..a<int>(8, 'locationId', PbFieldType.O3)
    ..hasRequiredFields = false;

  DataAccountDetail() : super();
  DataAccountDetail.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataAccountDetail.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataAccountDetail clone() => new DataAccountDetail()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataAccountDetail create() => new DataAccountDetail();
  static PbList<DataAccountDetail> createRepeated() =>
      new PbList<DataAccountDetail>();
  static DataAccountDetail getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyDataAccountDetail();
    return _defaultInstance;
  }

  static DataAccountDetail _defaultInstance;
  static void $checkItem(DataAccountDetail v) {
    if (v is! DataAccountDetail) checkItemFailed(v, 'DataAccountDetail');
  }

  List<CategoryId> get categories => $_getList(0);

  List<DataSocialMedia> get socialMedia => $_getList(1);

  double get latitude => $_getN(2);
  set latitude(double v) {
    $_setDouble(2, v);
  }

  bool hasLatitude() => $_has(2);
  void clearLatitude() => clearField(4);

  double get longitude => $_getN(3);
  set longitude(double v) {
    $_setDouble(3, v);
  }

  bool hasLongitude() => $_has(3);
  void clearLongitude() => clearField(5);

  String get url => $_getS(4, '');
  set url(String v) {
    $_setString(4, v);
  }

  bool hasUrl() => $_has(4);
  void clearUrl() => clearField(6);

  String get avatarCoverUrl => $_getS(5, '');
  set avatarCoverUrl(String v) {
    $_setString(5, v);
  }

  bool hasAvatarCoverUrl() => $_has(5);
  void clearAvatarCoverUrl() => clearField(7);

  int get locationId => $_get(6, 0);
  set locationId(int v) {
    $_setSignedInt32(6, v);
  }

  bool hasLocationId() => $_has(6);
  void clearLocationId() => clearField(8);
}

class _ReadonlyDataAccountDetail extends DataAccountDetail
    with ReadonlyMessageMixin {}

class DataAccount extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataAccount')
    ..a<DataAccountState>(1, 'state', PbFieldType.OM,
        DataAccountState.getDefault, DataAccountState.create)
    ..a<DataAccountSummary>(2, 'summary', PbFieldType.OM,
        DataAccountSummary.getDefault, DataAccountSummary.create)
    ..a<DataAccountDetail>(3, 'detail', PbFieldType.OM,
        DataAccountDetail.getDefault, DataAccountDetail.create)
    ..hasRequiredFields = false;

  DataAccount() : super();
  DataAccount.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataAccount.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataAccount clone() => new DataAccount()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataAccount create() => new DataAccount();
  static PbList<DataAccount> createRepeated() => new PbList<DataAccount>();
  static DataAccount getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDataAccount();
    return _defaultInstance;
  }

  static DataAccount _defaultInstance;
  static void $checkItem(DataAccount v) {
    if (v is! DataAccount) checkItemFailed(v, 'DataAccount');
  }

  DataAccountState get state => $_getN(0);
  set state(DataAccountState v) {
    setField(1, v);
  }

  bool hasState() => $_has(0);
  void clearState() => clearField(1);

  DataAccountSummary get summary => $_getN(1);
  set summary(DataAccountSummary v) {
    setField(2, v);
  }

  bool hasSummary() => $_has(1);
  void clearSummary() => clearField(2);

  DataAccountDetail get detail => $_getN(2);
  set detail(DataAccountDetail v) {
    setField(3, v);
  }

  bool hasDetail() => $_has(2);
  void clearDetail() => clearField(3);
}

class _ReadonlyDataAccount extends DataAccount with ReadonlyMessageMixin {}

class DataApplicant extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataApplicant')
    ..a<int>(1, 'applicantId', PbFieldType.O3)
    ..a<int>(2, 'offerId', PbFieldType.O3)
    ..a<int>(3, 'accountId', PbFieldType.O3)
    ..aInt64(4, 'haggleChatId')
    ..aOB(5, 'businessWantsDeal')
    ..aOB(6, 'influencerWantsDeal')
    ..aOB(7, 'influencerSaysDelivered')
    ..aOB(8, 'influencerSaysRewarded')
    ..aOB(9, 'businessSaysDelivered')
    ..aOB(10, 'businessSaysRewarded')
    ..a<int>(11, 'businessGaveRating', PbFieldType.O3)
    ..a<int>(12, 'influencerGaveRating', PbFieldType.O3)
    ..e<ApplicantState>(13, 'state', PbFieldType.OE, ApplicantState.AS_HAGGLING,
        ApplicantState.valueOf, ApplicantState.values)
    ..aOB(14, 'businessDisputed')
    ..aOB(15, 'influencerDisputed')
    ..hasRequiredFields = false;

  DataApplicant() : super();
  DataApplicant.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataApplicant.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataApplicant clone() => new DataApplicant()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataApplicant create() => new DataApplicant();
  static PbList<DataApplicant> createRepeated() => new PbList<DataApplicant>();
  static DataApplicant getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyDataApplicant();
    return _defaultInstance;
  }

  static DataApplicant _defaultInstance;
  static void $checkItem(DataApplicant v) {
    if (v is! DataApplicant) checkItemFailed(v, 'DataApplicant');
  }

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);

  int get offerId => $_get(1, 0);
  set offerId(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasOfferId() => $_has(1);
  void clearOfferId() => clearField(2);

  int get accountId => $_get(2, 0);
  set accountId(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasAccountId() => $_has(2);
  void clearAccountId() => clearField(3);

  Int64 get haggleChatId => $_getI64(3);
  set haggleChatId(Int64 v) {
    $_setInt64(3, v);
  }

  bool hasHaggleChatId() => $_has(3);
  void clearHaggleChatId() => clearField(4);

  bool get businessWantsDeal => $_get(4, false);
  set businessWantsDeal(bool v) {
    $_setBool(4, v);
  }

  bool hasBusinessWantsDeal() => $_has(4);
  void clearBusinessWantsDeal() => clearField(5);

  bool get influencerWantsDeal => $_get(5, false);
  set influencerWantsDeal(bool v) {
    $_setBool(5, v);
  }

  bool hasInfluencerWantsDeal() => $_has(5);
  void clearInfluencerWantsDeal() => clearField(6);

  bool get influencerSaysDelivered => $_get(6, false);
  set influencerSaysDelivered(bool v) {
    $_setBool(6, v);
  }

  bool hasInfluencerSaysDelivered() => $_has(6);
  void clearInfluencerSaysDelivered() => clearField(7);

  bool get influencerSaysRewarded => $_get(7, false);
  set influencerSaysRewarded(bool v) {
    $_setBool(7, v);
  }

  bool hasInfluencerSaysRewarded() => $_has(7);
  void clearInfluencerSaysRewarded() => clearField(8);

  bool get businessSaysDelivered => $_get(8, false);
  set businessSaysDelivered(bool v) {
    $_setBool(8, v);
  }

  bool hasBusinessSaysDelivered() => $_has(8);
  void clearBusinessSaysDelivered() => clearField(9);

  bool get businessSaysRewarded => $_get(9, false);
  set businessSaysRewarded(bool v) {
    $_setBool(9, v);
  }

  bool hasBusinessSaysRewarded() => $_has(9);
  void clearBusinessSaysRewarded() => clearField(10);

  int get businessGaveRating => $_get(10, 0);
  set businessGaveRating(int v) {
    $_setSignedInt32(10, v);
  }

  bool hasBusinessGaveRating() => $_has(10);
  void clearBusinessGaveRating() => clearField(11);

  int get influencerGaveRating => $_get(11, 0);
  set influencerGaveRating(int v) {
    $_setSignedInt32(11, v);
  }

  bool hasInfluencerGaveRating() => $_has(11);
  void clearInfluencerGaveRating() => clearField(12);

  ApplicantState get state => $_getN(12);
  set state(ApplicantState v) {
    setField(13, v);
  }

  bool hasState() => $_has(12);
  void clearState() => clearField(13);

  bool get businessDisputed => $_get(13, false);
  set businessDisputed(bool v) {
    $_setBool(13, v);
  }

  bool hasBusinessDisputed() => $_has(13);
  void clearBusinessDisputed() => clearField(14);

  bool get influencerDisputed => $_get(14, false);
  set influencerDisputed(bool v) {
    $_setBool(14, v);
  }

  bool hasInfluencerDisputed() => $_has(14);
  void clearInfluencerDisputed() => clearField(15);
}

class _ReadonlyDataApplicant extends DataApplicant with ReadonlyMessageMixin {}

class DataApplicantChat extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DataApplicantChat')
    ..a<int>(1, 'applicantId', PbFieldType.O3)
    ..a<int>(2, 'senderId', PbFieldType.O3)
    ..aOS(5, 'text')
    ..a<int>(6, 'clientGhostId', PbFieldType.O3)
    ..aInt64(7, 'chatId')
    ..e<ApplicantChatType>(
        8,
        'type',
        PbFieldType.OE,
        ApplicantChatType.ACT_PLAIN,
        ApplicantChatType.valueOf,
        ApplicantChatType.values)
    ..aInt64(9, 'seen')
    ..aInt64(10, 'sent')
    ..hasRequiredFields = false;

  DataApplicantChat() : super();
  DataApplicantChat.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataApplicantChat.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataApplicantChat clone() => new DataApplicantChat()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DataApplicantChat create() => new DataApplicantChat();
  static PbList<DataApplicantChat> createRepeated() =>
      new PbList<DataApplicantChat>();
  static DataApplicantChat getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyDataApplicantChat();
    return _defaultInstance;
  }

  static DataApplicantChat _defaultInstance;
  static void $checkItem(DataApplicantChat v) {
    if (v is! DataApplicantChat) checkItemFailed(v, 'DataApplicantChat');
  }

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);

  int get senderId => $_get(1, 0);
  set senderId(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasSenderId() => $_has(1);
  void clearSenderId() => clearField(2);

  String get text => $_getS(2, '');
  set text(String v) {
    $_setString(2, v);
  }

  bool hasText() => $_has(2);
  void clearText() => clearField(5);

  int get clientGhostId => $_get(3, 0);
  set clientGhostId(int v) {
    $_setSignedInt32(3, v);
  }

  bool hasClientGhostId() => $_has(3);
  void clearClientGhostId() => clearField(6);

  Int64 get chatId => $_getI64(4);
  set chatId(Int64 v) {
    $_setInt64(4, v);
  }

  bool hasChatId() => $_has(4);
  void clearChatId() => clearField(7);

  ApplicantChatType get type => $_getN(5);
  set type(ApplicantChatType v) {
    setField(8, v);
  }

  bool hasType() => $_has(5);
  void clearType() => clearField(8);

  Int64 get seen => $_getI64(6);
  set seen(Int64 v) {
    $_setInt64(6, v);
  }

  bool hasSeen() => $_has(6);
  void clearSeen() => clearField(9);

  Int64 get sent => $_getI64(7);
  set sent(Int64 v) {
    $_setInt64(7, v);
  }

  bool hasSent() => $_has(7);
  void clearSent() => clearField(10);
}

class _ReadonlyDataApplicantChat extends DataApplicantChat
    with ReadonlyMessageMixin {}

class NetDeviceAuthCreateReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetDeviceAuthCreateReq')
    ..a<List<int>>(1, 'aesKey', PbFieldType.OY)
    ..aOS(2, 'name')
    ..aOS(3, 'info')
    ..a<List<int>>(4, 'commonDeviceId', PbFieldType.OY)
    ..hasRequiredFields = false;

  NetDeviceAuthCreateReq() : super();
  NetDeviceAuthCreateReq.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetDeviceAuthCreateReq.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetDeviceAuthCreateReq clone() =>
      new NetDeviceAuthCreateReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetDeviceAuthCreateReq create() => new NetDeviceAuthCreateReq();
  static PbList<NetDeviceAuthCreateReq> createRepeated() =>
      new PbList<NetDeviceAuthCreateReq>();
  static NetDeviceAuthCreateReq getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetDeviceAuthCreateReq();
    return _defaultInstance;
  }

  static NetDeviceAuthCreateReq _defaultInstance;
  static void $checkItem(NetDeviceAuthCreateReq v) {
    if (v is! NetDeviceAuthCreateReq)
      checkItemFailed(v, 'NetDeviceAuthCreateReq');
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

class _ReadonlyNetDeviceAuthCreateReq extends NetDeviceAuthCreateReq
    with ReadonlyMessageMixin {}

class NetDeviceAuthChallengeReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetDeviceAuthChallengeReq')
    ..a<int>(1, 'deviceId', PbFieldType.O3)
    ..hasRequiredFields = false;

  NetDeviceAuthChallengeReq() : super();
  NetDeviceAuthChallengeReq.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetDeviceAuthChallengeReq.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetDeviceAuthChallengeReq clone() =>
      new NetDeviceAuthChallengeReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetDeviceAuthChallengeReq create() => new NetDeviceAuthChallengeReq();
  static PbList<NetDeviceAuthChallengeReq> createRepeated() =>
      new PbList<NetDeviceAuthChallengeReq>();
  static NetDeviceAuthChallengeReq getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetDeviceAuthChallengeReq();
    return _defaultInstance;
  }

  static NetDeviceAuthChallengeReq _defaultInstance;
  static void $checkItem(NetDeviceAuthChallengeReq v) {
    if (v is! NetDeviceAuthChallengeReq)
      checkItemFailed(v, 'NetDeviceAuthChallengeReq');
  }

  int get deviceId => $_get(0, 0);
  set deviceId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasDeviceId() => $_has(0);
  void clearDeviceId() => clearField(1);
}

class _ReadonlyNetDeviceAuthChallengeReq extends NetDeviceAuthChallengeReq
    with ReadonlyMessageMixin {}

class NetDeviceAuthChallengeResReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetDeviceAuthChallengeResReq')
    ..a<List<int>>(1, 'challenge', PbFieldType.OY)
    ..hasRequiredFields = false;

  NetDeviceAuthChallengeResReq() : super();
  NetDeviceAuthChallengeResReq.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetDeviceAuthChallengeResReq.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetDeviceAuthChallengeResReq clone() =>
      new NetDeviceAuthChallengeResReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetDeviceAuthChallengeResReq create() =>
      new NetDeviceAuthChallengeResReq();
  static PbList<NetDeviceAuthChallengeResReq> createRepeated() =>
      new PbList<NetDeviceAuthChallengeResReq>();
  static NetDeviceAuthChallengeResReq getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetDeviceAuthChallengeResReq();
    return _defaultInstance;
  }

  static NetDeviceAuthChallengeResReq _defaultInstance;
  static void $checkItem(NetDeviceAuthChallengeResReq v) {
    if (v is! NetDeviceAuthChallengeResReq)
      checkItemFailed(v, 'NetDeviceAuthChallengeResReq');
  }

  List<int> get challenge => $_getN(0);
  set challenge(List<int> v) {
    $_setBytes(0, v);
  }

  bool hasChallenge() => $_has(0);
  void clearChallenge() => clearField(1);
}

class _ReadonlyNetDeviceAuthChallengeResReq extends NetDeviceAuthChallengeResReq
    with ReadonlyMessageMixin {}

class NetDeviceAuthSignatureResReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetDeviceAuthSignatureResReq')
    ..a<List<int>>(1, 'signature', PbFieldType.OY)
    ..hasRequiredFields = false;

  NetDeviceAuthSignatureResReq() : super();
  NetDeviceAuthSignatureResReq.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetDeviceAuthSignatureResReq.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetDeviceAuthSignatureResReq clone() =>
      new NetDeviceAuthSignatureResReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetDeviceAuthSignatureResReq create() =>
      new NetDeviceAuthSignatureResReq();
  static PbList<NetDeviceAuthSignatureResReq> createRepeated() =>
      new PbList<NetDeviceAuthSignatureResReq>();
  static NetDeviceAuthSignatureResReq getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetDeviceAuthSignatureResReq();
    return _defaultInstance;
  }

  static NetDeviceAuthSignatureResReq _defaultInstance;
  static void $checkItem(NetDeviceAuthSignatureResReq v) {
    if (v is! NetDeviceAuthSignatureResReq)
      checkItemFailed(v, 'NetDeviceAuthSignatureResReq');
  }

  List<int> get signature => $_getN(0);
  set signature(List<int> v) {
    $_setBytes(0, v);
  }

  bool hasSignature() => $_has(0);
  void clearSignature() => clearField(1);
}

class _ReadonlyNetDeviceAuthSignatureResReq extends NetDeviceAuthSignatureResReq
    with ReadonlyMessageMixin {}

class NetDeviceAuthState extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetDeviceAuthState')
    ..a<DataAccount>(
        8, 'data', PbFieldType.OM, DataAccount.getDefault, DataAccount.create)
    ..hasRequiredFields = false;

  NetDeviceAuthState() : super();
  NetDeviceAuthState.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetDeviceAuthState.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetDeviceAuthState clone() =>
      new NetDeviceAuthState()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetDeviceAuthState create() => new NetDeviceAuthState();
  static PbList<NetDeviceAuthState> createRepeated() =>
      new PbList<NetDeviceAuthState>();
  static NetDeviceAuthState getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetDeviceAuthState();
    return _defaultInstance;
  }

  static NetDeviceAuthState _defaultInstance;
  static void $checkItem(NetDeviceAuthState v) {
    if (v is! NetDeviceAuthState) checkItemFailed(v, 'NetDeviceAuthState');
  }

  DataAccount get data => $_getN(0);
  set data(DataAccount v) {
    setField(8, v);
  }

  bool hasData() => $_has(0);
  void clearData() => clearField(8);
}

class _ReadonlyNetDeviceAuthState extends NetDeviceAuthState
    with ReadonlyMessageMixin {}

class NetSetAccountType extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetSetAccountType')
    ..e<AccountType>(1, 'accountType', PbFieldType.OE, AccountType.AT_UNKNOWN,
        AccountType.valueOf, AccountType.values)
    ..hasRequiredFields = false;

  NetSetAccountType() : super();
  NetSetAccountType.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetSetAccountType.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetSetAccountType clone() => new NetSetAccountType()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetSetAccountType create() => new NetSetAccountType();
  static PbList<NetSetAccountType> createRepeated() =>
      new PbList<NetSetAccountType>();
  static NetSetAccountType getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetSetAccountType();
    return _defaultInstance;
  }

  static NetSetAccountType _defaultInstance;
  static void $checkItem(NetSetAccountType v) {
    if (v is! NetSetAccountType) checkItemFailed(v, 'NetSetAccountType');
  }

  AccountType get accountType => $_getN(0);
  set accountType(AccountType v) {
    setField(1, v);
  }

  bool hasAccountType() => $_has(0);
  void clearAccountType() => clearField(1);
}

class _ReadonlyNetSetAccountType extends NetSetAccountType
    with ReadonlyMessageMixin {}

class NetOAuthUrlReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetOAuthUrlReq')
    ..a<int>(1, 'oauthProvider', PbFieldType.O3)
    ..hasRequiredFields = false;

  NetOAuthUrlReq() : super();
  NetOAuthUrlReq.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetOAuthUrlReq.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetOAuthUrlReq clone() => new NetOAuthUrlReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetOAuthUrlReq create() => new NetOAuthUrlReq();
  static PbList<NetOAuthUrlReq> createRepeated() =>
      new PbList<NetOAuthUrlReq>();
  static NetOAuthUrlReq getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetOAuthUrlReq();
    return _defaultInstance;
  }

  static NetOAuthUrlReq _defaultInstance;
  static void $checkItem(NetOAuthUrlReq v) {
    if (v is! NetOAuthUrlReq) checkItemFailed(v, 'NetOAuthUrlReq');
  }

  int get oauthProvider => $_get(0, 0);
  set oauthProvider(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasOauthProvider() => $_has(0);
  void clearOauthProvider() => clearField(1);
}

class _ReadonlyNetOAuthUrlReq extends NetOAuthUrlReq with ReadonlyMessageMixin {
}

class NetOAuthUrlRes extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetOAuthUrlRes')
    ..aOS(1, 'authUrl')
    ..aOS(2, 'callbackUrl')
    ..hasRequiredFields = false;

  NetOAuthUrlRes() : super();
  NetOAuthUrlRes.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetOAuthUrlRes.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetOAuthUrlRes clone() => new NetOAuthUrlRes()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetOAuthUrlRes create() => new NetOAuthUrlRes();
  static PbList<NetOAuthUrlRes> createRepeated() =>
      new PbList<NetOAuthUrlRes>();
  static NetOAuthUrlRes getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetOAuthUrlRes();
    return _defaultInstance;
  }

  static NetOAuthUrlRes _defaultInstance;
  static void $checkItem(NetOAuthUrlRes v) {
    if (v is! NetOAuthUrlRes) checkItemFailed(v, 'NetOAuthUrlRes');
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

class _ReadonlyNetOAuthUrlRes extends NetOAuthUrlRes with ReadonlyMessageMixin {
}

class NetOAuthConnectReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetOAuthConnectReq')
    ..a<int>(1, 'oauthProvider', PbFieldType.O3)
    ..aOS(2, 'callbackQuery')
    ..hasRequiredFields = false;

  NetOAuthConnectReq() : super();
  NetOAuthConnectReq.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetOAuthConnectReq.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetOAuthConnectReq clone() =>
      new NetOAuthConnectReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetOAuthConnectReq create() => new NetOAuthConnectReq();
  static PbList<NetOAuthConnectReq> createRepeated() =>
      new PbList<NetOAuthConnectReq>();
  static NetOAuthConnectReq getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetOAuthConnectReq();
    return _defaultInstance;
  }

  static NetOAuthConnectReq _defaultInstance;
  static void $checkItem(NetOAuthConnectReq v) {
    if (v is! NetOAuthConnectReq) checkItemFailed(v, 'NetOAuthConnectReq');
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

class _ReadonlyNetOAuthConnectReq extends NetOAuthConnectReq
    with ReadonlyMessageMixin {}

class NetOAuthConnectRes extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetOAuthConnectRes')
    ..a<DataSocialMedia>(1, 'socialMedia', PbFieldType.OM,
        DataSocialMedia.getDefault, DataSocialMedia.create)
    ..hasRequiredFields = false;

  NetOAuthConnectRes() : super();
  NetOAuthConnectRes.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetOAuthConnectRes.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetOAuthConnectRes clone() =>
      new NetOAuthConnectRes()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetOAuthConnectRes create() => new NetOAuthConnectRes();
  static PbList<NetOAuthConnectRes> createRepeated() =>
      new PbList<NetOAuthConnectRes>();
  static NetOAuthConnectRes getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetOAuthConnectRes();
    return _defaultInstance;
  }

  static NetOAuthConnectRes _defaultInstance;
  static void $checkItem(NetOAuthConnectRes v) {
    if (v is! NetOAuthConnectRes) checkItemFailed(v, 'NetOAuthConnectRes');
  }

  DataSocialMedia get socialMedia => $_getN(0);
  set socialMedia(DataSocialMedia v) {
    setField(1, v);
  }

  bool hasSocialMedia() => $_has(0);
  void clearSocialMedia() => clearField(1);
}

class _ReadonlyNetOAuthConnectRes extends NetOAuthConnectRes
    with ReadonlyMessageMixin {}

class NetAccountCreateReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetAccountCreateReq')
    ..a<double>(2, 'latitude', PbFieldType.OD)
    ..a<double>(3, 'longitude', PbFieldType.OD)
    ..hasRequiredFields = false;

  NetAccountCreateReq() : super();
  NetAccountCreateReq.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetAccountCreateReq.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetAccountCreateReq clone() =>
      new NetAccountCreateReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetAccountCreateReq create() => new NetAccountCreateReq();
  static PbList<NetAccountCreateReq> createRepeated() =>
      new PbList<NetAccountCreateReq>();
  static NetAccountCreateReq getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetAccountCreateReq();
    return _defaultInstance;
  }

  static NetAccountCreateReq _defaultInstance;
  static void $checkItem(NetAccountCreateReq v) {
    if (v is! NetAccountCreateReq) checkItemFailed(v, 'NetAccountCreateReq');
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

class _ReadonlyNetAccountCreateReq extends NetAccountCreateReq
    with ReadonlyMessageMixin {}

class NetUploadImageReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetUploadImageReq')
    ..aOS(1, 'fileName')
    ..a<int>(2, 'contentLength', PbFieldType.O3)
    ..a<List<int>>(3, 'contentSha256', PbFieldType.OY)
    ..aOS(4, 'contentType')
    ..hasRequiredFields = false;

  NetUploadImageReq() : super();
  NetUploadImageReq.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetUploadImageReq.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetUploadImageReq clone() => new NetUploadImageReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetUploadImageReq create() => new NetUploadImageReq();
  static PbList<NetUploadImageReq> createRepeated() =>
      new PbList<NetUploadImageReq>();
  static NetUploadImageReq getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetUploadImageReq();
    return _defaultInstance;
  }

  static NetUploadImageReq _defaultInstance;
  static void $checkItem(NetUploadImageReq v) {
    if (v is! NetUploadImageReq) checkItemFailed(v, 'NetUploadImageReq');
  }

  String get fileName => $_getS(0, '');
  set fileName(String v) {
    $_setString(0, v);
  }

  bool hasFileName() => $_has(0);
  void clearFileName() => clearField(1);

  int get contentLength => $_get(1, 0);
  set contentLength(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasContentLength() => $_has(1);
  void clearContentLength() => clearField(2);

  List<int> get contentSha256 => $_getN(2);
  set contentSha256(List<int> v) {
    $_setBytes(2, v);
  }

  bool hasContentSha256() => $_has(2);
  void clearContentSha256() => clearField(3);

  String get contentType => $_getS(3, '');
  set contentType(String v) {
    $_setString(3, v);
  }

  bool hasContentType() => $_has(3);
  void clearContentType() => clearField(4);
}

class _ReadonlyNetUploadImageReq extends NetUploadImageReq
    with ReadonlyMessageMixin {}

class NetUploadImageRes extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetUploadImageRes')
    ..aOS(1, 'requestMethod')
    ..aOS(2, 'requestUrl')
    ..aOB(9, 'fileExists')
    ..aOS(10, 'uploadKey')
    ..aOS(11, 'coverUrl')
    ..aOS(12, 'thumbnailUrl')
    ..hasRequiredFields = false;

  NetUploadImageRes() : super();
  NetUploadImageRes.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetUploadImageRes.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetUploadImageRes clone() => new NetUploadImageRes()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetUploadImageRes create() => new NetUploadImageRes();
  static PbList<NetUploadImageRes> createRepeated() =>
      new PbList<NetUploadImageRes>();
  static NetUploadImageRes getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetUploadImageRes();
    return _defaultInstance;
  }

  static NetUploadImageRes _defaultInstance;
  static void $checkItem(NetUploadImageRes v) {
    if (v is! NetUploadImageRes) checkItemFailed(v, 'NetUploadImageRes');
  }

  String get requestMethod => $_getS(0, '');
  set requestMethod(String v) {
    $_setString(0, v);
  }

  bool hasRequestMethod() => $_has(0);
  void clearRequestMethod() => clearField(1);

  String get requestUrl => $_getS(1, '');
  set requestUrl(String v) {
    $_setString(1, v);
  }

  bool hasRequestUrl() => $_has(1);
  void clearRequestUrl() => clearField(2);

  bool get fileExists => $_get(2, false);
  set fileExists(bool v) {
    $_setBool(2, v);
  }

  bool hasFileExists() => $_has(2);
  void clearFileExists() => clearField(9);

  String get uploadKey => $_getS(3, '');
  set uploadKey(String v) {
    $_setString(3, v);
  }

  bool hasUploadKey() => $_has(3);
  void clearUploadKey() => clearField(10);

  String get coverUrl => $_getS(4, '');
  set coverUrl(String v) {
    $_setString(4, v);
  }

  bool hasCoverUrl() => $_has(4);
  void clearCoverUrl() => clearField(11);

  String get thumbnailUrl => $_getS(5, '');
  set thumbnailUrl(String v) {
    $_setString(5, v);
  }

  bool hasThumbnailUrl() => $_has(5);
  void clearThumbnailUrl() => clearField(12);
}

class _ReadonlyNetUploadImageRes extends NetUploadImageRes
    with ReadonlyMessageMixin {}

class NetSetProfile extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetSetProfile')
    ..aOS(1, 'name')
    ..aOS(2, 'description')
    ..aOS(4, 'avatarKey')
    ..aOS(6, 'url')
    ..pp<CategoryId>(12, 'categories', PbFieldType.PM, CategoryId.$checkItem,
        CategoryId.create)
    ..a<double>(14, 'latitude', PbFieldType.OD)
    ..a<double>(15, 'longitude', PbFieldType.OD)
    ..hasRequiredFields = false;

  NetSetProfile() : super();
  NetSetProfile.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetSetProfile.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetSetProfile clone() => new NetSetProfile()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetSetProfile create() => new NetSetProfile();
  static PbList<NetSetProfile> createRepeated() => new PbList<NetSetProfile>();
  static NetSetProfile getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetSetProfile();
    return _defaultInstance;
  }

  static NetSetProfile _defaultInstance;
  static void $checkItem(NetSetProfile v) {
    if (v is! NetSetProfile) checkItemFailed(v, 'NetSetProfile');
  }

  String get name => $_getS(0, '');
  set name(String v) {
    $_setString(0, v);
  }

  bool hasName() => $_has(0);
  void clearName() => clearField(1);

  String get description => $_getS(1, '');
  set description(String v) {
    $_setString(1, v);
  }

  bool hasDescription() => $_has(1);
  void clearDescription() => clearField(2);

  String get avatarKey => $_getS(2, '');
  set avatarKey(String v) {
    $_setString(2, v);
  }

  bool hasAvatarKey() => $_has(2);
  void clearAvatarKey() => clearField(4);

  String get url => $_getS(3, '');
  set url(String v) {
    $_setString(3, v);
  }

  bool hasUrl() => $_has(3);
  void clearUrl() => clearField(6);

  List<CategoryId> get categories => $_getList(4);

  double get latitude => $_getN(5);
  set latitude(double v) {
    $_setDouble(5, v);
  }

  bool hasLatitude() => $_has(5);
  void clearLatitude() => clearField(14);

  double get longitude => $_getN(6);
  set longitude(double v) {
    $_setDouble(6, v);
  }

  bool hasLongitude() => $_has(6);
  void clearLongitude() => clearField(15);
}

class _ReadonlyNetSetProfile extends NetSetProfile with ReadonlyMessageMixin {}

class NetCreateOfferReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetCreateOfferReq')
    ..aOS(1, 'title')
    ..pPS(2, 'imageKeys')
    ..aOS(3, 'description')
    ..aOS(4, 'deliverables')
    ..aOS(5, 'reward')
    ..a<int>(6, 'locationId', PbFieldType.O3)
    ..hasRequiredFields = false;

  NetCreateOfferReq() : super();
  NetCreateOfferReq.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetCreateOfferReq.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetCreateOfferReq clone() => new NetCreateOfferReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetCreateOfferReq create() => new NetCreateOfferReq();
  static PbList<NetCreateOfferReq> createRepeated() =>
      new PbList<NetCreateOfferReq>();
  static NetCreateOfferReq getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetCreateOfferReq();
    return _defaultInstance;
  }

  static NetCreateOfferReq _defaultInstance;
  static void $checkItem(NetCreateOfferReq v) {
    if (v is! NetCreateOfferReq) checkItemFailed(v, 'NetCreateOfferReq');
  }

  String get title => $_getS(0, '');
  set title(String v) {
    $_setString(0, v);
  }

  bool hasTitle() => $_has(0);
  void clearTitle() => clearField(1);

  List<String> get imageKeys => $_getList(1);

  String get description => $_getS(2, '');
  set description(String v) {
    $_setString(2, v);
  }

  bool hasDescription() => $_has(2);
  void clearDescription() => clearField(3);

  String get deliverables => $_getS(3, '');
  set deliverables(String v) {
    $_setString(3, v);
  }

  bool hasDeliverables() => $_has(3);
  void clearDeliverables() => clearField(4);

  String get reward => $_getS(4, '');
  set reward(String v) {
    $_setString(4, v);
  }

  bool hasReward() => $_has(4);
  void clearReward() => clearField(5);

  int get locationId => $_get(5, 0);
  set locationId(int v) {
    $_setSignedInt32(5, v);
  }

  bool hasLocationId() => $_has(5);
  void clearLocationId() => clearField(6);
}

class _ReadonlyNetCreateOfferReq extends NetCreateOfferReq
    with ReadonlyMessageMixin {}

class NetLoadOffersReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetLoadOffersReq')
    ..a<int>(1, 'before', PbFieldType.O3)
    ..a<int>(2, 'after', PbFieldType.O3)
    ..a<int>(3, 'limit', PbFieldType.O3)
    ..hasRequiredFields = false;

  NetLoadOffersReq() : super();
  NetLoadOffersReq.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetLoadOffersReq.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetLoadOffersReq clone() => new NetLoadOffersReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetLoadOffersReq create() => new NetLoadOffersReq();
  static PbList<NetLoadOffersReq> createRepeated() =>
      new PbList<NetLoadOffersReq>();
  static NetLoadOffersReq getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetLoadOffersReq();
    return _defaultInstance;
  }

  static NetLoadOffersReq _defaultInstance;
  static void $checkItem(NetLoadOffersReq v) {
    if (v is! NetLoadOffersReq) checkItemFailed(v, 'NetLoadOffersReq');
  }

  int get before => $_get(0, 0);
  set before(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasBefore() => $_has(0);
  void clearBefore() => clearField(1);

  int get after => $_get(1, 0);
  set after(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasAfter() => $_has(1);
  void clearAfter() => clearField(2);

  int get limit => $_get(2, 0);
  set limit(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasLimit() => $_has(2);
  void clearLimit() => clearField(3);
}

class _ReadonlyNetLoadOffersReq extends NetLoadOffersReq
    with ReadonlyMessageMixin {}

class NetLoadOffersRes extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetLoadOffersRes')
    ..a<int>(1, 'oldest', PbFieldType.O3)
    ..a<int>(2, 'newest', PbFieldType.O3)
    ..hasRequiredFields = false;

  NetLoadOffersRes() : super();
  NetLoadOffersRes.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetLoadOffersRes.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetLoadOffersRes clone() => new NetLoadOffersRes()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetLoadOffersRes create() => new NetLoadOffersRes();
  static PbList<NetLoadOffersRes> createRepeated() =>
      new PbList<NetLoadOffersRes>();
  static NetLoadOffersRes getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetLoadOffersRes();
    return _defaultInstance;
  }

  static NetLoadOffersRes _defaultInstance;
  static void $checkItem(NetLoadOffersRes v) {
    if (v is! NetLoadOffersRes) checkItemFailed(v, 'NetLoadOffersRes');
  }

  int get oldest => $_get(0, 0);
  set oldest(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasOldest() => $_has(0);
  void clearOldest() => clearField(1);

  int get newest => $_get(1, 0);
  set newest(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasNewest() => $_has(1);
  void clearNewest() => clearField(2);
}

class _ReadonlyNetLoadOffersRes extends NetLoadOffersRes
    with ReadonlyMessageMixin {}

class NetOfferApplyReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetOfferApplyReq')
    ..a<int>(1, 'offerId', PbFieldType.O3)
    ..aOS(2, 'remarks')
    ..hasRequiredFields = false;

  NetOfferApplyReq() : super();
  NetOfferApplyReq.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetOfferApplyReq.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetOfferApplyReq clone() => new NetOfferApplyReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetOfferApplyReq create() => new NetOfferApplyReq();
  static PbList<NetOfferApplyReq> createRepeated() =>
      new PbList<NetOfferApplyReq>();
  static NetOfferApplyReq getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetOfferApplyReq();
    return _defaultInstance;
  }

  static NetOfferApplyReq _defaultInstance;
  static void $checkItem(NetOfferApplyReq v) {
    if (v is! NetOfferApplyReq) checkItemFailed(v, 'NetOfferApplyReq');
  }

  int get offerId => $_get(0, 0);
  set offerId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasOfferId() => $_has(0);
  void clearOfferId() => clearField(1);

  String get remarks => $_getS(1, '');
  set remarks(String v) {
    $_setString(1, v);
  }

  bool hasRemarks() => $_has(1);
  void clearRemarks() => clearField(2);
}

class _ReadonlyNetOfferApplyReq extends NetOfferApplyReq
    with ReadonlyMessageMixin {}

class NetChatPlain extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetChatPlain')
    ..a<int>(1, 'applicantId', PbFieldType.O3)
    ..aOS(6, 'text')
    ..hasRequiredFields = false;

  NetChatPlain() : super();
  NetChatPlain.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetChatPlain.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetChatPlain clone() => new NetChatPlain()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetChatPlain create() => new NetChatPlain();
  static PbList<NetChatPlain> createRepeated() => new PbList<NetChatPlain>();
  static NetChatPlain getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetChatPlain();
    return _defaultInstance;
  }

  static NetChatPlain _defaultInstance;
  static void $checkItem(NetChatPlain v) {
    if (v is! NetChatPlain) checkItemFailed(v, 'NetChatPlain');
  }

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);

  String get text => $_getS(1, '');
  set text(String v) {
    $_setString(1, v);
  }

  bool hasText() => $_has(1);
  void clearText() => clearField(6);
}

class _ReadonlyNetChatPlain extends NetChatPlain with ReadonlyMessageMixin {}

class NetChatHaggle extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetChatHaggle')
    ..a<int>(1, 'applicantId', PbFieldType.O3)
    ..aOS(2, 'remarks')
    ..aOS(3, 'deliverables')
    ..aOS(4, 'reward')
    ..hasRequiredFields = false;

  NetChatHaggle() : super();
  NetChatHaggle.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetChatHaggle.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetChatHaggle clone() => new NetChatHaggle()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetChatHaggle create() => new NetChatHaggle();
  static PbList<NetChatHaggle> createRepeated() => new PbList<NetChatHaggle>();
  static NetChatHaggle getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetChatHaggle();
    return _defaultInstance;
  }

  static NetChatHaggle _defaultInstance;
  static void $checkItem(NetChatHaggle v) {
    if (v is! NetChatHaggle) checkItemFailed(v, 'NetChatHaggle');
  }

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);

  String get remarks => $_getS(1, '');
  set remarks(String v) {
    $_setString(1, v);
  }

  bool hasRemarks() => $_has(1);
  void clearRemarks() => clearField(2);

  String get deliverables => $_getS(2, '');
  set deliverables(String v) {
    $_setString(2, v);
  }

  bool hasDeliverables() => $_has(2);
  void clearDeliverables() => clearField(3);

  String get reward => $_getS(3, '');
  set reward(String v) {
    $_setString(3, v);
  }

  bool hasReward() => $_has(3);
  void clearReward() => clearField(4);
}

class _ReadonlyNetChatHaggle extends NetChatHaggle with ReadonlyMessageMixin {}

class NetChatImageKey extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetChatImageKey')
    ..a<int>(1, 'applicantId', PbFieldType.O3)
    ..aOS(5, 'imageKey')
    ..hasRequiredFields = false;

  NetChatImageKey() : super();
  NetChatImageKey.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetChatImageKey.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetChatImageKey clone() => new NetChatImageKey()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetChatImageKey create() => new NetChatImageKey();
  static PbList<NetChatImageKey> createRepeated() =>
      new PbList<NetChatImageKey>();
  static NetChatImageKey getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetChatImageKey();
    return _defaultInstance;
  }

  static NetChatImageKey _defaultInstance;
  static void $checkItem(NetChatImageKey v) {
    if (v is! NetChatImageKey) checkItemFailed(v, 'NetChatImageKey');
  }

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);

  String get imageKey => $_getS(1, '');
  set imageKey(String v) {
    $_setString(1, v);
  }

  bool hasImageKey() => $_has(1);
  void clearImageKey() => clearField(5);
}

class _ReadonlyNetChatImageKey extends NetChatImageKey
    with ReadonlyMessageMixin {}

class NetApplicantCompletionReq extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('NetApplicantCompletionReq')
    ..a<int>(1, 'applicantId', PbFieldType.O3)
    ..aOB(2, 'delivered')
    ..aOB(3, 'rewarded')
    ..a<int>(4, 'rating', PbFieldType.O3)
    ..aOB(5, 'dispute')
    ..aOS(6, 'disputeDescription')
    ..hasRequiredFields = false;

  NetApplicantCompletionReq() : super();
  NetApplicantCompletionReq.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetApplicantCompletionReq.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetApplicantCompletionReq clone() =>
      new NetApplicantCompletionReq()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static NetApplicantCompletionReq create() => new NetApplicantCompletionReq();
  static PbList<NetApplicantCompletionReq> createRepeated() =>
      new PbList<NetApplicantCompletionReq>();
  static NetApplicantCompletionReq getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyNetApplicantCompletionReq();
    return _defaultInstance;
  }

  static NetApplicantCompletionReq _defaultInstance;
  static void $checkItem(NetApplicantCompletionReq v) {
    if (v is! NetApplicantCompletionReq)
      checkItemFailed(v, 'NetApplicantCompletionReq');
  }

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);

  bool get delivered => $_get(1, false);
  set delivered(bool v) {
    $_setBool(1, v);
  }

  bool hasDelivered() => $_has(1);
  void clearDelivered() => clearField(2);

  bool get rewarded => $_get(2, false);
  set rewarded(bool v) {
    $_setBool(2, v);
  }

  bool hasRewarded() => $_has(2);
  void clearRewarded() => clearField(3);

  int get rating => $_get(3, 0);
  set rating(int v) {
    $_setSignedInt32(3, v);
  }

  bool hasRating() => $_has(3);
  void clearRating() => clearField(4);

  bool get dispute => $_get(4, false);
  set dispute(bool v) {
    $_setBool(4, v);
  }

  bool hasDispute() => $_has(4);
  void clearDispute() => clearField(5);

  String get disputeDescription => $_getS(5, '');
  set disputeDescription(String v) {
    $_setString(5, v);
  }

  bool hasDisputeDescription() => $_has(5);
  void clearDisputeDescription() => clearField(6);
}

class _ReadonlyNetApplicantCompletionReq extends NetApplicantCompletionReq
    with ReadonlyMessageMixin {}
