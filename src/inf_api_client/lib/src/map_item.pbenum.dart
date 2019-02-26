///
//  Generated code. Do not modify.
//  source: map_item.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

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

