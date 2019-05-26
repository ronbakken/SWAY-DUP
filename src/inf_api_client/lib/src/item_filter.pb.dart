///
//  Generated code. Do not modify.
//  source: item_filter.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'money.pb.dart' as $3;
import 'location.pb.dart' as $2;

import 'offer.pbenum.dart' as $10;
import 'deliverable.pbenum.dart' as $8;
import 'user.pbenum.dart' as $5;
import 'conversation.pbenum.dart' as $12;

class ItemFilterDto_OfferFilterDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ItemFilterDto.OfferFilterDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'businessAccountId')
    ..pc<$10.OfferDto_Status>(2, 'offerStatuses', $pb.PbFieldType.PE, null, $10.OfferDto_Status.valueOf, $10.OfferDto_Status.values)
    ..pc<$8.DeliverableType>(3, 'deliverableTypes', $pb.PbFieldType.PE, null, $8.DeliverableType.valueOf, $8.DeliverableType.values)
    ..pc<$10.OfferDto_AcceptancePolicy>(4, 'acceptancePolicies', $pb.PbFieldType.PE, null, $10.OfferDto_AcceptancePolicy.valueOf, $10.OfferDto_AcceptancePolicy.values)
    ..a<$3.MoneyDto>(6, 'minimumRewardCash', $pb.PbFieldType.OM, $3.MoneyDto.getDefault, $3.MoneyDto.create)
    ..a<$core.int>(7, 'mapLevel', $pb.PbFieldType.O3)
    ..a<$2.GeoPointDto>(8, 'northWest', $pb.PbFieldType.OM, $2.GeoPointDto.getDefault, $2.GeoPointDto.create)
    ..a<$2.GeoPointDto>(9, 'southEast', $pb.PbFieldType.OM, $2.GeoPointDto.getDefault, $2.GeoPointDto.create)
    ..pPS(10, 'categoryIds')
    ..aOS(11, 'phrase')
    ..a<$3.MoneyDto>(12, 'minimumRewardService', $pb.PbFieldType.OM, $3.MoneyDto.getDefault, $3.MoneyDto.create)
    ..pPS(13, 'deliverableSocialMediaNetworkIds')
    ..hasRequiredFields = false
  ;

  ItemFilterDto_OfferFilterDto() : super();
  ItemFilterDto_OfferFilterDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ItemFilterDto_OfferFilterDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ItemFilterDto_OfferFilterDto clone() => ItemFilterDto_OfferFilterDto()..mergeFromMessage(this);
  ItemFilterDto_OfferFilterDto copyWith(void Function(ItemFilterDto_OfferFilterDto) updates) => super.copyWith((message) => updates(message as ItemFilterDto_OfferFilterDto));
  $pb.BuilderInfo get info_ => _i;
  static ItemFilterDto_OfferFilterDto create() => ItemFilterDto_OfferFilterDto();
  ItemFilterDto_OfferFilterDto createEmptyInstance() => create();
  static $pb.PbList<ItemFilterDto_OfferFilterDto> createRepeated() => $pb.PbList<ItemFilterDto_OfferFilterDto>();
  static ItemFilterDto_OfferFilterDto getDefault() => _defaultInstance ??= create()..freeze();
  static ItemFilterDto_OfferFilterDto _defaultInstance;

  $core.String get businessAccountId => $_getS(0, '');
  set businessAccountId($core.String v) { $_setString(0, v); }
  $core.bool hasBusinessAccountId() => $_has(0);
  void clearBusinessAccountId() => clearField(1);

  $core.List<$10.OfferDto_Status> get offerStatuses => $_getList(1);

  $core.List<$8.DeliverableType> get deliverableTypes => $_getList(2);

  $core.List<$10.OfferDto_AcceptancePolicy> get acceptancePolicies => $_getList(3);

  $3.MoneyDto get minimumRewardCash => $_getN(4);
  set minimumRewardCash($3.MoneyDto v) { setField(6, v); }
  $core.bool hasMinimumRewardCash() => $_has(4);
  void clearMinimumRewardCash() => clearField(6);

  $core.int get mapLevel => $_get(5, 0);
  set mapLevel($core.int v) { $_setSignedInt32(5, v); }
  $core.bool hasMapLevel() => $_has(5);
  void clearMapLevel() => clearField(7);

  $2.GeoPointDto get northWest => $_getN(6);
  set northWest($2.GeoPointDto v) { setField(8, v); }
  $core.bool hasNorthWest() => $_has(6);
  void clearNorthWest() => clearField(8);

  $2.GeoPointDto get southEast => $_getN(7);
  set southEast($2.GeoPointDto v) { setField(9, v); }
  $core.bool hasSouthEast() => $_has(7);
  void clearSouthEast() => clearField(9);

  $core.List<$core.String> get categoryIds => $_getList(8);

  $core.String get phrase => $_getS(9, '');
  set phrase($core.String v) { $_setString(9, v); }
  $core.bool hasPhrase() => $_has(9);
  void clearPhrase() => clearField(11);

  $3.MoneyDto get minimumRewardService => $_getN(10);
  set minimumRewardService($3.MoneyDto v) { setField(12, v); }
  $core.bool hasMinimumRewardService() => $_has(10);
  void clearMinimumRewardService() => clearField(12);

  $core.List<$core.String> get deliverableSocialMediaNetworkIds => $_getList(11);
}

