///
//  Generated code. Do not modify.
//  source: data_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'enum_protobuf.pbenum.dart' as $0;

class DataSocialMedia extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataSocialMedia',
      package: const $pb.PackageName('inf_common'))
    ..aOB(1, 'connected')
    ..a<int>(2, 'followersCount', $pb.PbFieldType.O3)
    ..a<int>(3, 'followingCount', $pb.PbFieldType.O3)
    ..aOS(4, 'screenName')
    ..aOS(5, 'displayName')
    ..aOS(6, 'description')
    ..aOS(7, 'location')
    ..aOS(8, 'url')
    ..a<int>(9, 'friendsCount', $pb.PbFieldType.O3)
    ..a<int>(10, 'postsCount', $pb.PbFieldType.O3)
    ..aOB(11, 'verified')
    ..aOS(12, 'email')
    ..aOS(13, 'profileUrl')
    ..aOS(14, 'avatarUrl')
    ..aOB(15, 'expired')
    ..aOS(16, 'blurredAvatarUrl')
    ..aOB(20, 'canSignUp')
    ..hasRequiredFields = false;

  DataSocialMedia() : super();
  DataSocialMedia.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataSocialMedia.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataSocialMedia clone() => new DataSocialMedia()..mergeFromMessage(this);
  DataSocialMedia copyWith(void Function(DataSocialMedia) updates) =>
      super.copyWith((message) => updates(message as DataSocialMedia));
  $pb.BuilderInfo get info_ => _i;
  static DataSocialMedia create() => new DataSocialMedia();
  static $pb.PbList<DataSocialMedia> createRepeated() =>
      new $pb.PbList<DataSocialMedia>();
  static DataSocialMedia getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DataSocialMedia _defaultInstance;
  static void $checkItem(DataSocialMedia v) {
    if (v is! DataSocialMedia) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  bool get connected => $_get(0, false);
  set connected(bool v) {
    $_setBool(0, v);
  }

  bool hasConnected() => $_has(0);
  void clearConnected() => clearField(1);

  int get followersCount => $_get(1, 0);
  set followersCount(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasFollowersCount() => $_has(1);
  void clearFollowersCount() => clearField(2);

  int get followingCount => $_get(2, 0);
  set followingCount(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasFollowingCount() => $_has(2);
  void clearFollowingCount() => clearField(3);

  String get screenName => $_getS(3, '');
  set screenName(String v) {
    $_setString(3, v);
  }

  bool hasScreenName() => $_has(3);
  void clearScreenName() => clearField(4);

  String get displayName => $_getS(4, '');
  set displayName(String v) {
    $_setString(4, v);
  }

  bool hasDisplayName() => $_has(4);
  void clearDisplayName() => clearField(5);

  String get description => $_getS(5, '');
  set description(String v) {
    $_setString(5, v);
  }

  bool hasDescription() => $_has(5);
  void clearDescription() => clearField(6);

  String get location => $_getS(6, '');
  set location(String v) {
    $_setString(6, v);
  }

  bool hasLocation() => $_has(6);
  void clearLocation() => clearField(7);

  String get url => $_getS(7, '');
  set url(String v) {
    $_setString(7, v);
  }

  bool hasUrl() => $_has(7);
  void clearUrl() => clearField(8);

  int get friendsCount => $_get(8, 0);
  set friendsCount(int v) {
    $_setSignedInt32(8, v);
  }

  bool hasFriendsCount() => $_has(8);
  void clearFriendsCount() => clearField(9);

  int get postsCount => $_get(9, 0);
  set postsCount(int v) {
    $_setSignedInt32(9, v);
  }

  bool hasPostsCount() => $_has(9);
  void clearPostsCount() => clearField(10);

  bool get verified => $_get(10, false);
  set verified(bool v) {
    $_setBool(10, v);
  }

  bool hasVerified() => $_has(10);
  void clearVerified() => clearField(11);

  String get email => $_getS(11, '');
  set email(String v) {
    $_setString(11, v);
  }

  bool hasEmail() => $_has(11);
  void clearEmail() => clearField(12);

  String get profileUrl => $_getS(12, '');
  set profileUrl(String v) {
    $_setString(12, v);
  }

  bool hasProfileUrl() => $_has(12);
  void clearProfileUrl() => clearField(13);

  String get avatarUrl => $_getS(13, '');
  set avatarUrl(String v) {
    $_setString(13, v);
  }

  bool hasAvatarUrl() => $_has(13);
  void clearAvatarUrl() => clearField(14);

  bool get expired => $_get(14, false);
  set expired(bool v) {
    $_setBool(14, v);
  }

  bool hasExpired() => $_has(14);
  void clearExpired() => clearField(15);

  String get blurredAvatarUrl => $_getS(15, '');
  set blurredAvatarUrl(String v) {
    $_setString(15, v);
  }

  bool hasBlurredAvatarUrl() => $_has(15);
  void clearBlurredAvatarUrl() => clearField(16);

  bool get canSignUp => $_get(16, false);
  set canSignUp(bool v) {
    $_setBool(16, v);
  }

  bool hasCanSignUp() => $_has(16);
  void clearCanSignUp() => clearField(20);
}

class DataOAuthCredentials extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataOAuthCredentials',
      package: const $pb.PackageName('inf_common'))
    ..aOS(1, 'token')
    ..aOS(2, 'tokenSecret')
    ..a<int>(3, 'tokenExpires', $pb.PbFieldType.O3)
    ..aOS(4, 'userId')
    ..hasRequiredFields = false;

  DataOAuthCredentials() : super();
  DataOAuthCredentials.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataOAuthCredentials.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataOAuthCredentials clone() =>
      new DataOAuthCredentials()..mergeFromMessage(this);
  DataOAuthCredentials copyWith(void Function(DataOAuthCredentials) updates) =>
      super.copyWith((message) => updates(message as DataOAuthCredentials));
  $pb.BuilderInfo get info_ => _i;
  static DataOAuthCredentials create() => new DataOAuthCredentials();
  static $pb.PbList<DataOAuthCredentials> createRepeated() =>
      new $pb.PbList<DataOAuthCredentials>();
  static DataOAuthCredentials getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DataOAuthCredentials _defaultInstance;
  static void $checkItem(DataOAuthCredentials v) {
    if (v is! DataOAuthCredentials)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get token => $_getS(0, '');
  set token(String v) {
    $_setString(0, v);
  }

  bool hasToken() => $_has(0);
  void clearToken() => clearField(1);

  String get tokenSecret => $_getS(1, '');
  set tokenSecret(String v) {
    $_setString(1, v);
  }

  bool hasTokenSecret() => $_has(1);
  void clearTokenSecret() => clearField(2);

  int get tokenExpires => $_get(2, 0);
  set tokenExpires(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasTokenExpires() => $_has(2);
  void clearTokenExpires() => clearField(3);

  String get userId => $_getS(3, '');
  set userId(String v) {
    $_setString(3, v);
  }

  bool hasUserId() => $_has(3);
  void clearUserId() => clearField(4);
}

class DataTerms extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataTerms',
      package: const $pb.PackageName('inf_common'))
    ..p<int>(1, 'deliverableSocialPlatforms', $pb.PbFieldType.P3)
    ..p<int>(2, 'deliverableContentFormats', $pb.PbFieldType.P3)
    ..aOS(3, 'deliverablesDescription')
    ..a<int>(4, 'rewardCashValue', $pb.PbFieldType.O3)
    ..a<int>(5, 'rewardItemOrServiceValue', $pb.PbFieldType.O3)
    ..aOS(6, 'rewardItemOrServiceDescription')
    ..hasRequiredFields = false;

  DataTerms() : super();
  DataTerms.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataTerms.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataTerms clone() => new DataTerms()..mergeFromMessage(this);
  DataTerms copyWith(void Function(DataTerms) updates) =>
      super.copyWith((message) => updates(message as DataTerms));
  $pb.BuilderInfo get info_ => _i;
  static DataTerms create() => new DataTerms();
  static $pb.PbList<DataTerms> createRepeated() => new $pb.PbList<DataTerms>();
  static DataTerms getDefault() => _defaultInstance ??= create()..freeze();
  static DataTerms _defaultInstance;
  static void $checkItem(DataTerms v) {
    if (v is! DataTerms) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<int> get deliverableSocialPlatforms => $_getList(0);

  List<int> get deliverableContentFormats => $_getList(1);

  String get deliverablesDescription => $_getS(2, '');
  set deliverablesDescription(String v) {
    $_setString(2, v);
  }

  bool hasDeliverablesDescription() => $_has(2);
  void clearDeliverablesDescription() => clearField(3);

  int get rewardCashValue => $_get(3, 0);
  set rewardCashValue(int v) {
    $_setSignedInt32(3, v);
  }

  bool hasRewardCashValue() => $_has(3);
  void clearRewardCashValue() => clearField(4);

  int get rewardItemOrServiceValue => $_get(4, 0);
  set rewardItemOrServiceValue(int v) {
    $_setSignedInt32(4, v);
  }

  bool hasRewardItemOrServiceValue() => $_has(4);
  void clearRewardItemOrServiceValue() => clearField(5);

  String get rewardItemOrServiceDescription => $_getS(5, '');
  set rewardItemOrServiceDescription(String v) {
    $_setString(5, v);
  }

  bool hasRewardItemOrServiceDescription() => $_has(5);
  void clearRewardItemOrServiceDescription() => clearField(6);
}

class DataOffer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataOffer',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'offerId')
    ..aInt64(2, 'senderId')
    ..aInt64(3, 'locationId')
    ..aOS(4, 'title')
    ..aOS(5, 'description')
    ..aOS(6, 'thumbnailUrl')
    ..aOS(9, 'locationAddress')
    ..pPS(10, 'coverUrls')
    ..e<$0.OfferState>(12, 'state', $pb.PbFieldType.OE, $0.OfferState.draft,
        $0.OfferState.valueOf, $0.OfferState.values)
    ..e<$0.OfferStateReason>(
        13,
        'stateReason',
        $pb.PbFieldType.OE,
        $0.OfferStateReason.newOffer,
        $0.OfferStateReason.valueOf,
        $0.OfferStateReason.values)
    ..a<double>(18, 'latitude', $pb.PbFieldType.OD)
    ..a<double>(19, 'longitude', $pb.PbFieldType.OD)
    ..aOS(21, 'senderName')
    ..aInt64(22, 'proposalId')
    ..p<int>(23, 'categories', $pb.PbFieldType.P3)
    ..aOB(26, 'archived')
    ..a<DataTerms>(
        27, 'terms', $pb.PbFieldType.OM, DataTerms.getDefault, DataTerms.create)
    ..a<List<int>>(28, 'thumbnailBlurred', $pb.PbFieldType.OY)
    ..p<List<int>>(29, 'coversBlurred', $pb.PbFieldType.PY)
    ..aOB(32, 'direct')
    ..p<int>(33, 'primaryCategories', $pb.PbFieldType.P3)
    ..pPS(34, 'coverKeys')
    ..aOS(35, 'senderAvatarUrl')
    ..a<List<int>>(36, 'senderAvatarBlurred', $pb.PbFieldType.OY)
    ..aOS(37, 'thumbnailKey')
    ..a<int>(38, 'proposalsProposing', $pb.PbFieldType.O3)
    ..a<int>(39, 'proposalsNegotiating', $pb.PbFieldType.O3)
    ..a<int>(40, 'proposalsDeal', $pb.PbFieldType.O3)
    ..a<int>(41, 'proposalsRejected', $pb.PbFieldType.O3)
    ..a<int>(42, 'proposalsDispute', $pb.PbFieldType.O3)
    ..a<int>(43, 'proposalsResolved', $pb.PbFieldType.O3)
    ..a<int>(44, 'proposalsComplete', $pb.PbFieldType.O3)
    ..e<$0.AccountType>(45, 'senderType', $pb.PbFieldType.OE,
        $0.AccountType.unknown, $0.AccountType.valueOf, $0.AccountType.values)
    ..hasRequiredFields = false;

  DataOffer() : super();
  DataOffer.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataOffer.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataOffer clone() => new DataOffer()..mergeFromMessage(this);
  DataOffer copyWith(void Function(DataOffer) updates) =>
      super.copyWith((message) => updates(message as DataOffer));
  $pb.BuilderInfo get info_ => _i;
  static DataOffer create() => new DataOffer();
  static $pb.PbList<DataOffer> createRepeated() => new $pb.PbList<DataOffer>();
  static DataOffer getDefault() => _defaultInstance ??= create()..freeze();
  static DataOffer _defaultInstance;
  static void $checkItem(DataOffer v) {
    if (v is! DataOffer) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get offerId => $_getI64(0);
  set offerId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasOfferId() => $_has(0);
  void clearOfferId() => clearField(1);

  Int64 get senderId => $_getI64(1);
  set senderId(Int64 v) {
    $_setInt64(1, v);
  }

  bool hasSenderId() => $_has(1);
  void clearSenderId() => clearField(2);

  Int64 get locationId => $_getI64(2);
  set locationId(Int64 v) {
    $_setInt64(2, v);
  }

  bool hasLocationId() => $_has(2);
  void clearLocationId() => clearField(3);

  String get title => $_getS(3, '');
  set title(String v) {
    $_setString(3, v);
  }

  bool hasTitle() => $_has(3);
  void clearTitle() => clearField(4);

  String get description => $_getS(4, '');
  set description(String v) {
    $_setString(4, v);
  }

  bool hasDescription() => $_has(4);
  void clearDescription() => clearField(5);

  String get thumbnailUrl => $_getS(5, '');
  set thumbnailUrl(String v) {
    $_setString(5, v);
  }

  bool hasThumbnailUrl() => $_has(5);
  void clearThumbnailUrl() => clearField(6);

  String get locationAddress => $_getS(6, '');
  set locationAddress(String v) {
    $_setString(6, v);
  }

  bool hasLocationAddress() => $_has(6);
  void clearLocationAddress() => clearField(9);

  List<String> get coverUrls => $_getList(7);

  $0.OfferState get state => $_getN(8);
  set state($0.OfferState v) {
    setField(12, v);
  }

  bool hasState() => $_has(8);
  void clearState() => clearField(12);

  $0.OfferStateReason get stateReason => $_getN(9);
  set stateReason($0.OfferStateReason v) {
    setField(13, v);
  }

  bool hasStateReason() => $_has(9);
  void clearStateReason() => clearField(13);

  double get latitude => $_getN(10);
  set latitude(double v) {
    $_setDouble(10, v);
  }

  bool hasLatitude() => $_has(10);
  void clearLatitude() => clearField(18);

  double get longitude => $_getN(11);
  set longitude(double v) {
    $_setDouble(11, v);
  }

  bool hasLongitude() => $_has(11);
  void clearLongitude() => clearField(19);

  String get senderName => $_getS(12, '');
  set senderName(String v) {
    $_setString(12, v);
  }

  bool hasSenderName() => $_has(12);
  void clearSenderName() => clearField(21);

  Int64 get proposalId => $_getI64(13);
  set proposalId(Int64 v) {
    $_setInt64(13, v);
  }

  bool hasProposalId() => $_has(13);
  void clearProposalId() => clearField(22);

  List<int> get categories => $_getList(14);

  bool get archived => $_get(15, false);
  set archived(bool v) {
    $_setBool(15, v);
  }

  bool hasArchived() => $_has(15);
  void clearArchived() => clearField(26);

  DataTerms get terms => $_getN(16);
  set terms(DataTerms v) {
    setField(27, v);
  }

  bool hasTerms() => $_has(16);
  void clearTerms() => clearField(27);

  List<int> get thumbnailBlurred => $_getN(17);
  set thumbnailBlurred(List<int> v) {
    $_setBytes(17, v);
  }

  bool hasThumbnailBlurred() => $_has(17);
  void clearThumbnailBlurred() => clearField(28);

  List<List<int>> get coversBlurred => $_getList(18);

  bool get direct => $_get(19, false);
  set direct(bool v) {
    $_setBool(19, v);
  }

  bool hasDirect() => $_has(19);
  void clearDirect() => clearField(32);

  List<int> get primaryCategories => $_getList(20);

  List<String> get coverKeys => $_getList(21);

  String get senderAvatarUrl => $_getS(22, '');
  set senderAvatarUrl(String v) {
    $_setString(22, v);
  }

  bool hasSenderAvatarUrl() => $_has(22);
  void clearSenderAvatarUrl() => clearField(35);

  List<int> get senderAvatarBlurred => $_getN(23);
  set senderAvatarBlurred(List<int> v) {
    $_setBytes(23, v);
  }

  bool hasSenderAvatarBlurred() => $_has(23);
  void clearSenderAvatarBlurred() => clearField(36);

  String get thumbnailKey => $_getS(24, '');
  set thumbnailKey(String v) {
    $_setString(24, v);
  }

  bool hasThumbnailKey() => $_has(24);
  void clearThumbnailKey() => clearField(37);

  int get proposalsProposing => $_get(25, 0);
  set proposalsProposing(int v) {
    $_setSignedInt32(25, v);
  }

  bool hasProposalsProposing() => $_has(25);
  void clearProposalsProposing() => clearField(38);

  int get proposalsNegotiating => $_get(26, 0);
  set proposalsNegotiating(int v) {
    $_setSignedInt32(26, v);
  }

  bool hasProposalsNegotiating() => $_has(26);
  void clearProposalsNegotiating() => clearField(39);

  int get proposalsDeal => $_get(27, 0);
  set proposalsDeal(int v) {
    $_setSignedInt32(27, v);
  }

  bool hasProposalsDeal() => $_has(27);
  void clearProposalsDeal() => clearField(40);

  int get proposalsRejected => $_get(28, 0);
  set proposalsRejected(int v) {
    $_setSignedInt32(28, v);
  }

  bool hasProposalsRejected() => $_has(28);
  void clearProposalsRejected() => clearField(41);

  int get proposalsDispute => $_get(29, 0);
  set proposalsDispute(int v) {
    $_setSignedInt32(29, v);
  }

  bool hasProposalsDispute() => $_has(29);
  void clearProposalsDispute() => clearField(42);

  int get proposalsResolved => $_get(30, 0);
  set proposalsResolved(int v) {
    $_setSignedInt32(30, v);
  }

  bool hasProposalsResolved() => $_has(30);
  void clearProposalsResolved() => clearField(43);

  int get proposalsComplete => $_get(31, 0);
  set proposalsComplete(int v) {
    $_setSignedInt32(31, v);
  }

  bool hasProposalsComplete() => $_has(31);
  void clearProposalsComplete() => clearField(44);

  $0.AccountType get senderType => $_getN(32);
  set senderType($0.AccountType v) {
    setField(45, v);
  }

  bool hasSenderType() => $_has(32);
  void clearSenderType() => clearField(45);
}

class DataLocation extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataLocation',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'locationId')
    ..aOS(2, 'name')
    ..a<double>(4, 'latitude', $pb.PbFieldType.OD)
    ..a<double>(5, 'longitude', $pb.PbFieldType.OD)
    ..aOS(7, 'approximate')
    ..aOS(8, 'detail')
    ..aOS(9, 'postcode')
    ..aOS(10, 'regionCode')
    ..aOS(11, 'countryCode')
    ..aInt64(12, 's2cellId')
    ..aInt64(14, 'geohashInt')
    ..aOS(15, 'geohash')
    ..hasRequiredFields = false;

  DataLocation() : super();
  DataLocation.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataLocation.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataLocation clone() => new DataLocation()..mergeFromMessage(this);
  DataLocation copyWith(void Function(DataLocation) updates) =>
      super.copyWith((message) => updates(message as DataLocation));
  $pb.BuilderInfo get info_ => _i;
  static DataLocation create() => new DataLocation();
  static $pb.PbList<DataLocation> createRepeated() =>
      new $pb.PbList<DataLocation>();
  static DataLocation getDefault() => _defaultInstance ??= create()..freeze();
  static DataLocation _defaultInstance;
  static void $checkItem(DataLocation v) {
    if (v is! DataLocation) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get locationId => $_getI64(0);
  set locationId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasLocationId() => $_has(0);
  void clearLocationId() => clearField(1);

  String get name => $_getS(1, '');
  set name(String v) {
    $_setString(1, v);
  }

  bool hasName() => $_has(1);
  void clearName() => clearField(2);

  double get latitude => $_getN(2);
  set latitude(double v) {
    $_setDouble(2, v);
  }

  bool hasLatitude() => $_has(2);
  void clearLatitude() => clearField(4);

  double get longitude => $_getN(3);
  set longitude(double v) {
    $_setDouble(3, v);
  }

  bool hasLongitude() => $_has(3);
  void clearLongitude() => clearField(5);

  String get approximate => $_getS(4, '');
  set approximate(String v) {
    $_setString(4, v);
  }

  bool hasApproximate() => $_has(4);
  void clearApproximate() => clearField(7);

  String get detail => $_getS(5, '');
  set detail(String v) {
    $_setString(5, v);
  }

  bool hasDetail() => $_has(5);
  void clearDetail() => clearField(8);

  String get postcode => $_getS(6, '');
  set postcode(String v) {
    $_setString(6, v);
  }

  bool hasPostcode() => $_has(6);
  void clearPostcode() => clearField(9);

  String get regionCode => $_getS(7, '');
  set regionCode(String v) {
    $_setString(7, v);
  }

  bool hasRegionCode() => $_has(7);
  void clearRegionCode() => clearField(10);

  String get countryCode => $_getS(8, '');
  set countryCode(String v) {
    $_setString(8, v);
  }

  bool hasCountryCode() => $_has(8);
  void clearCountryCode() => clearField(11);

  Int64 get s2cellId => $_getI64(9);
  set s2cellId(Int64 v) {
    $_setInt64(9, v);
  }

  bool hasS2cellId() => $_has(9);
  void clearS2cellId() => clearField(12);

  Int64 get geohashInt => $_getI64(10);
  set geohashInt(Int64 v) {
    $_setInt64(10, v);
  }

  bool hasGeohashInt() => $_has(10);
  void clearGeohashInt() => clearField(14);

  String get geohash => $_getS(11, '');
  set geohash(String v) {
    $_setString(11, v);
  }

  bool hasGeohash() => $_has(11);
  void clearGeohash() => clearField(15);
}

class DataAccount extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataAccount',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(4, 'sessionId')
    ..aInt64(5, 'accountId')
    ..e<$0.AccountType>(6, 'accountType', $pb.PbFieldType.OE,
        $0.AccountType.unknown, $0.AccountType.valueOf, $0.AccountType.values)
    ..e<$0.GlobalAccountState>(
        7,
        'globalAccountState',
        $pb.PbFieldType.OE,
        $0.GlobalAccountState.initialize,
        $0.GlobalAccountState.valueOf,
        $0.GlobalAccountState.values)
    ..e<$0.GlobalAccountStateReason>(
        8,
        'globalAccountStateReason',
        $pb.PbFieldType.OE,
        $0.GlobalAccountStateReason.newAccount,
        $0.GlobalAccountStateReason.valueOf,
        $0.GlobalAccountStateReason.values)
    ..e<$0.AccountLevel>(9, 'accountLevel', $pb.PbFieldType.OE,
        $0.AccountLevel.free, $0.AccountLevel.valueOf, $0.AccountLevel.values)
    ..e<$0.NotificationFlags>(
        10,
        'notificationFlags',
        $pb.PbFieldType.OE,
        $0.NotificationFlags.accountState,
        $0.NotificationFlags.valueOf,
        $0.NotificationFlags.values)
    ..aOS(11, 'firebaseToken')
    ..aOS(12, 'name')
    ..aOS(13, 'description')
    ..aOS(14, 'location')
    ..aOS(15, 'avatarUrl')
    ..aOS(16, 'blurredAvatarUrl')
    ..p<int>(18, 'categories', $pb.PbFieldType.P3)
    ..pp<DataSocialMedia>(19, 'socialMedia', $pb.PbFieldType.PM,
        DataSocialMedia.$checkItem, DataSocialMedia.create)
    ..pPS(21, 'coverUrls')
    ..pPS(22, 'blurredCoverUrls')
    ..aOS(24, 'website')
    ..aOS(25, 'email')
    ..aOS(27, 'locationName')
    ..aOS(28, 'locationAddress')
    ..a<double>(29, 'latitude', $pb.PbFieldType.OD)
    ..a<double>(30, 'longitude', $pb.PbFieldType.OD)
    ..aInt64(31, 'locationId')
    ..hasRequiredFields = false;

  DataAccount() : super();
  DataAccount.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataAccount.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataAccount clone() => new DataAccount()..mergeFromMessage(this);
  DataAccount copyWith(void Function(DataAccount) updates) =>
      super.copyWith((message) => updates(message as DataAccount));
  $pb.BuilderInfo get info_ => _i;
  static DataAccount create() => new DataAccount();
  static $pb.PbList<DataAccount> createRepeated() =>
      new $pb.PbList<DataAccount>();
  static DataAccount getDefault() => _defaultInstance ??= create()..freeze();
  static DataAccount _defaultInstance;
  static void $checkItem(DataAccount v) {
    if (v is! DataAccount) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get sessionId => $_getI64(0);
  set sessionId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasSessionId() => $_has(0);
  void clearSessionId() => clearField(4);

  Int64 get accountId => $_getI64(1);
  set accountId(Int64 v) {
    $_setInt64(1, v);
  }

  bool hasAccountId() => $_has(1);
  void clearAccountId() => clearField(5);

  $0.AccountType get accountType => $_getN(2);
  set accountType($0.AccountType v) {
    setField(6, v);
  }

  bool hasAccountType() => $_has(2);
  void clearAccountType() => clearField(6);

  $0.GlobalAccountState get globalAccountState => $_getN(3);
  set globalAccountState($0.GlobalAccountState v) {
    setField(7, v);
  }

  bool hasGlobalAccountState() => $_has(3);
  void clearGlobalAccountState() => clearField(7);

  $0.GlobalAccountStateReason get globalAccountStateReason => $_getN(4);
  set globalAccountStateReason($0.GlobalAccountStateReason v) {
    setField(8, v);
  }

  bool hasGlobalAccountStateReason() => $_has(4);
  void clearGlobalAccountStateReason() => clearField(8);

  $0.AccountLevel get accountLevel => $_getN(5);
  set accountLevel($0.AccountLevel v) {
    setField(9, v);
  }

  bool hasAccountLevel() => $_has(5);
  void clearAccountLevel() => clearField(9);

  $0.NotificationFlags get notificationFlags => $_getN(6);
  set notificationFlags($0.NotificationFlags v) {
    setField(10, v);
  }

  bool hasNotificationFlags() => $_has(6);
  void clearNotificationFlags() => clearField(10);

  String get firebaseToken => $_getS(7, '');
  set firebaseToken(String v) {
    $_setString(7, v);
  }

  bool hasFirebaseToken() => $_has(7);
  void clearFirebaseToken() => clearField(11);

  String get name => $_getS(8, '');
  set name(String v) {
    $_setString(8, v);
  }

  bool hasName() => $_has(8);
  void clearName() => clearField(12);

  String get description => $_getS(9, '');
  set description(String v) {
    $_setString(9, v);
  }

  bool hasDescription() => $_has(9);
  void clearDescription() => clearField(13);

  String get location => $_getS(10, '');
  set location(String v) {
    $_setString(10, v);
  }

  bool hasLocation() => $_has(10);
  void clearLocation() => clearField(14);

  String get avatarUrl => $_getS(11, '');
  set avatarUrl(String v) {
    $_setString(11, v);
  }

  bool hasAvatarUrl() => $_has(11);
  void clearAvatarUrl() => clearField(15);

  String get blurredAvatarUrl => $_getS(12, '');
  set blurredAvatarUrl(String v) {
    $_setString(12, v);
  }

  bool hasBlurredAvatarUrl() => $_has(12);
  void clearBlurredAvatarUrl() => clearField(16);

  List<int> get categories => $_getList(13);

  List<DataSocialMedia> get socialMedia => $_getList(14);

  List<String> get coverUrls => $_getList(15);

  List<String> get blurredCoverUrls => $_getList(16);

  String get website => $_getS(17, '');
  set website(String v) {
    $_setString(17, v);
  }

  bool hasWebsite() => $_has(17);
  void clearWebsite() => clearField(24);

  String get email => $_getS(18, '');
  set email(String v) {
    $_setString(18, v);
  }

  bool hasEmail() => $_has(18);
  void clearEmail() => clearField(25);

  String get locationName => $_getS(19, '');
  set locationName(String v) {
    $_setString(19, v);
  }

  bool hasLocationName() => $_has(19);
  void clearLocationName() => clearField(27);

  String get locationAddress => $_getS(20, '');
  set locationAddress(String v) {
    $_setString(20, v);
  }

  bool hasLocationAddress() => $_has(20);
  void clearLocationAddress() => clearField(28);

  double get latitude => $_getN(21);
  set latitude(double v) {
    $_setDouble(21, v);
  }

  bool hasLatitude() => $_has(21);
  void clearLatitude() => clearField(29);

  double get longitude => $_getN(22);
  set longitude(double v) {
    $_setDouble(22, v);
  }

  bool hasLongitude() => $_has(22);
  void clearLongitude() => clearField(30);

  Int64 get locationId => $_getI64(23);
  set locationId(Int64 v) {
    $_setInt64(23, v);
  }

  bool hasLocationId() => $_has(23);
  void clearLocationId() => clearField(31);
}

class DataProposal extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataProposal',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'proposalId')
    ..aInt64(2, 'offerId')
    ..aInt64(3, 'influencerAccountId')
    ..aInt64(4, 'termsChatId')
    ..aOB(5, 'businessWantsDeal')
    ..aOB(6, 'influencerWantsDeal')
    ..aOB(7, 'influencerMarkedDelivered')
    ..aOB(8, 'influencerMarkedRewarded')
    ..aOB(9, 'businessMarkedDelivered')
    ..aOB(10, 'businessMarkedRewarded')
    ..a<int>(11, 'businessGaveRating', $pb.PbFieldType.O3)
    ..a<int>(12, 'influencerGaveRating', $pb.PbFieldType.O3)
    ..e<$0.ProposalState>(
        13,
        'state',
        $pb.PbFieldType.OE,
        $0.ProposalState.proposing,
        $0.ProposalState.valueOf,
        $0.ProposalState.values)
    ..aOB(14, 'businessDisputed')
    ..aOB(15, 'influencerDisputed')
    ..aInt64(16, 'businessAccountId')
    ..aOS(17, 'influencerName')
    ..aOS(18, 'businessName')
    ..aOS(19, 'offerTitle')
    ..aInt64(20, 'senderAccountId')
    ..aOB(21, 'archived')
    ..aInt64(22, 'lastChatId')
    ..aInt64(23, 'influencerSeenChatId')
    ..aInt64(24, 'influencerSeenTime')
    ..aInt64(25, 'businessSeenChatId')
    ..aInt64(26, 'businessSeenTime')
    ..hasRequiredFields = false;

  DataProposal() : super();
  DataProposal.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataProposal.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataProposal clone() => new DataProposal()..mergeFromMessage(this);
  DataProposal copyWith(void Function(DataProposal) updates) =>
      super.copyWith((message) => updates(message as DataProposal));
  $pb.BuilderInfo get info_ => _i;
  static DataProposal create() => new DataProposal();
  static $pb.PbList<DataProposal> createRepeated() =>
      new $pb.PbList<DataProposal>();
  static DataProposal getDefault() => _defaultInstance ??= create()..freeze();
  static DataProposal _defaultInstance;
  static void $checkItem(DataProposal v) {
    if (v is! DataProposal) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get proposalId => $_getI64(0);
  set proposalId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasProposalId() => $_has(0);
  void clearProposalId() => clearField(1);

  Int64 get offerId => $_getI64(1);
  set offerId(Int64 v) {
    $_setInt64(1, v);
  }

  bool hasOfferId() => $_has(1);
  void clearOfferId() => clearField(2);

  Int64 get influencerAccountId => $_getI64(2);
  set influencerAccountId(Int64 v) {
    $_setInt64(2, v);
  }

  bool hasInfluencerAccountId() => $_has(2);
  void clearInfluencerAccountId() => clearField(3);

  Int64 get termsChatId => $_getI64(3);
  set termsChatId(Int64 v) {
    $_setInt64(3, v);
  }

  bool hasTermsChatId() => $_has(3);
  void clearTermsChatId() => clearField(4);

  bool get businessWantsDeal => $_get(4, false);
  set businessWantsDeal(bool v) {
    $_setBool(4, v);
  }

  bool hasBusinessWantsDeal() => $_has(4);
  void clearBusinessWantsDeal() => clearField(5);

  bool get influencerWantsDeal => $_get(5, false);
  set influencerWantsDeal(bool v) {
    $_setBool(5, v);
  }

  bool hasInfluencerWantsDeal() => $_has(5);
  void clearInfluencerWantsDeal() => clearField(6);

  bool get influencerMarkedDelivered => $_get(6, false);
  set influencerMarkedDelivered(bool v) {
    $_setBool(6, v);
  }

  bool hasInfluencerMarkedDelivered() => $_has(6);
  void clearInfluencerMarkedDelivered() => clearField(7);

  bool get influencerMarkedRewarded => $_get(7, false);
  set influencerMarkedRewarded(bool v) {
    $_setBool(7, v);
  }

  bool hasInfluencerMarkedRewarded() => $_has(7);
  void clearInfluencerMarkedRewarded() => clearField(8);

  bool get businessMarkedDelivered => $_get(8, false);
  set businessMarkedDelivered(bool v) {
    $_setBool(8, v);
  }

  bool hasBusinessMarkedDelivered() => $_has(8);
  void clearBusinessMarkedDelivered() => clearField(9);

  bool get businessMarkedRewarded => $_get(9, false);
  set businessMarkedRewarded(bool v) {
    $_setBool(9, v);
  }

  bool hasBusinessMarkedRewarded() => $_has(9);
  void clearBusinessMarkedRewarded() => clearField(10);

  int get businessGaveRating => $_get(10, 0);
  set businessGaveRating(int v) {
    $_setSignedInt32(10, v);
  }

  bool hasBusinessGaveRating() => $_has(10);
  void clearBusinessGaveRating() => clearField(11);

  int get influencerGaveRating => $_get(11, 0);
  set influencerGaveRating(int v) {
    $_setSignedInt32(11, v);
  }

  bool hasInfluencerGaveRating() => $_has(11);
  void clearInfluencerGaveRating() => clearField(12);

  $0.ProposalState get state => $_getN(12);
  set state($0.ProposalState v) {
    setField(13, v);
  }

  bool hasState() => $_has(12);
  void clearState() => clearField(13);

  bool get businessDisputed => $_get(13, false);
  set businessDisputed(bool v) {
    $_setBool(13, v);
  }

  bool hasBusinessDisputed() => $_has(13);
  void clearBusinessDisputed() => clearField(14);

  bool get influencerDisputed => $_get(14, false);
  set influencerDisputed(bool v) {
    $_setBool(14, v);
  }

  bool hasInfluencerDisputed() => $_has(14);
  void clearInfluencerDisputed() => clearField(15);

  Int64 get businessAccountId => $_getI64(15);
  set businessAccountId(Int64 v) {
    $_setInt64(15, v);
  }

  bool hasBusinessAccountId() => $_has(15);
  void clearBusinessAccountId() => clearField(16);

  String get influencerName => $_getS(16, '');
  set influencerName(String v) {
    $_setString(16, v);
  }

  bool hasInfluencerName() => $_has(16);
  void clearInfluencerName() => clearField(17);

  String get businessName => $_getS(17, '');
  set businessName(String v) {
    $_setString(17, v);
  }

  bool hasBusinessName() => $_has(17);
  void clearBusinessName() => clearField(18);

  String get offerTitle => $_getS(18, '');
  set offerTitle(String v) {
    $_setString(18, v);
  }

  bool hasOfferTitle() => $_has(18);
  void clearOfferTitle() => clearField(19);

  Int64 get senderAccountId => $_getI64(19);
  set senderAccountId(Int64 v) {
    $_setInt64(19, v);
  }

  bool hasSenderAccountId() => $_has(19);
  void clearSenderAccountId() => clearField(20);

  bool get archived => $_get(20, false);
  set archived(bool v) {
    $_setBool(20, v);
  }

  bool hasArchived() => $_has(20);
  void clearArchived() => clearField(21);

  Int64 get lastChatId => $_getI64(21);
  set lastChatId(Int64 v) {
    $_setInt64(21, v);
  }

  bool hasLastChatId() => $_has(21);
  void clearLastChatId() => clearField(22);

  Int64 get influencerSeenChatId => $_getI64(22);
  set influencerSeenChatId(Int64 v) {
    $_setInt64(22, v);
  }

  bool hasInfluencerSeenChatId() => $_has(22);
  void clearInfluencerSeenChatId() => clearField(23);

  Int64 get influencerSeenTime => $_getI64(23);
  set influencerSeenTime(Int64 v) {
    $_setInt64(23, v);
  }

  bool hasInfluencerSeenTime() => $_has(23);
  void clearInfluencerSeenTime() => clearField(24);

  Int64 get businessSeenChatId => $_getI64(24);
  set businessSeenChatId(Int64 v) {
    $_setInt64(24, v);
  }

  bool hasBusinessSeenChatId() => $_has(24);
  void clearBusinessSeenChatId() => clearField(25);

  Int64 get businessSeenTime => $_getI64(25);
  set businessSeenTime(Int64 v) {
    $_setInt64(25, v);
  }

  bool hasBusinessSeenTime() => $_has(25);
  void clearBusinessSeenTime() => clearField(26);
}

class DataProposalChat extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataProposalChat',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'proposalId')
    ..aInt64(2, 'senderId')
    ..aOS(5, 'text')
    ..a<int>(6, 'sessionGhostId', $pb.PbFieldType.O3)
    ..aInt64(7, 'chatId')
    ..e<$0.ProposalChatType>(
        8,
        'type',
        $pb.PbFieldType.OE,
        $0.ProposalChatType.plain,
        $0.ProposalChatType.valueOf,
        $0.ProposalChatType.values)
    ..aInt64(10, 'sent')
    ..aInt64(11, 'sessionId')
    ..hasRequiredFields = false;

  DataProposalChat() : super();
  DataProposalChat.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataProposalChat.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataProposalChat clone() => new DataProposalChat()..mergeFromMessage(this);
  DataProposalChat copyWith(void Function(DataProposalChat) updates) =>
      super.copyWith((message) => updates(message as DataProposalChat));
  $pb.BuilderInfo get info_ => _i;
  static DataProposalChat create() => new DataProposalChat();
  static $pb.PbList<DataProposalChat> createRepeated() =>
      new $pb.PbList<DataProposalChat>();
  static DataProposalChat getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DataProposalChat _defaultInstance;
  static void $checkItem(DataProposalChat v) {
    if (v is! DataProposalChat) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get proposalId => $_getI64(0);
  set proposalId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasProposalId() => $_has(0);
  void clearProposalId() => clearField(1);

  Int64 get senderId => $_getI64(1);
  set senderId(Int64 v) {
    $_setInt64(1, v);
  }

  bool hasSenderId() => $_has(1);
  void clearSenderId() => clearField(2);

  String get text => $_getS(2, '');
  set text(String v) {
    $_setString(2, v);
  }

  bool hasText() => $_has(2);
  void clearText() => clearField(5);

  int get sessionGhostId => $_get(3, 0);
  set sessionGhostId(int v) {
    $_setSignedInt32(3, v);
  }

  bool hasSessionGhostId() => $_has(3);
  void clearSessionGhostId() => clearField(6);

  Int64 get chatId => $_getI64(4);
  set chatId(Int64 v) {
    $_setInt64(4, v);
  }

  bool hasChatId() => $_has(4);
  void clearChatId() => clearField(7);

  $0.ProposalChatType get type => $_getN(5);
  set type($0.ProposalChatType v) {
    setField(8, v);
  }

  bool hasType() => $_has(5);
  void clearType() => clearField(8);

  Int64 get sent => $_getI64(6);
  set sent(Int64 v) {
    $_setInt64(6, v);
  }

  bool hasSent() => $_has(6);
  void clearSent() => clearField(10);

  Int64 get sessionId => $_getI64(7);
  set sessionId(Int64 v) {
    $_setInt64(7, v);
  }

  bool hasSessionId() => $_has(7);
  void clearSessionId() => clearField(11);
}
