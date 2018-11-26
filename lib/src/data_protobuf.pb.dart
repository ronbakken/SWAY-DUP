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

class DataOffer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataOffer',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'offerId')
    ..aInt64(2, 'accountId')
    ..aInt64(3, 'locationId')
    ..aOS(4, 'title')
    ..aOS(5, 'description')
    ..aOS(6, 'thumbnailUrl')
    ..aOS(7, 'deliverables')
    ..aOS(8, 'reward')
    ..aOS(9, 'location')
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
    ..a<int>(20, 'locationOfferCount', $pb.PbFieldType.O3)
    ..aOS(21, 'locationName')
    ..aInt64(22, 'influencerProposalId')
    ..a<List<int>>(23, 'categories', $pb.PbFieldType.OY)
    ..aOS(24, 'blurredThumbnailUrl')
    ..pPS(25, 'blurredCoverUrls')
    ..aOB(26, 'archived')
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

  Int64 get accountId => $_getI64(1);
  set accountId(Int64 v) {
    $_setInt64(1, v);
  }

  bool hasAccountId() => $_has(1);
  void clearAccountId() => clearField(2);

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

  String get deliverables => $_getS(6, '');
  set deliverables(String v) {
    $_setString(6, v);
  }

  bool hasDeliverables() => $_has(6);
  void clearDeliverables() => clearField(7);

  String get reward => $_getS(7, '');
  set reward(String v) {
    $_setString(7, v);
  }

  bool hasReward() => $_has(7);
  void clearReward() => clearField(8);

  String get location => $_getS(8, '');
  set location(String v) {
    $_setString(8, v);
  }

  bool hasLocation() => $_has(8);
  void clearLocation() => clearField(9);

  List<String> get coverUrls => $_getList(9);

  $0.OfferState get state => $_getN(10);
  set state($0.OfferState v) {
    setField(12, v);
  }

  bool hasState() => $_has(10);
  void clearState() => clearField(12);

  $0.OfferStateReason get stateReason => $_getN(11);
  set stateReason($0.OfferStateReason v) {
    setField(13, v);
  }

  bool hasStateReason() => $_has(11);
  void clearStateReason() => clearField(13);

  double get latitude => $_getN(12);
  set latitude(double v) {
    $_setDouble(12, v);
  }

  bool hasLatitude() => $_has(12);
  void clearLatitude() => clearField(18);

  double get longitude => $_getN(13);
  set longitude(double v) {
    $_setDouble(13, v);
  }

  bool hasLongitude() => $_has(13);
  void clearLongitude() => clearField(19);

  int get locationOfferCount => $_get(14, 0);
  set locationOfferCount(int v) {
    $_setSignedInt32(14, v);
  }

  bool hasLocationOfferCount() => $_has(14);
  void clearLocationOfferCount() => clearField(20);

  String get locationName => $_getS(15, '');
  set locationName(String v) {
    $_setString(15, v);
  }

  bool hasLocationName() => $_has(15);
  void clearLocationName() => clearField(21);

  Int64 get influencerProposalId => $_getI64(16);
  set influencerProposalId(Int64 v) {
    $_setInt64(16, v);
  }

  bool hasInfluencerProposalId() => $_has(16);
  void clearInfluencerProposalId() => clearField(22);

  List<int> get categories => $_getN(17);
  set categories(List<int> v) {
    $_setBytes(17, v);
  }

  bool hasCategories() => $_has(17);
  void clearCategories() => clearField(23);

  String get blurredThumbnailUrl => $_getS(18, '');
  set blurredThumbnailUrl(String v) {
    $_setString(18, v);
  }

  bool hasBlurredThumbnailUrl() => $_has(18);
  void clearBlurredThumbnailUrl() => clearField(24);

  List<String> get blurredCoverUrls => $_getList(19);

  bool get archived => $_get(20, false);
  set archived(bool v) {
    $_setBool(20, v);
  }

  bool hasArchived() => $_has(20);
  void clearArchived() => clearField(26);
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
    ..aOS(15, 'geoHash')
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

  String get geoHash => $_getS(11, '');
  set geoHash(String v) {
    $_setString(11, v);
  }

  bool hasGeoHash() => $_has(11);
  void clearGeoHash() => clearField(15);
}

