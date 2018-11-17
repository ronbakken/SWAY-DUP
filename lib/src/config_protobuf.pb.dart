///
//  Generated code. Do not modify.
//  source: config_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'enum_protobuf.pbenum.dart' as $0;

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
    if (v is! ConfigSubCategories)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
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
    if (v is! ConfigCategories) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<ConfigSubCategories> get sub => $_getList(0);
}

class ConfigOAuthProvider extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigOAuthProvider',
      package: const $pb.PackageName('inf'))
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
    if (v is! ConfigOAuthProviders)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<ConfigOAuthProvider> get all => $_getList(0);
}

class ConfigServices extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigServices',
      package: const $pb.PackageName('inf'))
    ..aOS(1, 'mapboxApi')
    ..aOS(2, 'mapboxUrlTemplateDark')
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
    ..aOS(30, 'mapboxUrlTemplateLight')
    ..aOS(31, 'cloudinaryBlurredThumbnailUrl')
    ..aOS(32, 'cloudinaryBlurredCoverUrl')
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

  String get mapboxUrlTemplateLight => $_getS(29, '');
  set mapboxUrlTemplateLight(String v) {
    $_setString(29, v);
  }

  bool hasMapboxUrlTemplateLight() => $_has(29);
  void clearMapboxUrlTemplateLight() => clearField(30);

  String get cloudinaryBlurredThumbnailUrl => $_getS(30, '');
  set cloudinaryBlurredThumbnailUrl(String v) {
    $_setString(30, v);
  }

  bool hasCloudinaryBlurredThumbnailUrl() => $_has(30);
  void clearCloudinaryBlurredThumbnailUrl() => clearField(31);

  String get cloudinaryBlurredCoverUrl => $_getS(31, '');
  set cloudinaryBlurredCoverUrl(String v) {
    $_setString(31, v);
  }

  bool hasCloudinaryBlurredCoverUrl() => $_has(31);
  void clearCloudinaryBlurredCoverUrl() => clearField(32);
}

class ConfigContent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConfigContent',
      package: const $pb.PackageName('inf'))
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
        ..a<ConfigContent>(7, 'content', $pb.PbFieldType.OM,
            ConfigContent.getDefault, ConfigContent.create)
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

  ConfigContent get content => $_getN(5);
  set content(ConfigContent v) {
    setField(7, v);
  }

  bool hasContent() => $_has(5);
  void clearContent() => clearField(7);
}
