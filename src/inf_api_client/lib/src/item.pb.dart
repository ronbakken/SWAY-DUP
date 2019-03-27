///
//  Generated code. Do not modify.
//  source: item.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'offer.pb.dart' as $11;
import 'user.pb.dart' as $5;
import 'map_item.pb.dart' as $12;
import 'conversation.pb.dart' as $13;
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
  static const Map<int, ItemDto_Data> _ItemDto_DataByTag = {
    1 : ItemDto_Data.offer,
    2 : ItemDto_Data.user,
    3 : ItemDto_Data.mapItem,
    4 : ItemDto_Data.conversation,
    5 : ItemDto_Data.message,
    0 : ItemDto_Data.notSet
  };
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ItemDto', package: const $pb.PackageName('api'))
    ..a<$11.OfferDto>(1, 'offer', $pb.PbFieldType.OM, $11.OfferDto.getDefault, $11.OfferDto.create)
    ..a<$5.UserDto>(2, 'user', $pb.PbFieldType.OM, $5.UserDto.getDefault, $5.UserDto.create)
    ..a<$12.MapItemDto>(3, 'mapItem', $pb.PbFieldType.OM, $12.MapItemDto.getDefault, $12.MapItemDto.create)
    ..a<$13.ConversationDto>(4, 'conversation', $pb.PbFieldType.OM, $13.ConversationDto.getDefault, $13.ConversationDto.create)
    ..a<$7.MessageDto>(5, 'message', $pb.PbFieldType.OM, $7.MessageDto.getDefault, $7.MessageDto.create)
    ..oo(0, [1, 2, 3, 4, 5])
    ..hasRequiredFields = false
  ;

  ItemDto() : super();
  ItemDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ItemDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ItemDto clone() => new ItemDto()..mergeFromMessage(this);
  ItemDto copyWith(void Function(ItemDto) updates) => super.copyWith((message) => updates(message as ItemDto));
  $pb.BuilderInfo get info_ => _i;
  static ItemDto create() => new ItemDto();
  ItemDto createEmptyInstance() => create();
  static $pb.PbList<ItemDto> createRepeated() => new $pb.PbList<ItemDto>();
  static ItemDto getDefault() => _defaultInstance ??= create()..freeze();
  static ItemDto _defaultInstance;
  static void $checkItem(ItemDto v) {
    if (v is! ItemDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  ItemDto_Data whichData() => _ItemDto_DataByTag[$_whichOneof(0)];
  void clearData() => clearField($_whichOneof(0));

  $11.OfferDto get offer => $_getN(0);
  set offer($11.OfferDto v) { setField(1, v); }
  bool hasOffer() => $_has(0);
  void clearOffer() => clearField(1);

  $5.UserDto get user => $_getN(1);
  set user($5.UserDto v) { setField(2, v); }
  bool hasUser() => $_has(1);
  void clearUser() => clearField(2);

  $12.MapItemDto get mapItem => $_getN(2);
  set mapItem($12.MapItemDto v) { setField(3, v); }
  bool hasMapItem() => $_has(2);
  void clearMapItem() => clearField(3);

  $13.ConversationDto get conversation => $_getN(3);
  set conversation($13.ConversationDto v) { setField(4, v); }
  bool hasConversation() => $_has(3);
  void clearConversation() => clearField(4);

  $7.MessageDto get message => $_getN(4);
  set message($7.MessageDto v) { setField(5, v); }
  bool hasMessage() => $_has(4);
  void clearMessage() => clearField(5);
}

