///
//  Generated code. Do not modify.
//  source: map_item.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class MapItemDto_MapItemStatus extends $pb.ProtobufEnum {
  static const MapItemDto_MapItemStatus inactive = MapItemDto_MapItemStatus._(0, 'inactive');
  static const MapItemDto_MapItemStatus active = MapItemDto_MapItemStatus._(1, 'active');

  static const $core.List<MapItemDto_MapItemStatus> values = <MapItemDto_MapItemStatus> [
    inactive,
    active,
  ];

  static final $core.Map<$core.int, MapItemDto_MapItemStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MapItemDto_MapItemStatus valueOf($core.int value) => _byValue[value];

  const MapItemDto_MapItemStatus._($core.int v, $core.String n) : super(v, n);
}