class DataAccountState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataAccountState',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'sessionId')
    ..aInt64(2, 'accountId')
    ..e<$0.AccountType>(3, 'accountType', $pb.PbFieldType.OE,
        $0.AccountType.unknown, $0.AccountType.valueOf, $0.AccountType.values)
    ..e<$0.GlobalAccountState>(
        4,
        'globalAccountState',
        $pb.PbFieldType.OE,
        $0.GlobalAccountState.initialize,
        $0.GlobalAccountState.valueOf,
        $0.GlobalAccountState.values)
    ..e<$0.GlobalAccountStateReason>(
        5,
        'globalAccountStateReason',
        $pb.PbFieldType.OE,
        $0.GlobalAccountStateReason.newAccount,
        $0.GlobalAccountStateReason.valueOf,
        $0.GlobalAccountStateReason.values)
    ..e<$0.NotificationFlags>(
        6,
        'notificationFlags',
        $pb.PbFieldType.OE,
        $0.NotificationFlags.accountState,
        $0.NotificationFlags.valueOf,
        $0.NotificationFlags.values)
    ..aOS(7, 'firebaseToken')
    ..e<$0.AccountLevel>(8, 'accountLevel', $pb.PbFieldType.OE,
        $0.AccountLevel.free, $0.AccountLevel.valueOf, $0.AccountLevel.values)
    ..hasRequiredFields = false;

  DataAccountState() : super();
  DataAccountState.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataAccountState.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataAccountState clone() => new DataAccountState()..mergeFromMessage(this);
  DataAccountState copyWith(void Function(DataAccountState) updates) =>
      super.copyWith((message) => updates(message as DataAccountState));
  $pb.BuilderInfo get info_ => _i;
  static DataAccountState create() => new DataAccountState();
  static $pb.PbList<DataAccountState> createRepeated() =>
      new $pb.PbList<DataAccountState>();
  static DataAccountState getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DataAccountState _defaultInstance;
  static void $checkItem(DataAccountState v) {
    if (v is! DataAccountState) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get sessionId => $_getI64(0);
  set sessionId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasSessionId() => $_has(0);
  void clearSessionId() => clearField(1);

  Int64 get accountId => $_getI64(1);
  set accountId(Int64 v) {
    $_setInt64(1, v);
  }

  bool hasAccountId() => $_has(1);
  void clearAccountId() => clearField(2);

  $0.AccountType get accountType => $_getN(2);
  set accountType($0.AccountType v) {
    setField(3, v);
  }

  bool hasAccountType() => $_has(2);
  void clearAccountType() => clearField(3);

  $0.GlobalAccountState get globalAccountState => $_getN(3);
  set globalAccountState($0.GlobalAccountState v) {
    setField(4, v);
  }

  bool hasGlobalAccountState() => $_has(3);
  void clearGlobalAccountState() => clearField(4);

  $0.GlobalAccountStateReason get globalAccountStateReason => $_getN(4);
  set globalAccountStateReason($0.GlobalAccountStateReason v) {
    setField(5, v);
  }

  bool hasGlobalAccountStateReason() => $_has(4);
  void clearGlobalAccountStateReason() => clearField(5);

  $0.NotificationFlags get notificationFlags => $_getN(5);
  set notificationFlags($0.NotificationFlags v) {
    setField(6, v);
  }

  bool hasNotificationFlags() => $_has(5);
  void clearNotificationFlags() => clearField(6);

  String get firebaseToken => $_getS(6, '');
  set firebaseToken(String v) {
    $_setString(6, v);
  }

  bool hasFirebaseToken() => $_has(6);
  void clearFirebaseToken() => clearField(7);

  $0.AccountLevel get accountLevel => $_getN(7);
  set accountLevel($0.AccountLevel v) {
    setField(8, v);
  }

  bool hasAccountLevel() => $_has(7);
  void clearAccountLevel() => clearField(8);
}

class DataAccountSummary extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataAccountSummary',
      package: const $pb.PackageName('inf_common'))
    ..aOS(1, 'name')
    ..aOS(2, 'description')
    ..aOS(3, 'location')
    ..aOS(4, 'avatarThumbnailUrl')
    ..aOS(5, 'blurredAvatarThumbnailUrl')
    ..hasRequiredFields = false;

  DataAccountSummary() : super();
  DataAccountSummary.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataAccountSummary.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataAccountSummary clone() =>
      new DataAccountSummary()..mergeFromMessage(this);
  DataAccountSummary copyWith(void Function(DataAccountSummary) updates) =>
      super.copyWith((message) => updates(message as DataAccountSummary));
  $pb.BuilderInfo get info_ => _i;
  static DataAccountSummary create() => new DataAccountSummary();
  static $pb.PbList<DataAccountSummary> createRepeated() =>
      new $pb.PbList<DataAccountSummary>();
  static DataAccountSummary getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DataAccountSummary _defaultInstance;
  static void $checkItem(DataAccountSummary v) {
    if (v is! DataAccountSummary)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get name => $_getS(0, '');
  set name(String v) {
    $_setString(0, v);
  }

  bool hasName() => $_has(0);
  void clearName() => clearField(1);

  String get description => $_getS(1, '');
  set description(String v) {
    $_setString(1, v);
  }

  bool hasDescription() => $_has(1);
  void clearDescription() => clearField(2);

  String get location => $_getS(2, '');
  set location(String v) {
    $_setString(2, v);
  }

  bool hasLocation() => $_has(2);
  void clearLocation() => clearField(3);

  String get avatarThumbnailUrl => $_getS(3, '');
  set avatarThumbnailUrl(String v) {
    $_setString(3, v);
  }

  bool hasAvatarThumbnailUrl() => $_has(3);
  void clearAvatarThumbnailUrl() => clearField(4);

  String get blurredAvatarThumbnailUrl => $_getS(4, '');
  set blurredAvatarThumbnailUrl(String v) {
    $_setString(4, v);
  }

  bool hasBlurredAvatarThumbnailUrl() => $_has(4);
  void clearBlurredAvatarThumbnailUrl() => clearField(5);
}

