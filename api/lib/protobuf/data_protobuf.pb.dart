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
      package: const $pb.PackageName('inf'))
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
    if (v is! DataSocialMedia) $pb.checkItemFailed(v, _i.messageName);
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
}

class DataOAuthCredentials extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataOAuthCredentials',
      package: const $pb.PackageName('inf'))
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
    if (v is! DataOAuthCredentials) $pb.checkItemFailed(v, _i.messageName);
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

class DataBusinessOffer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataBusinessOffer',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'offerId', $pb.PbFieldType.O3)
    ..a<int>(2, 'accountId', $pb.PbFieldType.O3)
    ..a<int>(3, 'locationId', $pb.PbFieldType.O3)
    ..aOS(4, 'title')
    ..aOS(5, 'description')
    ..aOS(6, 'thumbnailUrl')
    ..aOS(7, 'deliverables')
    ..aOS(8, 'reward')
    ..aOS(9, 'location')
    ..pPS(10, 'coverUrls')
    ..e<$0.BusinessOfferState>(
        12,
        'state',
        $pb.PbFieldType.OE,
        $0.BusinessOfferState.BOS_DRAFT,
        $0.BusinessOfferState.valueOf,
        $0.BusinessOfferState.values)
    ..e<$0.BusinessOfferStateReason>(
        13,
        'stateReason',
        $pb.PbFieldType.OE,
        $0.BusinessOfferStateReason.BOSR_NEW_OFFER,
        $0.BusinessOfferStateReason.valueOf,
        $0.BusinessOfferStateReason.values)
    ..a<int>(14, 'applicantsNew', $pb.PbFieldType.O3)
    ..a<int>(15, 'applicantsAccepted', $pb.PbFieldType.O3)
    ..a<int>(16, 'applicantsCompleted', $pb.PbFieldType.O3)
    ..a<int>(17, 'applicantsRefused', $pb.PbFieldType.O3)
    ..a<double>(18, 'latitude', $pb.PbFieldType.OD)
    ..a<double>(19, 'longitude', $pb.PbFieldType.OD)
    ..a<int>(20, 'locationOfferCount', $pb.PbFieldType.O3)
    ..aOS(21, 'locationName')
    ..a<int>(22, 'influencerApplicantId', $pb.PbFieldType.O3)
    ..a<List<int>>(23, 'categories', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  DataBusinessOffer() : super();
  DataBusinessOffer.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataBusinessOffer.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataBusinessOffer clone() => new DataBusinessOffer()..mergeFromMessage(this);
  DataBusinessOffer copyWith(void Function(DataBusinessOffer) updates) =>
      super.copyWith((message) => updates(message as DataBusinessOffer));
  $pb.BuilderInfo get info_ => _i;
  static DataBusinessOffer create() => new DataBusinessOffer();
  static $pb.PbList<DataBusinessOffer> createRepeated() =>
      new $pb.PbList<DataBusinessOffer>();
  static DataBusinessOffer getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DataBusinessOffer _defaultInstance;
  static void $checkItem(DataBusinessOffer v) {
    if (v is! DataBusinessOffer) $pb.checkItemFailed(v, _i.messageName);
  }

  int get offerId => $_get(0, 0);
  set offerId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasOfferId() => $_has(0);
  void clearOfferId() => clearField(1);

  int get accountId => $_get(1, 0);
  set accountId(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasAccountId() => $_has(1);
  void clearAccountId() => clearField(2);

  int get locationId => $_get(2, 0);
  set locationId(int v) {
    $_setSignedInt32(2, v);
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

  $0.BusinessOfferState get state => $_getN(10);
  set state($0.BusinessOfferState v) {
    setField(12, v);
  }

  bool hasState() => $_has(10);
  void clearState() => clearField(12);

  $0.BusinessOfferStateReason get stateReason => $_getN(11);
  set stateReason($0.BusinessOfferStateReason v) {
    setField(13, v);
  }

  bool hasStateReason() => $_has(11);
  void clearStateReason() => clearField(13);

  int get applicantsNew => $_get(12, 0);
  set applicantsNew(int v) {
    $_setSignedInt32(12, v);
  }

  bool hasApplicantsNew() => $_has(12);
  void clearApplicantsNew() => clearField(14);

  int get applicantsAccepted => $_get(13, 0);
  set applicantsAccepted(int v) {
    $_setSignedInt32(13, v);
  }

  bool hasApplicantsAccepted() => $_has(13);
  void clearApplicantsAccepted() => clearField(15);

  int get applicantsCompleted => $_get(14, 0);
  set applicantsCompleted(int v) {
    $_setSignedInt32(14, v);
  }

  bool hasApplicantsCompleted() => $_has(14);
  void clearApplicantsCompleted() => clearField(16);

  int get applicantsRefused => $_get(15, 0);
  set applicantsRefused(int v) {
    $_setSignedInt32(15, v);
  }

  bool hasApplicantsRefused() => $_has(15);
  void clearApplicantsRefused() => clearField(17);

  double get latitude => $_getN(16);
  set latitude(double v) {
    $_setDouble(16, v);
  }

  bool hasLatitude() => $_has(16);
  void clearLatitude() => clearField(18);

  double get longitude => $_getN(17);
  set longitude(double v) {
    $_setDouble(17, v);
  }

  bool hasLongitude() => $_has(17);
  void clearLongitude() => clearField(19);

  int get locationOfferCount => $_get(18, 0);
  set locationOfferCount(int v) {
    $_setSignedInt32(18, v);
  }

  bool hasLocationOfferCount() => $_has(18);
  void clearLocationOfferCount() => clearField(20);

  String get locationName => $_getS(19, '');
  set locationName(String v) {
    $_setString(19, v);
  }

  bool hasLocationName() => $_has(19);
  void clearLocationName() => clearField(21);

  int get influencerApplicantId => $_get(20, 0);
  set influencerApplicantId(int v) {
    $_setSignedInt32(20, v);
  }

  bool hasInfluencerApplicantId() => $_has(20);
  void clearInfluencerApplicantId() => clearField(22);

  List<int> get categories => $_getN(21);
  set categories(List<int> v) {
    $_setBytes(21, v);
  }

  bool hasCategories() => $_has(21);
  void clearCategories() => clearField(23);
}

class DataLocation extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('DataLocation', package: const $pb.PackageName('inf'))
        ..a<int>(1, 'locationId', $pb.PbFieldType.O3)
        ..aOS(2, 'name')
        ..a<double>(4, 'latitude', $pb.PbFieldType.OD)
        ..a<double>(5, 'longitude', $pb.PbFieldType.OD)
        ..aOS(6, 'avatarUrl')
        ..aOS(7, 'approximate')
        ..aOS(8, 'detail')
        ..aOS(9, 'postcode')
        ..aOS(10, 'regionCode')
        ..aOS(11, 'countryCode')
        ..aInt64(12, 's2cellId')
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
    if (v is! DataLocation) $pb.checkItemFailed(v, _i.messageName);
  }

  int get locationId => $_get(0, 0);
  set locationId(int v) {
    $_setSignedInt32(0, v);
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

  String get avatarUrl => $_getS(4, '');
  set avatarUrl(String v) {
    $_setString(4, v);
  }

  bool hasAvatarUrl() => $_has(4);
  void clearAvatarUrl() => clearField(6);

  String get approximate => $_getS(5, '');
  set approximate(String v) {
    $_setString(5, v);
  }

  bool hasApproximate() => $_has(5);
  void clearApproximate() => clearField(7);

  String get detail => $_getS(6, '');
  set detail(String v) {
    $_setString(6, v);
  }

  bool hasDetail() => $_has(6);
  void clearDetail() => clearField(8);

  String get postcode => $_getS(7, '');
  set postcode(String v) {
    $_setString(7, v);
  }

  bool hasPostcode() => $_has(7);
  void clearPostcode() => clearField(9);

  String get regionCode => $_getS(8, '');
  set regionCode(String v) {
    $_setString(8, v);
  }

  bool hasRegionCode() => $_has(8);
  void clearRegionCode() => clearField(10);

  String get countryCode => $_getS(9, '');
  set countryCode(String v) {
    $_setString(9, v);
  }

  bool hasCountryCode() => $_has(9);
  void clearCountryCode() => clearField(11);

  Int64 get s2cellId => $_getI64(10);
  set s2cellId(Int64 v) {
    $_setInt64(10, v);
  }

  bool hasS2cellId() => $_has(10);
  void clearS2cellId() => clearField(12);
}

class DataAccountState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataAccountState',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'deviceId', $pb.PbFieldType.O3)
    ..a<int>(2, 'accountId', $pb.PbFieldType.O3)
    ..e<$0.AccountType>(
        3,
        'accountType',
        $pb.PbFieldType.OE,
        $0.AccountType.AT_UNKNOWN,
        $0.AccountType.valueOf,
        $0.AccountType.values)
    ..e<$0.GlobalAccountState>(
        4,
        'globalAccountState',
        $pb.PbFieldType.OE,
        $0.GlobalAccountState.GAS_INITIALIZE,
        $0.GlobalAccountState.valueOf,
        $0.GlobalAccountState.values)
    ..e<$0.GlobalAccountStateReason>(
        5,
        'globalAccountStateReason',
        $pb.PbFieldType.OE,
        $0.GlobalAccountStateReason.GASR_NEW_ACCOUNT,
        $0.GlobalAccountStateReason.valueOf,
        $0.GlobalAccountStateReason.values)
    ..e<$0.NotificationFlags>(
        6,
        'notificationFlags',
        $pb.PbFieldType.OE,
        $0.NotificationFlags.NF_ACCOUNT_STATE,
        $0.NotificationFlags.valueOf,
        $0.NotificationFlags.values)
    ..aOS(7, 'firebaseToken')
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
    if (v is! DataAccountState) $pb.checkItemFailed(v, _i.messageName);
  }

  int get deviceId => $_get(0, 0);
  set deviceId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasDeviceId() => $_has(0);
  void clearDeviceId() => clearField(1);

  int get accountId => $_get(1, 0);
  set accountId(int v) {
    $_setSignedInt32(1, v);
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
}

