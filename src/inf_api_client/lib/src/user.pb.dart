///
//  Generated code. Do not modify.
//  source: user.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'location.pb.dart' as $2;
import 'social_media_account.pb.dart' as $3;

import 'user.pbenum.dart';

export 'user.pbenum.dart';

class UserDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UserDto', package: const $pb.PackageName('api'))
    ..aOB(2, 'verified')
    ..e<AccountState>(3, 'accountState', $pb.PbFieldType.OE, AccountState.unknown, AccountState.valueOf, AccountState.values)
    ..e<UserType>(4, 'userType', $pb.PbFieldType.OE, UserType.influencer, UserType.valueOf, UserType.values)
    ..aOS(5, 'name')
    ..aOS(6, 'description')
    ..aOS(7, 'email')
    ..aOS(8, 'websiteUrl')
    ..aOB(9, 'acceptsDirectOffers')
    ..aOB(10, 'showLocation')
    ..a<int>(11, 'accountCompletionInPercent', $pb.PbFieldType.O3)
    ..aOS(12, 'locationAsString')
    ..a<$2.LocationDto>(13, 'location', $pb.PbFieldType.OM, $2.LocationDto.getDefault, $2.LocationDto.create)
    ..aOS(14, 'avatarThumbnailUrl')
    ..a<List<int>>(15, 'avatarThumbnailLowRes', $pb.PbFieldType.OY)
    ..aOS(16, 'avatarUrl')
    ..a<List<int>>(17, 'avatarLowRes', $pb.PbFieldType.OY)
    ..p<int>(18, 'categoryIds', $pb.PbFieldType.P3)
    ..a<int>(19, 'minimalFee', $pb.PbFieldType.O3)
    ..pp<$3.SocialMediaAccountDto>(26, 'socialMediaAccounts', $pb.PbFieldType.PM, $3.SocialMediaAccountDto.$checkItem, $3.SocialMediaAccountDto.create)
    ..hasRequiredFields = false
  ;

  UserDto() : super();
  UserDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UserDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UserDto clone() => new UserDto()..mergeFromMessage(this);
  UserDto copyWith(void Function(UserDto) updates) => super.copyWith((message) => updates(message as UserDto));
  $pb.BuilderInfo get info_ => _i;
  static UserDto create() => new UserDto();
  UserDto createEmptyInstance() => create();
  static $pb.PbList<UserDto> createRepeated() => new $pb.PbList<UserDto>();
  static UserDto getDefault() => _defaultInstance ??= create()..freeze();
  static UserDto _defaultInstance;
  static void $checkItem(UserDto v) {
    if (v is! UserDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  bool get verified => $_get(0, false);
  set verified(bool v) { $_setBool(0, v); }
  bool hasVerified() => $_has(0);
  void clearVerified() => clearField(2);

  AccountState get accountState => $_getN(1);
  set accountState(AccountState v) { setField(3, v); }
  bool hasAccountState() => $_has(1);
  void clearAccountState() => clearField(3);

  UserType get userType => $_getN(2);
  set userType(UserType v) { setField(4, v); }
  bool hasUserType() => $_has(2);
  void clearUserType() => clearField(4);

  String get name => $_getS(3, '');
  set name(String v) { $_setString(3, v); }
  bool hasName() => $_has(3);
  void clearName() => clearField(5);

  String get description => $_getS(4, '');
  set description(String v) { $_setString(4, v); }
  bool hasDescription() => $_has(4);
  void clearDescription() => clearField(6);

  String get email => $_getS(5, '');
  set email(String v) { $_setString(5, v); }
  bool hasEmail() => $_has(5);
  void clearEmail() => clearField(7);

  String get websiteUrl => $_getS(6, '');
  set websiteUrl(String v) { $_setString(6, v); }
  bool hasWebsiteUrl() => $_has(6);
  void clearWebsiteUrl() => clearField(8);

  bool get acceptsDirectOffers => $_get(7, false);
  set acceptsDirectOffers(bool v) { $_setBool(7, v); }
  bool hasAcceptsDirectOffers() => $_has(7);
  void clearAcceptsDirectOffers() => clearField(9);

  bool get showLocation => $_get(8, false);
  set showLocation(bool v) { $_setBool(8, v); }
  bool hasShowLocation() => $_has(8);
  void clearShowLocation() => clearField(10);

  int get accountCompletionInPercent => $_get(9, 0);
  set accountCompletionInPercent(int v) { $_setSignedInt32(9, v); }
  bool hasAccountCompletionInPercent() => $_has(9);
  void clearAccountCompletionInPercent() => clearField(11);

  String get locationAsString => $_getS(10, '');
  set locationAsString(String v) { $_setString(10, v); }
  bool hasLocationAsString() => $_has(10);
  void clearLocationAsString() => clearField(12);

  $2.LocationDto get location => $_getN(11);
  set location($2.LocationDto v) { setField(13, v); }
  bool hasLocation() => $_has(11);
  void clearLocation() => clearField(13);

  String get avatarThumbnailUrl => $_getS(12, '');
  set avatarThumbnailUrl(String v) { $_setString(12, v); }
  bool hasAvatarThumbnailUrl() => $_has(12);
  void clearAvatarThumbnailUrl() => clearField(14);

  List<int> get avatarThumbnailLowRes => $_getN(13);
  set avatarThumbnailLowRes(List<int> v) { $_setBytes(13, v); }
  bool hasAvatarThumbnailLowRes() => $_has(13);
  void clearAvatarThumbnailLowRes() => clearField(15);

  String get avatarUrl => $_getS(14, '');
  set avatarUrl(String v) { $_setString(14, v); }
  bool hasAvatarUrl() => $_has(14);
  void clearAvatarUrl() => clearField(16);

  List<int> get avatarLowRes => $_getN(15);
  set avatarLowRes(List<int> v) { $_setBytes(15, v); }
  bool hasAvatarLowRes() => $_has(15);
  void clearAvatarLowRes() => clearField(17);

  List<int> get categoryIds => $_getList(16);

  int get minimalFee => $_get(17, 0);
  set minimalFee(int v) { $_setSignedInt32(17, v); }
  bool hasMinimalFee() => $_has(17);
  void clearMinimalFee() => clearField(19);

  List<$3.SocialMediaAccountDto> get socialMediaAccounts => $_getList(18);
}

