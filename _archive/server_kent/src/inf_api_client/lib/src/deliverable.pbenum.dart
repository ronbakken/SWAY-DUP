///
//  Generated code. Do not modify.
//  source: deliverable.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class DeliverableType extends $pb.ProtobufEnum {
  static const DeliverableType post = DeliverableType._(0, 'post');
  static const DeliverableType mention = DeliverableType._(1, 'mention');
  static const DeliverableType video = DeliverableType._(2, 'video');
  static const DeliverableType custom = DeliverableType._(3, 'custom');

  static const $core.List<DeliverableType> values = <DeliverableType> [
    post,
    mention,
    video,
    custom,
  ];

  static final $core.Map<$core.int, DeliverableType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DeliverableType valueOf($core.int value) => _byValue[value];

  const DeliverableType._($core.int v, $core.String n) : super(v, n);
}

