///
//  Generated code. Do not modify.
//  source: message.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'user.pb.dart' as $5;
import 'google/protobuf/timestamp.pb.dart' as $6;

class MessageDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('MessageDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'id')
    ..a<$5.UserDto>(2, 'user', $pb.PbFieldType.OM, $5.UserDto.getDefault, $5.UserDto.create)
    ..aOS(3, 'action')
    ..a<$6.Timestamp>(4, 'timestamp', $pb.PbFieldType.OM, $6.Timestamp.getDefault, $6.Timestamp.create)
    ..aOS(5, 'text')
    ..pp<MessageAttachmentDto>(6, 'attachments', $pb.PbFieldType.PM, MessageAttachmentDto.$checkItem, MessageAttachmentDto.create)
    ..hasRequiredFields = false
  ;

  MessageDto() : super();
  MessageDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MessageDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MessageDto clone() => new MessageDto()..mergeFromMessage(this);
  MessageDto copyWith(void Function(MessageDto) updates) => super.copyWith((message) => updates(message as MessageDto));
  $pb.BuilderInfo get info_ => _i;
  static MessageDto create() => new MessageDto();
  MessageDto createEmptyInstance() => create();
  static $pb.PbList<MessageDto> createRepeated() => new $pb.PbList<MessageDto>();
  static MessageDto getDefault() => _defaultInstance ??= create()..freeze();
  static MessageDto _defaultInstance;
  static void $checkItem(MessageDto v) {
    if (v is! MessageDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get id => $_getS(0, '');
  set id(String v) { $_setString(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  $5.UserDto get user => $_getN(1);
  set user($5.UserDto v) { setField(2, v); }
  bool hasUser() => $_has(1);
  void clearUser() => clearField(2);

  String get action => $_getS(2, '');
  set action(String v) { $_setString(2, v); }
  bool hasAction() => $_has(2);
  void clearAction() => clearField(3);

  $6.Timestamp get timestamp => $_getN(3);
  set timestamp($6.Timestamp v) { setField(4, v); }
  bool hasTimestamp() => $_has(3);
  void clearTimestamp() => clearField(4);

  String get text => $_getS(4, '');
  set text(String v) { $_setString(4, v); }
  bool hasText() => $_has(4);
  void clearText() => clearField(5);

  List<MessageAttachmentDto> get attachments => $_getList(5);
}

class MessageAttachmentDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('MessageAttachmentDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'contentType')
    ..a<List<int>>(2, 'data', $pb.PbFieldType.OY)
    ..m<String, String>(3, 'metadata', $pb.PbFieldType.OS, $pb.PbFieldType.OS)
    ..hasRequiredFields = false
  ;

  MessageAttachmentDto() : super();
  MessageAttachmentDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MessageAttachmentDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MessageAttachmentDto clone() => new MessageAttachmentDto()..mergeFromMessage(this);
  MessageAttachmentDto copyWith(void Function(MessageAttachmentDto) updates) => super.copyWith((message) => updates(message as MessageAttachmentDto));
  $pb.BuilderInfo get info_ => _i;
  static MessageAttachmentDto create() => new MessageAttachmentDto();
  MessageAttachmentDto createEmptyInstance() => create();
  static $pb.PbList<MessageAttachmentDto> createRepeated() => new $pb.PbList<MessageAttachmentDto>();
  static MessageAttachmentDto getDefault() => _defaultInstance ??= create()..freeze();
  static MessageAttachmentDto _defaultInstance;
  static void $checkItem(MessageAttachmentDto v) {
    if (v is! MessageAttachmentDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get contentType => $_getS(0, '');
  set contentType(String v) { $_setString(0, v); }
  bool hasContentType() => $_has(0);
  void clearContentType() => clearField(1);

  List<int> get data => $_getN(1);
  set data(List<int> v) { $_setBytes(1, v); }
  bool hasData() => $_has(1);
  void clearData() => clearField(2);

  Map<String, String> get metadata => $_getMap(2);
}