class ItemFilterDto_UserFilterDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ItemFilterDto.UserFilterDto', package: const $pb.PackageName('api'))
    ..pc<$5.UserType>(1, 'userTypes', $pb.PbFieldType.PE, null, $5.UserType.valueOf, $5.UserType.values)
    ..pPS(2, 'socialMediaNetworkIds')
    ..a<$core.int>(7, 'mapLevel', $pb.PbFieldType.O3)
    ..a<$2.GeoPointDto>(8, 'northWest', $pb.PbFieldType.OM, $2.GeoPointDto.getDefault, $2.GeoPointDto.create)
    ..a<$2.GeoPointDto>(9, 'southEast', $pb.PbFieldType.OM, $2.GeoPointDto.getDefault, $2.GeoPointDto.create)
    ..pPS(10, 'categoryIds')
    ..aOS(11, 'phrase')
    ..a<$3.MoneyDto>(12, 'minimumValue', $pb.PbFieldType.OM, $3.MoneyDto.getDefault, $3.MoneyDto.create)
    ..a<$3.MoneyDto>(13, 'maximumValue', $pb.PbFieldType.OM, $3.MoneyDto.getDefault, $3.MoneyDto.create)
    ..hasRequiredFields = false
  ;

  ItemFilterDto_UserFilterDto() : super();
  ItemFilterDto_UserFilterDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ItemFilterDto_UserFilterDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ItemFilterDto_UserFilterDto clone() => ItemFilterDto_UserFilterDto()..mergeFromMessage(this);
  ItemFilterDto_UserFilterDto copyWith(void Function(ItemFilterDto_UserFilterDto) updates) => super.copyWith((message) => updates(message as ItemFilterDto_UserFilterDto));
  $pb.BuilderInfo get info_ => _i;
  static ItemFilterDto_UserFilterDto create() => ItemFilterDto_UserFilterDto();
  ItemFilterDto_UserFilterDto createEmptyInstance() => create();
  static $pb.PbList<ItemFilterDto_UserFilterDto> createRepeated() => $pb.PbList<ItemFilterDto_UserFilterDto>();
  static ItemFilterDto_UserFilterDto getDefault() => _defaultInstance ??= create()..freeze();
  static ItemFilterDto_UserFilterDto _defaultInstance;

  $core.List<$5.UserType> get userTypes => $_getList(0);

  $core.List<$core.String> get socialMediaNetworkIds => $_getList(1);

  $core.int get mapLevel => $_get(2, 0);
  set mapLevel($core.int v) { $_setSignedInt32(2, v); }
  $core.bool hasMapLevel() => $_has(2);
  void clearMapLevel() => clearField(7);

  $2.GeoPointDto get northWest => $_getN(3);
  set northWest($2.GeoPointDto v) { setField(8, v); }
  $core.bool hasNorthWest() => $_has(3);
  void clearNorthWest() => clearField(8);

  $2.GeoPointDto get southEast => $_getN(4);
  set southEast($2.GeoPointDto v) { setField(9, v); }
  $core.bool hasSouthEast() => $_has(4);
  void clearSouthEast() => clearField(9);

  $core.List<$core.String> get categoryIds => $_getList(5);

  $core.String get phrase => $_getS(6, '');
  set phrase($core.String v) { $_setString(6, v); }
  $core.bool hasPhrase() => $_has(6);
  void clearPhrase() => clearField(11);

  $3.MoneyDto get minimumValue => $_getN(7);
  set minimumValue($3.MoneyDto v) { setField(12, v); }
  $core.bool hasMinimumValue() => $_has(7);
  void clearMinimumValue() => clearField(12);

  $3.MoneyDto get maximumValue => $_getN(8);
  set maximumValue($3.MoneyDto v) { setField(13, v); }
  $core.bool hasMaximumValue() => $_has(8);
  void clearMaximumValue() => clearField(13);
}