class DataAccountDetail extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataAccountDetail',
      package: const $pb.PackageName('inf_common'))
    ..pp<DataSocialMedia>(3, 'socialMedia', $pb.PbFieldType.PM,
        DataSocialMedia.$checkItem, DataSocialMedia.create)
    ..a<double>(4, 'latitude', $pb.PbFieldType.OD)
    ..a<double>(5, 'longitude', $pb.PbFieldType.OD)
    ..aOS(6, 'website')
    ..aOS(7, 'avatarCoverUrl')
    ..aInt64(8, 'locationId')
    ..aOS(9, 'email')
    ..aOS(12, 'blurredAvatarCoverUrl')
    ..p<int>(13, 'categories', $pb.PbFieldType.P3)
    ..aOS(14, 'locationName')
    ..aOS(15, 'location')
    ..hasRequiredFields = false;

  DataAccountDetail() : super();
  DataAccountDetail.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataAccountDetail.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataAccountDetail clone() => new DataAccountDetail()..mergeFromMessage(this);
  DataAccountDetail copyWith(void Function(DataAccountDetail) updates) =>
      super.copyWith((message) => updates(message as DataAccountDetail));
  $pb.BuilderInfo get info_ => _i;
  static DataAccountDetail create() => new DataAccountDetail();
  static $pb.PbList<DataAccountDetail> createRepeated() =>
      new $pb.PbList<DataAccountDetail>();
  static DataAccountDetail getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DataAccountDetail _defaultInstance;
  static void $checkItem(DataAccountDetail v) {
    if (v is! DataAccountDetail)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<DataSocialMedia> get socialMedia => $_getList(0);

  double get latitude => $_getN(1);
  set latitude(double v) {
    $_setDouble(1, v);
  }

  bool hasLatitude() => $_has(1);
  void clearLatitude() => clearField(4);

  double get longitude => $_getN(2);
  set longitude(double v) {
    $_setDouble(2, v);
  }

  bool hasLongitude() => $_has(2);
  void clearLongitude() => clearField(5);

  String get website => $_getS(3, '');
  set website(String v) {
    $_setString(3, v);
  }

  bool hasWebsite() => $_has(3);
  void clearWebsite() => clearField(6);

  String get avatarCoverUrl => $_getS(4, '');
  set avatarCoverUrl(String v) {
    $_setString(4, v);
  }

  bool hasAvatarCoverUrl() => $_has(4);
  void clearAvatarCoverUrl() => clearField(7);

  Int64 get locationId => $_getI64(5);
  set locationId(Int64 v) {
    $_setInt64(5, v);
  }

  bool hasLocationId() => $_has(5);
  void clearLocationId() => clearField(8);

  String get email => $_getS(6, '');
  set email(String v) {
    $_setString(6, v);
  }

  bool hasEmail() => $_has(6);
  void clearEmail() => clearField(9);

  String get blurredAvatarCoverUrl => $_getS(7, '');
  set blurredAvatarCoverUrl(String v) {
    $_setString(7, v);
  }

  bool hasBlurredAvatarCoverUrl() => $_has(7);
  void clearBlurredAvatarCoverUrl() => clearField(12);

  List<int> get categories => $_getList(8);

  String get locationName => $_getS(9, '');
  set locationName(String v) {
    $_setString(9, v);
  }

  bool hasLocationName() => $_has(9);
  void clearLocationName() => clearField(14);

  String get location => $_getS(10, '');
  set location(String v) {
    $_setString(10, v);
  }

  bool hasLocation() => $_has(10);
  void clearLocation() => clearField(15);
}

class DataAccount extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataAccount',
      package: const $pb.PackageName('inf_common'))
    ..a<DataAccountState>(1, 'state', $pb.PbFieldType.OM,
        DataAccountState.getDefault, DataAccountState.create)
    ..a<DataAccountSummary>(2, 'summary', $pb.PbFieldType.OM,
        DataAccountSummary.getDefault, DataAccountSummary.create)
    ..a<DataAccountDetail>(3, 'detail', $pb.PbFieldType.OM,
        DataAccountDetail.getDefault, DataAccountDetail.create)
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

  DataAccountState get state => $_getN(0);
  set state(DataAccountState v) {
    setField(1, v);
  }

  bool hasState() => $_has(0);
  void clearState() => clearField(1);

  DataAccountSummary get summary => $_getN(1);
  set summary(DataAccountSummary v) {
    setField(2, v);
  }

  bool hasSummary() => $_has(1);
  void clearSummary() => clearField(2);

  DataAccountDetail get detail => $_getN(2);
  set detail(DataAccountDetail v) {
    setField(3, v);
  }

  bool hasDetail() => $_has(2);
  void clearDetail() => clearField(3);
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
