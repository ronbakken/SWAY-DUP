///
//  Generated code. Do not modify.
//  source: conversation.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'message.pb.dart' as $7;

import 'conversation.pbenum.dart';

export 'conversation.pbenum.dart';

class ConversationDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ConversationDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'id')
    ..aOS(2, 'topicId')
    ..e<ConversationDto_Status>(3, 'status', $pb.PbFieldType.OE, ConversationDto_Status.closed, ConversationDto_Status.valueOf, ConversationDto_Status.values)
    ..a<$7.MessageDto>(4, 'latestMessage', $pb.PbFieldType.OM, $7.MessageDto.getDefault, $7.MessageDto.create)
    ..hasRequiredFields = false
  ;

  ConversationDto() : super();
  ConversationDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ConversationDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ConversationDto clone() => new ConversationDto()..mergeFromMessage(this);
  ConversationDto copyWith(void Function(ConversationDto) updates) => super.copyWith((message) => updates(message as ConversationDto));
  $pb.BuilderInfo get info_ => _i;
  static ConversationDto create() => new ConversationDto();
  ConversationDto createEmptyInstance() => create();
  static $pb.PbList<ConversationDto> createRepeated() => new $pb.PbList<ConversationDto>();
  static ConversationDto getDefault() => _defaultInstance ??= create()..freeze();
  static ConversationDto _defaultInstance;
  static void $checkItem(ConversationDto v) {
    if (v is! ConversationDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get id => $_getS(0, '');
  set id(String v) { $_setString(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  String get topicId => $_getS(1, '');
  set topicId(String v) { $_setString(1, v); }
  bool hasTopicId() => $_has(1);
  void clearTopicId() => clearField(2);

  ConversationDto_Status get status => $_getN(2);
  set status(ConversationDto_Status v) { setField(3, v); }
  bool hasStatus() => $_has(2);
  void clearStatus() => clearField(3);

  $7.MessageDto get latestMessage => $_getN(3);
  set latestMessage($7.MessageDto v) { setField(4, v); }
  bool hasLatestMessage() => $_has(3);
  void clearLatestMessage() => clearField(4);
}

