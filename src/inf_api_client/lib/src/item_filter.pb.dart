///
//  Generated code. Do not modify.
//  source: item_filter.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'money.pb.dart' as $3;
import 'location.pb.dart' as $2;

import 'offer.pbenum.dart' as $11;
import 'deliverable.pbenum.dart' as $8;
import 'reward.pbenum.dart' as $9;
import 'user.pbenum.dart' as $5;
import 'conversation.pbenum.dart' as $13;

class ItemFilterDto_OfferFilterDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ItemFilterDto.OfferFilterDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'businessAccountId')
    ..pp<$11.OfferDto_Status>(2, 'offerStatuses', $pb.PbFieldType.PE, $11.OfferDto_Status.$checkItem, null, $11.OfferDto_Status.valueOf, $11.OfferDto_Status.values)
    ..pp<$8.DeliverableType>(3, 'deliverableTypes', $pb.PbFieldType.PE, $8.DeliverableType.$checkItem, null, $8.DeliverableType.valueOf, $8.DeliverableType.values)
    ..pp<$11.OfferDto_AcceptancePolicy>(4, 'acceptancePolicies', $pb.PbFieldType.PE, $11.OfferDto_AcceptancePolicy.$checkItem, null, $11.OfferDto_AcceptancePolicy.valueOf, $11.OfferDto_AcceptancePolicy.values)
    ..pp<$9.RewardDto_Type>(5, 'rewardTypes', $pb.PbFieldType.PE, $9.RewardDto_Type.$checkItem, null, $9.RewardDto_Type.valueOf, $9.RewardDto_Type.values)
    ..a<$3.MoneyDto>(6, 'minimumReward', $pb.PbFieldType.OM, $3.MoneyDto.getDefault, $3.MoneyDto.create)
    ..a<int>(7, 'mapLevel', $pb.PbFieldType.O3)
    ..a<$2.GeoPointDto>(8, 'northWest', $pb.PbFieldType.OM, $2.GeoPointDto.getDefault, $2.GeoPointDto.create)
    ..a<$2.GeoPointDto>(9, 'southEast', $pb.PbFieldType.OM, $2.GeoPointDto.getDefault, $2.GeoPointDto.create)
    ..pPS(10, 'categoryIds')
    ..aOS(11, 'phrase')
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

  List<$11.OfferDto_Status> get offerStatuses => $_getList(1);

  List<$8.DeliverableType> get deliverableTypes => $_getList(2);

  List<$11.OfferDto_AcceptancePolicy> get acceptancePolicies => $_getList(3);

  List<$9.RewardDto_Type> get rewardTypes => $_getList(4);

  $3.MoneyDto get minimumReward => $_getN(5);
  set minimumReward($3.MoneyDto v) { setField(6, v); }
  bool hasMinimumReward() => $_has(5);
  void clearMinimumReward() => clearField(6);

  int get mapLevel => $_get(6, 0);
  set mapLevel(int v) { $_setSignedInt32(6, v); }
  bool hasMapLevel() => $_has(6);
  void clearMapLevel() => clearField(7);

  $2.GeoPointDto get northWest => $_getN(7);
  set northWest($2.GeoPointDto v) { setField(8, v); }
  bool hasNorthWest() => $_has(7);
  void clearNorthWest() => clearField(8);

  $2.GeoPointDto get southEast => $_getN(8);
  set southEast($2.GeoPointDto v) { setField(9, v); }
  bool hasSouthEast() => $_has(8);
  void clearSouthEast() => clearField(9);

  List<String> get categoryIds => $_getList(9);

  String get phrase => $_getS(10, '');
  set phrase(String v) { $_setString(10, v); }
  bool hasPhrase() => $_has(10);
  void clearPhrase() => clearField(11);
}

class ItemFilterDto_UserFilterDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ItemFilterDto.UserFilterDto', package: const $pb.PackageName('api'))
    ..pp<$5.UserType>(1, 'userTypes', $pb.PbFieldType.PE, $5.UserType.$checkItem, null, $5.UserType.valueOf, $5.UserType.values)
    ..pPS(2, 'socialMediaNetworkIds')
    ..a<int>(7, 'mapLevel', $pb.PbFieldType.O3)
    ..a<$2.GeoPointDto>(8, 'northWest', $pb.PbFieldType.OM, $2.GeoPointDto.getDefault, $2.GeoPointDto.create)
    ..a<$2.GeoPointDto>(9, 'southEast', $pb.PbFieldType.OM, $2.GeoPointDto.getDefault, $2.GeoPointDto.create)
    ..pPS(10, 'categoryIds')
    ..aOS(11, 'phrase')
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

  List<$5.UserType> get userTypes => $_getList(0);

  List<String> get socialMediaNetworkIds => $_getList(1);

  int get mapLevel => $_get(2, 0);
  set mapLevel(int v) { $_setSignedInt32(2, v); }
  bool hasMapLevel() => $_has(2);
  void clearMapLevel() => clearField(7);

  $2.GeoPointDto get northWest => $_getN(3);
  set northWest($2.GeoPointDto v) { setField(8, v); }
  bool hasNorthWest() => $_has(3);
  void clearNorthWest() => clearField(8);

  $2.GeoPointDto get southEast => $_getN(4);
  set southEast($2.GeoPointDto v) { setField(9, v); }
  bool hasSouthEast() => $_has(4);
  void clearSouthEast() => clearField(9);

  List<String> get categoryIds => $_getList(5);

  String get phrase => $_getS(6, '');
  set phrase(String v) { $_setString(6, v); }
  bool hasPhrase() => $_has(6);
  void clearPhrase() => clearField(11);
}

