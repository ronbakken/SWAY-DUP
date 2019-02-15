///
//  Generated code. Do not modify.
//  source: inf_mapping.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class SearchRequest_ItemType extends $pb.ProtobufEnum {
  static const SearchRequest_ItemType offers = const SearchRequest_ItemType._(0, 'offers');
  static const SearchRequest_ItemType users = const SearchRequest_ItemType._(1, 'users');

  static const List<SearchRequest_ItemType> values = const <SearchRequest_ItemType> [
    offers,
    users,
  ];

  static final Map<int, SearchRequest_ItemType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SearchRequest_ItemType valueOf(int value) => _byValue[value];
  static void $checkItem(SearchRequest_ItemType v) {
    if (v is! SearchRequest_ItemType) $pb.checkItemFailed(v, 'SearchRequest_ItemType');
  }

  const SearchRequest_ItemType._(int v, String n) : super(v, n);
}

class MapItemDto_MapItemStatus extends $pb.ProtobufEnum {
  static const MapItemDto_MapItemStatus inactive = const MapItemDto_MapItemStatus._(0, 'inactive');
  static const MapItemDto_MapItemStatus active = const MapItemDto_MapItemStatus._(1, 'active');

  static const List<MapItemDto_MapItemStatus> values = const <MapItemDto_MapItemStatus> [
    inactive,
    active,
  ];

  static final Map<int, MapItemDto_MapItemStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MapItemDto_MapItemStatus valueOf(int value) => _byValue[value];
  static void $checkItem(MapItemDto_MapItemStatus v) {
    if (v is! MapItemDto_MapItemStatus) $pb.checkItemFailed(v, 'MapItemDto_MapItemStatus');
  }

  const MapItemDto_MapItemStatus._(int v, String n) : super(v, n);
}

