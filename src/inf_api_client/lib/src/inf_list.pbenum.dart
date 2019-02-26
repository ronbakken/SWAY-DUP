///
//  Generated code. Do not modify.
//  source: inf_list.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class ListRequest_State extends $pb.ProtobufEnum {
  static const ListRequest_State paused = const ListRequest_State._(0, 'paused');
  static const ListRequest_State resumed = const ListRequest_State._(1, 'resumed');

  static const List<ListRequest_State> values = const <ListRequest_State> [
    paused,
    resumed,
  ];

  static final Map<int, ListRequest_State> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ListRequest_State valueOf(int value) => _byValue[value];
  static void $checkItem(ListRequest_State v) {
    if (v is! ListRequest_State) $pb.checkItemFailed(v, 'ListRequest_State');
  }

  const ListRequest_State._(int v, String n) : super(v, n);
}

