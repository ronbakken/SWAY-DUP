///
//  Generated code. Do not modify.
//  source: user.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'image.pb.dart' as $1;
import 'location.pb.dart' as $2;
import 'money.pb.dart' as $3;
import 'social_media_account.pb.dart' as $4;

import 'user.pbenum.dart';

export 'user.pbenum.dart';

class UserDto_HandleDataDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UserDto.HandleDataDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'name')
    ..a<$1.ImageDto>(2, 'avatarThumbnail', $pb.PbFieldType.OM, $1.ImageDto.getDefault, $1.ImageDto.create)
    ..hasRequiredFields = false
  ;

  UserDto_HandleDataDto() : super();
  UserDto_HandleDataDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UserDto_HandleDataDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UserDto_HandleDataDto clone() => UserDto_HandleDataDto()..mergeFromMessage(this);
  UserDto_HandleDataDto copyWith(void Function(UserDto_HandleDataDto) updates) => super.copyWith((message) => updates(message as UserDto_HandleDataDto));
  $pb.BuilderInfo get info_ => _i;
  static UserDto_HandleDataDto create() => UserDto_HandleDataDto();
  UserDto_HandleDataDto createEmptyInstance() => create();
  static $pb.PbList<UserDto_HandleDataDto> createRepeated() => $pb.PbList<UserDto_HandleDataDto>();
  static UserDto_HandleDataDto getDefault() => _defaultInstance ??= create()..freeze();
  static UserDto_HandleDataDto _defaultInstance;

  $core.String get name => $_getS(0, '');
  set name($core.String v) { $_setString(0, v); }
  $core.bool hasName() => $_has(0);
  void clearName() => clearField(1);

  $1.ImageDto get avatarThumbnail => $_getN(1);
  set avatarThumbnail($1.ImageDto v) { setField(2, v); }
  $core.bool hasAvatarThumbnail() => $_has(1);
  void clearAvatarThumbnail() => clearField(2);
}

class UserDto_ListDataDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UserDto.ListDataDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'name')
    ..e<UserType>(2, 'type', $pb.PbFieldType.OE, UserType.unknownType, UserType.valueOf, UserType.values)
    ..aOS(4, 'description')
    ..aOB(8, 'showLocation')
    ..a<$2.LocationDto>(10, 'location', $pb.PbFieldType.OM, $2.LocationDto.getDefault, $2.LocationDto.create)
    ..a<$1.ImageDto>(11, 'avatar', $pb.PbFieldType.OM, $1.ImageDto.getDefault, $1.ImageDto.create)
    ..a<$1.ImageDto>(12, 'avatarThumbnail', $pb.PbFieldType.OM, $1.ImageDto.getDefault, $1.ImageDto.create)
    ..pPS(13, 'categoryIds')
    ..pPS(14, 'socialMediaProviderIds')
    ..hasRequiredFields = false
  ;

  UserDto_ListDataDto() : super();
  UserDto_ListDataDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UserDto_ListDataDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UserDto_ListDataDto clone() => UserDto_ListDataDto()..mergeFromMessage(this);
  UserDto_ListDataDto copyWith(void Function(UserDto_ListDataDto) updates) => super.copyWith((message) => updates(message as UserDto_ListDataDto));
  $pb.BuilderInfo get info_ => _i;
  static UserDto_ListDataDto create() => UserDto_ListDataDto();
  UserDto_ListDataDto createEmptyInstance() => create();
  static $pb.PbList<UserDto_ListDataDto> createRepeated() => $pb.PbList<UserDto_ListDataDto>();
  static UserDto_ListDataDto getDefault() => _defaultInstance ??= create()..freeze();
  static UserDto_ListDataDto _defaultInstance;

  $core.String get name => $_getS(0, '');
  set name($core.String v) { $_setString(0, v); }
  $core.bool hasName() => $_has(0);
  void clearName() => clearField(1);

  UserType get type => $_getN(1);
  set type(UserType v) { setField(2, v); }
  $core.bool hasType() => $_has(1);
  void clearType() => clearField(2);

  $core.String get description => $_getS(2, '');
  set description($core.String v) { $_setString(2, v); }
  $core.bool hasDescription() => $_has(2);
  void clearDescription() => clearField(4);

  $core.bool get showLocation => $_get(3, false);
  set showLocation($core.bool v) { $_setBool(3, v); }
  $core.bool hasShowLocation() => $_has(3);
  void clearShowLocation() => clearField(8);

  $2.LocationDto get location => $_getN(4);
  set location($2.LocationDto v) { setField(10, v); }
  $core.bool hasLocation() => $_has(4);
  void clearLocation() => clearField(10);

  $1.ImageDto get avatar => $_getN(5);
  set avatar($1.ImageDto v) { setField(11, v); }
  $core.bool hasAvatar() => $_has(5);
  void clearAvatar() => clearField(11);

  $1.ImageDto get avatarThumbnail => $_getN(6);
  set avatarThumbnail($1.ImageDto v) { setField(12, v); }
  $core.bool hasAvatarThumbnail() => $_has(6);
  void clearAvatarThumbnail() => clearField(12);

  $core.List<$core.String> get categoryIds => $_getList(7);

  $core.List<$core.String> get socialMediaProviderIds => $_getList(8);
}

