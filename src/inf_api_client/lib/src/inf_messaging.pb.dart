///
//  Generated code. Do not modify.
//  source: inf_messaging.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'message.pb.dart' as $7;
import 'conversation.pb.dart' as $13;

class CreateConversationRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CreateConversationRequest', package: const $pb.PackageName('api'))
    ..pPS(1, 'participantIds')
    ..aOS(2, 'topicId')
    ..a<$7.MessageDto>(3, 'firstMessage', $pb.PbFieldType.OM, $7.MessageDto.getDefault, $7.MessageDto.create)
    ..m<$core.String, $core.String>(4, 'metadata', 'CreateConversationRequest.MetadataEntry',$pb.PbFieldType.OS, $pb.PbFieldType.OS, null, null, null , const $pb.PackageName('api'))
    ..hasRequiredFields = false
  ;

  CreateConversationRequest() : super();
  CreateConversationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateConversationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateConversationRequest clone() => CreateConversationRequest()..mergeFromMessage(this);
  CreateConversationRequest copyWith(void Function(CreateConversationRequest) updates) => super.copyWith((message) => updates(message as CreateConversationRequest));
  $pb.BuilderInfo get info_ => _i;
  static CreateConversationRequest create() => CreateConversationRequest();
  CreateConversationRequest createEmptyInstance() => create();
  static $pb.PbList<CreateConversationRequest> createRepeated() => $pb.PbList<CreateConversationRequest>();
  static CreateConversationRequest getDefault() => _defaultInstance ??= create()..freeze();
  static CreateConversationRequest _defaultInstance;

  $core.List<$core.String> get participantIds => $_getList(0);

  $core.String get topicId => $_getS(1, '');
  set topicId($core.String v) { $_setString(1, v); }
  $core.bool hasTopicId() => $_has(1);
  void clearTopicId() => clearField(2);

  $7.MessageDto get firstMessage => $_getN(2);
  set firstMessage($7.MessageDto v) { setField(3, v); }
  $core.bool hasFirstMessage() => $_has(2);
  void clearFirstMessage() => clearField(3);

  $core.Map<$core.String, $core.String> get metadata => $_getMap(3);
}

class CreateConversationResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CreateConversationResponse', package: const $pb.PackageName('api'))
    ..a<$13.ConversationDto>(1, 'conversation', $pb.PbFieldType.OM, $13.ConversationDto.getDefault, $13.ConversationDto.create)
    ..hasRequiredFields = false
  ;

  CreateConversationResponse() : super();
  CreateConversationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateConversationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateConversationResponse clone() => CreateConversationResponse()..mergeFromMessage(this);
  CreateConversationResponse copyWith(void Function(CreateConversationResponse) updates) => super.copyWith((message) => updates(message as CreateConversationResponse));
  $pb.BuilderInfo get info_ => _i;
  static CreateConversationResponse create() => CreateConversationResponse();
  CreateConversationResponse createEmptyInstance() => create();
  static $pb.PbList<CreateConversationResponse> createRepeated() => $pb.PbList<CreateConversationResponse>();
  static CreateConversationResponse getDefault() => _defaultInstance ??= create()..freeze();
  static CreateConversationResponse _defaultInstance;

  $13.ConversationDto get conversation => $_getN(0);
  set conversation($13.ConversationDto v) { setField(1, v); }
  $core.bool hasConversation() => $_has(0);
  void clearConversation() => clearField(1);
}

class CloseConversationRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CloseConversationRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'conversationId')
    ..hasRequiredFields = false
  ;

  CloseConversationRequest() : super();
  CloseConversationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CloseConversationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CloseConversationRequest clone() => CloseConversationRequest()..mergeFromMessage(this);
  CloseConversationRequest copyWith(void Function(CloseConversationRequest) updates) => super.copyWith((message) => updates(message as CloseConversationRequest));
  $pb.BuilderInfo get info_ => _i;
  static CloseConversationRequest create() => CloseConversationRequest();
  CloseConversationRequest createEmptyInstance() => create();
  static $pb.PbList<CloseConversationRequest> createRepeated() => $pb.PbList<CloseConversationRequest>();
  static CloseConversationRequest getDefault() => _defaultInstance ??= create()..freeze();
  static CloseConversationRequest _defaultInstance;

  $core.String get conversationId => $_getS(0, '');
  set conversationId($core.String v) { $_setString(0, v); }
  $core.bool hasConversationId() => $_has(0);
  void clearConversationId() => clearField(1);
}

class CloseConversationResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CloseConversationResponse', package: const $pb.PackageName('api'))
    ..a<$13.ConversationDto>(1, 'conversation', $pb.PbFieldType.OM, $13.ConversationDto.getDefault, $13.ConversationDto.create)
    ..hasRequiredFields = false
  ;

  CloseConversationResponse() : super();
  CloseConversationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CloseConversationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CloseConversationResponse clone() => CloseConversationResponse()..mergeFromMessage(this);
  CloseConversationResponse copyWith(void Function(CloseConversationResponse) updates) => super.copyWith((message) => updates(message as CloseConversationResponse));
  $pb.BuilderInfo get info_ => _i;
  static CloseConversationResponse create() => CloseConversationResponse();
  CloseConversationResponse createEmptyInstance() => create();
  static $pb.PbList<CloseConversationResponse> createRepeated() => $pb.PbList<CloseConversationResponse>();
  static CloseConversationResponse getDefault() => _defaultInstance ??= create()..freeze();
  static CloseConversationResponse _defaultInstance;

  $13.ConversationDto get conversation => $_getN(0);
  set conversation($13.ConversationDto v) { setField(1, v); }
  $core.bool hasConversation() => $_has(0);
  void clearConversation() => clearField(1);
}

class CreateMessageRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CreateMessageRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'conversationId')
    ..a<$7.MessageDto>(2, 'message', $pb.PbFieldType.OM, $7.MessageDto.getDefault, $7.MessageDto.create)
    ..hasRequiredFields = false
  ;

  CreateMessageRequest() : super();
  CreateMessageRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateMessageRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateMessageRequest clone() => CreateMessageRequest()..mergeFromMessage(this);
  CreateMessageRequest copyWith(void Function(CreateMessageRequest) updates) => super.copyWith((message) => updates(message as CreateMessageRequest));
  $pb.BuilderInfo get info_ => _i;
  static CreateMessageRequest create() => CreateMessageRequest();
  CreateMessageRequest createEmptyInstance() => create();
  static $pb.PbList<CreateMessageRequest> createRepeated() => $pb.PbList<CreateMessageRequest>();
  static CreateMessageRequest getDefault() => _defaultInstance ??= create()..freeze();
  static CreateMessageRequest _defaultInstance;

  $core.String get conversationId => $_getS(0, '');
  set conversationId($core.String v) { $_setString(0, v); }
  $core.bool hasConversationId() => $_has(0);
  void clearConversationId() => clearField(1);

  $7.MessageDto get message => $_getN(1);
  set message($7.MessageDto v) { setField(2, v); }
  $core.bool hasMessage() => $_has(1);
  void clearMessage() => clearField(2);
}

class CreateMessageResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CreateMessageResponse', package: const $pb.PackageName('api'))
    ..a<$7.MessageDto>(1, 'message', $pb.PbFieldType.OM, $7.MessageDto.getDefault, $7.MessageDto.create)
    ..hasRequiredFields = false
  ;

  CreateMessageResponse() : super();
  CreateMessageResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateMessageResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateMessageResponse clone() => CreateMessageResponse()..mergeFromMessage(this);
  CreateMessageResponse copyWith(void Function(CreateMessageResponse) updates) => super.copyWith((message) => updates(message as CreateMessageResponse));
  $pb.BuilderInfo get info_ => _i;
  static CreateMessageResponse create() => CreateMessageResponse();
  CreateMessageResponse createEmptyInstance() => create();
  static $pb.PbList<CreateMessageResponse> createRepeated() => $pb.PbList<CreateMessageResponse>();
  static CreateMessageResponse getDefault() => _defaultInstance ??= create()..freeze();
  static CreateMessageResponse _defaultInstance;

  $7.MessageDto get message => $_getN(0);
  set message($7.MessageDto v) { setField(1, v); }
  $core.bool hasMessage() => $_has(0);
  void clearMessage() => clearField(1);
}

