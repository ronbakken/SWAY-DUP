///
//  Generated code. Do not modify.
//  source: inf_config.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'category.pb.dart' as $5;
import 'social_network_provider.pb.dart' as $6;
import 'deliverable.pb.dart' as $7;

class GetVersionsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetVersionsResponse', package: const $pb.PackageName('api'))
    ..a<InfVersionInfoDto>(1, 'versionInfo', $pb.PbFieldType.OM, InfVersionInfoDto.getDefault, InfVersionInfoDto.create)
    ..hasRequiredFields = false
  ;

  GetVersionsResponse() : super();
  GetVersionsResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetVersionsResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetVersionsResponse clone() => new GetVersionsResponse()..mergeFromMessage(this);
  GetVersionsResponse copyWith(void Function(GetVersionsResponse) updates) => super.copyWith((message) => updates(message as GetVersionsResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetVersionsResponse create() => new GetVersionsResponse();
  GetVersionsResponse createEmptyInstance() => create();
  static $pb.PbList<GetVersionsResponse> createRepeated() => new $pb.PbList<GetVersionsResponse>();
  static GetVersionsResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetVersionsResponse _defaultInstance;
  static void $checkItem(GetVersionsResponse v) {
    if (v is! GetVersionsResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  InfVersionInfoDto get versionInfo => $_getN(0);
  set versionInfo(InfVersionInfoDto v) { setField(1, v); }
  bool hasVersionInfo() => $_has(0);
  void clearVersionInfo() => clearField(1);
}

class GetAppConfigResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetAppConfigResponse', package: const $pb.PackageName('api'))
    ..a<AppConfigDto>(1, 'appConfigData', $pb.PbFieldType.OM, AppConfigDto.getDefault, AppConfigDto.create)
    ..hasRequiredFields = false
  ;

  GetAppConfigResponse() : super();
  GetAppConfigResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetAppConfigResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetAppConfigResponse clone() => new GetAppConfigResponse()..mergeFromMessage(this);
  GetAppConfigResponse copyWith(void Function(GetAppConfigResponse) updates) => super.copyWith((message) => updates(message as GetAppConfigResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetAppConfigResponse create() => new GetAppConfigResponse();
  GetAppConfigResponse createEmptyInstance() => create();
  static $pb.PbList<GetAppConfigResponse> createRepeated() => new $pb.PbList<GetAppConfigResponse>();
  static GetAppConfigResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetAppConfigResponse _defaultInstance;
  static void $checkItem(GetAppConfigResponse v) {
    if (v is! GetAppConfigResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  AppConfigDto get appConfigData => $_getN(0);
  set appConfigData(AppConfigDto v) { setField(1, v); }
  bool hasAppConfigData() => $_has(0);
  void clearAppConfigData() => clearField(1);
}

class InfVersionInfoDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('InfVersionInfoDto', package: const $pb.PackageName('api'))
    ..a<int>(1, 'apiVersion', $pb.PbFieldType.O3)
    ..a<int>(2, 'configVersion', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  InfVersionInfoDto() : super();
  InfVersionInfoDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  InfVersionInfoDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  InfVersionInfoDto clone() => new InfVersionInfoDto()..mergeFromMessage(this);
  InfVersionInfoDto copyWith(void Function(InfVersionInfoDto) updates) => super.copyWith((message) => updates(message as InfVersionInfoDto));
  $pb.BuilderInfo get info_ => _i;
  static InfVersionInfoDto create() => new InfVersionInfoDto();
  InfVersionInfoDto createEmptyInstance() => create();
  static $pb.PbList<InfVersionInfoDto> createRepeated() => new $pb.PbList<InfVersionInfoDto>();
  static InfVersionInfoDto getDefault() => _defaultInstance ??= create()..freeze();
  static InfVersionInfoDto _defaultInstance;
  static void $checkItem(InfVersionInfoDto v) {
    if (v is! InfVersionInfoDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
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

class AppConfigDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AppConfigDto', package: const $pb.PackageName('api'))
    ..a<int>(1, 'configVersion', $pb.PbFieldType.O3)
    ..a<ServiceConfigDto>(5, 'serviceConfig', $pb.PbFieldType.OM, ServiceConfigDto.getDefault, ServiceConfigDto.create)
    ..pp<$5.CategoryDto>(6, 'categories', $pb.PbFieldType.PM, $5.CategoryDto.$checkItem, $5.CategoryDto.create)
    ..pp<$6.SocialNetworkProviderDto>(7, 'socialNetworkProviders', $pb.PbFieldType.PM, $6.SocialNetworkProviderDto.$checkItem, $6.SocialNetworkProviderDto.create)
    ..pp<$7.DeliverableIconDto>(8, 'deliverableIcons', $pb.PbFieldType.PM, $7.DeliverableIconDto.$checkItem, $7.DeliverableIconDto.create)
    ..aOS(10, 'termsOfServiceUrl')
    ..aOS(11, 'privacyPolicyUrl')
    ..aOB(12, 'userNeedInvitationToSignUp')
    ..hasRequiredFields = false
  ;

  AppConfigDto() : super();
  AppConfigDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AppConfigDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AppConfigDto clone() => new AppConfigDto()..mergeFromMessage(this);
  AppConfigDto copyWith(void Function(AppConfigDto) updates) => super.copyWith((message) => updates(message as AppConfigDto));
  $pb.BuilderInfo get info_ => _i;
  static AppConfigDto create() => new AppConfigDto();
  AppConfigDto createEmptyInstance() => create();
  static $pb.PbList<AppConfigDto> createRepeated() => new $pb.PbList<AppConfigDto>();
  static AppConfigDto getDefault() => _defaultInstance ??= create()..freeze();
  static AppConfigDto _defaultInstance;
  static void $checkItem(AppConfigDto v) {
    if (v is! AppConfigDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get configVersion => $_get(0, 0);
  set configVersion(int v) { $_setSignedInt32(0, v); }
  bool hasConfigVersion() => $_has(0);
  void clearConfigVersion() => clearField(1);

  ServiceConfigDto get serviceConfig => $_getN(1);
  set serviceConfig(ServiceConfigDto v) { setField(5, v); }
  bool hasServiceConfig() => $_has(1);
  void clearServiceConfig() => clearField(5);

  List<$5.CategoryDto> get categories => $_getList(2);

  List<$6.SocialNetworkProviderDto> get socialNetworkProviders => $_getList(3);

  List<$7.DeliverableIconDto> get deliverableIcons => $_getList(4);

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

class ServiceConfigDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ServiceConfigDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'mapboxUrlTemplateDark')
    ..aOS(2, 'mapboxUrlTemplateLight')
    ..aOS(3, 'mapboxToken')
    ..hasRequiredFields = false
  ;

  ServiceConfigDto() : super();
  ServiceConfigDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ServiceConfigDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ServiceConfigDto clone() => new ServiceConfigDto()..mergeFromMessage(this);
  ServiceConfigDto copyWith(void Function(ServiceConfigDto) updates) => super.copyWith((message) => updates(message as ServiceConfigDto));
  $pb.BuilderInfo get info_ => _i;
  static ServiceConfigDto create() => new ServiceConfigDto();
  ServiceConfigDto createEmptyInstance() => create();
  static $pb.PbList<ServiceConfigDto> createRepeated() => new $pb.PbList<ServiceConfigDto>();
  static ServiceConfigDto getDefault() => _defaultInstance ??= create()..freeze();
  static ServiceConfigDto _defaultInstance;
  static void $checkItem(ServiceConfigDto v) {
    if (v is! ServiceConfigDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
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

class GetWelcomeImagesResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetWelcomeImagesResponse', package: const $pb.PackageName('api'))
    ..pPS(1, 'imageUrls')
    ..hasRequiredFields = false
  ;

  GetWelcomeImagesResponse() : super();
  GetWelcomeImagesResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetWelcomeImagesResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetWelcomeImagesResponse clone() => new GetWelcomeImagesResponse()..mergeFromMessage(this);
  GetWelcomeImagesResponse copyWith(void Function(GetWelcomeImagesResponse) updates) => super.copyWith((message) => updates(message as GetWelcomeImagesResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetWelcomeImagesResponse create() => new GetWelcomeImagesResponse();
  GetWelcomeImagesResponse createEmptyInstance() => create();
  static $pb.PbList<GetWelcomeImagesResponse> createRepeated() => new $pb.PbList<GetWelcomeImagesResponse>();
  static GetWelcomeImagesResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetWelcomeImagesResponse _defaultInstance;
  static void $checkItem(GetWelcomeImagesResponse v) {
    if (v is! GetWelcomeImagesResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<String> get imageUrls => $_getList(0);
}

