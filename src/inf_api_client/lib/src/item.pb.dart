///
//  Generated code. Do not modify.
//  source: item.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'offer.pb.dart' as $10;
import 'user.pb.dart' as $5;
import 'map_item.pb.dart' as $11;
import 'conversation.pb.dart' as $12;
import 'message.pb.dart' as $7;

enum ItemDto_Data {
  offer, 
  user, 
  mapItem, 
  conversation, 
  message, 
  notSet
}

class ItemDto extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, ItemDto_Data> _ItemDto_DataByTag = {
    1 : ItemDto_Data.offer,
    2 : ItemDto_Data.user,
    3 : ItemDto_Data.mapItem,
    4 : ItemDto_Data.conversation,
    5 : ItemDto_Data.message,
    0 : ItemDto_Data.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ItemDto', package: const $pb.PackageName('api'))
    ..a<$10.OfferDto>(1, 'offer', $pb.PbFieldType.OM, $10.OfferDto.getDefault, $10.OfferDto.create)
    ..a<$5.UserDto>(2, 'user', $pb.PbFieldType.OM, $5.UserDto.getDefault, $5.UserDto.create)
    ..a<$11.MapItemDto>(3, 'mapItem', $pb.PbFieldType.OM, $11.MapItemDto.getDefault, $11.MapItemDto.create)
    ..a<$12.ConversationDto>(4, 'conversation', $pb.PbFieldType.OM, $12.ConversationDto.getDefault, $12.ConversationDto.create)
    ..a<$7.MessageDto>(5, 'message', $pb.PbFieldType.OM, $7.MessageDto.getDefault, $7.MessageDto.create)
    ..oo(0, [1, 2, 3, 4, 5])
    ..hasRequiredFields = false
  ;

  ItemDto() : super();
  ItemDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ItemDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ItemDto clone() => ItemDto()..mergeFromMessage(this);
  ItemDto copyWith(void Function(ItemDto) updates) => super.copyWith((message) => updates(message as ItemDto));
  $pb.BuilderInfo get info_ => _i;
  static ItemDto create() => ItemDto();
  ItemDto createEmptyInstance() => create();
  static $pb.PbList<ItemDto> createRepeated() => $pb.PbList<ItemDto>();
  static ItemDto getDefault() => _defaultInstance ??= create()..freeze();
  static ItemDto _defaultInstance;

  ItemDto_Data whichData() => _ItemDto_DataByTag[$_whichOneof(0)];
  void clearData() => clearField($_whichOneof(0));

  $10.OfferDto get offer => $_getN(0);
  set offer($10.OfferDto v) { setField(1, v); }
  $core.bool hasOffer() => $_has(0);
  void clearOffer() => clearField(1);

  $5.UserDto get user => $_getN(1);
  set user($5.UserDto v) { setField(2, v); }
  $core.bool hasUser() => $_has(1);
  void clearUser() => clearField(2);

  $11.MapItemDto get mapItem => $_getN(2);
  set mapItem($11.MapItemDto v) { setField(3, v); }
  $core.bool hasMapItem() => $_has(2);
  void clearMapItem() => clearField(3);

  $12.ConversationDto get conversation => $_getN(3);
  set conversation($12.ConversationDto v) { setField(4, v); }
  $core.bool hasConversation() => $_has(3);
  void clearConversation() => clearField(4);

  $7.MessageDto get message => $_getN(4);
  set message($7.MessageDto v) { setField(5, v); }
  $core.bool hasMessage() => $_has(4);
  void clearMessage() => clearField(5);
}

