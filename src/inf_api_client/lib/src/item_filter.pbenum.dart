///
//  Generated code. Do not modify.
//  source: item_filter.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class ItemFilterDto_ItemType extends $pb.ProtobufEnum {
  static const ItemFilterDto_ItemType offers = const ItemFilterDto_ItemType._(0, 'offers');
  static const ItemFilterDto_ItemType users = const ItemFilterDto_ItemType._(1, 'users');

  static const List<ItemFilterDto_ItemType> values = const <ItemFilterDto_ItemType> [
    offers,
    users,
  ];

  static final Map<int, ItemFilterDto_ItemType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ItemFilterDto_ItemType valueOf(int value) => _byValue[value];
  static void $checkItem(ItemFilterDto_ItemType v) {
    if (v is! ItemFilterDto_ItemType) $pb.checkItemFailed(v, 'ItemFilterDto_ItemType');
  }

  const ItemFilterDto_ItemType._(int v, String n) : super(v, n);
}

