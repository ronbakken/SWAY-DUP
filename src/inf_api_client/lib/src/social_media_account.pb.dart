///
//  Generated code. Do not modify.
//  source: social_media_account.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

class SocialMediaAccountDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SocialMediaAccountDto', package: const $pb.PackageName('api'))
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

  String get displayName => $_getS(0, '');
  set displayName(String v) { $_setString(0, v); }
  bool hasDisplayName() => $_has(0);
  void clearDisplayName() => clearField(4);

  int get socialNetworkProviderId => $_get(1, 0);
  set socialNetworkProviderId(int v) { $_setSignedInt32(1, v); }
  bool hasSocialNetworkProviderId() => $_has(1);
  void clearSocialNetworkProviderId() => clearField(5);

  String get profileUrl => $_getS(2, '');
  set profileUrl(String v) { $_setString(2, v); }
  bool hasProfileUrl() => $_has(2);
  void clearProfileUrl() => clearField(6);

  String get description => $_getS(3, '');
  set description(String v) { $_setString(3, v); }
  bool hasDescription() => $_has(3);
  void clearDescription() => clearField(7);

  String get email => $_getS(4, '');
  set email(String v) { $_setString(4, v); }
  bool hasEmail() => $_has(4);
  void clearEmail() => clearField(8);

  String get userId => $_getS(5, '');
  set userId(String v) { $_setString(5, v); }
  bool hasUserId() => $_has(5);
  void clearUserId() => clearField(9);

  String get pageId => $_getS(6, '');
  set pageId(String v) { $_setString(6, v); }
  bool hasPageId() => $_has(6);
  void clearPageId() => clearField(10);

  int get audienceSize => $_get(7, 0);
  set audienceSize(int v) { $_setSignedInt32(7, v); }
  bool hasAudienceSize() => $_has(7);
  void clearAudienceSize() => clearField(11);

  int get postCount => $_get(8, 0);
  set postCount(int v) { $_setSignedInt32(8, v); }
  bool hasPostCount() => $_has(8);
  void clearPostCount() => clearField(12);

  bool get verified => $_get(9, false);
  set verified(bool v) { $_setBool(9, v); }
  bool hasVerified() => $_has(9);
  void clearVerified() => clearField(13);

  String get accessToken => $_getS(10, '');
  set accessToken(String v) { $_setString(10, v); }
  bool hasAccessToken() => $_has(10);
  void clearAccessToken() => clearField(14);

  String get accessTokenSecret => $_getS(11, '');
  set accessTokenSecret(String v) { $_setString(11, v); }
  bool hasAccessTokenSecret() => $_has(11);
  void clearAccessTokenSecret() => clearField(15);

  String get refreshToken => $_getS(12, '');
  set refreshToken(String v) { $_setString(12, v); }
  bool hasRefreshToken() => $_has(12);
  void clearRefreshToken() => clearField(16);
}