class ItemFilterDto_ConversationFilterDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ItemFilterDto.ConversationFilterDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'participatingUserId')
    ..aOS(2, 'topicId')
    ..pc<$12.ConversationDto_Status>(3, 'conversationStatuses', $pb.PbFieldType.PE, null, $12.ConversationDto_Status.valueOf, $12.ConversationDto_Status.values)
    ..hasRequiredFields = false
  ;

  ItemFilterDto_ConversationFilterDto() : super();
  ItemFilterDto_ConversationFilterDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ItemFilterDto_ConversationFilterDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ItemFilterDto_ConversationFilterDto clone() => ItemFilterDto_ConversationFilterDto()..mergeFromMessage(this);
  ItemFilterDto_ConversationFilterDto copyWith(void Function(ItemFilterDto_ConversationFilterDto) updates) => super.copyWith((message) => updates(message as ItemFilterDto_ConversationFilterDto));
  $pb.BuilderInfo get info_ => _i;
  static ItemFilterDto_ConversationFilterDto create() => ItemFilterDto_ConversationFilterDto();
  ItemFilterDto_ConversationFilterDto createEmptyInstance() => create();
  static $pb.PbList<ItemFilterDto_ConversationFilterDto> createRepeated() => $pb.PbList<ItemFilterDto_ConversationFilterDto>();
  static ItemFilterDto_ConversationFilterDto getDefault() => _defaultInstance ??= create()..freeze();
  static ItemFilterDto_ConversationFilterDto _defaultInstance;

  $core.String get participatingUserId => $_getS(0, '');
  set participatingUserId($core.String v) { $_setString(0, v); }
  $core.bool hasParticipatingUserId() => $_has(0);
  void clearParticipatingUserId() => clearField(1);

  $core.String get topicId => $_getS(1, '');
  set topicId($core.String v) { $_setString(1, v); }
  $core.bool hasTopicId() => $_has(1);
  void clearTopicId() => clearField(2);

  $core.List<$12.ConversationDto_Status> get conversationStatuses => $_getList(2);
}

