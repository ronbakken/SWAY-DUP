///
//  Generated code. Do not modify.
//  source: social_network_provider.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'social_network_provider.pbenum.dart';

export 'social_network_provider.pbenum.dart';

class SocialNetworkProviderDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SocialNetworkProviderDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'id')
    ..e<SocialNetworkProviderType>(2, 'type', $pb.PbFieldType.OE, SocialNetworkProviderType.INSTAGRAM, SocialNetworkProviderType.valueOf, SocialNetworkProviderType.values)
    ..aOS(3, 'name')
    ..a<$core.List<$core.int>>(4, 'logoColoredData', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(5, 'logoMonochromeData', $pb.PbFieldType.OY)
    ..a<$core.int>(6, 'logoBackGroundColor', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(7, 'logoBackgroundData', $pb.PbFieldType.OY)
    ..aOS(8, 'apiKey')
    ..aOS(9, 'apiKeySecret')
    ..hasRequiredFields = false
  ;

  SocialNetworkProviderDto() : super();
  SocialNetworkProviderDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SocialNetworkProviderDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SocialNetworkProviderDto clone() => SocialNetworkProviderDto()..mergeFromMessage(this);
  SocialNetworkProviderDto copyWith(void Function(SocialNetworkProviderDto) updates) => super.copyWith((message) => updates(message as SocialNetworkProviderDto));
  $pb.BuilderInfo get info_ => _i;
  static SocialNetworkProviderDto create() => SocialNetworkProviderDto();
  SocialNetworkProviderDto createEmptyInstance() => create();
  static $pb.PbList<SocialNetworkProviderDto> createRepeated() => $pb.PbList<SocialNetworkProviderDto>();
  static SocialNetworkProviderDto getDefault() => _defaultInstance ??= create()..freeze();
  static SocialNetworkProviderDto _defaultInstance;

  $core.String get id => $_getS(0, '');
  set id($core.String v) { $_setString(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  SocialNetworkProviderType get type => $_getN(1);
  set type(SocialNetworkProviderType v) { setField(2, v); }
  $core.bool hasType() => $_has(1);
  void clearType() => clearField(2);

  $core.String get name => $_getS(2, '');
  set name($core.String v) { $_setString(2, v); }
  $core.bool hasName() => $_has(2);
  void clearName() => clearField(3);

  $core.List<$core.int> get logoColoredData => $_getN(3);
  set logoColoredData($core.List<$core.int> v) { $_setBytes(3, v); }
  $core.bool hasLogoColoredData() => $_has(3);
  void clearLogoColoredData() => clearField(4);

  $core.List<$core.int> get logoMonochromeData => $_getN(4);
  set logoMonochromeData($core.List<$core.int> v) { $_setBytes(4, v); }
  $core.bool hasLogoMonochromeData() => $_has(4);
  void clearLogoMonochromeData() => clearField(5);

  $core.int get logoBackGroundColor => $_get(5, 0);
  set logoBackGroundColor($core.int v) { $_setUnsignedInt32(5, v); }
  $core.bool hasLogoBackGroundColor() => $_has(5);
  void clearLogoBackGroundColor() => clearField(6);

  $core.List<$core.int> get logoBackgroundData => $_getN(6);
  set logoBackgroundData($core.List<$core.int> v) { $_setBytes(6, v); }
  $core.bool hasLogoBackgroundData() => $_has(6);
  void clearLogoBackgroundData() => clearField(7);

  $core.String get apiKey => $_getS(7, '');
  set apiKey($core.String v) { $_setString(7, v); }
  $core.bool hasApiKey() => $_has(7);
  void clearApiKey() => clearField(8);

  $core.String get apiKeySecret => $_getS(8, '');
  set apiKeySecret($core.String v) { $_setString(8, v); }
  $core.bool hasApiKeySecret() => $_has(8);
  void clearApiKeySecret() => clearField(9);
}

