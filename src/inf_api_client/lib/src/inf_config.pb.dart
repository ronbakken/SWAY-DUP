///
//  Generated code. Do not modify.
//  source: inf_config.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'category.pb.dart' as $4;
import 'social_network_provider.pb.dart' as $2;
import 'deliverable.pb.dart' as $5;

class InfVersionInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('InfVersionInfo', package: const $pb.PackageName('api'))
    ..a<int>(1, 'apiVersion', $pb.PbFieldType.O3)
    ..a<int>(2, 'configVersion', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  InfVersionInfo() : super();
  InfVersionInfo.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  InfVersionInfo.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  InfVersionInfo clone() => new InfVersionInfo()..mergeFromMessage(this);
  InfVersionInfo copyWith(void Function(InfVersionInfo) updates) => super.copyWith((message) => updates(message as InfVersionInfo));
  $pb.BuilderInfo get info_ => _i;
  static InfVersionInfo create() => new InfVersionInfo();
  InfVersionInfo createEmptyInstance() => create();
  static $pb.PbList<InfVersionInfo> createRepeated() => new $pb.PbList<InfVersionInfo>();
  static InfVersionInfo getDefault() => _defaultInstance ??= create()..freeze();
  static InfVersionInfo _defaultInstance;
  static void $checkItem(InfVersionInfo v) {
    if (v is! InfVersionInfo) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get apiVersion => $_get(0, 0);
  set apiVersion(int v) { $_setSignedInt32(0, v); }
  bool hasApiVersion() => $_has(0);
  void clearApiVersion() => clearField(1);

  int get configVersion => $_get(1, 0);
  set configVersion(int v) { $_setSignedInt32(1, v); }
  bool hasConfigVersion() => $_has(1);
  void clearConfigVersion() => clearField(2);
}

class AppConfigData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AppConfigData', package: const $pb.PackageName('api'))
    ..a<int>(1, 'configVersion', $pb.PbFieldType.O3)
    ..a<ServiceConfig>(5, 'serviceConfig', $pb.PbFieldType.OM, ServiceConfig.getDefault, ServiceConfig.create)
    ..pp<$4.Category>(6, 'categories', $pb.PbFieldType.PM, $4.Category.$checkItem, $4.Category.create)
    ..pp<$2.SocialNetworkProvider>(7, 'socialNetworkProviders', $pb.PbFieldType.PM, $2.SocialNetworkProvider.$checkItem, $2.SocialNetworkProvider.create)
    ..pp<$5.DeliverableIcon>(8, 'deliverableIcons', $pb.PbFieldType.PM, $5.DeliverableIcon.$checkItem, $5.DeliverableIcon.create)
    ..aOS(10, 'termsOfServiceUrl')
    ..aOS(11, 'privacyPolicyUrl')
    ..aOB(12, 'userNeedInvitationToSignUp')
    ..hasRequiredFields = false
  ;

  AppConfigData() : super();
  AppConfigData.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AppConfigData.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AppConfigData clone() => new AppConfigData()..mergeFromMessage(this);
  AppConfigData copyWith(void Function(AppConfigData) updates) => super.copyWith((message) => updates(message as AppConfigData));
  $pb.BuilderInfo get info_ => _i;
  static AppConfigData create() => new AppConfigData();
  AppConfigData createEmptyInstance() => create();
  static $pb.PbList<AppConfigData> createRepeated() => new $pb.PbList<AppConfigData>();
  static AppConfigData getDefault() => _defaultInstance ??= create()..freeze();
  static AppConfigData _defaultInstance;
  static void $checkItem(AppConfigData v) {
    if (v is! AppConfigData) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get configVersion => $_get(0, 0);
  set configVersion(int v) { $_setSignedInt32(0, v); }
  bool hasConfigVersion() => $_has(0);
  void clearConfigVersion() => clearField(1);

  ServiceConfig get serviceConfig => $_getN(1);
  set serviceConfig(ServiceConfig v) { setField(5, v); }
  bool hasServiceConfig() => $_has(1);
  void clearServiceConfig() => clearField(5);

  List<$4.Category> get categories => $_getList(2);

  List<$2.SocialNetworkProvider> get socialNetworkProviders => $_getList(3);

  List<$5.DeliverableIcon> get deliverableIcons => $_getList(4);

  String get termsOfServiceUrl => $_getS(5, '');
  set termsOfServiceUrl(String v) { $_setString(5, v); }
  bool hasTermsOfServiceUrl() => $_has(5);
  void clearTermsOfServiceUrl() => clearField(10);

  String get privacyPolicyUrl => $_getS(6, '');
  set privacyPolicyUrl(String v) { $_setString(6, v); }
  bool hasPrivacyPolicyUrl() => $_has(6);
  void clearPrivacyPolicyUrl() => clearField(11);

  bool get userNeedInvitationToSignUp => $_get(7, false);
  set userNeedInvitationToSignUp(bool v) { $_setBool(7, v); }
  bool hasUserNeedInvitationToSignUp() => $_has(7);
  void clearUserNeedInvitationToSignUp() => clearField(12);
}

class ServiceConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ServiceConfig', package: const $pb.PackageName('api'))
    ..aOS(1, 'mapboxUrlTemplateDark')
    ..aOS(2, 'mapboxUrlTemplateLight')
    ..aOS(3, 'mapboxToken')
    ..hasRequiredFields = false
  ;

  ServiceConfig() : super();
  ServiceConfig.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ServiceConfig.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ServiceConfig clone() => new ServiceConfig()..mergeFromMessage(this);
  ServiceConfig copyWith(void Function(ServiceConfig) updates) => super.copyWith((message) => updates(message as ServiceConfig));
  $pb.BuilderInfo get info_ => _i;
  static ServiceConfig create() => new ServiceConfig();
  ServiceConfig createEmptyInstance() => create();
  static $pb.PbList<ServiceConfig> createRepeated() => new $pb.PbList<ServiceConfig>();
  static ServiceConfig getDefault() => _defaultInstance ??= create()..freeze();
  static ServiceConfig _defaultInstance;
  static void $checkItem(ServiceConfig v) {
    if (v is! ServiceConfig) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get mapboxUrlTemplateDark => $_getS(0, '');
  set mapboxUrlTemplateDark(String v) { $_setString(0, v); }
  bool hasMapboxUrlTemplateDark() => $_has(0);
  void clearMapboxUrlTemplateDark() => clearField(1);

  String get mapboxUrlTemplateLight => $_getS(1, '');
  set mapboxUrlTemplateLight(String v) { $_setString(1, v); }
  bool hasMapboxUrlTemplateLight() => $_has(1);
  void clearMapboxUrlTemplateLight() => clearField(2);

  String get mapboxToken => $_getS(2, '');
  set mapboxToken(String v) { $_setString(2, v); }
  bool hasMapboxToken() => $_has(2);
  void clearMapboxToken() => clearField(3);
}

class WelcomeImages extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('WelcomeImages', package: const $pb.PackageName('api'))
    ..pPS(1, 'imageUrls')
    ..hasRequiredFields = false
  ;

  WelcomeImages() : super();
  WelcomeImages.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  WelcomeImages.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  WelcomeImages clone() => new WelcomeImages()..mergeFromMessage(this);
  WelcomeImages copyWith(void Function(WelcomeImages) updates) => super.copyWith((message) => updates(message as WelcomeImages));
  $pb.BuilderInfo get info_ => _i;
  static WelcomeImages create() => new WelcomeImages();
  WelcomeImages createEmptyInstance() => create();
  static $pb.PbList<WelcomeImages> createRepeated() => new $pb.PbList<WelcomeImages>();
  static WelcomeImages getDefault() => _defaultInstance ??= create()..freeze();
  static WelcomeImages _defaultInstance;
  static void $checkItem(WelcomeImages v) {
    if (v is! WelcomeImages) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<String> get imageUrls => $_getList(0);
}

