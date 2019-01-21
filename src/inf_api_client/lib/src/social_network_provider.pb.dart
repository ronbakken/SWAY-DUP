///
//  Generated code. Do not modify.
//  source: social_network_provider.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'social_network_provider.pbenum.dart';

export 'social_network_provider.pbenum.dart';

class SocialNetworkProviderDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SocialNetworkProviderDto', package: const $pb.PackageName('api'))
    ..a<int>(1, 'id', $pb.PbFieldType.O3)
    ..e<SocialNetworkProviderType>(2, 'type', $pb.PbFieldType.OE, SocialNetworkProviderType.INSTAGRAM, SocialNetworkProviderType.valueOf, SocialNetworkProviderType.values)
    ..aOS(3, 'name')
    ..a<List<int>>(4, 'logoColoredData', $pb.PbFieldType.OY)
    ..a<List<int>>(5, 'logoMonochromeData', $pb.PbFieldType.OY)
    ..a<int>(6, 'logoBackGroundColor', $pb.PbFieldType.OU3)
    ..a<List<int>>(7, 'logoBackgroundData', $pb.PbFieldType.OY)
    ..aOS(8, 'apiKey')
    ..aOS(9, 'apiKeySecret')
    ..hasRequiredFields = false
  ;

  SocialNetworkProviderDto() : super();
  SocialNetworkProviderDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SocialNetworkProviderDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SocialNetworkProviderDto clone() => new SocialNetworkProviderDto()..mergeFromMessage(this);
  SocialNetworkProviderDto copyWith(void Function(SocialNetworkProviderDto) updates) => super.copyWith((message) => updates(message as SocialNetworkProviderDto));
  $pb.BuilderInfo get info_ => _i;
  static SocialNetworkProviderDto create() => new SocialNetworkProviderDto();
  SocialNetworkProviderDto createEmptyInstance() => create();
  static $pb.PbList<SocialNetworkProviderDto> createRepeated() => new $pb.PbList<SocialNetworkProviderDto>();
  static SocialNetworkProviderDto getDefault() => _defaultInstance ??= create()..freeze();
  static SocialNetworkProviderDto _defaultInstance;
  static void $checkItem(SocialNetworkProviderDto v) {
    if (v is! SocialNetworkProviderDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get id => $_get(0, 0);
  set id(int v) { $_setSignedInt32(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  SocialNetworkProviderType get type => $_getN(1);
  set type(SocialNetworkProviderType v) { setField(2, v); }
  bool hasType() => $_has(1);
  void clearType() => clearField(2);

  String get name => $_getS(2, '');
  set name(String v) { $_setString(2, v); }
  bool hasName() => $_has(2);
  void clearName() => clearField(3);

  List<int> get logoColoredData => $_getN(3);
  set logoColoredData(List<int> v) { $_setBytes(3, v); }
  bool hasLogoColoredData() => $_has(3);
  void clearLogoColoredData() => clearField(4);

  List<int> get logoMonochromeData => $_getN(4);
  set logoMonochromeData(List<int> v) { $_setBytes(4, v); }
  bool hasLogoMonochromeData() => $_has(4);
  void clearLogoMonochromeData() => clearField(5);

  int get logoBackGroundColor => $_get(5, 0);
  set logoBackGroundColor(int v) { $_setUnsignedInt32(5, v); }
  bool hasLogoBackGroundColor() => $_has(5);
  void clearLogoBackGroundColor() => clearField(6);

  List<int> get logoBackgroundData => $_getN(6);
  set logoBackgroundData(List<int> v) { $_setBytes(6, v); }
  bool hasLogoBackgroundData() => $_has(6);
  void clearLogoBackgroundData() => clearField(7);

  String get apiKey => $_getS(7, '');
  set apiKey(String v) { $_setString(7, v); }
  bool hasApiKey() => $_has(7);
  void clearApiKey() => clearField(8);

  String get apiKeySecret => $_getS(8, '');
  set apiKeySecret(String v) { $_setString(8, v); }
  bool hasApiKeySecret() => $_has(8);
  void clearApiKeySecret() => clearField(9);
}

