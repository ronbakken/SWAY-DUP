///
//  Generated code. Do not modify.
//  source: social_media_account.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'social_network_provider.pbenum.dart' as $2;

class SocialMediaAccount extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SocialMediaAccount', package: const $pb.PackageName('api'))
    ..a<int>(1, 'id', $pb.PbFieldType.O3)
    ..aInt64(2, 'lastUpdated')
    ..e<$2.SocialNetworkProviderType>(3, 'type', $pb.PbFieldType.OE, $2.SocialNetworkProviderType.instagram, $2.SocialNetworkProviderType.valueOf, $2.SocialNetworkProviderType.values)
    ..aOS(4, 'displayName')
    ..a<int>(5, 'socialNetworkProviderId', $pb.PbFieldType.O3)
    ..aOS(6, 'profileUrl')
    ..aOS(7, 'description')
    ..aOS(8, 'email')
    ..aOS(9, 'userId')
    ..a<int>(10, 'audienceSize', $pb.PbFieldType.O3)
    ..a<int>(11, 'postsCount', $pb.PbFieldType.O3)
    ..aOB(12, 'verified')
    ..aOS(13, 'accessToken')
    ..aOS(14, 'accessTokenSecret')
    ..aOS(15, 'refreshToken')
    ..hasRequiredFields = false
  ;

  SocialMediaAccount() : super();
  SocialMediaAccount.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SocialMediaAccount.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SocialMediaAccount clone() => new SocialMediaAccount()..mergeFromMessage(this);
  SocialMediaAccount copyWith(void Function(SocialMediaAccount) updates) => super.copyWith((message) => updates(message as SocialMediaAccount));
  $pb.BuilderInfo get info_ => _i;
  static SocialMediaAccount create() => new SocialMediaAccount();
  SocialMediaAccount createEmptyInstance() => create();
  static $pb.PbList<SocialMediaAccount> createRepeated() => new $pb.PbList<SocialMediaAccount>();
  static SocialMediaAccount getDefault() => _defaultInstance ??= create()..freeze();
  static SocialMediaAccount _defaultInstance;
  static void $checkItem(SocialMediaAccount v) {
    if (v is! SocialMediaAccount) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get id => $_get(0, 0);
  set id(int v) { $_setSignedInt32(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  Int64 get lastUpdated => $_getI64(1);
  set lastUpdated(Int64 v) { $_setInt64(1, v); }
  bool hasLastUpdated() => $_has(1);
  void clearLastUpdated() => clearField(2);

  $2.SocialNetworkProviderType get type => $_getN(2);
  set type($2.SocialNetworkProviderType v) { setField(3, v); }
  bool hasType() => $_has(2);
  void clearType() => clearField(3);

  String get displayName => $_getS(3, '');
  set displayName(String v) { $_setString(3, v); }
  bool hasDisplayName() => $_has(3);
  void clearDisplayName() => clearField(4);

  int get socialNetworkProviderId => $_get(4, 0);
  set socialNetworkProviderId(int v) { $_setSignedInt32(4, v); }
  bool hasSocialNetworkProviderId() => $_has(4);
  void clearSocialNetworkProviderId() => clearField(5);

  String get profileUrl => $_getS(5, '');
  set profileUrl(String v) { $_setString(5, v); }
  bool hasProfileUrl() => $_has(5);
  void clearProfileUrl() => clearField(6);

  String get description => $_getS(6, '');
  set description(String v) { $_setString(6, v); }
  bool hasDescription() => $_has(6);
  void clearDescription() => clearField(7);

  String get email => $_getS(7, '');
  set email(String v) { $_setString(7, v); }
  bool hasEmail() => $_has(7);
  void clearEmail() => clearField(8);

  String get userId => $_getS(8, '');
  set userId(String v) { $_setString(8, v); }
  bool hasUserId() => $_has(8);
  void clearUserId() => clearField(9);

  int get audienceSize => $_get(9, 0);
  set audienceSize(int v) { $_setSignedInt32(9, v); }
  bool hasAudienceSize() => $_has(9);
  void clearAudienceSize() => clearField(10);

  int get postsCount => $_get(10, 0);
  set postsCount(int v) { $_setSignedInt32(10, v); }
  bool hasPostsCount() => $_has(10);
  void clearPostsCount() => clearField(11);

  bool get verified => $_get(11, false);
  set verified(bool v) { $_setBool(11, v); }
  bool hasVerified() => $_has(11);
  void clearVerified() => clearField(12);

  String get accessToken => $_getS(12, '');
  set accessToken(String v) { $_setString(12, v); }
  bool hasAccessToken() => $_has(12);
  void clearAccessToken() => clearField(13);

  String get accessTokenSecret => $_getS(13, '');
  set accessTokenSecret(String v) { $_setString(13, v); }
  bool hasAccessTokenSecret() => $_has(13);
  void clearAccessTokenSecret() => clearField(14);

  String get refreshToken => $_getS(14, '');
  set refreshToken(String v) { $_setString(14, v); }
  bool hasRefreshToken() => $_has(14);
  void clearRefreshToken() => clearField(15);
}

