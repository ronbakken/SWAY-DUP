///
//  Generated code. Do not modify.
//  source: inf_config.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'category.pb.dart' as $14;
import 'social_network_provider.pb.dart' as $15;
import 'deliverable.pb.dart' as $8;

class GetVersionsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetVersionsResponse', package: const $pb.PackageName('api'))
    ..a<InfVersionInfoDto>(1, 'versionInfo', $pb.PbFieldType.OM, InfVersionInfoDto.getDefault, InfVersionInfoDto.create)
    ..hasRequiredFields = false
  ;

  GetVersionsResponse() : super();
  GetVersionsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetVersionsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetVersionsResponse clone() => GetVersionsResponse()..mergeFromMessage(this);
  GetVersionsResponse copyWith(void Function(GetVersionsResponse) updates) => super.copyWith((message) => updates(message as GetVersionsResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetVersionsResponse create() => GetVersionsResponse();
  GetVersionsResponse createEmptyInstance() => create();
  static $pb.PbList<GetVersionsResponse> createRepeated() => $pb.PbList<GetVersionsResponse>();
  static GetVersionsResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetVersionsResponse _defaultInstance;

  InfVersionInfoDto get versionInfo => $_getN(0);
  set versionInfo(InfVersionInfoDto v) { setField(1, v); }
  $core.bool hasVersionInfo() => $_has(0);
  void clearVersionInfo() => clearField(1);
}

class GetAppConfigResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetAppConfigResponse', package: const $pb.PackageName('api'))
    ..a<AppConfigDto>(1, 'appConfigData', $pb.PbFieldType.OM, AppConfigDto.getDefault, AppConfigDto.create)
    ..hasRequiredFields = false
  ;

  GetAppConfigResponse() : super();
  GetAppConfigResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetAppConfigResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetAppConfigResponse clone() => GetAppConfigResponse()..mergeFromMessage(this);
  GetAppConfigResponse copyWith(void Function(GetAppConfigResponse) updates) => super.copyWith((message) => updates(message as GetAppConfigResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetAppConfigResponse create() => GetAppConfigResponse();
  GetAppConfigResponse createEmptyInstance() => create();
  static $pb.PbList<GetAppConfigResponse> createRepeated() => $pb.PbList<GetAppConfigResponse>();
  static GetAppConfigResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetAppConfigResponse _defaultInstance;

  AppConfigDto get appConfigData => $_getN(0);
  set appConfigData(AppConfigDto v) { setField(1, v); }
  $core.bool hasAppConfigData() => $_has(0);
  void clearAppConfigData() => clearField(1);
}

class InfVersionInfoDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('InfVersionInfoDto', package: const $pb.PackageName('api'))
    ..a<$core.int>(1, 'apiVersion', $pb.PbFieldType.O3)
    ..a<$core.int>(2, 'configVersion', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  InfVersionInfoDto() : super();
  InfVersionInfoDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  InfVersionInfoDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  InfVersionInfoDto clone() => InfVersionInfoDto()..mergeFromMessage(this);
  InfVersionInfoDto copyWith(void Function(InfVersionInfoDto) updates) => super.copyWith((message) => updates(message as InfVersionInfoDto));
  $pb.BuilderInfo get info_ => _i;
  static InfVersionInfoDto create() => InfVersionInfoDto();
  InfVersionInfoDto createEmptyInstance() => create();
  static $pb.PbList<InfVersionInfoDto> createRepeated() => $pb.PbList<InfVersionInfoDto>();
  static InfVersionInfoDto getDefault() => _defaultInstance ??= create()..freeze();
  static InfVersionInfoDto _defaultInstance;

  $core.int get apiVersion => $_get(0, 0);
  set apiVersion($core.int v) { $_setSignedInt32(0, v); }
  $core.bool hasApiVersion() => $_has(0);
  void clearApiVersion() => clearField(1);

  $core.int get configVersion => $_get(1, 0);
  set configVersion($core.int v) { $_setSignedInt32(1, v); }
  $core.bool hasConfigVersion() => $_has(1);
  void clearConfigVersion() => clearField(2);
}

class AppConfigDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AppConfigDto', package: const $pb.PackageName('api'))
    ..a<$core.int>(1, 'configVersion', $pb.PbFieldType.O3)
    ..a<ServiceConfigDto>(5, 'serviceConfig', $pb.PbFieldType.OM, ServiceConfigDto.getDefault, ServiceConfigDto.create)
    ..pc<$14.CategoryDto>(6, 'categories', $pb.PbFieldType.PM,$14.CategoryDto.create)
    ..pc<$15.SocialNetworkProviderDto>(7, 'socialNetworkProviders', $pb.PbFieldType.PM,$15.SocialNetworkProviderDto.create)
    ..pc<$8.DeliverableIconDto>(8, 'deliverableIcons', $pb.PbFieldType.PM,$8.DeliverableIconDto.create)
    ..aOS(10, 'termsOfServiceUrl')
    ..aOS(11, 'privacyPolicyUrl')
    ..aOB(12, 'userNeedInvitationToSignUp')
    ..hasRequiredFields = false
  ;

  AppConfigDto() : super();
  AppConfigDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AppConfigDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AppConfigDto clone() => AppConfigDto()..mergeFromMessage(this);
  AppConfigDto copyWith(void Function(AppConfigDto) updates) => super.copyWith((message) => updates(message as AppConfigDto));
  $pb.BuilderInfo get info_ => _i;
  static AppConfigDto create() => AppConfigDto();
  AppConfigDto createEmptyInstance() => create();
  static $pb.PbList<AppConfigDto> createRepeated() => $pb.PbList<AppConfigDto>();
  static AppConfigDto getDefault() => _defaultInstance ??= create()..freeze();
  static AppConfigDto _defaultInstance;

  $core.int get configVersion => $_get(0, 0);
  set configVersion($core.int v) { $_setSignedInt32(0, v); }
  $core.bool hasConfigVersion() => $_has(0);
  void clearConfigVersion() => clearField(1);

  ServiceConfigDto get serviceConfig => $_getN(1);
  set serviceConfig(ServiceConfigDto v) { setField(5, v); }
  $core.bool hasServiceConfig() => $_has(1);
  void clearServiceConfig() => clearField(5);

  $core.List<$14.CategoryDto> get categories => $_getList(2);

  $core.List<$15.SocialNetworkProviderDto> get socialNetworkProviders => $_getList(3);

  $core.List<$8.DeliverableIconDto> get deliverableIcons => $_getList(4);

  $core.String get termsOfServiceUrl => $_getS(5, '');
  set termsOfServiceUrl($core.String v) { $_setString(5, v); }
  $core.bool hasTermsOfServiceUrl() => $_has(5);
  void clearTermsOfServiceUrl() => clearField(10);

  $core.String get privacyPolicyUrl => $_getS(6, '');
  set privacyPolicyUrl($core.String v) { $_setString(6, v); }
  $core.bool hasPrivacyPolicyUrl() => $_has(6);
  void clearPrivacyPolicyUrl() => clearField(11);

  $core.bool get userNeedInvitationToSignUp => $_get(7, false);
  set userNeedInvitationToSignUp($core.bool v) { $_setBool(7, v); }
  $core.bool hasUserNeedInvitationToSignUp() => $_has(7);
  void clearUserNeedInvitationToSignUp() => clearField(12);
}

class ServiceConfigDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ServiceConfigDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'mapboxUrlTemplateDark')
    ..aOS(2, 'mapboxUrlTemplateLight')
    ..aOS(3, 'mapboxToken')
    ..hasRequiredFields = false
  ;

  ServiceConfigDto() : super();
  ServiceConfigDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ServiceConfigDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ServiceConfigDto clone() => ServiceConfigDto()..mergeFromMessage(this);
  ServiceConfigDto copyWith(void Function(ServiceConfigDto) updates) => super.copyWith((message) => updates(message as ServiceConfigDto));
  $pb.BuilderInfo get info_ => _i;
  static ServiceConfigDto create() => ServiceConfigDto();
  ServiceConfigDto createEmptyInstance() => create();
  static $pb.PbList<ServiceConfigDto> createRepeated() => $pb.PbList<ServiceConfigDto>();
  static ServiceConfigDto getDefault() => _defaultInstance ??= create()..freeze();
  static ServiceConfigDto _defaultInstance;

  $core.String get mapboxUrlTemplateDark => $_getS(0, '');
  set mapboxUrlTemplateDark($core.String v) { $_setString(0, v); }
  $core.bool hasMapboxUrlTemplateDark() => $_has(0);
  void clearMapboxUrlTemplateDark() => clearField(1);

  $core.String get mapboxUrlTemplateLight => $_getS(1, '');
  set mapboxUrlTemplateLight($core.String v) { $_setString(1, v); }
  $core.bool hasMapboxUrlTemplateLight() => $_has(1);
  void clearMapboxUrlTemplateLight() => clearField(2);

  $core.String get mapboxToken => $_getS(2, '');
  set mapboxToken($core.String v) { $_setString(2, v); }
  $core.bool hasMapboxToken() => $_has(2);
  void clearMapboxToken() => clearField(3);
}

class GetWelcomeImagesResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetWelcomeImagesResponse', package: const $pb.PackageName('api'))
    ..pPS(1, 'imageUrls')
    ..hasRequiredFields = false
  ;

  GetWelcomeImagesResponse() : super();
  GetWelcomeImagesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetWelcomeImagesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetWelcomeImagesResponse clone() => GetWelcomeImagesResponse()..mergeFromMessage(this);
  GetWelcomeImagesResponse copyWith(void Function(GetWelcomeImagesResponse) updates) => super.copyWith((message) => updates(message as GetWelcomeImagesResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetWelcomeImagesResponse create() => GetWelcomeImagesResponse();
  GetWelcomeImagesResponse createEmptyInstance() => create();
  static $pb.PbList<GetWelcomeImagesResponse> createRepeated() => $pb.PbList<GetWelcomeImagesResponse>();
  static GetWelcomeImagesResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetWelcomeImagesResponse _defaultInstance;

  $core.List<$core.String> get imageUrls => $_getList(0);
}

