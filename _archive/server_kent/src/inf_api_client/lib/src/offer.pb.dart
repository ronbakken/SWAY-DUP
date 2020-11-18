///
//  Generated code. Do not modify.
//  source: offer.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'location.pb.dart' as $2;
import 'google/protobuf/timestamp.pb.dart' as $6;
import 'image.pb.dart' as $1;
import 'deal_terms.pb.dart' as $9;

import 'offer.pbenum.dart';

export 'offer.pbenum.dart';

class OfferDto_ListDataDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OfferDto.ListDataDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'businessAccountId')
    ..aOS(2, 'businessName')
    ..aOS(3, 'businessDescription')
    ..aOS(4, 'businessAvatarThumbnailUrl')
    ..aOS(5, 'title')
    ..aOS(6, 'description')
    ..a<$6.Timestamp>(7, 'created', $pb.PbFieldType.OM, $6.Timestamp.getDefault, $6.Timestamp.create)
    ..a<$6.Timestamp>(8, 'start', $pb.PbFieldType.OM, $6.Timestamp.getDefault, $6.Timestamp.create)
    ..a<$6.Timestamp>(9, 'end', $pb.PbFieldType.OM, $6.Timestamp.getDefault, $6.Timestamp.create)
    ..a<$core.int>(10, 'numberOffered', $pb.PbFieldType.O3)
    ..a<$core.int>(11, 'numberRemaining', $pb.PbFieldType.O3)
    ..a<$1.ImageDto>(12, 'thumbnail', $pb.PbFieldType.OM, $1.ImageDto.getDefault, $1.ImageDto.create)
    ..a<$1.ImageDto>(13, 'featuredImage', $pb.PbFieldType.OM, $1.ImageDto.getDefault, $1.ImageDto.create)
    ..a<$9.DealTermsDto>(14, 'terms', $pb.PbFieldType.OM, $9.DealTermsDto.getDefault, $9.DealTermsDto.create)
    ..aOS(15, 'featuredCategoryId')
    ..hasRequiredFields = false
  ;

  OfferDto_ListDataDto() : super();
  OfferDto_ListDataDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OfferDto_ListDataDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OfferDto_ListDataDto clone() => OfferDto_ListDataDto()..mergeFromMessage(this);
  OfferDto_ListDataDto copyWith(void Function(OfferDto_ListDataDto) updates) => super.copyWith((message) => updates(message as OfferDto_ListDataDto));
  $pb.BuilderInfo get info_ => _i;
  static OfferDto_ListDataDto create() => OfferDto_ListDataDto();
  OfferDto_ListDataDto createEmptyInstance() => create();
  static $pb.PbList<OfferDto_ListDataDto> createRepeated() => $pb.PbList<OfferDto_ListDataDto>();
  static OfferDto_ListDataDto getDefault() => _defaultInstance ??= create()..freeze();
  static OfferDto_ListDataDto _defaultInstance;

  $core.String get businessAccountId => $_getS(0, '');
  set businessAccountId($core.String v) { $_setString(0, v); }
  $core.bool hasBusinessAccountId() => $_has(0);
  void clearBusinessAccountId() => clearField(1);

  $core.String get businessName => $_getS(1, '');
  set businessName($core.String v) { $_setString(1, v); }
  $core.bool hasBusinessName() => $_has(1);
  void clearBusinessName() => clearField(2);

  $core.String get businessDescription => $_getS(2, '');
  set businessDescription($core.String v) { $_setString(2, v); }
  $core.bool hasBusinessDescription() => $_has(2);
  void clearBusinessDescription() => clearField(3);

  $core.String get businessAvatarThumbnailUrl => $_getS(3, '');
  set businessAvatarThumbnailUrl($core.String v) { $_setString(3, v); }
  $core.bool hasBusinessAvatarThumbnailUrl() => $_has(3);
  void clearBusinessAvatarThumbnailUrl() => clearField(4);

  $core.String get title => $_getS(4, '');
  set title($core.String v) { $_setString(4, v); }
  $core.bool hasTitle() => $_has(4);
  void clearTitle() => clearField(5);

  $core.String get description => $_getS(5, '');
  set description($core.String v) { $_setString(5, v); }
  $core.bool hasDescription() => $_has(5);
  void clearDescription() => clearField(6);

  $6.Timestamp get created => $_getN(6);
  set created($6.Timestamp v) { setField(7, v); }
  $core.bool hasCreated() => $_has(6);
  void clearCreated() => clearField(7);

  $6.Timestamp get start => $_getN(7);
  set start($6.Timestamp v) { setField(8, v); }
  $core.bool hasStart() => $_has(7);
  void clearStart() => clearField(8);

  $6.Timestamp get end => $_getN(8);
  set end($6.Timestamp v) { setField(9, v); }
  $core.bool hasEnd() => $_has(8);
  void clearEnd() => clearField(9);

  $core.int get numberOffered => $_get(9, 0);
  set numberOffered($core.int v) { $_setSignedInt32(9, v); }
  $core.bool hasNumberOffered() => $_has(9);
  void clearNumberOffered() => clearField(10);

  $core.int get numberRemaining => $_get(10, 0);
  set numberRemaining($core.int v) { $_setSignedInt32(10, v); }
  $core.bool hasNumberRemaining() => $_has(10);
  void clearNumberRemaining() => clearField(11);

  $1.ImageDto get thumbnail => $_getN(11);
  set thumbnail($1.ImageDto v) { setField(12, v); }
  $core.bool hasThumbnail() => $_has(11);
  void clearThumbnail() => clearField(12);

  $1.ImageDto get featuredImage => $_getN(12);
  set featuredImage($1.ImageDto v) { setField(13, v); }
  $core.bool hasFeaturedImage() => $_has(12);
  void clearFeaturedImage() => clearField(13);

  $9.DealTermsDto get terms => $_getN(13);
  set terms($9.DealTermsDto v) { setField(14, v); }
  $core.bool hasTerms() => $_has(13);
  void clearTerms() => clearField(14);

  $core.String get featuredCategoryId => $_getS(14, '');
  set featuredCategoryId($core.String v) { $_setString(14, v); }
  $core.bool hasFeaturedCategoryId() => $_has(14);
  void clearFeaturedCategoryId() => clearField(15);
}

