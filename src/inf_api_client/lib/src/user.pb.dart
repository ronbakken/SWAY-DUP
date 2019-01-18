///
//  Generated code. Do not modify.
//  source: user.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'user.pbenum.dart';

export 'user.pbenum.dart';

class User extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('User', package: const $pb.PackageName('api'))
    ..a<int>(1, 'id', $pb.PbFieldType.O3)
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
    ..aOS(14, 'avatarThumbnailUrl')
    ..a<List<int>>(15, 'avatarThumbnailLowRes', $pb.PbFieldType.OY)
    ..aOS(16, 'avatarUrl')
    ..a<List<int>>(17, 'avatarLowRes', $pb.PbFieldType.OY)
    ..p<int>(18, 'categoriesIds', $pb.PbFieldType.P3)
    ..a<int>(19, 'minimalFee', $pb.PbFieldType.O3)
    ..p<int>(25, 'activeSocialMediaProviders', $pb.PbFieldType.P3)
    ..p<int>(26, 'socialMediaAccountIds', $pb.PbFieldType.P3)
    ..hasRequiredFields = false
  ;

  User() : super();
  User.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  User.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  User clone() => new User()..mergeFromMessage(this);
  User copyWith(void Function(User) updates) => super.copyWith((message) => updates(message as User));
  $pb.BuilderInfo get info_ => _i;
  static User create() => new User();
  User createEmptyInstance() => create();
  static $pb.PbList<User> createRepeated() => new $pb.PbList<User>();
  static User getDefault() => _defaultInstance ??= create()..freeze();
  static User _defaultInstance;
  static void $checkItem(User v) {
    if (v is! User) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get id => $_get(0, 0);
  set id(int v) { $_setSignedInt32(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  bool get verified => $_get(1, false);
  set verified(bool v) { $_setBool(1, v); }
  bool hasVerified() => $_has(1);
  void clearVerified() => clearField(2);

  AccountState get accountState => $_getN(2);
  set accountState(AccountState v) { setField(3, v); }
  bool hasAccountState() => $_has(2);
  void clearAccountState() => clearField(3);

  UserType get userType => $_getN(3);
  set userType(UserType v) { setField(4, v); }
  bool hasUserType() => $_has(3);
  void clearUserType() => clearField(4);

  String get name => $_getS(4, '');
  set name(String v) { $_setString(4, v); }
  bool hasName() => $_has(4);
  void clearName() => clearField(5);

  String get description => $_getS(5, '');
  set description(String v) { $_setString(5, v); }
  bool hasDescription() => $_has(5);
  void clearDescription() => clearField(6);

  String get email => $_getS(6, '');
  set email(String v) { $_setString(6, v); }
  bool hasEmail() => $_has(6);
  void clearEmail() => clearField(7);

  String get websiteUrl => $_getS(7, '');
  set websiteUrl(String v) { $_setString(7, v); }
  bool hasWebsiteUrl() => $_has(7);
  void clearWebsiteUrl() => clearField(8);

  bool get acceptsDirectOffers => $_get(8, false);
  set acceptsDirectOffers(bool v) { $_setBool(8, v); }
  bool hasAcceptsDirectOffers() => $_has(8);
  void clearAcceptsDirectOffers() => clearField(9);

  bool get showLocation => $_get(9, false);
  set showLocation(bool v) { $_setBool(9, v); }
  bool hasShowLocation() => $_has(9);
  void clearShowLocation() => clearField(10);

  int get accountCompletionInPercent => $_get(10, 0);
  set accountCompletionInPercent(int v) { $_setSignedInt32(10, v); }
  bool hasAccountCompletionInPercent() => $_has(10);
  void clearAccountCompletionInPercent() => clearField(11);

  String get locationAsString => $_getS(11, '');
  set locationAsString(String v) { $_setString(11, v); }
  bool hasLocationAsString() => $_has(11);
  void clearLocationAsString() => clearField(12);

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

  List<int> get categoriesIds => $_getList(16);

  int get minimalFee => $_get(17, 0);
  set minimalFee(int v) { $_setSignedInt32(17, v); }
  bool hasMinimalFee() => $_has(17);
  void clearMinimalFee() => clearField(19);

  List<int> get activeSocialMediaProviders => $_getList(18);

  List<int> get socialMediaAccountIds => $_getList(19);
}

