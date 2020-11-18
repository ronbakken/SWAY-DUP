///
//  Generated code. Do not modify.
//  source: message.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'user.pb.dart' as $5;
import 'google/protobuf/timestamp.pb.dart' as $6;

class MessageDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('MessageDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'id')
    ..a<$5.UserDto>(2, 'user', $pb.PbFieldType.OM, $5.UserDto.getDefault, $5.UserDto.create)
    ..aOS(3, 'action')
    ..a<$6.Timestamp>(4, 'timestamp', $pb.PbFieldType.OM, $6.Timestamp.getDefault, $6.Timestamp.create)
    ..aOS(5, 'text')
    ..pc<MessageAttachmentDto>(6, 'attachments', $pb.PbFieldType.PM,MessageAttachmentDto.create)
    ..hasRequiredFields = false
  ;

  MessageDto() : super();
  MessageDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MessageDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MessageDto clone() => MessageDto()..mergeFromMessage(this);
  MessageDto copyWith(void Function(MessageDto) updates) => super.copyWith((message) => updates(message as MessageDto));
  $pb.BuilderInfo get info_ => _i;
  static MessageDto create() => MessageDto();
  MessageDto createEmptyInstance() => create();
  static $pb.PbList<MessageDto> createRepeated() => $pb.PbList<MessageDto>();
  static MessageDto getDefault() => _defaultInstance ??= create()..freeze();
  static MessageDto _defaultInstance;

  $core.String get id => $_getS(0, '');
  set id($core.String v) { $_setString(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  $5.UserDto get user => $_getN(1);
  set user($5.UserDto v) { setField(2, v); }
  $core.bool hasUser() => $_has(1);
  void clearUser() => clearField(2);

  $core.String get action => $_getS(2, '');
  set action($core.String v) { $_setString(2, v); }
  $core.bool hasAction() => $_has(2);
  void clearAction() => clearField(3);

  $6.Timestamp get timestamp => $_getN(3);
  set timestamp($6.Timestamp v) { setField(4, v); }
  $core.bool hasTimestamp() => $_has(3);
  void clearTimestamp() => clearField(4);

  $core.String get text => $_getS(4, '');
  set text($core.String v) { $_setString(4, v); }
  $core.bool hasText() => $_has(4);
  void clearText() => clearField(5);

  $core.List<MessageAttachmentDto> get attachments => $_getList(5);
}

class MessageAttachmentDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('MessageAttachmentDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'contentType')
    ..a<$core.List<$core.int>>(2, 'data', $pb.PbFieldType.OY)
    ..m<$core.String, $core.String>(3, 'metadata', 'MessageAttachmentDto.MetadataEntry',$pb.PbFieldType.OS, $pb.PbFieldType.OS, null, null, null , const $pb.PackageName('api'))
    ..hasRequiredFields = false
  ;

  MessageAttachmentDto() : super();
  MessageAttachmentDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MessageAttachmentDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MessageAttachmentDto clone() => MessageAttachmentDto()..mergeFromMessage(this);
  MessageAttachmentDto copyWith(void Function(MessageAttachmentDto) updates) => super.copyWith((message) => updates(message as MessageAttachmentDto));
  $pb.BuilderInfo get info_ => _i;
  static MessageAttachmentDto create() => MessageAttachmentDto();
  MessageAttachmentDto createEmptyInstance() => create();
  static $pb.PbList<MessageAttachmentDto> createRepeated() => $pb.PbList<MessageAttachmentDto>();
  static MessageAttachmentDto getDefault() => _defaultInstance ??= create()..freeze();
  static MessageAttachmentDto _defaultInstance;

  $core.String get contentType => $_getS(0, '');
  set contentType($core.String v) { $_setString(0, v); }
  $core.bool hasContentType() => $_has(0);
  void clearContentType() => clearField(1);

  $core.List<$core.int> get data => $_getN(1);
  set data($core.List<$core.int> v) { $_setBytes(1, v); }
  $core.bool hasData() => $_has(1);
  void clearData() => clearField(2);

  $core.Map<$core.String, $core.String> get metadata => $_getMap(2);
}

