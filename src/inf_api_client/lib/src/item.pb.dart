///
//  Generated code. Do not modify.
//  source: item.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'offer.pb.dart' as $9;
import 'user.pb.dart' as $10;
import 'map_item.pb.dart' as $11;

enum ItemDto_Data {
  offer, 
  user, 
  mapItem, 
  notSet
}

class ItemDto extends $pb.GeneratedMessage {
  static const Map<int, ItemDto_Data> _ItemDto_DataByTag = {
    1 : ItemDto_Data.offer,
    2 : ItemDto_Data.user,
    3 : ItemDto_Data.mapItem,
    0 : ItemDto_Data.notSet
  };
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ItemDto', package: const $pb.PackageName('api'))
    ..a<$9.OfferDto>(1, 'offer', $pb.PbFieldType.OM, $9.OfferDto.getDefault, $9.OfferDto.create)
    ..a<$10.UserDto>(2, 'user', $pb.PbFieldType.OM, $10.UserDto.getDefault, $10.UserDto.create)
    ..a<$11.MapItemDto>(3, 'mapItem', $pb.PbFieldType.OM, $11.MapItemDto.getDefault, $11.MapItemDto.create)
    ..oo(0, [1, 2, 3])
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

  $9.OfferDto get offer => $_getN(0);
  set offer($9.OfferDto v) { setField(1, v); }
  bool hasOffer() => $_has(0);
  void clearOffer() => clearField(1);

  $10.UserDto get user => $_getN(1);
  set user($10.UserDto v) { setField(2, v); }
  bool hasUser() => $_has(1);
  void clearUser() => clearField(2);

  $11.MapItemDto get mapItem => $_getN(2);
  set mapItem($11.MapItemDto v) { setField(3, v); }
  bool hasMapItem() => $_has(2);
  void clearMapItem() => clearField(3);
}

