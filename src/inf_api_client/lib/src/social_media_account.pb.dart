///
//  Generated code. Do not modify.
//  source: social_media_account.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'social_network_provider.pbenum.dart' as $1;

class SocialMediaAccountDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SocialMediaAccountDto', package: const $pb.PackageName('api'))
    ..e<$1.SocialNetworkProviderType>(3, 'type', $pb.PbFieldType.OE, $1.SocialNetworkProviderType.INSTAGRAM, $1.SocialNetworkProviderType.valueOf, $1.SocialNetworkProviderType.values)
    ..aOS(4, 'displayName')
    ..a<int>(5, 'socialNetworkProviderId', $pb.PbFieldType.O3)
    ..aOS(6, 'profileUrl')
    ..aOS(7, 'description')
    ..aOS(8, 'email')
    ..aOS(9, 'userId')
    ..aOS(10, 'pageId')
    ..a<int>(11, 'audienceSize', $pb.PbFieldType.O3)
    ..a<int>(12, 'postCount', $pb.PbFieldType.O3)
    ..aOB(13, 'verified')
    ..aOS(14, 'accessToken')
    ..aOS(15, 'accessTokenSecret')
    ..aOS(16, 'refreshToken')
    ..hasRequiredFields = false
  ;

  SocialMediaAccountDto() : super();
  SocialMediaAccountDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SocialMediaAccountDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SocialMediaAccountDto clone() => new SocialMediaAccountDto()..mergeFromMessage(this);
  SocialMediaAccountDto copyWith(void Function(SocialMediaAccountDto) updates) => super.copyWith((message) => updates(message as SocialMediaAccountDto));
  $pb.BuilderInfo get info_ => _i;
  static SocialMediaAccountDto create() => new SocialMediaAccountDto();
  SocialMediaAccountDto createEmptyInstance() => create();
  static $pb.PbList<SocialMediaAccountDto> createRepeated() => new $pb.PbList<SocialMediaAccountDto>();
  static SocialMediaAccountDto getDefault() => _defaultInstance ??= create()..freeze();
  static SocialMediaAccountDto _defaultInstance;
  static void $checkItem(SocialMediaAccountDto v) {
    if (v is! SocialMediaAccountDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $1.SocialNetworkProviderType get type => $_getN(0);
  set type($1.SocialNetworkProviderType v) { setField(3, v); }
  bool hasType() => $_has(0);
  void clearType() => clearField(3);

  String get displayName => $_getS(1, '');
  set displayName(String v) { $_setString(1, v); }
  bool hasDisplayName() => $_has(1);
  void clearDisplayName() => clearField(4);

  int get socialNetworkProviderId => $_get(2, 0);
  set socialNetworkProviderId(int v) { $_setSignedInt32(2, v); }
  bool hasSocialNetworkProviderId() => $_has(2);
  void clearSocialNetworkProviderId() => clearField(5);

  String get profileUrl => $_getS(3, '');
  set profileUrl(String v) { $_setString(3, v); }
  bool hasProfileUrl() => $_has(3);
  void clearProfileUrl() => clearField(6);

  String get description => $_getS(4, '');
  set description(String v) { $_setString(4, v); }
  bool hasDescription() => $_has(4);
  void clearDescription() => clearField(7);

  String get email => $_getS(5, '');
  set email(String v) { $_setString(5, v); }
  bool hasEmail() => $_has(5);
  void clearEmail() => clearField(8);

  String get userId => $_getS(6, '');
  set userId(String v) { $_setString(6, v); }
  bool hasUserId() => $_has(6);
  void clearUserId() => clearField(9);

  String get pageId => $_getS(7, '');
  set pageId(String v) { $_setString(7, v); }
  bool hasPageId() => $_has(7);
  void clearPageId() => clearField(10);

  int get audienceSize => $_get(8, 0);
  set audienceSize(int v) { $_setSignedInt32(8, v); }
  bool hasAudienceSize() => $_has(8);
  void clearAudienceSize() => clearField(11);

  int get postCount => $_get(9, 0);
  set postCount(int v) { $_setSignedInt32(9, v); }
  bool hasPostCount() => $_has(9);
  void clearPostCount() => clearField(12);

  bool get verified => $_get(10, false);
  set verified(bool v) { $_setBool(10, v); }
  bool hasVerified() => $_has(10);
  void clearVerified() => clearField(13);

  String get accessToken => $_getS(11, '');
  set accessToken(String v) { $_setString(11, v); }
  bool hasAccessToken() => $_has(11);
  void clearAccessToken() => clearField(14);

  String get accessTokenSecret => $_getS(12, '');
  set accessTokenSecret(String v) { $_setString(12, v); }
  bool hasAccessTokenSecret() => $_has(12);
  void clearAccessTokenSecret() => clearField(15);

  String get refreshToken => $_getS(13, '');
  set refreshToken(String v) { $_setString(13, v); }
  bool hasRefreshToken() => $_has(13);
  void clearRefreshToken() => clearField(16);
}