class OfferDto_FullDataDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OfferDto.FullDataDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'businessAccountId')
    ..aOS(2, 'businessName')
    ..aOS(3, 'businessDescription')
    ..aOS(4, 'businessAvatarThumbnailUrl')
    ..aOS(5, 'title')
    ..aOS(6, 'description')
    ..a<$6.Timestamp>(7, 'created', $pb.PbFieldType.OM, $6.Timestamp.getDefault, $6.Timestamp.create)
    ..a<$6.Timestamp>(8, 'start', $pb.PbFieldType.OM, $6.Timestamp.getDefault, $6.Timestamp.create)
    ..a<$6.Timestamp>(9, 'end', $pb.PbFieldType.OM, $6.Timestamp.getDefault, $6.Timestamp.create)
    ..a<$core.int>(10, 'minFollowers', $pb.PbFieldType.O3)
    ..a<$core.int>(11, 'numberOffered', $pb.PbFieldType.O3)
    ..a<$core.int>(12, 'numberRemaining', $pb.PbFieldType.O3)
    ..a<$1.ImageDto>(13, 'thumbnail', $pb.PbFieldType.OM, $1.ImageDto.getDefault, $1.ImageDto.create)
    ..a<$9.DealTermsDto>(14, 'terms', $pb.PbFieldType.OM, $9.DealTermsDto.getDefault, $9.DealTermsDto.create)
    ..e<OfferDto_AcceptancePolicy>(15, 'acceptancePolicy', $pb.PbFieldType.OE, OfferDto_AcceptancePolicy.manualReview, OfferDto_AcceptancePolicy.valueOf, OfferDto_AcceptancePolicy.values)
    ..pc<$1.ImageDto>(17, 'images', $pb.PbFieldType.PM,$1.ImageDto.create)
    ..pPS(18, 'categoryIds')
    ..hasRequiredFields = false
  ;

  OfferDto_FullDataDto() : super();
  OfferDto_FullDataDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OfferDto_FullDataDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OfferDto_FullDataDto clone() => OfferDto_FullDataDto()..mergeFromMessage(this);
  OfferDto_FullDataDto copyWith(void Function(OfferDto_FullDataDto) updates) => super.copyWith((message) => updates(message as OfferDto_FullDataDto));
  $pb.BuilderInfo get info_ => _i;
  static OfferDto_FullDataDto create() => OfferDto_FullDataDto();
  OfferDto_FullDataDto createEmptyInstance() => create();
  static $pb.PbList<OfferDto_FullDataDto> createRepeated() => $pb.PbList<OfferDto_FullDataDto>();
  static OfferDto_FullDataDto getDefault() => _defaultInstance ??= create()..freeze();
  static OfferDto_FullDataDto _defaultInstance;

  $core.String get businessAccountId => $_getS(0, '');
  set businessAccountId($core.String v) { $_setString(0, v); }
  $core.bool hasBusinessAccountId() => $_has(0);
  void clearBusinessAccountId() => clearField(1);

  $core.String get businessName => $_getS(1, '');
  set businessName($core.String v) { $_setString(1, v); }
  $core.bool hasBusinessName() => $_has(1);
  void clearBusinessName() => clearField(2);

  $core.String get businessDescription => $_getS(2, '');
  set businessDescription($core.String v) { $_setString(2, v); }
  $core.bool hasBusinessDescription() => $_has(2);
  void clearBusinessDescription() => clearField(3);

  $core.String get businessAvatarThumbnailUrl => $_getS(3, '');
  set businessAvatarThumbnailUrl($core.String v) { $_setString(3, v); }
  $core.bool hasBusinessAvatarThumbnailUrl() => $_has(3);
  void clearBusinessAvatarThumbnailUrl() => clearField(4);

  $core.String get title => $_getS(4, '');
  set title($core.String v) { $_setString(4, v); }
  $core.bool hasTitle() => $_has(4);
  void clearTitle() => clearField(5);

  $core.String get description => $_getS(5, '');
  set description($core.String v) { $_setString(5, v); }
  $core.bool hasDescription() => $_has(5);
  void clearDescription() => clearField(6);

  $6.Timestamp get created => $_getN(6);
  set created($6.Timestamp v) { setField(7, v); }
  $core.bool hasCreated() => $_has(6);
  void clearCreated() => clearField(7);

  $6.Timestamp get start => $_getN(7);
  set start($6.Timestamp v) { setField(8, v); }
  $core.bool hasStart() => $_has(7);
  void clearStart() => clearField(8);

  $6.Timestamp get end => $_getN(8);
  set end($6.Timestamp v) { setField(9, v); }
  $core.bool hasEnd() => $_has(8);
  void clearEnd() => clearField(9);

  $core.int get minFollowers => $_get(9, 0);
  set minFollowers($core.int v) { $_setSignedInt32(9, v); }
  $core.bool hasMinFollowers() => $_has(9);
  void clearMinFollowers() => clearField(10);

  $core.int get numberOffered => $_get(10, 0);
  set numberOffered($core.int v) { $_setSignedInt32(10, v); }
  $core.bool hasNumberOffered() => $_has(10);
  void clearNumberOffered() => clearField(11);

  $core.int get numberRemaining => $_get(11, 0);
  set numberRemaining($core.int v) { $_setSignedInt32(11, v); }
  $core.bool hasNumberRemaining() => $_has(11);
  void clearNumberRemaining() => clearField(12);

  $1.ImageDto get thumbnail => $_getN(12);
  set thumbnail($1.ImageDto v) { setField(13, v); }
  $core.bool hasThumbnail() => $_has(12);
  void clearThumbnail() => clearField(13);

  $9.DealTermsDto get terms => $_getN(13);
  set terms($9.DealTermsDto v) { setField(14, v); }
  $core.bool hasTerms() => $_has(13);
  void clearTerms() => clearField(14);

  OfferDto_AcceptancePolicy get acceptancePolicy => $_getN(14);
  set acceptancePolicy(OfferDto_AcceptancePolicy v) { setField(15, v); }
  $core.bool hasAcceptancePolicy() => $_has(14);
  void clearAcceptancePolicy() => clearField(15);

  $core.List<$1.ImageDto> get images => $_getList(15);

  $core.List<$core.String> get categoryIds => $_getList(16);
}