class DataAccountSummary extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataAccountSummary',
      package: const $pb.PackageName('inf'))
    ..aOS(1, 'name')
    ..aOS(2, 'description')
    ..aOS(3, 'location')
    ..aOS(4, 'avatarThumbnailUrl')
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
    if (v is! DataAccountSummary) $pb.checkItemFailed(v, _i.messageName);
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
}

class DataAccountDetail extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataAccountDetail',
      package: const $pb.PackageName('inf'))
    ..pp<DataSocialMedia>(3, 'socialMedia', $pb.PbFieldType.PM,
        DataSocialMedia.$checkItem, DataSocialMedia.create)
    ..a<double>(4, 'latitude', $pb.PbFieldType.OD)
    ..a<double>(5, 'longitude', $pb.PbFieldType.OD)
    ..aOS(6, 'url')
    ..aOS(7, 'avatarCoverUrl')
    ..a<int>(8, 'locationId', $pb.PbFieldType.O3)
    ..aOS(9, 'email')
    ..a<List<int>>(11, 'categories', $pb.PbFieldType.OY)
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
    if (v is! DataAccountDetail) $pb.checkItemFailed(v, _i.messageName);
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

  String get url => $_getS(3, '');
  set url(String v) {
    $_setString(3, v);
  }

  bool hasUrl() => $_has(3);
  void clearUrl() => clearField(6);

  String get avatarCoverUrl => $_getS(4, '');
  set avatarCoverUrl(String v) {
    $_setString(4, v);
  }

  bool hasAvatarCoverUrl() => $_has(4);
  void clearAvatarCoverUrl() => clearField(7);

  int get locationId => $_get(5, 0);
  set locationId(int v) {
    $_setSignedInt32(5, v);
  }

  bool hasLocationId() => $_has(5);
  void clearLocationId() => clearField(8);

  String get email => $_getS(6, '');
  set email(String v) {
    $_setString(6, v);
  }

  bool hasEmail() => $_has(6);
  void clearEmail() => clearField(9);

  List<int> get categories => $_getN(7);
  set categories(List<int> v) {
    $_setBytes(7, v);
  }

  bool hasCategories() => $_has(7);
  void clearCategories() => clearField(11);
}

