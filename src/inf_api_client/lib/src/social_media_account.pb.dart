///
//  Generated code. Do not modify.
//  source: social_media_account.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

class SocialMediaAccountDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SocialMediaAccountDto', package: const $pb.PackageName('api'))
    ..aOS(4, 'displayName')
    ..aOS(5, 'socialNetworkProviderId')
    ..aOS(6, 'profileUrl')
    ..aOS(7, 'description')
    ..aOS(8, 'email')
    ..aOS(9, 'userId')
    ..aOS(10, 'pageId')
    ..a<$core.int>(11, 'audienceSize', $pb.PbFieldType.O3)
    ..a<$core.int>(12, 'postCount', $pb.PbFieldType.O3)
    ..aOB(13, 'isVerified')
    ..aOS(14, 'accessToken')
    ..aOS(15, 'accessTokenSecret')
    ..aOS(16, 'refreshToken')
    ..hasRequiredFields = false
  ;

  SocialMediaAccountDto() : super();
  SocialMediaAccountDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SocialMediaAccountDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SocialMediaAccountDto clone() => SocialMediaAccountDto()..mergeFromMessage(this);
  SocialMediaAccountDto copyWith(void Function(SocialMediaAccountDto) updates) => super.copyWith((message) => updates(message as SocialMediaAccountDto));
  $pb.BuilderInfo get info_ => _i;
  static SocialMediaAccountDto create() => SocialMediaAccountDto();
  SocialMediaAccountDto createEmptyInstance() => create();
  static $pb.PbList<SocialMediaAccountDto> createRepeated() => $pb.PbList<SocialMediaAccountDto>();
  static SocialMediaAccountDto getDefault() => _defaultInstance ??= create()..freeze();
  static SocialMediaAccountDto _defaultInstance;

  $core.String get displayName => $_getS(0, '');
  set displayName($core.String v) { $_setString(0, v); }
  $core.bool hasDisplayName() => $_has(0);
  void clearDisplayName() => clearField(4);

  $core.String get socialNetworkProviderId => $_getS(1, '');
  set socialNetworkProviderId($core.String v) { $_setString(1, v); }
  $core.bool hasSocialNetworkProviderId() => $_has(1);
  void clearSocialNetworkProviderId() => clearField(5);

  $core.String get profileUrl => $_getS(2, '');
  set profileUrl($core.String v) { $_setString(2, v); }
  $core.bool hasProfileUrl() => $_has(2);
  void clearProfileUrl() => clearField(6);

  $core.String get description => $_getS(3, '');
  set description($core.String v) { $_setString(3, v); }
  $core.bool hasDescription() => $_has(3);
  void clearDescription() => clearField(7);

  $core.String get email => $_getS(4, '');
  set email($core.String v) { $_setString(4, v); }
  $core.bool hasEmail() => $_has(4);
  void clearEmail() => clearField(8);

  $core.String get userId => $_getS(5, '');
  set userId($core.String v) { $_setString(5, v); }
  $core.bool hasUserId() => $_has(5);
  void clearUserId() => clearField(9);

  $core.String get pageId => $_getS(6, '');
  set pageId($core.String v) { $_setString(6, v); }
  $core.bool hasPageId() => $_has(6);
  void clearPageId() => clearField(10);

  $core.int get audienceSize => $_get(7, 0);
  set audienceSize($core.int v) { $_setSignedInt32(7, v); }
  $core.bool hasAudienceSize() => $_has(7);
  void clearAudienceSize() => clearField(11);

  $core.int get postCount => $_get(8, 0);
  set postCount($core.int v) { $_setSignedInt32(8, v); }
  $core.bool hasPostCount() => $_has(8);
  void clearPostCount() => clearField(12);

  $core.bool get isVerified => $_get(9, false);
  set isVerified($core.bool v) { $_setBool(9, v); }
  $core.bool hasIsVerified() => $_has(9);
  void clearIsVerified() => clearField(13);

  $core.String get accessToken => $_getS(10, '');
  set accessToken($core.String v) { $_setString(10, v); }
  $core.bool hasAccessToken() => $_has(10);
  void clearAccessToken() => clearField(14);

  $core.String get accessTokenSecret => $_getS(11, '');
  set accessTokenSecret($core.String v) { $_setString(11, v); }
  $core.bool hasAccessTokenSecret() => $_has(11);
  void clearAccessTokenSecret() => clearField(15);

  $core.String get refreshToken => $_getS(12, '');
  set refreshToken($core.String v) { $_setString(12, v); }
  $core.bool hasRefreshToken() => $_has(12);
  void clearRefreshToken() => clearField(16);
}

