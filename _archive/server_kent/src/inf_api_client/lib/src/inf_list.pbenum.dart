///
//  Generated code. Do not modify.
//  source: inf_list.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class ListRequest_State extends $pb.ProtobufEnum {
  static const ListRequest_State paused = ListRequest_State._(0, 'paused');
  static const ListRequest_State resumed = ListRequest_State._(1, 'resumed');

  static const $core.List<ListRequest_State> values = <ListRequest_State> [
    paused,
    resumed,
  ];

  static final $core.Map<$core.int, ListRequest_State> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ListRequest_State valueOf($core.int value) => _byValue[value];

  const ListRequest_State._($core.int v, $core.String n) : super(v, n);
}

