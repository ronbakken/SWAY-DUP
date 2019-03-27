///
//  Generated code. Do not modify.
//  source: offer.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'location.pb.dart' as $2;
import 'google/protobuf/timestamp.pb.dart' as $6;
import 'image.pb.dart' as $1;
import 'deal_terms.pb.dart' as $10;

import 'offer.pbenum.dart';

export 'offer.pbenum.dart';

class OfferDto_ListDataDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('OfferDto.ListDataDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'businessAccountId')
    ..aOS(2, 'businessName')
    ..aOS(3, 'businessDescription')
    ..aOS(4, 'businessAvatarThumbnailUrl')
    ..aOS(5, 'title')
    ..aOS(6, 'description')
    ..a<$6.Timestamp>(7, 'created', $pb.PbFieldType.OM, $6.Timestamp.getDefault, $6.Timestamp.create)
    ..a<$6.Timestamp>(8, 'start', $pb.PbFieldType.OM, $6.Timestamp.getDefault, $6.Timestamp.create)
    ..a<$6.Timestamp>(9, 'end', $pb.PbFieldType.OM, $6.Timestamp.getDefault, $6.Timestamp.create)
    ..a<int>(10, 'numberOffered', $pb.PbFieldType.O3)
    ..a<int>(11, 'numberRemaining', $pb.PbFieldType.O3)
    ..a<$1.ImageDto>(12, 'thumbnail', $pb.PbFieldType.OM, $1.ImageDto.getDefault, $1.ImageDto.create)
    ..a<$1.ImageDto>(13, 'featuredImage', $pb.PbFieldType.OM, $1.ImageDto.getDefault, $1.ImageDto.create)
    ..a<$10.DealTermsDto>(14, 'terms', $pb.PbFieldType.OM, $10.DealTermsDto.getDefault, $10.DealTermsDto.create)
    ..hasRequiredFields = false
  ;

  OfferDto_ListDataDto() : super();
  OfferDto_ListDataDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OfferDto_ListDataDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OfferDto_ListDataDto clone() => new OfferDto_ListDataDto()..mergeFromMessage(this);
  OfferDto_ListDataDto copyWith(void Function(OfferDto_ListDataDto) updates) => super.copyWith((message) => updates(message as OfferDto_ListDataDto));
  $pb.BuilderInfo get info_ => _i;
  static OfferDto_ListDataDto create() => new OfferDto_ListDataDto();
  OfferDto_ListDataDto createEmptyInstance() => create();
  static $pb.PbList<OfferDto_ListDataDto> createRepeated() => new $pb.PbList<OfferDto_ListDataDto>();
  static OfferDto_ListDataDto getDefault() => _defaultInstance ??= create()..freeze();
  static OfferDto_ListDataDto _defaultInstance;
  static void $checkItem(OfferDto_ListDataDto v) {
    if (v is! OfferDto_ListDataDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get businessAccountId => $_getS(0, '');
  set businessAccountId(String v) { $_setString(0, v); }
  bool hasBusinessAccountId() => $_has(0);
  void clearBusinessAccountId() => clearField(1);

  String get businessName => $_getS(1, '');
  set businessName(String v) { $_setString(1, v); }
  bool hasBusinessName() => $_has(1);
  void clearBusinessName() => clearField(2);

  String get businessDescription => $_getS(2, '');
  set businessDescription(String v) { $_setString(2, v); }
  bool hasBusinessDescription() => $_has(2);
  void clearBusinessDescription() => clearField(3);

  String get businessAvatarThumbnailUrl => $_getS(3, '');
  set businessAvatarThumbnailUrl(String v) { $_setString(3, v); }
  bool hasBusinessAvatarThumbnailUrl() => $_has(3);
  void clearBusinessAvatarThumbnailUrl() => clearField(4);

  String get title => $_getS(4, '');
  set title(String v) { $_setString(4, v); }
  bool hasTitle() => $_has(4);
  void clearTitle() => clearField(5);

  String get description => $_getS(5, '');
  set description(String v) { $_setString(5, v); }
  bool hasDescription() => $_has(5);
  void clearDescription() => clearField(6);

  $6.Timestamp get created => $_getN(6);
  set created($6.Timestamp v) { setField(7, v); }
  bool hasCreated() => $_has(6);
  void clearCreated() => clearField(7);

  $6.Timestamp get start => $_getN(7);
  set start($6.Timestamp v) { setField(8, v); }
  bool hasStart() => $_has(7);
  void clearStart() => clearField(8);

  $6.Timestamp get end => $_getN(8);
  set end($6.Timestamp v) { setField(9, v); }
  bool hasEnd() => $_has(8);
  void clearEnd() => clearField(9);

  int get numberOffered => $_get(9, 0);
  set numberOffered(int v) { $_setSignedInt32(9, v); }
  bool hasNumberOffered() => $_has(9);
  void clearNumberOffered() => clearField(10);

  int get numberRemaining => $_get(10, 0);
  set numberRemaining(int v) { $_setSignedInt32(10, v); }
  bool hasNumberRemaining() => $_has(10);
  void clearNumberRemaining() => clearField(11);

  $1.ImageDto get thumbnail => $_getN(11);
  set thumbnail($1.ImageDto v) { setField(12, v); }
  bool hasThumbnail() => $_has(11);
  void clearThumbnail() => clearField(12);

  $1.ImageDto get featuredImage => $_getN(12);
  set featuredImage($1.ImageDto v) { setField(13, v); }
  bool hasFeaturedImage() => $_has(12);
  void clearFeaturedImage() => clearField(13);

  $10.DealTermsDto get terms => $_getN(13);
  set terms($10.DealTermsDto v) { setField(14, v); }
  bool hasTerms() => $_has(13);
  void clearTerms() => clearField(14);
}

class OfferDto_FullDataDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('OfferDto.FullDataDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'businessAccountId')
    ..aOS(2, 'businessName')
    ..aOS(3, 'businessDescription')
    ..aOS(4, 'businessAvatarThumbnailUrl')
    ..aOS(5, 'title')
    ..aOS(6, 'description')
    ..a<$6.Timestamp>(7, 'created', $pb.PbFieldType.OM, $6.Timestamp.getDefault, $6.Timestamp.create)
    ..a<$6.Timestamp>(8, 'start', $pb.PbFieldType.OM, $6.Timestamp.getDefault, $6.Timestamp.create)
    ..a<$6.Timestamp>(9, 'end', $pb.PbFieldType.OM, $6.Timestamp.getDefault, $6.Timestamp.create)
    ..a<int>(10, 'minFollowers', $pb.PbFieldType.O3)
    ..a<int>(11, 'numberOffered', $pb.PbFieldType.O3)
    ..a<int>(12, 'numberRemaining', $pb.PbFieldType.O3)
    ..a<$1.ImageDto>(13, 'thumbnail', $pb.PbFieldType.OM, $1.ImageDto.getDefault, $1.ImageDto.create)
    ..a<$10.DealTermsDto>(14, 'terms', $pb.PbFieldType.OM, $10.DealTermsDto.getDefault, $10.DealTermsDto.create)
    ..e<OfferDto_AcceptancePolicy>(15, 'acceptancePolicy', $pb.PbFieldType.OE, OfferDto_AcceptancePolicy.manualReview, OfferDto_AcceptancePolicy.valueOf, OfferDto_AcceptancePolicy.values)
    ..pp<$1.ImageDto>(17, 'images', $pb.PbFieldType.PM, $1.ImageDto.$checkItem, $1.ImageDto.create)
    ..pPS(18, 'categoryIds')
    ..hasRequiredFields = false
  ;

  OfferDto_FullDataDto() : super();
  OfferDto_FullDataDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OfferDto_FullDataDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OfferDto_FullDataDto clone() => new OfferDto_FullDataDto()..mergeFromMessage(this);
  OfferDto_FullDataDto copyWith(void Function(OfferDto_FullDataDto) updates) => super.copyWith((message) => updates(message as OfferDto_FullDataDto));
  $pb.BuilderInfo get info_ => _i;
  static OfferDto_FullDataDto create() => new OfferDto_FullDataDto();
  OfferDto_FullDataDto createEmptyInstance() => create();
  static $pb.PbList<OfferDto_FullDataDto> createRepeated() => new $pb.PbList<OfferDto_FullDataDto>();
  static OfferDto_FullDataDto getDefault() => _defaultInstance ??= create()..freeze();
  static OfferDto_FullDataDto _defaultInstance;
  static void $checkItem(OfferDto_FullDataDto v) {
    if (v is! OfferDto_FullDataDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get businessAccountId => $_getS(0, '');
  set businessAccountId(String v) { $_setString(0, v); }
  bool hasBusinessAccountId() => $_has(0);
  void clearBusinessAccountId() => clearField(1);

  String get businessName => $_getS(1, '');
  set businessName(String v) { $_setString(1, v); }
  bool hasBusinessName() => $_has(1);
  void clearBusinessName() => clearField(2);

  String get businessDescription => $_getS(2, '');
  set businessDescription(String v) { $_setString(2, v); }
  bool hasBusinessDescription() => $_has(2);
  void clearBusinessDescription() => clearField(3);

  String get businessAvatarThumbnailUrl => $_getS(3, '');
  set businessAvatarThumbnailUrl(String v) { $_setString(3, v); }
  bool hasBusinessAvatarThumbnailUrl() => $_has(3);
  void clearBusinessAvatarThumbnailUrl() => clearField(4);

  String get title => $_getS(4, '');
  set title(String v) { $_setString(4, v); }
  bool hasTitle() => $_has(4);
  void clearTitle() => clearField(5);

  String get description => $_getS(5, '');
  set description(String v) { $_setString(5, v); }
  bool hasDescription() => $_has(5);
  void clearDescription() => clearField(6);

  $6.Timestamp get created => $_getN(6);
  set created($6.Timestamp v) { setField(7, v); }
  bool hasCreated() => $_has(6);
  void clearCreated() => clearField(7);

  $6.Timestamp get start => $_getN(7);
  set start($6.Timestamp v) { setField(8, v); }
  bool hasStart() => $_has(7);
  void clearStart() => clearField(8);

  $6.Timestamp get end => $_getN(8);
  set end($6.Timestamp v) { setField(9, v); }
  bool hasEnd() => $_has(8);
  void clearEnd() => clearField(9);

  int get minFollowers => $_get(9, 0);
  set minFollowers(int v) { $_setSignedInt32(9, v); }
  bool hasMinFollowers() => $_has(9);
  void clearMinFollowers() => clearField(10);

  int get numberOffered => $_get(10, 0);
  set numberOffered(int v) { $_setSignedInt32(10, v); }
  bool hasNumberOffered() => $_has(10);
  void clearNumberOffered() => clearField(11);

  int get numberRemaining => $_get(11, 0);
  set numberRemaining(int v) { $_setSignedInt32(11, v); }
  bool hasNumberRemaining() => $_has(11);
  void clearNumberRemaining() => clearField(12);

  $1.ImageDto get thumbnail => $_getN(12);
  set thumbnail($1.ImageDto v) { setField(13, v); }
  bool hasThumbnail() => $_has(12);
  void clearThumbnail() => clearField(13);

  $10.DealTermsDto get terms => $_getN(13);
  set terms($10.DealTermsDto v) { setField(14, v); }
  bool hasTerms() => $_has(13);
  void clearTerms() => clearField(14);

  OfferDto_AcceptancePolicy get acceptancePolicy => $_getN(14);
  set acceptancePolicy(OfferDto_AcceptancePolicy v) { setField(15, v); }
  bool hasAcceptancePolicy() => $_has(14);
  void clearAcceptancePolicy() => clearField(15);

  List<$1.ImageDto> get images => $_getList(15);

  List<String> get categoryIds => $_getList(16);
}

enum OfferDto_Data {
  list, 
  full, 
  notSet
}

class OfferDto extends $pb.GeneratedMessage {
  static const Map<int, OfferDto_Data> _OfferDto_DataByTag = {
    7 : OfferDto_Data.list,
    8 : OfferDto_Data.full,
    0 : OfferDto_Data.notSet
  };
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('OfferDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'id')
    ..a<int>(2, 'revision', $pb.PbFieldType.OU3)
    ..e<OfferDto_Status>(4, 'status', $pb.PbFieldType.OE, OfferDto_Status.unknown, OfferDto_Status.valueOf, OfferDto_Status.values)
    ..e<OfferDto_StatusReason>(5, 'statusReason', $pb.PbFieldType.OE, OfferDto_StatusReason.open, OfferDto_StatusReason.valueOf, OfferDto_StatusReason.values)
    ..a<$2.LocationDto>(6, 'location', $pb.PbFieldType.OM, $2.LocationDto.getDefault, $2.LocationDto.create)
    ..a<OfferDto_ListDataDto>(7, 'list', $pb.PbFieldType.OM, OfferDto_ListDataDto.getDefault, OfferDto_ListDataDto.create)
    ..a<OfferDto_FullDataDto>(8, 'full', $pb.PbFieldType.OM, OfferDto_FullDataDto.getDefault, OfferDto_FullDataDto.create)
    ..oo(0, [7, 8])
    ..hasRequiredFields = false
  ;

  OfferDto() : super();
  OfferDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OfferDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OfferDto clone() => new OfferDto()..mergeFromMessage(this);
  OfferDto copyWith(void Function(OfferDto) updates) => super.copyWith((message) => updates(message as OfferDto));
  $pb.BuilderInfo get info_ => _i;
  static OfferDto create() => new OfferDto();
  OfferDto createEmptyInstance() => create();
  static $pb.PbList<OfferDto> createRepeated() => new $pb.PbList<OfferDto>();
  static OfferDto getDefault() => _defaultInstance ??= create()..freeze();
  static OfferDto _defaultInstance;
  static void $checkItem(OfferDto v) {
    if (v is! OfferDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  OfferDto_Data whichData() => _OfferDto_DataByTag[$_whichOneof(0)];
  void clearData() => clearField($_whichOneof(0));

  String get id => $_getS(0, '');
  set id(String v) { $_setString(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  int get revision => $_get(1, 0);
  set revision(int v) { $_setUnsignedInt32(1, v); }
  bool hasRevision() => $_has(1);
  void clearRevision() => clearField(2);

  OfferDto_Status get status => $_getN(2);
  set status(OfferDto_Status v) { setField(4, v); }
  bool hasStatus() => $_has(2);
  void clearStatus() => clearField(4);

  OfferDto_StatusReason get statusReason => $_getN(3);
  set statusReason(OfferDto_StatusReason v) { setField(5, v); }
  bool hasStatusReason() => $_has(3);
  void clearStatusReason() => clearField(5);

  $2.LocationDto get location => $_getN(4);
  set location($2.LocationDto v) { setField(6, v); }
  bool hasLocation() => $_has(4);
  void clearLocation() => clearField(6);

  OfferDto_ListDataDto get list => $_getN(5);
  set list(OfferDto_ListDataDto v) { setField(7, v); }
  bool hasList() => $_has(5);
  void clearList() => clearField(7);

  OfferDto_FullDataDto get full => $_getN(6);
  set full(OfferDto_FullDataDto v) { setField(8, v); }
  bool hasFull() => $_has(6);
  void clearFull() => clearField(8);
}

