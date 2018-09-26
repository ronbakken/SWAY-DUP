///
//  Generated code. Do not modify.
//  source: inf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'inf.pbenum.dart';

export 'inf.pbenum.dart';

class ConfigSubCategories extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigSubCategories',
      package: const $pb.PackageName('inf'))
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
    if (v is! ConfigSubCategories) $pb.checkItemFailed(v, _i.messageName);
  }

  List<String> get labels => $_getList(0);
}

class ConfigCategories extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigCategories',
      package: const $pb.PackageName('inf'))
    ..pp<ConfigSubCategories>(1, 'sub', $pb.PbFieldType.PM,
        ConfigSubCategories.$checkItem, ConfigSubCategories.create)
    ..hasRequiredFields = false;

  ConfigCategories() : super();
  ConfigCategories.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConfigCategories.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ConfigCategories clone() => new ConfigCategories()..mergeFromMessage(this);
  ConfigCategories copyWith(void Function(ConfigCategories) updates) =>
      super.copyWith((message) => updates(message as ConfigCategories));
  $pb.BuilderInfo get info_ => _i;
  static ConfigCategories create() => new ConfigCategories();
  static $pb.PbList<ConfigCategories> createRepeated() =>
      new $pb.PbList<ConfigCategories>();
  static ConfigCategories getDefault() =>
      _defaultInstance ??= create()..freeze();
  static ConfigCategories _defaultInstance;
  static void $checkItem(ConfigCategories v) {
    if (v is! ConfigCategories) $pb.checkItemFailed(v, _i.messageName);
  }

  List<ConfigSubCategories> get sub => $_getList(0);
}

class ConfigOAuthProvider extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigOAuthProvider',
      package: const $pb.PackageName('inf'))
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
    ..a<int>(14, 'fontAwesomeBrand', $pb.PbFieldType.O3)
    ..e<OAuthMechanism>(15, 'mechanism', $pb.PbFieldType.OE,
        OAuthMechanism.OAM_NONE, OAuthMechanism.valueOf, OAuthMechanism.values)
    ..aOS(16, 'accessTokenUrl')
    ..aOS(17, 'clientSecret')
    ..pPS(18, 'whitelistHosts')
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
    if (v is! ConfigOAuthProvider) $pb.checkItemFailed(v, _i.messageName);
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

class ConfigOAuthProviders extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigOAuthProviders',
      package: const $pb.PackageName('inf'))
    ..pp<ConfigOAuthProvider>(1, 'all', $pb.PbFieldType.PM,
        ConfigOAuthProvider.$checkItem, ConfigOAuthProvider.create)
    ..hasRequiredFields = false;

  ConfigOAuthProviders() : super();
  ConfigOAuthProviders.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ConfigOAuthProviders.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ConfigOAuthProviders clone() =>
      new ConfigOAuthProviders()..mergeFromMessage(this);
  ConfigOAuthProviders copyWith(void Function(ConfigOAuthProviders) updates) =>
      super.copyWith((message) => updates(message as ConfigOAuthProviders));
  $pb.BuilderInfo get info_ => _i;
  static ConfigOAuthProviders create() => new ConfigOAuthProviders();
  static $pb.PbList<ConfigOAuthProviders> createRepeated() =>
      new $pb.PbList<ConfigOAuthProviders>();
  static ConfigOAuthProviders getDefault() =>
      _defaultInstance ??= create()..freeze();
  static ConfigOAuthProviders _defaultInstance;
  static void $checkItem(ConfigOAuthProviders v) {
    if (v is! ConfigOAuthProviders) $pb.checkItemFailed(v, _i.messageName);
  }

  List<ConfigOAuthProvider> get all => $_getList(0);
}

class ConfigServices extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigServices',
      package: const $pb.PackageName('inf'))
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
    ..a<int>(15, 'mariadbPort', $pb.PbFieldType.O3)
    ..aOS(16, 'mariadbUser')
    ..aOS(17, 'mariadbPassword')
    ..aOS(18, 'mariadbDatabase')
    ..aOS(19, 'cloudinaryUrl')
    ..aOS(20, 'cloudinaryThumbnailUrl')
    ..aOS(21, 'cloudinaryCoverUrl')
    ..aOS(22, 'freshdeskApi')
    ..aOS(23, 'freshdeskKey')
    ..aOS(24, 'domain')
    ..aOS(25, 'firebaseServerKey')
    ..aOS(26, 'firebaseSenderId')
    ..aOS(27, 'firebaseLegacyApi')
    ..aOS(28, 'firebaseLegacyServerKey')
    ..aOS(29, 'connectionFailedUrl')
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
    if (v is! ConfigServices) $pb.checkItemFailed(v, _i.messageName);
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
}

class ConfigData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('ConfigData', package: const $pb.PackageName('inf'))
        ..a<int>(1, 'clientVersion', $pb.PbFieldType.O3)
        ..a<ConfigCategories>(2, 'categories', $pb.PbFieldType.OM,
            ConfigCategories.getDefault, ConfigCategories.create)
        ..a<ConfigOAuthProviders>(3, 'oauthProviders', $pb.PbFieldType.OM,
            ConfigOAuthProviders.getDefault, ConfigOAuthProviders.create)
        ..aInt64(5, 'timestamp')
        ..a<ConfigServices>(6, 'services', $pb.PbFieldType.OM,
            ConfigServices.getDefault, ConfigServices.create)
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
    if (v is! ConfigData) $pb.checkItemFailed(v, _i.messageName);
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