class ItemFilterDto_ConversationFilterDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ItemFilterDto.ConversationFilterDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'participatingUserId')
    ..aOS(2, 'topicId')
    ..pp<$13.ConversationDto_Status>(3, 'conversationStatuses', $pb.PbFieldType.PE, $13.ConversationDto_Status.$checkItem, null, $13.ConversationDto_Status.valueOf, $13.ConversationDto_Status.values)
    ..hasRequiredFields = false
  ;

  ItemFilterDto_ConversationFilterDto() : super();
  ItemFilterDto_ConversationFilterDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ItemFilterDto_ConversationFilterDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ItemFilterDto_ConversationFilterDto clone() => new ItemFilterDto_ConversationFilterDto()..mergeFromMessage(this);
  ItemFilterDto_ConversationFilterDto copyWith(void Function(ItemFilterDto_ConversationFilterDto) updates) => super.copyWith((message) => updates(message as ItemFilterDto_ConversationFilterDto));
  $pb.BuilderInfo get info_ => _i;
  static ItemFilterDto_ConversationFilterDto create() => new ItemFilterDto_ConversationFilterDto();
  ItemFilterDto_ConversationFilterDto createEmptyInstance() => create();
  static $pb.PbList<ItemFilterDto_ConversationFilterDto> createRepeated() => new $pb.PbList<ItemFilterDto_ConversationFilterDto>();
  static ItemFilterDto_ConversationFilterDto getDefault() => _defaultInstance ??= create()..freeze();
  static ItemFilterDto_ConversationFilterDto _defaultInstance;
  static void $checkItem(ItemFilterDto_ConversationFilterDto v) {
    if (v is! ItemFilterDto_ConversationFilterDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get participatingUserId => $_getS(0, '');
  set participatingUserId(String v) { $_setString(0, v); }
  bool hasParticipatingUserId() => $_has(0);
  void clearParticipatingUserId() => clearField(1);

  String get topicId => $_getS(1, '');
  set topicId(String v) { $_setString(1, v); }
  bool hasTopicId() => $_has(1);
  void clearTopicId() => clearField(2);

  List<$13.ConversationDto_Status> get conversationStatuses => $_getList(2);
}

class ItemFilterDto_MessageFilterDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ItemFilterDto.MessageFilterDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'conversationId')
    ..hasRequiredFields = false
  ;

  ItemFilterDto_MessageFilterDto() : super();
  ItemFilterDto_MessageFilterDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ItemFilterDto_MessageFilterDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ItemFilterDto_MessageFilterDto clone() => new ItemFilterDto_MessageFilterDto()..mergeFromMessage(this);
  ItemFilterDto_MessageFilterDto copyWith(void Function(ItemFilterDto_MessageFilterDto) updates) => super.copyWith((message) => updates(message as ItemFilterDto_MessageFilterDto));
  $pb.BuilderInfo get info_ => _i;
  static ItemFilterDto_MessageFilterDto create() => new ItemFilterDto_MessageFilterDto();
  ItemFilterDto_MessageFilterDto createEmptyInstance() => create();
  static $pb.PbList<ItemFilterDto_MessageFilterDto> createRepeated() => new $pb.PbList<ItemFilterDto_MessageFilterDto>();
  static ItemFilterDto_MessageFilterDto getDefault() => _defaultInstance ??= create()..freeze();
  static ItemFilterDto_MessageFilterDto _defaultInstance;
  static void $checkItem(ItemFilterDto_MessageFilterDto v) {
    if (v is! ItemFilterDto_MessageFilterDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get conversationId => $_getS(0, '');
  set conversationId(String v) { $_setString(0, v); }
  bool hasConversationId() => $_has(0);
  void clearConversationId() => clearField(1);
}

class ItemFilterDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ItemFilterDto', package: const $pb.PackageName('api'))
    ..a<ItemFilterDto_OfferFilterDto>(10, 'offerFilter', $pb.PbFieldType.OM, ItemFilterDto_OfferFilterDto.getDefault, ItemFilterDto_OfferFilterDto.create)
    ..a<ItemFilterDto_UserFilterDto>(11, 'userFilter', $pb.PbFieldType.OM, ItemFilterDto_UserFilterDto.getDefault, ItemFilterDto_UserFilterDto.create)
    ..a<ItemFilterDto_ConversationFilterDto>(12, 'conversationFilter', $pb.PbFieldType.OM, ItemFilterDto_ConversationFilterDto.getDefault, ItemFilterDto_ConversationFilterDto.create)
    ..a<ItemFilterDto_MessageFilterDto>(13, 'messageFilter', $pb.PbFieldType.OM, ItemFilterDto_MessageFilterDto.getDefault, ItemFilterDto_MessageFilterDto.create)
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

  ItemFilterDto_OfferFilterDto get offerFilter => $_getN(0);
  set offerFilter(ItemFilterDto_OfferFilterDto v) { setField(10, v); }
  bool hasOfferFilter() => $_has(0);
  void clearOfferFilter() => clearField(10);

  ItemFilterDto_UserFilterDto get userFilter => $_getN(1);
  set userFilter(ItemFilterDto_UserFilterDto v) { setField(11, v); }
  bool hasUserFilter() => $_has(1);
  void clearUserFilter() => clearField(11);

  ItemFilterDto_ConversationFilterDto get conversationFilter => $_getN(2);
  set conversationFilter(ItemFilterDto_ConversationFilterDto v) { setField(12, v); }
  bool hasConversationFilter() => $_has(2);
  void clearConversationFilter() => clearField(12);

  ItemFilterDto_MessageFilterDto get messageFilter => $_getN(3);
  set messageFilter(ItemFilterDto_MessageFilterDto v) { setField(13, v); }
  bool hasMessageFilter() => $_has(3);
  void clearMessageFilter() => clearField(13);
}