class UserDto_FullDataDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UserDto.FullDataDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'name')
    ..e<UserType>(2, 'type', $pb.PbFieldType.OE, UserType.unknownType, UserType.valueOf, UserType.values)
    ..aOB(3, 'isVerified')
    ..aOS(4, 'description')
    ..aOS(5, 'email')
    ..aOS(6, 'websiteUrl')
    ..aOB(7, 'acceptsDirectOffers')
    ..aOB(8, 'showLocation')
    ..a<$core.int>(9, 'accountCompletionInPercent', $pb.PbFieldType.O3)
    ..a<$2.LocationDto>(10, 'location', $pb.PbFieldType.OM, $2.LocationDto.getDefault, $2.LocationDto.create)
    ..a<$1.ImageDto>(11, 'avatar', $pb.PbFieldType.OM, $1.ImageDto.getDefault, $1.ImageDto.create)
    ..a<$1.ImageDto>(12, 'avatarThumbnail', $pb.PbFieldType.OM, $1.ImageDto.getDefault, $1.ImageDto.create)
    ..pPS(13, 'categoryIds')
    ..a<$3.MoneyDto>(14, 'minimalFee', $pb.PbFieldType.OM, $3.MoneyDto.getDefault, $3.MoneyDto.create)
    ..pc<$4.SocialMediaAccountDto>(15, 'socialMediaAccounts', $pb.PbFieldType.PM,$4.SocialMediaAccountDto.create)
    ..pPS(16, 'registrationTokens')
    ..pc<$2.LocationDto>(17, 'locationsOfInfluence', $pb.PbFieldType.PM,$2.LocationDto.create)
    ..hasRequiredFields = false
  ;

  UserDto_FullDataDto() : super();
  UserDto_FullDataDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UserDto_FullDataDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UserDto_FullDataDto clone() => UserDto_FullDataDto()..mergeFromMessage(this);
  UserDto_FullDataDto copyWith(void Function(UserDto_FullDataDto) updates) => super.copyWith((message) => updates(message as UserDto_FullDataDto));
  $pb.BuilderInfo get info_ => _i;
  static UserDto_FullDataDto create() => UserDto_FullDataDto();
  UserDto_FullDataDto createEmptyInstance() => create();
  static $pb.PbList<UserDto_FullDataDto> createRepeated() => $pb.PbList<UserDto_FullDataDto>();
  static UserDto_FullDataDto getDefault() => _defaultInstance ??= create()..freeze();
  static UserDto_FullDataDto _defaultInstance;

  $core.String get name => $_getS(0, '');
  set name($core.String v) { $_setString(0, v); }
  $core.bool hasName() => $_has(0);
  void clearName() => clearField(1);

  UserType get type => $_getN(1);
  set type(UserType v) { setField(2, v); }
  $core.bool hasType() => $_has(1);
  void clearType() => clearField(2);

  $core.bool get isVerified => $_get(2, false);
  set isVerified($core.bool v) { $_setBool(2, v); }
  $core.bool hasIsVerified() => $_has(2);
  void clearIsVerified() => clearField(3);

  $core.String get description => $_getS(3, '');
  set description($core.String v) { $_setString(3, v); }
  $core.bool hasDescription() => $_has(3);
  void clearDescription() => clearField(4);

  $core.String get email => $_getS(4, '');
  set email($core.String v) { $_setString(4, v); }
  $core.bool hasEmail() => $_has(4);
  void clearEmail() => clearField(5);

  $core.String get websiteUrl => $_getS(5, '');
  set websiteUrl($core.String v) { $_setString(5, v); }
  $core.bool hasWebsiteUrl() => $_has(5);
  void clearWebsiteUrl() => clearField(6);

  $core.bool get acceptsDirectOffers => $_get(6, false);
  set acceptsDirectOffers($core.bool v) { $_setBool(6, v); }
  $core.bool hasAcceptsDirectOffers() => $_has(6);
  void clearAcceptsDirectOffers() => clearField(7);

  $core.bool get showLocation => $_get(7, false);
  set showLocation($core.bool v) { $_setBool(7, v); }
  $core.bool hasShowLocation() => $_has(7);
  void clearShowLocation() => clearField(8);

  $core.int get accountCompletionInPercent => $_get(8, 0);
  set accountCompletionInPercent($core.int v) { $_setSignedInt32(8, v); }
  $core.bool hasAccountCompletionInPercent() => $_has(8);
  void clearAccountCompletionInPercent() => clearField(9);

  $2.LocationDto get location => $_getN(9);
  set location($2.LocationDto v) { setField(10, v); }
  $core.bool hasLocation() => $_has(9);
  void clearLocation() => clearField(10);

  $1.ImageDto get avatar => $_getN(10);
  set avatar($1.ImageDto v) { setField(11, v); }
  $core.bool hasAvatar() => $_has(10);
  void clearAvatar() => clearField(11);

  $1.ImageDto get avatarThumbnail => $_getN(11);
  set avatarThumbnail($1.ImageDto v) { setField(12, v); }
  $core.bool hasAvatarThumbnail() => $_has(11);
  void clearAvatarThumbnail() => clearField(12);

  $core.List<$core.String> get categoryIds => $_getList(12);

  $3.MoneyDto get minimalFee => $_getN(13);
  set minimalFee($3.MoneyDto v) { setField(14, v); }
  $core.bool hasMinimalFee() => $_has(13);
  void clearMinimalFee() => clearField(14);

  $core.List<$4.SocialMediaAccountDto> get socialMediaAccounts => $_getList(14);

  $core.List<$core.String> get registrationTokens => $_getList(15);

  $core.List<$2.LocationDto> get locationsOfInfluence => $_getList(16);
}

