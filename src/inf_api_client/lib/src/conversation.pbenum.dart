///
//  Generated code. Do not modify.
//  source: conversation.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class ConversationDto_Status extends $pb.ProtobufEnum {
  static const ConversationDto_Status closed = const ConversationDto_Status._(0, 'closed');
  static const ConversationDto_Status open = const ConversationDto_Status._(1, 'open');

  static const List<ConversationDto_Status> values = const <ConversationDto_Status> [
    closed,
    open,
  ];

  static final Map<int, ConversationDto_Status> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ConversationDto_Status valueOf(int value) => _byValue[value];
  static void $checkItem(ConversationDto_Status v) {
    if (v is! ConversationDto_Status) $pb.checkItemFailed(v, 'ConversationDto_Status');
  }

  const ConversationDto_Status._(int v, String n) : super(v, n);
}