class CategoryId extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('CategoryId', package: const $pb.PackageName('inf'))
        ..a<int>(1, 'main', $pb.PbFieldType.O3)
        ..a<int>(2, 'sub', $pb.PbFieldType.O3)
        ..hasRequiredFields = false;

  CategoryId() : super();
  CategoryId.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  CategoryId.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  CategoryId clone() => new CategoryId()..mergeFromMessage(this);
  CategoryId copyWith(void Function(CategoryId) updates) =>
      super.copyWith((message) => updates(message as CategoryId));
  $pb.BuilderInfo get info_ => _i;
  static CategoryId create() => new CategoryId();
  static $pb.PbList<CategoryId> createRepeated() =>
      new $pb.PbList<CategoryId>();
  static CategoryId getDefault() => _defaultInstance ??= create()..freeze();
  static CategoryId _defaultInstance;
  static void $checkItem(CategoryId v) {
    if (v is! CategoryId) $pb.checkItemFailed(v, _i.messageName);
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

class DataSocialMedia extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataSocialMedia',
      package: const $pb.PackageName('inf'))
    ..aOB(1, 'connected')
    ..a<int>(2, 'followersCount', $pb.PbFieldType.O3)
    ..a<int>(3, 'followingCount', $pb.PbFieldType.O3)
    ..aOS(4, 'screenName')
    ..aOS(5, 'displayName')
    ..aOS(6, 'description')
    ..aOS(7, 'location')
    ..aOS(8, 'url')
    ..a<int>(9, 'friendsCount', $pb.PbFieldType.O3)
    ..a<int>(10, 'postsCount', $pb.PbFieldType.O3)
    ..aOB(11, 'verified')
    ..aOS(12, 'email')
    ..aOS(13, 'profileUrl')
    ..aOS(14, 'avatarUrl')
    ..aOB(15, 'expired')
    ..hasRequiredFields = false;

  DataSocialMedia() : super();
  DataSocialMedia.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataSocialMedia.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataSocialMedia clone() => new DataSocialMedia()..mergeFromMessage(this);
  DataSocialMedia copyWith(void Function(DataSocialMedia) updates) =>
      super.copyWith((message) => updates(message as DataSocialMedia));
  $pb.BuilderInfo get info_ => _i;
  static DataSocialMedia create() => new DataSocialMedia();
  static $pb.PbList<DataSocialMedia> createRepeated() =>
      new $pb.PbList<DataSocialMedia>();
  static DataSocialMedia getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DataSocialMedia _defaultInstance;
  static void $checkItem(DataSocialMedia v) {
    if (v is! DataSocialMedia) $pb.checkItemFailed(v, _i.messageName);
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

class DataOAuthCredentials extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataOAuthCredentials',
      package: const $pb.PackageName('inf'))
    ..aOS(1, 'token')
    ..aOS(2, 'tokenSecret')
    ..a<int>(3, 'tokenExpires', $pb.PbFieldType.O3)
    ..aOS(4, 'userId')
    ..hasRequiredFields = false;

  DataOAuthCredentials() : super();
  DataOAuthCredentials.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataOAuthCredentials.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataOAuthCredentials clone() =>
      new DataOAuthCredentials()..mergeFromMessage(this);
  DataOAuthCredentials copyWith(void Function(DataOAuthCredentials) updates) =>
      super.copyWith((message) => updates(message as DataOAuthCredentials));
  $pb.BuilderInfo get info_ => _i;
  static DataOAuthCredentials create() => new DataOAuthCredentials();
  static $pb.PbList<DataOAuthCredentials> createRepeated() =>
      new $pb.PbList<DataOAuthCredentials>();
  static DataOAuthCredentials getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DataOAuthCredentials _defaultInstance;
  static void $checkItem(DataOAuthCredentials v) {
    if (v is! DataOAuthCredentials) $pb.checkItemFailed(v, _i.messageName);
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

class DataBusinessOffer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataBusinessOffer',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'offerId', $pb.PbFieldType.O3)
    ..a<int>(2, 'accountId', $pb.PbFieldType.O3)
    ..a<int>(3, 'locationId', $pb.PbFieldType.O3)
    ..aOS(4, 'title')
    ..aOS(5, 'description')
    ..aOS(6, 'thumbnailUrl')
    ..aOS(7, 'deliverables')
    ..aOS(8, 'reward')
    ..aOS(9, 'location')
    ..pPS(10, 'coverUrls')
    ..pp<CategoryId>(11, 'categories', $pb.PbFieldType.PM,
        CategoryId.$checkItem, CategoryId.create)
    ..e<BusinessOfferState>(
        12,
        'state',
        $pb.PbFieldType.OE,
        BusinessOfferState.BOS_DRAFT,
        BusinessOfferState.valueOf,
        BusinessOfferState.values)
    ..e<BusinessOfferStateReason>(
        13,
        'stateReason',
        $pb.PbFieldType.OE,
        BusinessOfferStateReason.BOSR_NEW_OFFER,
        BusinessOfferStateReason.valueOf,
        BusinessOfferStateReason.values)
    ..a<int>(14, 'applicantsNew', $pb.PbFieldType.O3)
    ..a<int>(15, 'applicantsAccepted', $pb.PbFieldType.O3)
    ..a<int>(16, 'applicantsCompleted', $pb.PbFieldType.O3)
    ..a<int>(17, 'applicantsRefused', $pb.PbFieldType.O3)
    ..a<double>(18, 'latitude', $pb.PbFieldType.OD)
    ..a<double>(19, 'longitude', $pb.PbFieldType.OD)
    ..a<int>(20, 'locationOfferCount', $pb.PbFieldType.O3)
    ..aOS(21, 'locationName')
    ..a<int>(22, 'influencerApplicantId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  DataBusinessOffer() : super();
  DataBusinessOffer.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataBusinessOffer.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataBusinessOffer clone() => new DataBusinessOffer()..mergeFromMessage(this);
  DataBusinessOffer copyWith(void Function(DataBusinessOffer) updates) =>
      super.copyWith((message) => updates(message as DataBusinessOffer));
  $pb.BuilderInfo get info_ => _i;
  static DataBusinessOffer create() => new DataBusinessOffer();
  static $pb.PbList<DataBusinessOffer> createRepeated() =>
      new $pb.PbList<DataBusinessOffer>();
  static DataBusinessOffer getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DataBusinessOffer _defaultInstance;
  static void $checkItem(DataBusinessOffer v) {
    if (v is! DataBusinessOffer) $pb.checkItemFailed(v, _i.messageName);
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

  int get locationOfferCount => $_get(19, 0);
  set locationOfferCount(int v) {
    $_setSignedInt32(19, v);
  }

  bool hasLocationOfferCount() => $_has(19);
  void clearLocationOfferCount() => clearField(20);

  String get locationName => $_getS(20, '');
  set locationName(String v) {
    $_setString(20, v);
  }

  bool hasLocationName() => $_has(20);
  void clearLocationName() => clearField(21);

  int get influencerApplicantId => $_get(21, 0);
  set influencerApplicantId(int v) {
    $_setSignedInt32(21, v);
  }

  bool hasInfluencerApplicantId() => $_has(21);
  void clearInfluencerApplicantId() => clearField(22);
}

class DataLocation extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('DataLocation', package: const $pb.PackageName('inf'))
        ..a<int>(1, 'locationId', $pb.PbFieldType.O3)
        ..aOS(2, 'name')
        ..a<double>(4, 'latitude', $pb.PbFieldType.OD)
        ..a<double>(5, 'longitude', $pb.PbFieldType.OD)
        ..aOS(6, 'avatarUrl')
        ..aOS(7, 'approximate')
        ..aOS(8, 'detail')
        ..aOS(9, 'postcode')
        ..aOS(10, 'regionCode')
        ..aOS(11, 'countryCode')
        ..aInt64(12, 's2cellId')
        ..hasRequiredFields = false;

  DataLocation() : super();
  DataLocation.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataLocation.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataLocation clone() => new DataLocation()..mergeFromMessage(this);
  DataLocation copyWith(void Function(DataLocation) updates) =>
      super.copyWith((message) => updates(message as DataLocation));
  $pb.BuilderInfo get info_ => _i;
  static DataLocation create() => new DataLocation();
  static $pb.PbList<DataLocation> createRepeated() =>
      new $pb.PbList<DataLocation>();
  static DataLocation getDefault() => _defaultInstance ??= create()..freeze();
  static DataLocation _defaultInstance;
  static void $checkItem(DataLocation v) {
    if (v is! DataLocation) $pb.checkItemFailed(v, _i.messageName);
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

  Int64 get s2cellId => $_getI64(10);
  set s2cellId(Int64 v) {
    $_setInt64(10, v);
  }

  bool hasS2cellId() => $_has(10);
  void clearS2cellId() => clearField(12);
}

class DataAccountState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataAccountState',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'deviceId', $pb.PbFieldType.O3)
    ..a<int>(2, 'accountId', $pb.PbFieldType.O3)
    ..e<AccountType>(3, 'accountType', $pb.PbFieldType.OE,
        AccountType.AT_UNKNOWN, AccountType.valueOf, AccountType.values)
    ..e<GlobalAccountState>(
        4,
        'globalAccountState',
        $pb.PbFieldType.OE,
        GlobalAccountState.GAS_INITIALIZE,
        GlobalAccountState.valueOf,
        GlobalAccountState.values)
    ..e<GlobalAccountStateReason>(
        5,
        'globalAccountStateReason',
        $pb.PbFieldType.OE,
        GlobalAccountStateReason.GASR_NEW_ACCOUNT,
        GlobalAccountStateReason.valueOf,
        GlobalAccountStateReason.values)
    ..e<NotificationFlags>(
        6,
        'notificationFlags',
        $pb.PbFieldType.OE,
        NotificationFlags.NF_ACCOUNT_STATE,
        NotificationFlags.valueOf,
        NotificationFlags.values)
    ..aOS(7, 'firebaseToken')
    ..hasRequiredFields = false;

  DataAccountState() : super();
  DataAccountState.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataAccountState.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataAccountState clone() => new DataAccountState()..mergeFromMessage(this);
  DataAccountState copyWith(void Function(DataAccountState) updates) =>
      super.copyWith((message) => updates(message as DataAccountState));
  $pb.BuilderInfo get info_ => _i;
  static DataAccountState create() => new DataAccountState();
  static $pb.PbList<DataAccountState> createRepeated() =>
      new $pb.PbList<DataAccountState>();
  static DataAccountState getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DataAccountState _defaultInstance;
  static void $checkItem(DataAccountState v) {
    if (v is! DataAccountState) $pb.checkItemFailed(v, _i.messageName);
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

  String get firebaseToken => $_getS(6, '');
  set firebaseToken(String v) {
    $_setString(6, v);
  }

  bool hasFirebaseToken() => $_has(6);
  void clearFirebaseToken() => clearField(7);
}

class DataAccountSummary extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataAccountSummary',
      package: const $pb.PackageName('inf'))
    ..aOS(1, 'name')
    ..aOS(2, 'description')
    ..aOS(3, 'location')
    ..aOS(4, 'avatarThumbnailUrl')
    ..hasRequiredFields = false;

  DataAccountSummary() : super();
  DataAccountSummary.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataAccountSummary.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataAccountSummary clone() =>
      new DataAccountSummary()..mergeFromMessage(this);
  DataAccountSummary copyWith(void Function(DataAccountSummary) updates) =>
      super.copyWith((message) => updates(message as DataAccountSummary));
  $pb.BuilderInfo get info_ => _i;
  static DataAccountSummary create() => new DataAccountSummary();
  static $pb.PbList<DataAccountSummary> createRepeated() =>
      new $pb.PbList<DataAccountSummary>();
  static DataAccountSummary getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DataAccountSummary _defaultInstance;
  static void $checkItem(DataAccountSummary v) {
    if (v is! DataAccountSummary) $pb.checkItemFailed(v, _i.messageName);
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

class DataAccountDetail extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataAccountDetail',
      package: const $pb.PackageName('inf'))
    ..pp<CategoryId>(2, 'categories', $pb.PbFieldType.PM, CategoryId.$checkItem,
        CategoryId.create)
    ..pp<DataSocialMedia>(3, 'socialMedia', $pb.PbFieldType.PM,
        DataSocialMedia.$checkItem, DataSocialMedia.create)
    ..a<double>(4, 'latitude', $pb.PbFieldType.OD)
    ..a<double>(5, 'longitude', $pb.PbFieldType.OD)
    ..aOS(6, 'url')
    ..aOS(7, 'avatarCoverUrl')
    ..a<int>(8, 'locationId', $pb.PbFieldType.O3)
    ..aOS(9, 'email')
    ..hasRequiredFields = false;

  DataAccountDetail() : super();
  DataAccountDetail.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataAccountDetail.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataAccountDetail clone() => new DataAccountDetail()..mergeFromMessage(this);
  DataAccountDetail copyWith(void Function(DataAccountDetail) updates) =>
      super.copyWith((message) => updates(message as DataAccountDetail));
  $pb.BuilderInfo get info_ => _i;
  static DataAccountDetail create() => new DataAccountDetail();
  static $pb.PbList<DataAccountDetail> createRepeated() =>
      new $pb.PbList<DataAccountDetail>();
  static DataAccountDetail getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DataAccountDetail _defaultInstance;
  static void $checkItem(DataAccountDetail v) {
    if (v is! DataAccountDetail) $pb.checkItemFailed(v, _i.messageName);
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

  String get email => $_getS(7, '');
  set email(String v) {
    $_setString(7, v);
  }

  bool hasEmail() => $_has(7);
  void clearEmail() => clearField(9);
}

class DataAccount extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('DataAccount', package: const $pb.PackageName('inf'))
        ..a<DataAccountState>(1, 'state', $pb.PbFieldType.OM,
            DataAccountState.getDefault, DataAccountState.create)
        ..a<DataAccountSummary>(2, 'summary', $pb.PbFieldType.OM,
            DataAccountSummary.getDefault, DataAccountSummary.create)
        ..a<DataAccountDetail>(3, 'detail', $pb.PbFieldType.OM,
            DataAccountDetail.getDefault, DataAccountDetail.create)
        ..hasRequiredFields = false;

  DataAccount() : super();
  DataAccount.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataAccount.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataAccount clone() => new DataAccount()..mergeFromMessage(this);
  DataAccount copyWith(void Function(DataAccount) updates) =>
      super.copyWith((message) => updates(message as DataAccount));
  $pb.BuilderInfo get info_ => _i;
  static DataAccount create() => new DataAccount();
  static $pb.PbList<DataAccount> createRepeated() =>
      new $pb.PbList<DataAccount>();
  static DataAccount getDefault() => _defaultInstance ??= create()..freeze();
  static DataAccount _defaultInstance;
  static void $checkItem(DataAccount v) {
    if (v is! DataAccount) $pb.checkItemFailed(v, _i.messageName);
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

class DataApplicant extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataApplicant',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..a<int>(2, 'offerId', $pb.PbFieldType.O3)
    ..a<int>(3, 'influencerAccountId', $pb.PbFieldType.O3)
    ..aInt64(4, 'haggleChatId')
    ..aOB(5, 'businessWantsDeal')
    ..aOB(6, 'influencerWantsDeal')
    ..aOB(7, 'influencerMarkedDelivered')
    ..aOB(8, 'influencerMarkedRewarded')
    ..aOB(9, 'businessMarkedDelivered')
    ..aOB(10, 'businessMarkedRewarded')
    ..a<int>(11, 'businessGaveRating', $pb.PbFieldType.O3)
    ..a<int>(12, 'influencerGaveRating', $pb.PbFieldType.O3)
    ..e<ApplicantState>(
        13,
        'state',
        $pb.PbFieldType.OE,
        ApplicantState.AS_HAGGLING,
        ApplicantState.valueOf,
        ApplicantState.values)
    ..aOB(14, 'businessDisputed')
    ..aOB(15, 'influencerDisputed')
    ..a<int>(16, 'businessAccountId', $pb.PbFieldType.O3)
    ..aOS(17, 'influencerName')
    ..aOS(18, 'businessName')
    ..aOS(19, 'offerTitle')
    ..hasRequiredFields = false;

  DataApplicant() : super();
  DataApplicant.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataApplicant.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataApplicant clone() => new DataApplicant()..mergeFromMessage(this);
  DataApplicant copyWith(void Function(DataApplicant) updates) =>
      super.copyWith((message) => updates(message as DataApplicant));
  $pb.BuilderInfo get info_ => _i;
  static DataApplicant create() => new DataApplicant();
  static $pb.PbList<DataApplicant> createRepeated() =>
      new $pb.PbList<DataApplicant>();
  static DataApplicant getDefault() => _defaultInstance ??= create()..freeze();
  static DataApplicant _defaultInstance;
  static void $checkItem(DataApplicant v) {
    if (v is! DataApplicant) $pb.checkItemFailed(v, _i.messageName);
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

  int get influencerAccountId => $_get(2, 0);
  set influencerAccountId(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasInfluencerAccountId() => $_has(2);
  void clearInfluencerAccountId() => clearField(3);

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

  bool get influencerMarkedDelivered => $_get(6, false);
  set influencerMarkedDelivered(bool v) {
    $_setBool(6, v);
  }

  bool hasInfluencerMarkedDelivered() => $_has(6);
  void clearInfluencerMarkedDelivered() => clearField(7);

  bool get influencerMarkedRewarded => $_get(7, false);
  set influencerMarkedRewarded(bool v) {
    $_setBool(7, v);
  }

  bool hasInfluencerMarkedRewarded() => $_has(7);
  void clearInfluencerMarkedRewarded() => clearField(8);

  bool get businessMarkedDelivered => $_get(8, false);
  set businessMarkedDelivered(bool v) {
    $_setBool(8, v);
  }

  bool hasBusinessMarkedDelivered() => $_has(8);
  void clearBusinessMarkedDelivered() => clearField(9);

  bool get businessMarkedRewarded => $_get(9, false);
  set businessMarkedRewarded(bool v) {
    $_setBool(9, v);
  }

  bool hasBusinessMarkedRewarded() => $_has(9);
  void clearBusinessMarkedRewarded() => clearField(10);

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

  int get businessAccountId => $_get(15, 0);
  set businessAccountId(int v) {
    $_setSignedInt32(15, v);
  }

  bool hasBusinessAccountId() => $_has(15);
  void clearBusinessAccountId() => clearField(16);

  String get influencerName => $_getS(16, '');
  set influencerName(String v) {
    $_setString(16, v);
  }

  bool hasInfluencerName() => $_has(16);
  void clearInfluencerName() => clearField(17);

  String get businessName => $_getS(17, '');
  set businessName(String v) {
    $_setString(17, v);
  }

  bool hasBusinessName() => $_has(17);
  void clearBusinessName() => clearField(18);

  String get offerTitle => $_getS(18, '');
  set offerTitle(String v) {
    $_setString(18, v);
  }

  bool hasOfferTitle() => $_has(18);
  void clearOfferTitle() => clearField(19);
}

class DataApplicantChat extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataApplicantChat',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..a<int>(2, 'senderId', $pb.PbFieldType.O3)
    ..aOS(5, 'text')
    ..a<int>(6, 'deviceGhostId', $pb.PbFieldType.O3)
    ..aInt64(7, 'chatId')
    ..e<ApplicantChatType>(
        8,
        'type',
        $pb.PbFieldType.OE,
        ApplicantChatType.ACT_PLAIN,
        ApplicantChatType.valueOf,
        ApplicantChatType.values)
    ..aInt64(9, 'seen')
    ..aInt64(10, 'sent')
    ..a<int>(11, 'deviceId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  DataApplicantChat() : super();
  DataApplicantChat.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataApplicantChat.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataApplicantChat clone() => new DataApplicantChat()..mergeFromMessage(this);
  DataApplicantChat copyWith(void Function(DataApplicantChat) updates) =>
      super.copyWith((message) => updates(message as DataApplicantChat));
  $pb.BuilderInfo get info_ => _i;
  static DataApplicantChat create() => new DataApplicantChat();
  static $pb.PbList<DataApplicantChat> createRepeated() =>
      new $pb.PbList<DataApplicantChat>();
  static DataApplicantChat getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DataApplicantChat _defaultInstance;
  static void $checkItem(DataApplicantChat v) {
    if (v is! DataApplicantChat) $pb.checkItemFailed(v, _i.messageName);
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

  int get deviceGhostId => $_get(3, 0);
  set deviceGhostId(int v) {
    $_setSignedInt32(3, v);
  }

  bool hasDeviceGhostId() => $_has(3);
  void clearDeviceGhostId() => clearField(6);

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

  int get deviceId => $_get(8, 0);
  set deviceId(int v) {
    $_setSignedInt32(8, v);
  }

  bool hasDeviceId() => $_has(8);
  void clearDeviceId() => clearField(11);
}

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
    if (v is! NetDeviceAuthCreateReq) $pb.checkItemFailed(v, _i.messageName);
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
    if (v is! NetDeviceAuthChallengeReq) $pb.checkItemFailed(v, _i.messageName);
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
      $pb.checkItemFailed(v, _i.messageName);
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
      $pb.checkItemFailed(v, _i.messageName);
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
    ..a<DataAccount>(8, 'data', $pb.PbFieldType.OM, DataAccount.getDefault,
        DataAccount.create)
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
    if (v is! NetDeviceAuthState) $pb.checkItemFailed(v, _i.messageName);
  }

  DataAccount get data => $_getN(0);
  set data(DataAccount v) {
    setField(8, v);
  }

  bool hasData() => $_has(0);
  void clearData() => clearField(8);
}

class NetSetAccountType extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetSetAccountType',
      package: const $pb.PackageName('inf'))
    ..e<AccountType>(1, 'accountType', $pb.PbFieldType.OE,
        AccountType.AT_UNKNOWN, AccountType.valueOf, AccountType.values)
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
    if (v is! NetSetAccountType) $pb.checkItemFailed(v, _i.messageName);
  }

  AccountType get accountType => $_getN(0);
  set accountType(AccountType v) {
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
    if (v is! NetSetFirebaseToken) $pb.checkItemFailed(v, _i.messageName);
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
    if (v is! NetOAuthUrlReq) $pb.checkItemFailed(v, _i.messageName);
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
    if (v is! NetOAuthUrlRes) $pb.checkItemFailed(v, _i.messageName);
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
    if (v is! NetOAuthConnectReq) $pb.checkItemFailed(v, _i.messageName);
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
    ..a<DataSocialMedia>(1, 'socialMedia', $pb.PbFieldType.OM,
        DataSocialMedia.getDefault, DataSocialMedia.create)
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
    if (v is! NetOAuthConnectRes) $pb.checkItemFailed(v, _i.messageName);
  }

  DataSocialMedia get socialMedia => $_getN(0);
  set socialMedia(DataSocialMedia v) {
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
    if (v is! NetAccountCreateReq) $pb.checkItemFailed(v, _i.messageName);
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

class NetUploadImageReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetUploadImageReq',
      package: const $pb.PackageName('inf'))
    ..aOS(1, 'fileName')
    ..a<int>(2, 'contentLength', $pb.PbFieldType.O3)
    ..a<List<int>>(3, 'contentSha256', $pb.PbFieldType.OY)
    ..aOS(4, 'contentType')
    ..hasRequiredFields = false;

  NetUploadImageReq() : super();
  NetUploadImageReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetUploadImageReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetUploadImageReq clone() => new NetUploadImageReq()..mergeFromMessage(this);
  NetUploadImageReq copyWith(void Function(NetUploadImageReq) updates) =>
      super.copyWith((message) => updates(message as NetUploadImageReq));
  $pb.BuilderInfo get info_ => _i;
  static NetUploadImageReq create() => new NetUploadImageReq();
  static $pb.PbList<NetUploadImageReq> createRepeated() =>
      new $pb.PbList<NetUploadImageReq>();
  static NetUploadImageReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetUploadImageReq _defaultInstance;
  static void $checkItem(NetUploadImageReq v) {
    if (v is! NetUploadImageReq) $pb.checkItemFailed(v, _i.messageName);
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

class NetUploadImageRes extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetUploadImageRes',
      package: const $pb.PackageName('inf'))
    ..aOS(1, 'requestMethod')
    ..aOS(2, 'requestUrl')
    ..aOB(9, 'fileExists')
    ..aOS(10, 'uploadKey')
    ..aOS(11, 'coverUrl')
    ..aOS(12, 'thumbnailUrl')
    ..hasRequiredFields = false;

  NetUploadImageRes() : super();
  NetUploadImageRes.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetUploadImageRes.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetUploadImageRes clone() => new NetUploadImageRes()..mergeFromMessage(this);
  NetUploadImageRes copyWith(void Function(NetUploadImageRes) updates) =>
      super.copyWith((message) => updates(message as NetUploadImageRes));
  $pb.BuilderInfo get info_ => _i;
  static NetUploadImageRes create() => new NetUploadImageRes();
  static $pb.PbList<NetUploadImageRes> createRepeated() =>
      new $pb.PbList<NetUploadImageRes>();
  static NetUploadImageRes getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetUploadImageRes _defaultInstance;
  static void $checkItem(NetUploadImageRes v) {
    if (v is! NetUploadImageRes) $pb.checkItemFailed(v, _i.messageName);
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

class NetSetProfile extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetSetProfile',
      package: const $pb.PackageName('inf'))
    ..aOS(1, 'name')
    ..aOS(2, 'description')
    ..aOS(4, 'avatarKey')
    ..aOS(6, 'url')
    ..pp<CategoryId>(12, 'categories', $pb.PbFieldType.PM,
        CategoryId.$checkItem, CategoryId.create)
    ..a<double>(14, 'latitude', $pb.PbFieldType.OD)
    ..a<double>(15, 'longitude', $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  NetSetProfile() : super();
  NetSetProfile.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetSetProfile.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetSetProfile clone() => new NetSetProfile()..mergeFromMessage(this);
  NetSetProfile copyWith(void Function(NetSetProfile) updates) =>
      super.copyWith((message) => updates(message as NetSetProfile));
  $pb.BuilderInfo get info_ => _i;
  static NetSetProfile create() => new NetSetProfile();
  static $pb.PbList<NetSetProfile> createRepeated() =>
      new $pb.PbList<NetSetProfile>();
  static NetSetProfile getDefault() => _defaultInstance ??= create()..freeze();
  static NetSetProfile _defaultInstance;
  static void $checkItem(NetSetProfile v) {
    if (v is! NetSetProfile) $pb.checkItemFailed(v, _i.messageName);
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

class NetCreateOfferReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetCreateOfferReq',
      package: const $pb.PackageName('inf'))
    ..aOS(1, 'title')
    ..pPS(2, 'imageKeys')
    ..aOS(3, 'description')
    ..aOS(4, 'deliverables')
    ..aOS(5, 'reward')
    ..a<int>(6, 'locationId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetCreateOfferReq() : super();
  NetCreateOfferReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetCreateOfferReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetCreateOfferReq clone() => new NetCreateOfferReq()..mergeFromMessage(this);
  NetCreateOfferReq copyWith(void Function(NetCreateOfferReq) updates) =>
      super.copyWith((message) => updates(message as NetCreateOfferReq));
  $pb.BuilderInfo get info_ => _i;
  static NetCreateOfferReq create() => new NetCreateOfferReq();
  static $pb.PbList<NetCreateOfferReq> createRepeated() =>
      new $pb.PbList<NetCreateOfferReq>();
  static NetCreateOfferReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetCreateOfferReq _defaultInstance;
  static void $checkItem(NetCreateOfferReq v) {
    if (v is! NetCreateOfferReq) $pb.checkItemFailed(v, _i.messageName);
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

class NetLoadOffersReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetLoadOffersReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'before', $pb.PbFieldType.O3)
    ..a<int>(2, 'after', $pb.PbFieldType.O3)
    ..a<int>(3, 'limit', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetLoadOffersReq() : super();
  NetLoadOffersReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetLoadOffersReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetLoadOffersReq clone() => new NetLoadOffersReq()..mergeFromMessage(this);
  NetLoadOffersReq copyWith(void Function(NetLoadOffersReq) updates) =>
      super.copyWith((message) => updates(message as NetLoadOffersReq));
  $pb.BuilderInfo get info_ => _i;
  static NetLoadOffersReq create() => new NetLoadOffersReq();
  static $pb.PbList<NetLoadOffersReq> createRepeated() =>
      new $pb.PbList<NetLoadOffersReq>();
  static NetLoadOffersReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetLoadOffersReq _defaultInstance;
  static void $checkItem(NetLoadOffersReq v) {
    if (v is! NetLoadOffersReq) $pb.checkItemFailed(v, _i.messageName);
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

class NetLoadOffersRes extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetLoadOffersRes',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'oldest', $pb.PbFieldType.O3)
    ..a<int>(2, 'newest', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetLoadOffersRes() : super();
  NetLoadOffersRes.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetLoadOffersRes.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetLoadOffersRes clone() => new NetLoadOffersRes()..mergeFromMessage(this);
  NetLoadOffersRes copyWith(void Function(NetLoadOffersRes) updates) =>
      super.copyWith((message) => updates(message as NetLoadOffersRes));
  $pb.BuilderInfo get info_ => _i;
  static NetLoadOffersRes create() => new NetLoadOffersRes();
  static $pb.PbList<NetLoadOffersRes> createRepeated() =>
      new $pb.PbList<NetLoadOffersRes>();
  static NetLoadOffersRes getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetLoadOffersRes _defaultInstance;
  static void $checkItem(NetLoadOffersRes v) {
    if (v is! NetLoadOffersRes) $pb.checkItemFailed(v, _i.messageName);
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

class NetOfferApplyReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetOfferApplyReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'offerId', $pb.PbFieldType.O3)
    ..aOS(2, 'remarks')
    ..a<int>(8, 'deviceGhostId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetOfferApplyReq() : super();
  NetOfferApplyReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetOfferApplyReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetOfferApplyReq clone() => new NetOfferApplyReq()..mergeFromMessage(this);
  NetOfferApplyReq copyWith(void Function(NetOfferApplyReq) updates) =>
      super.copyWith((message) => updates(message as NetOfferApplyReq));
  $pb.BuilderInfo get info_ => _i;
  static NetOfferApplyReq create() => new NetOfferApplyReq();
  static $pb.PbList<NetOfferApplyReq> createRepeated() =>
      new $pb.PbList<NetOfferApplyReq>();
  static NetOfferApplyReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetOfferApplyReq _defaultInstance;
  static void $checkItem(NetOfferApplyReq v) {
    if (v is! NetOfferApplyReq) $pb.checkItemFailed(v, _i.messageName);
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

  int get deviceGhostId => $_get(2, 0);
  set deviceGhostId(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasDeviceGhostId() => $_has(2);
  void clearDeviceGhostId() => clearField(8);
}

class NetLoadApplicantsReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetLoadApplicantsReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'before', $pb.PbFieldType.O3)
    ..a<int>(2, 'after', $pb.PbFieldType.O3)
    ..a<int>(3, 'limit', $pb.PbFieldType.O3)
    ..a<int>(4, 'offerId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetLoadApplicantsReq() : super();
  NetLoadApplicantsReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetLoadApplicantsReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetLoadApplicantsReq clone() =>
      new NetLoadApplicantsReq()..mergeFromMessage(this);
  NetLoadApplicantsReq copyWith(void Function(NetLoadApplicantsReq) updates) =>
      super.copyWith((message) => updates(message as NetLoadApplicantsReq));
  $pb.BuilderInfo get info_ => _i;
  static NetLoadApplicantsReq create() => new NetLoadApplicantsReq();
  static $pb.PbList<NetLoadApplicantsReq> createRepeated() =>
      new $pb.PbList<NetLoadApplicantsReq>();
  static NetLoadApplicantsReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetLoadApplicantsReq _defaultInstance;
  static void $checkItem(NetLoadApplicantsReq v) {
    if (v is! NetLoadApplicantsReq) $pb.checkItemFailed(v, _i.messageName);
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

  int get offerId => $_get(3, 0);
  set offerId(int v) {
    $_setSignedInt32(3, v);
  }

  bool hasOfferId() => $_has(3);
  void clearOfferId() => clearField(4);
}

class NetLoadApplicantReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetLoadApplicantReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetLoadApplicantReq() : super();
  NetLoadApplicantReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetLoadApplicantReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetLoadApplicantReq clone() =>
      new NetLoadApplicantReq()..mergeFromMessage(this);
  NetLoadApplicantReq copyWith(void Function(NetLoadApplicantReq) updates) =>
      super.copyWith((message) => updates(message as NetLoadApplicantReq));
  $pb.BuilderInfo get info_ => _i;
  static NetLoadApplicantReq create() => new NetLoadApplicantReq();
  static $pb.PbList<NetLoadApplicantReq> createRepeated() =>
      new $pb.PbList<NetLoadApplicantReq>();
  static NetLoadApplicantReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetLoadApplicantReq _defaultInstance;
  static void $checkItem(NetLoadApplicantReq v) {
    if (v is! NetLoadApplicantReq) $pb.checkItemFailed(v, _i.messageName);
  }

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);
}

class NetLoadApplicantChatsReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'NetLoadApplicantChatsReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'before', $pb.PbFieldType.O3)
    ..a<int>(2, 'after', $pb.PbFieldType.O3)
    ..a<int>(3, 'limit', $pb.PbFieldType.O3)
    ..a<int>(5, 'applicantId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetLoadApplicantChatsReq() : super();
  NetLoadApplicantChatsReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetLoadApplicantChatsReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetLoadApplicantChatsReq clone() =>
      new NetLoadApplicantChatsReq()..mergeFromMessage(this);
  NetLoadApplicantChatsReq copyWith(
          void Function(NetLoadApplicantChatsReq) updates) =>
      super.copyWith((message) => updates(message as NetLoadApplicantChatsReq));
  $pb.BuilderInfo get info_ => _i;
  static NetLoadApplicantChatsReq create() => new NetLoadApplicantChatsReq();
  static $pb.PbList<NetLoadApplicantChatsReq> createRepeated() =>
      new $pb.PbList<NetLoadApplicantChatsReq>();
  static NetLoadApplicantChatsReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetLoadApplicantChatsReq _defaultInstance;
  static void $checkItem(NetLoadApplicantChatsReq v) {
    if (v is! NetLoadApplicantChatsReq) $pb.checkItemFailed(v, _i.messageName);
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

  int get applicantId => $_get(3, 0);
  set applicantId(int v) {
    $_setSignedInt32(3, v);
  }

  bool hasApplicantId() => $_has(3);
  void clearApplicantId() => clearField(5);
}

class NetChatPlain extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('NetChatPlain', package: const $pb.PackageName('inf'))
        ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
        ..aOS(6, 'text')
        ..a<int>(8, 'deviceGhostId', $pb.PbFieldType.O3)
        ..hasRequiredFields = false;

  NetChatPlain() : super();
  NetChatPlain.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetChatPlain.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetChatPlain clone() => new NetChatPlain()..mergeFromMessage(this);
  NetChatPlain copyWith(void Function(NetChatPlain) updates) =>
      super.copyWith((message) => updates(message as NetChatPlain));
  $pb.BuilderInfo get info_ => _i;
  static NetChatPlain create() => new NetChatPlain();
  static $pb.PbList<NetChatPlain> createRepeated() =>
      new $pb.PbList<NetChatPlain>();
  static NetChatPlain getDefault() => _defaultInstance ??= create()..freeze();
  static NetChatPlain _defaultInstance;
  static void $checkItem(NetChatPlain v) {
    if (v is! NetChatPlain) $pb.checkItemFailed(v, _i.messageName);
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

  int get deviceGhostId => $_get(2, 0);
  set deviceGhostId(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasDeviceGhostId() => $_has(2);
  void clearDeviceGhostId() => clearField(8);
}

class NetChatHaggle extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetChatHaggle',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..aOS(2, 'remarks')
    ..aOS(3, 'deliverables')
    ..aOS(4, 'reward')
    ..a<int>(8, 'deviceGhostId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetChatHaggle() : super();
  NetChatHaggle.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetChatHaggle.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetChatHaggle clone() => new NetChatHaggle()..mergeFromMessage(this);
  NetChatHaggle copyWith(void Function(NetChatHaggle) updates) =>
      super.copyWith((message) => updates(message as NetChatHaggle));
  $pb.BuilderInfo get info_ => _i;
  static NetChatHaggle create() => new NetChatHaggle();
  static $pb.PbList<NetChatHaggle> createRepeated() =>
      new $pb.PbList<NetChatHaggle>();
  static NetChatHaggle getDefault() => _defaultInstance ??= create()..freeze();
  static NetChatHaggle _defaultInstance;
  static void $checkItem(NetChatHaggle v) {
    if (v is! NetChatHaggle) $pb.checkItemFailed(v, _i.messageName);
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

  int get deviceGhostId => $_get(4, 0);
  set deviceGhostId(int v) {
    $_setSignedInt32(4, v);
  }

  bool hasDeviceGhostId() => $_has(4);
  void clearDeviceGhostId() => clearField(8);
}

class NetChatImageKey extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetChatImageKey',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..aOS(5, 'imageKey')
    ..a<int>(8, 'deviceGhostId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetChatImageKey() : super();
  NetChatImageKey.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetChatImageKey.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetChatImageKey clone() => new NetChatImageKey()..mergeFromMessage(this);
  NetChatImageKey copyWith(void Function(NetChatImageKey) updates) =>
      super.copyWith((message) => updates(message as NetChatImageKey));
  $pb.BuilderInfo get info_ => _i;
  static NetChatImageKey create() => new NetChatImageKey();
  static $pb.PbList<NetChatImageKey> createRepeated() =>
      new $pb.PbList<NetChatImageKey>();
  static NetChatImageKey getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetChatImageKey _defaultInstance;
  static void $checkItem(NetChatImageKey v) {
    if (v is! NetChatImageKey) $pb.checkItemFailed(v, _i.messageName);
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

  int get deviceGhostId => $_get(2, 0);
  set deviceGhostId(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasDeviceGhostId() => $_has(2);
  void clearDeviceGhostId() => clearField(8);
}

class NetApplicantWantDealReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'NetApplicantWantDealReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..aInt64(2, 'haggleChatId')
    ..hasRequiredFields = false;

  NetApplicantWantDealReq() : super();
  NetApplicantWantDealReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetApplicantWantDealReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetApplicantWantDealReq clone() =>
      new NetApplicantWantDealReq()..mergeFromMessage(this);
  NetApplicantWantDealReq copyWith(
          void Function(NetApplicantWantDealReq) updates) =>
      super.copyWith((message) => updates(message as NetApplicantWantDealReq));
  $pb.BuilderInfo get info_ => _i;
  static NetApplicantWantDealReq create() => new NetApplicantWantDealReq();
  static $pb.PbList<NetApplicantWantDealReq> createRepeated() =>
      new $pb.PbList<NetApplicantWantDealReq>();
  static NetApplicantWantDealReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetApplicantWantDealReq _defaultInstance;
  static void $checkItem(NetApplicantWantDealReq v) {
    if (v is! NetApplicantWantDealReq) $pb.checkItemFailed(v, _i.messageName);
  }

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);

  Int64 get haggleChatId => $_getI64(1);
  set haggleChatId(Int64 v) {
    $_setInt64(1, v);
  }

  bool hasHaggleChatId() => $_has(1);
  void clearHaggleChatId() => clearField(2);
}

class NetApplicantRejectReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetApplicantRejectReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..aOS(2, 'reason')
    ..hasRequiredFields = false;

  NetApplicantRejectReq() : super();
  NetApplicantRejectReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetApplicantRejectReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetApplicantRejectReq clone() =>
      new NetApplicantRejectReq()..mergeFromMessage(this);
  NetApplicantRejectReq copyWith(
          void Function(NetApplicantRejectReq) updates) =>
      super.copyWith((message) => updates(message as NetApplicantRejectReq));
  $pb.BuilderInfo get info_ => _i;
  static NetApplicantRejectReq create() => new NetApplicantRejectReq();
  static $pb.PbList<NetApplicantRejectReq> createRepeated() =>
      new $pb.PbList<NetApplicantRejectReq>();
  static NetApplicantRejectReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetApplicantRejectReq _defaultInstance;
  static void $checkItem(NetApplicantRejectReq v) {
    if (v is! NetApplicantRejectReq) $pb.checkItemFailed(v, _i.messageName);
  }

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);

  String get reason => $_getS(1, '');
  set reason(String v) {
    $_setString(1, v);
  }

  bool hasReason() => $_has(1);
  void clearReason() => clearField(2);
}

class NetApplicantReportReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetApplicantReportReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..aOS(2, 'text')
    ..hasRequiredFields = false;

  NetApplicantReportReq() : super();
  NetApplicantReportReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetApplicantReportReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetApplicantReportReq clone() =>
      new NetApplicantReportReq()..mergeFromMessage(this);
  NetApplicantReportReq copyWith(
          void Function(NetApplicantReportReq) updates) =>
      super.copyWith((message) => updates(message as NetApplicantReportReq));
  $pb.BuilderInfo get info_ => _i;
  static NetApplicantReportReq create() => new NetApplicantReportReq();
  static $pb.PbList<NetApplicantReportReq> createRepeated() =>
      new $pb.PbList<NetApplicantReportReq>();
  static NetApplicantReportReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetApplicantReportReq _defaultInstance;
  static void $checkItem(NetApplicantReportReq v) {
    if (v is! NetApplicantReportReq) $pb.checkItemFailed(v, _i.messageName);
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
  void clearText() => clearField(2);
}

class NetApplicantCompletionReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'NetApplicantCompletionReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..aOB(2, 'delivered')
    ..aOB(3, 'rewarded')
    ..a<int>(4, 'rating', $pb.PbFieldType.O3)
    ..aOB(5, 'dispute')
    ..aOS(6, 'disputeDescription')
    ..hasRequiredFields = false;

  NetApplicantCompletionReq() : super();
  NetApplicantCompletionReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetApplicantCompletionReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetApplicantCompletionReq clone() =>
      new NetApplicantCompletionReq()..mergeFromMessage(this);
  NetApplicantCompletionReq copyWith(
          void Function(NetApplicantCompletionReq) updates) =>
      super
          .copyWith((message) => updates(message as NetApplicantCompletionReq));
  $pb.BuilderInfo get info_ => _i;
  static NetApplicantCompletionReq create() => new NetApplicantCompletionReq();
  static $pb.PbList<NetApplicantCompletionReq> createRepeated() =>
      new $pb.PbList<NetApplicantCompletionReq>();
  static NetApplicantCompletionReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetApplicantCompletionReq _defaultInstance;
  static void $checkItem(NetApplicantCompletionReq v) {
    if (v is! NetApplicantCompletionReq) $pb.checkItemFailed(v, _i.messageName);
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

class NetApplicantCommonRes extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetApplicantCommonRes',
      package: const $pb.PackageName('inf'))
    ..a<DataApplicant>(1, 'updateApplicant', $pb.PbFieldType.OM,
        DataApplicant.getDefault, DataApplicant.create)
    ..pp<DataApplicantChat>(2, 'newChats', $pb.PbFieldType.PM,
        DataApplicantChat.$checkItem, DataApplicantChat.create)
    ..hasRequiredFields = false;

  NetApplicantCommonRes() : super();
  NetApplicantCommonRes.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetApplicantCommonRes.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetApplicantCommonRes clone() =>
      new NetApplicantCommonRes()..mergeFromMessage(this);
  NetApplicantCommonRes copyWith(
          void Function(NetApplicantCommonRes) updates) =>
      super.copyWith((message) => updates(message as NetApplicantCommonRes));
  $pb.BuilderInfo get info_ => _i;
  static NetApplicantCommonRes create() => new NetApplicantCommonRes();
  static $pb.PbList<NetApplicantCommonRes> createRepeated() =>
      new $pb.PbList<NetApplicantCommonRes>();
  static NetApplicantCommonRes getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetApplicantCommonRes _defaultInstance;
  static void $checkItem(NetApplicantCommonRes v) {
    if (v is! NetApplicantCommonRes) $pb.checkItemFailed(v, _i.messageName);
  }

  DataApplicant get updateApplicant => $_getN(0);
  set updateApplicant(DataApplicant v) {
    setField(1, v);
  }

  bool hasUpdateApplicant() => $_has(0);
  void clearUpdateApplicant() => clearField(1);

  List<DataApplicantChat> get newChats => $_getList(1);
}

class NetLoadPublicProfileReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'NetLoadPublicProfileReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'accountId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetLoadPublicProfileReq() : super();
  NetLoadPublicProfileReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetLoadPublicProfileReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetLoadPublicProfileReq clone() =>
      new NetLoadPublicProfileReq()..mergeFromMessage(this);
  NetLoadPublicProfileReq copyWith(
          void Function(NetLoadPublicProfileReq) updates) =>
      super.copyWith((message) => updates(message as NetLoadPublicProfileReq));
  $pb.BuilderInfo get info_ => _i;
  static NetLoadPublicProfileReq create() => new NetLoadPublicProfileReq();
  static $pb.PbList<NetLoadPublicProfileReq> createRepeated() =>
      new $pb.PbList<NetLoadPublicProfileReq>();
  static NetLoadPublicProfileReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetLoadPublicProfileReq _defaultInstance;
  static void $checkItem(NetLoadPublicProfileReq v) {
    if (v is! NetLoadPublicProfileReq) $pb.checkItemFailed(v, _i.messageName);
  }

  int get accountId => $_get(0, 0);
  set accountId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasAccountId() => $_has(0);
  void clearAccountId() => clearField(1);
}