enum UserDto_Data {
  handle, 
  list, 
  full, 
  notSet
}

class UserDto extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, UserDto_Data> _UserDto_DataByTag = {
    4 : UserDto_Data.handle,
    5 : UserDto_Data.list,
    6 : UserDto_Data.full,
    0 : UserDto_Data.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UserDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'id')
    ..a<$core.int>(2, 'revision', $pb.PbFieldType.OU3)
    ..e<UserDto_Status>(3, 'status', $pb.PbFieldType.OE, UserDto_Status.unknown, UserDto_Status.valueOf, UserDto_Status.values)
    ..a<UserDto_HandleDataDto>(4, 'handle', $pb.PbFieldType.OM, UserDto_HandleDataDto.getDefault, UserDto_HandleDataDto.create)
    ..a<UserDto_ListDataDto>(5, 'list', $pb.PbFieldType.OM, UserDto_ListDataDto.getDefault, UserDto_ListDataDto.create)
    ..a<UserDto_FullDataDto>(6, 'full', $pb.PbFieldType.OM, UserDto_FullDataDto.getDefault, UserDto_FullDataDto.create)
    ..oo(0, [4, 5, 6])
    ..hasRequiredFields = false
  ;

  UserDto() : super();
  UserDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UserDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UserDto clone() => UserDto()..mergeFromMessage(this);
  UserDto copyWith(void Function(UserDto) updates) => super.copyWith((message) => updates(message as UserDto));
  $pb.BuilderInfo get info_ => _i;
  static UserDto create() => UserDto();
  UserDto createEmptyInstance() => create();
  static $pb.PbList<UserDto> createRepeated() => $pb.PbList<UserDto>();
  static UserDto getDefault() => _defaultInstance ??= create()..freeze();
  static UserDto _defaultInstance;

  UserDto_Data whichData() => _UserDto_DataByTag[$_whichOneof(0)];
  void clearData() => clearField($_whichOneof(0));

  $core.String get id => $_getS(0, '');
  set id($core.String v) { $_setString(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  $core.int get revision => $_get(1, 0);
  set revision($core.int v) { $_setUnsignedInt32(1, v); }
  $core.bool hasRevision() => $_has(1);
  void clearRevision() => clearField(2);

  UserDto_Status get status => $_getN(2);
  set status(UserDto_Status v) { setField(3, v); }
  $core.bool hasStatus() => $_has(2);
  void clearStatus() => clearField(3);

  UserDto_HandleDataDto get handle => $_getN(3);
  set handle(UserDto_HandleDataDto v) { setField(4, v); }
  $core.bool hasHandle() => $_has(3);
  void clearHandle() => clearField(4);

  UserDto_ListDataDto get list => $_getN(4);
  set list(UserDto_ListDataDto v) { setField(5, v); }
  $core.bool hasList() => $_has(4);
  void clearList() => clearField(5);

  UserDto_FullDataDto get full => $_getN(5);
  set full(UserDto_FullDataDto v) { setField(6, v); }
  $core.bool hasFull() => $_has(5);
  void clearFull() => clearField(6);
}