class ItemFilterDto_MessageFilterDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ItemFilterDto.MessageFilterDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'conversationId')
    ..hasRequiredFields = false
  ;

  ItemFilterDto_MessageFilterDto() : super();
  ItemFilterDto_MessageFilterDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ItemFilterDto_MessageFilterDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ItemFilterDto_MessageFilterDto clone() => ItemFilterDto_MessageFilterDto()..mergeFromMessage(this);
  ItemFilterDto_MessageFilterDto copyWith(void Function(ItemFilterDto_MessageFilterDto) updates) => super.copyWith((message) => updates(message as ItemFilterDto_MessageFilterDto));
  $pb.BuilderInfo get info_ => _i;
  static ItemFilterDto_MessageFilterDto create() => ItemFilterDto_MessageFilterDto();
  ItemFilterDto_MessageFilterDto createEmptyInstance() => create();
  static $pb.PbList<ItemFilterDto_MessageFilterDto> createRepeated() => $pb.PbList<ItemFilterDto_MessageFilterDto>();
  static ItemFilterDto_MessageFilterDto getDefault() => _defaultInstance ??= create()..freeze();
  static ItemFilterDto_MessageFilterDto _defaultInstance;

  $core.String get conversationId => $_getS(0, '');
  set conversationId($core.String v) { $_setString(0, v); }
  $core.bool hasConversationId() => $_has(0);
  void clearConversationId() => clearField(1);
}

class ItemFilterDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ItemFilterDto', package: const $pb.PackageName('api'))
    ..a<ItemFilterDto_OfferFilterDto>(10, 'offerFilter', $pb.PbFieldType.OM, ItemFilterDto_OfferFilterDto.getDefault, ItemFilterDto_OfferFilterDto.create)
    ..a<ItemFilterDto_UserFilterDto>(11, 'userFilter', $pb.PbFieldType.OM, ItemFilterDto_UserFilterDto.getDefault, ItemFilterDto_UserFilterDto.create)
    ..a<ItemFilterDto_ConversationFilterDto>(12, 'conversationFilter', $pb.PbFieldType.OM, ItemFilterDto_ConversationFilterDto.getDefault, ItemFilterDto_ConversationFilterDto.create)
    ..a<ItemFilterDto_MessageFilterDto>(13, 'messageFilter', $pb.PbFieldType.OM, ItemFilterDto_MessageFilterDto.getDefault, ItemFilterDto_MessageFilterDto.create)
    ..hasRequiredFields = false
  ;

  ItemFilterDto() : super();
  ItemFilterDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ItemFilterDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ItemFilterDto clone() => ItemFilterDto()..mergeFromMessage(this);
  ItemFilterDto copyWith(void Function(ItemFilterDto) updates) => super.copyWith((message) => updates(message as ItemFilterDto));
  $pb.BuilderInfo get info_ => _i;
  static ItemFilterDto create() => ItemFilterDto();
  ItemFilterDto createEmptyInstance() => create();
  static $pb.PbList<ItemFilterDto> createRepeated() => $pb.PbList<ItemFilterDto>();
  static ItemFilterDto getDefault() => _defaultInstance ??= create()..freeze();
  static ItemFilterDto _defaultInstance;

  ItemFilterDto_OfferFilterDto get offerFilter => $_getN(0);
  set offerFilter(ItemFilterDto_OfferFilterDto v) { setField(10, v); }
  $core.bool hasOfferFilter() => $_has(0);
  void clearOfferFilter() => clearField(10);

  ItemFilterDto_UserFilterDto get userFilter => $_getN(1);
  set userFilter(ItemFilterDto_UserFilterDto v) { setField(11, v); }
  $core.bool hasUserFilter() => $_has(1);
  void clearUserFilter() => clearField(11);

  ItemFilterDto_ConversationFilterDto get conversationFilter => $_getN(2);
  set conversationFilter(ItemFilterDto_ConversationFilterDto v) { setField(12, v); }
  $core.bool hasConversationFilter() => $_has(2);
  void clearConversationFilter() => clearField(12);

  ItemFilterDto_MessageFilterDto get messageFilter => $_getN(3);
  set messageFilter(ItemFilterDto_MessageFilterDto v) { setField(13, v); }
  $core.bool hasMessageFilter() => $_has(3);
  void clearMessageFilter() => clearField(13);
}

