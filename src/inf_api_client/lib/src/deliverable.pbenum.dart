///
//  Generated code. Do not modify.
//  source: deliverable.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class DeliverableType extends $pb.ProtobufEnum {
  static const DeliverableType POST = const DeliverableType._(0, 'POST');
  static const DeliverableType MENTION = const DeliverableType._(1, 'MENTION');
  static const DeliverableType VIDEO = const DeliverableType._(2, 'VIDEO');
  static const DeliverableType CUSTOM_DELIVERABLE = const DeliverableType._(3, 'CUSTOM_DELIVERABLE');

  static const List<DeliverableType> values = const <DeliverableType> [
    POST,
    MENTION,
    VIDEO,
    CUSTOM_DELIVERABLE,
  ];

  static final Map<int, DeliverableType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DeliverableType valueOf(int value) => _byValue[value];
  static void $checkItem(DeliverableType v) {
    if (v is! DeliverableType) $pb.checkItemFailed(v, 'DeliverableType');
  }

  const DeliverableType._(int v, String n) : super(v, n);
}

