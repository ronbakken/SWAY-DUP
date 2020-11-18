///
//  Generated code. Do not modify.
//  source: conversation.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'message.pb.dart' as $7;

import 'conversation.pbenum.dart';

export 'conversation.pbenum.dart';

class ConversationDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ConversationDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'id')
    ..aOS(2, 'topicId')
    ..e<ConversationDto_Status>(3, 'status', $pb.PbFieldType.OE, ConversationDto_Status.closed, ConversationDto_Status.valueOf, ConversationDto_Status.values)
    ..a<$7.MessageDto>(4, 'latestMessage', $pb.PbFieldType.OM, $7.MessageDto.getDefault, $7.MessageDto.create)
    ..a<$7.MessageDto>(5, 'latestMessageWithAction', $pb.PbFieldType.OM, $7.MessageDto.getDefault, $7.MessageDto.create)
    ..m<$core.String, $core.String>(6, 'metadata', 'ConversationDto.MetadataEntry',$pb.PbFieldType.OS, $pb.PbFieldType.OS, null, null, null , const $pb.PackageName('api'))
    ..hasRequiredFields = false
  ;

  ConversationDto() : super();
  ConversationDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ConversationDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ConversationDto clone() => ConversationDto()..mergeFromMessage(this);
  ConversationDto copyWith(void Function(ConversationDto) updates) => super.copyWith((message) => updates(message as ConversationDto));
  $pb.BuilderInfo get info_ => _i;
  static ConversationDto create() => ConversationDto();
  ConversationDto createEmptyInstance() => create();
  static $pb.PbList<ConversationDto> createRepeated() => $pb.PbList<ConversationDto>();
  static ConversationDto getDefault() => _defaultInstance ??= create()..freeze();
  static ConversationDto _defaultInstance;

  $core.String get id => $_getS(0, '');
  set id($core.String v) { $_setString(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  $core.String get topicId => $_getS(1, '');
  set topicId($core.String v) { $_setString(1, v); }
  $core.bool hasTopicId() => $_has(1);
  void clearTopicId() => clearField(2);

  ConversationDto_Status get status => $_getN(2);
  set status(ConversationDto_Status v) { setField(3, v); }
  $core.bool hasStatus() => $_has(2);
  void clearStatus() => clearField(3);

  $7.MessageDto get latestMessage => $_getN(3);
  set latestMessage($7.MessageDto v) { setField(4, v); }
  $core.bool hasLatestMessage() => $_has(3);
  void clearLatestMessage() => clearField(4);

  $7.MessageDto get latestMessageWithAction => $_getN(4);
  set latestMessageWithAction($7.MessageDto v) { setField(5, v); }
  $core.bool hasLatestMessageWithAction() => $_has(4);
  void clearLatestMessageWithAction() => clearField(5);

  $core.Map<$core.String, $core.String> get metadata => $_getMap(5);
}