enum OfferDto_Data {
  list, 
  full, 
  notSet
}

class OfferDto extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, OfferDto_Data> _OfferDto_DataByTag = {
    7 : OfferDto_Data.list,
    8 : OfferDto_Data.full,
    0 : OfferDto_Data.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OfferDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'id')
    ..a<$core.int>(2, 'revision', $pb.PbFieldType.OU3)
    ..e<OfferDto_Status>(4, 'status', $pb.PbFieldType.OE, OfferDto_Status.unknown, OfferDto_Status.valueOf, OfferDto_Status.values)
    ..e<OfferDto_StatusReason>(5, 'statusReason', $pb.PbFieldType.OE, OfferDto_StatusReason.open, OfferDto_StatusReason.valueOf, OfferDto_StatusReason.values)
    ..a<$2.LocationDto>(6, 'location', $pb.PbFieldType.OM, $2.LocationDto.getDefault, $2.LocationDto.create)
    ..a<OfferDto_ListDataDto>(7, 'list', $pb.PbFieldType.OM, OfferDto_ListDataDto.getDefault, OfferDto_ListDataDto.create)
    ..a<OfferDto_FullDataDto>(8, 'full', $pb.PbFieldType.OM, OfferDto_FullDataDto.getDefault, OfferDto_FullDataDto.create)
    ..oo(0, [7, 8])
    ..hasRequiredFields = false
  ;

  OfferDto() : super();
  OfferDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OfferDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OfferDto clone() => OfferDto()..mergeFromMessage(this);
  OfferDto copyWith(void Function(OfferDto) updates) => super.copyWith((message) => updates(message as OfferDto));
  $pb.BuilderInfo get info_ => _i;
  static OfferDto create() => OfferDto();
  OfferDto createEmptyInstance() => create();
  static $pb.PbList<OfferDto> createRepeated() => $pb.PbList<OfferDto>();
  static OfferDto getDefault() => _defaultInstance ??= create()..freeze();
  static OfferDto _defaultInstance;

  OfferDto_Data whichData() => _OfferDto_DataByTag[$_whichOneof(0)];
  void clearData() => clearField($_whichOneof(0));

  $core.String get id => $_getS(0, '');
  set id($core.String v) { $_setString(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  $core.int get revision => $_get(1, 0);
  set revision($core.int v) { $_setUnsignedInt32(1, v); }
  $core.bool hasRevision() => $_has(1);
  void clearRevision() => clearField(2);

  OfferDto_Status get status => $_getN(2);
  set status(OfferDto_Status v) { setField(4, v); }
  $core.bool hasStatus() => $_has(2);
  void clearStatus() => clearField(4);

  OfferDto_StatusReason get statusReason => $_getN(3);
  set statusReason(OfferDto_StatusReason v) { setField(5, v); }
  $core.bool hasStatusReason() => $_has(3);
  void clearStatusReason() => clearField(5);

  $2.LocationDto get location => $_getN(4);
  set location($2.LocationDto v) { setField(6, v); }
  $core.bool hasLocation() => $_has(4);
  void clearLocation() => clearField(6);

  OfferDto_ListDataDto get list => $_getN(5);
  set list(OfferDto_ListDataDto v) { setField(7, v); }
  $core.bool hasList() => $_has(5);
  void clearList() => clearField(7);

  OfferDto_FullDataDto get full => $_getN(6);
  set full(OfferDto_FullDataDto v) { setField(8, v); }
  $core.bool hasFull() => $_has(6);
  void clearFull() => clearField(8);
}

