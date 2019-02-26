///
//  Generated code. Do not modify.
//  source: item_filter.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'location.pb.dart' as $4;
import 'money.pb.dart' as $1;

import 'item_filter.pbenum.dart';
import 'offer.pbenum.dart' as $9;
import 'deliverable.pbenum.dart' as $2;
import 'reward.pbenum.dart' as $3;
import 'user.pbenum.dart' as $10;

export 'item_filter.pbenum.dart';

class ItemFilterDto_OfferFilterDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ItemFilterDto.OfferFilterDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'businessAccountId')
    ..pp<$9.OfferDto_Status>(2, 'offerStatuses', $pb.PbFieldType.PE, $9.OfferDto_Status.$checkItem, null, $9.OfferDto_Status.valueOf, $9.OfferDto_Status.values)
    ..pp<$2.DeliverableType>(3, 'deliverableTypes', $pb.PbFieldType.PE, $2.DeliverableType.$checkItem, null, $2.DeliverableType.valueOf, $2.DeliverableType.values)
    ..pp<$9.OfferDto_AcceptancePolicy>(4, 'acceptancePolicies', $pb.PbFieldType.PE, $9.OfferDto_AcceptancePolicy.$checkItem, null, $9.OfferDto_AcceptancePolicy.valueOf, $9.OfferDto_AcceptancePolicy.values)
    ..pp<$3.RewardDto_Type>(5, 'rewardTypes', $pb.PbFieldType.PE, $3.RewardDto_Type.$checkItem, null, $3.RewardDto_Type.valueOf, $3.RewardDto_Type.values)
    ..a<$1.MoneyDto>(6, 'minimumReward', $pb.PbFieldType.OM, $1.MoneyDto.getDefault, $1.MoneyDto.create)
    ..hasRequiredFields = false
  ;

  ItemFilterDto_OfferFilterDto() : super();
  ItemFilterDto_OfferFilterDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ItemFilterDto_OfferFilterDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ItemFilterDto_OfferFilterDto clone() => new ItemFilterDto_OfferFilterDto()..mergeFromMessage(this);
  ItemFilterDto_OfferFilterDto copyWith(void Function(ItemFilterDto_OfferFilterDto) updates) => super.copyWith((message) => updates(message as ItemFilterDto_OfferFilterDto));
  $pb.BuilderInfo get info_ => _i;
  static ItemFilterDto_OfferFilterDto create() => new ItemFilterDto_OfferFilterDto();
  ItemFilterDto_OfferFilterDto createEmptyInstance() => create();
  static $pb.PbList<ItemFilterDto_OfferFilterDto> createRepeated() => new $pb.PbList<ItemFilterDto_OfferFilterDto>();
  static ItemFilterDto_OfferFilterDto getDefault() => _defaultInstance ??= create()..freeze();
  static ItemFilterDto_OfferFilterDto _defaultInstance;
  static void $checkItem(ItemFilterDto_OfferFilterDto v) {
    if (v is! ItemFilterDto_OfferFilterDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get businessAccountId => $_getS(0, '');
  set businessAccountId(String v) { $_setString(0, v); }
  bool hasBusinessAccountId() => $_has(0);
  void clearBusinessAccountId() => clearField(1);

  List<$9.OfferDto_Status> get offerStatuses => $_getList(1);

  List<$2.DeliverableType> get deliverableTypes => $_getList(2);

  List<$9.OfferDto_AcceptancePolicy> get acceptancePolicies => $_getList(3);

  List<$3.RewardDto_Type> get rewardTypes => $_getList(4);

  $1.MoneyDto get minimumReward => $_getN(5);
  set minimumReward($1.MoneyDto v) { setField(6, v); }
  bool hasMinimumReward() => $_has(5);
  void clearMinimumReward() => clearField(6);
}

class ItemFilterDto_UserFilterDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ItemFilterDto.UserFilterDto', package: const $pb.PackageName('api'))
    ..pp<$10.UserType>(1, 'userTypes', $pb.PbFieldType.PE, $10.UserType.$checkItem, null, $10.UserType.valueOf, $10.UserType.values)
    ..pPS(2, 'socialMediaNetworkIds')
    ..hasRequiredFields = false
  ;

  ItemFilterDto_UserFilterDto() : super();
  ItemFilterDto_UserFilterDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ItemFilterDto_UserFilterDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ItemFilterDto_UserFilterDto clone() => new ItemFilterDto_UserFilterDto()..mergeFromMessage(this);
  ItemFilterDto_UserFilterDto copyWith(void Function(ItemFilterDto_UserFilterDto) updates) => super.copyWith((message) => updates(message as ItemFilterDto_UserFilterDto));
  $pb.BuilderInfo get info_ => _i;
  static ItemFilterDto_UserFilterDto create() => new ItemFilterDto_UserFilterDto();
  ItemFilterDto_UserFilterDto createEmptyInstance() => create();
  static $pb.PbList<ItemFilterDto_UserFilterDto> createRepeated() => new $pb.PbList<ItemFilterDto_UserFilterDto>();
  static ItemFilterDto_UserFilterDto getDefault() => _defaultInstance ??= create()..freeze();
  static ItemFilterDto_UserFilterDto _defaultInstance;
  static void $checkItem(ItemFilterDto_UserFilterDto v) {
    if (v is! ItemFilterDto_UserFilterDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<$10.UserType> get userTypes => $_getList(0);

  List<String> get socialMediaNetworkIds => $_getList(1);
}

class ItemFilterDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ItemFilterDto', package: const $pb.PackageName('api'))
    ..pp<ItemFilterDto_ItemType>(1, 'itemTypes', $pb.PbFieldType.PE, ItemFilterDto_ItemType.$checkItem, null, ItemFilterDto_ItemType.valueOf, ItemFilterDto_ItemType.values)
    ..a<$4.GeoPointDto>(2, 'northWest', $pb.PbFieldType.OM, $4.GeoPointDto.getDefault, $4.GeoPointDto.create)
    ..a<$4.GeoPointDto>(3, 'southEast', $pb.PbFieldType.OM, $4.GeoPointDto.getDefault, $4.GeoPointDto.create)
    ..a<int>(4, 'mapLevel', $pb.PbFieldType.O3)
    ..pPS(5, 'categoryIds')
    ..aOS(6, 'phrase')
    ..a<ItemFilterDto_OfferFilterDto>(10, 'offerFilter', $pb.PbFieldType.OM, ItemFilterDto_OfferFilterDto.getDefault, ItemFilterDto_OfferFilterDto.create)
    ..a<ItemFilterDto_UserFilterDto>(11, 'userFilter', $pb.PbFieldType.OM, ItemFilterDto_UserFilterDto.getDefault, ItemFilterDto_UserFilterDto.create)
    ..hasRequiredFields = false
  ;

  ItemFilterDto() : super();
  ItemFilterDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ItemFilterDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ItemFilterDto clone() => new ItemFilterDto()..mergeFromMessage(this);
  ItemFilterDto copyWith(void Function(ItemFilterDto) updates) => super.copyWith((message) => updates(message as ItemFilterDto));
  $pb.BuilderInfo get info_ => _i;
  static ItemFilterDto create() => new ItemFilterDto();
  ItemFilterDto createEmptyInstance() => create();
  static $pb.PbList<ItemFilterDto> createRepeated() => new $pb.PbList<ItemFilterDto>();
  static ItemFilterDto getDefault() => _defaultInstance ??= create()..freeze();
  static ItemFilterDto _defaultInstance;
  static void $checkItem(ItemFilterDto v) {
    if (v is! ItemFilterDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<ItemFilterDto_ItemType> get itemTypes => $_getList(0);

  $4.GeoPointDto get northWest => $_getN(1);
  set northWest($4.GeoPointDto v) { setField(2, v); }
  bool hasNorthWest() => $_has(1);
  void clearNorthWest() => clearField(2);

  $4.GeoPointDto get southEast => $_getN(2);
  set southEast($4.GeoPointDto v) { setField(3, v); }
  bool hasSouthEast() => $_has(2);
  void clearSouthEast() => clearField(3);

  int get mapLevel => $_get(3, 0);
  set mapLevel(int v) { $_setSignedInt32(3, v); }
  bool hasMapLevel() => $_has(3);
  void clearMapLevel() => clearField(4);

  List<String> get categoryIds => $_getList(4);

  String get phrase => $_getS(5, '');
  set phrase(String v) { $_setString(5, v); }
  bool hasPhrase() => $_has(5);
  void clearPhrase() => clearField(6);

  ItemFilterDto_OfferFilterDto get offerFilter => $_getN(6);
  set offerFilter(ItemFilterDto_OfferFilterDto v) { setField(10, v); }
  bool hasOfferFilter() => $_has(6);
  void clearOfferFilter() => clearField(10);

  ItemFilterDto_UserFilterDto get userFilter => $_getN(7);
  set userFilter(ItemFilterDto_UserFilterDto v) { setField(11, v); }
  bool hasUserFilter() => $_has(7);
  void clearUserFilter() => clearField(11);
}