class DataAccount extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('DataAccount', package: const $pb.PackageName('inf'))
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
    if (v is! DataAccount) $pb.checkItemFailed(v, _i.messageName);
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

class DataApplicant extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataApplicant',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..a<int>(2, 'offerId', $pb.PbFieldType.O3)
    ..a<int>(3, 'influencerAccountId', $pb.PbFieldType.O3)
    ..aInt64(4, 'haggleChatId')
    ..aOB(5, 'businessWantsDeal')
    ..aOB(6, 'influencerWantsDeal')
    ..aOB(7, 'influencerMarkedDelivered')
    ..aOB(8, 'influencerMarkedRewarded')
    ..aOB(9, 'businessMarkedDelivered')
    ..aOB(10, 'businessMarkedRewarded')
    ..a<int>(11, 'businessGaveRating', $pb.PbFieldType.O3)
    ..a<int>(12, 'influencerGaveRating', $pb.PbFieldType.O3)
    ..e<$0.ApplicantState>(
        13,
        'state',
        $pb.PbFieldType.OE,
        $0.ApplicantState.AS_HAGGLING,
        $0.ApplicantState.valueOf,
        $0.ApplicantState.values)
    ..aOB(14, 'businessDisputed')
    ..aOB(15, 'influencerDisputed')
    ..a<int>(16, 'businessAccountId', $pb.PbFieldType.O3)
    ..aOS(17, 'influencerName')
    ..aOS(18, 'businessName')
    ..aOS(19, 'offerTitle')
    ..hasRequiredFields = false;

  DataApplicant() : super();
  DataApplicant.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataApplicant.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataApplicant clone() => new DataApplicant()..mergeFromMessage(this);
  DataApplicant copyWith(void Function(DataApplicant) updates) =>
      super.copyWith((message) => updates(message as DataApplicant));
  $pb.BuilderInfo get info_ => _i;
  static DataApplicant create() => new DataApplicant();
  static $pb.PbList<DataApplicant> createRepeated() =>
      new $pb.PbList<DataApplicant>();
  static DataApplicant getDefault() => _defaultInstance ??= create()..freeze();
  static DataApplicant _defaultInstance;
  static void $checkItem(DataApplicant v) {
    if (v is! DataApplicant) $pb.checkItemFailed(v, _i.messageName);
  }

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);

  int get offerId => $_get(1, 0);
  set offerId(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasOfferId() => $_has(1);
  void clearOfferId() => clearField(2);

  int get influencerAccountId => $_get(2, 0);
  set influencerAccountId(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasInfluencerAccountId() => $_has(2);
  void clearInfluencerAccountId() => clearField(3);

  Int64 get haggleChatId => $_getI64(3);
  set haggleChatId(Int64 v) {
    $_setInt64(3, v);
  }

  bool hasHaggleChatId() => $_has(3);
  void clearHaggleChatId() => clearField(4);

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

  $0.ApplicantState get state => $_getN(12);
  set state($0.ApplicantState v) {
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

  int get businessAccountId => $_get(15, 0);
  set businessAccountId(int v) {
    $_setSignedInt32(15, v);
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
}

class DataApplicantChat extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DataApplicantChat',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..a<int>(2, 'senderId', $pb.PbFieldType.O3)
    ..aOS(5, 'text')
    ..a<int>(6, 'deviceGhostId', $pb.PbFieldType.O3)
    ..aInt64(7, 'chatId')
    ..e<$0.ApplicantChatType>(
        8,
        'type',
        $pb.PbFieldType.OE,
        $0.ApplicantChatType.ACT_PLAIN,
        $0.ApplicantChatType.valueOf,
        $0.ApplicantChatType.values)
    ..aInt64(9, 'seen')
    ..aInt64(10, 'sent')
    ..a<int>(11, 'deviceId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  DataApplicantChat() : super();
  DataApplicantChat.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DataApplicantChat.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DataApplicantChat clone() => new DataApplicantChat()..mergeFromMessage(this);
  DataApplicantChat copyWith(void Function(DataApplicantChat) updates) =>
      super.copyWith((message) => updates(message as DataApplicantChat));
  $pb.BuilderInfo get info_ => _i;
  static DataApplicantChat create() => new DataApplicantChat();
  static $pb.PbList<DataApplicantChat> createRepeated() =>
      new $pb.PbList<DataApplicantChat>();
  static DataApplicantChat getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DataApplicantChat _defaultInstance;
  static void $checkItem(DataApplicantChat v) {
    if (v is! DataApplicantChat) $pb.checkItemFailed(v, _i.messageName);
  }

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);

  int get senderId => $_get(1, 0);
  set senderId(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasSenderId() => $_has(1);
  void clearSenderId() => clearField(2);

  String get text => $_getS(2, '');
  set text(String v) {
    $_setString(2, v);
  }

  bool hasText() => $_has(2);
  void clearText() => clearField(5);

  int get deviceGhostId => $_get(3, 0);
  set deviceGhostId(int v) {
    $_setSignedInt32(3, v);
  }

  bool hasDeviceGhostId() => $_has(3);
  void clearDeviceGhostId() => clearField(6);

  Int64 get chatId => $_getI64(4);
  set chatId(Int64 v) {
    $_setInt64(4, v);
  }

  bool hasChatId() => $_has(4);
  void clearChatId() => clearField(7);

  $0.ApplicantChatType get type => $_getN(5);
  set type($0.ApplicantChatType v) {
    setField(8, v);
  }

  bool hasType() => $_has(5);
  void clearType() => clearField(8);

  Int64 get seen => $_getI64(6);
  set seen(Int64 v) {
    $_setInt64(6, v);
  }

  bool hasSeen() => $_has(6);
  void clearSeen() => clearField(9);

  Int64 get sent => $_getI64(7);
  set sent(Int64 v) {
    $_setInt64(7, v);
  }

  bool hasSent() => $_has(7);
  void clearSent() => clearField(10);

  int get deviceId => $_get(8, 0);
  set deviceId(int v) {
    $_setSignedInt32(8, v);
  }

  bool hasDeviceId() => $_has(8);
  void clearDeviceId() => clearField(11);
}
