///
//  Generated code. Do not modify.
//  source: conversation.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class ConversationDto_Status extends $pb.ProtobufEnum {
  static const ConversationDto_Status closed = ConversationDto_Status._(0, 'closed');
  static const ConversationDto_Status open = ConversationDto_Status._(1, 'open');

  static const $core.List<ConversationDto_Status> values = <ConversationDto_Status> [
    closed,
    open,
  ];

  static final $core.Map<$core.int, ConversationDto_Status> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ConversationDto_Status valueOf($core.int value) => _byValue[value];

  const ConversationDto_Status._($core.int v, $core.String n) : super(v, n);
}

