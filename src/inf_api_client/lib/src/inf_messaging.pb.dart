///
//  Generated code. Do not modify.
//  source: inf_messaging.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'message.pb.dart' as $7;
import 'conversation.pb.dart' as $13;

class CreateConversationRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CreateConversationRequest', package: const $pb.PackageName('api'))
    ..pPS(1, 'participantIds')
    ..aOS(2, 'topicId')
    ..a<$7.MessageDto>(3, 'firstMessage', $pb.PbFieldType.OM, $7.MessageDto.getDefault, $7.MessageDto.create)
    ..hasRequiredFields = false
  ;

  CreateConversationRequest() : super();
  CreateConversationRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateConversationRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateConversationRequest clone() => new CreateConversationRequest()..mergeFromMessage(this);
  CreateConversationRequest copyWith(void Function(CreateConversationRequest) updates) => super.copyWith((message) => updates(message as CreateConversationRequest));
  $pb.BuilderInfo get info_ => _i;
  static CreateConversationRequest create() => new CreateConversationRequest();
  CreateConversationRequest createEmptyInstance() => create();
  static $pb.PbList<CreateConversationRequest> createRepeated() => new $pb.PbList<CreateConversationRequest>();
  static CreateConversationRequest getDefault() => _defaultInstance ??= create()..freeze();
  static CreateConversationRequest _defaultInstance;
  static void $checkItem(CreateConversationRequest v) {
    if (v is! CreateConversationRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<String> get participantIds => $_getList(0);

  String get topicId => $_getS(1, '');
  set topicId(String v) { $_setString(1, v); }
  bool hasTopicId() => $_has(1);
  void clearTopicId() => clearField(2);

  $7.MessageDto get firstMessage => $_getN(2);
  set firstMessage($7.MessageDto v) { setField(3, v); }
  bool hasFirstMessage() => $_has(2);
  void clearFirstMessage() => clearField(3);
}

class CreateConversationResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CreateConversationResponse', package: const $pb.PackageName('api'))
    ..a<$13.ConversationDto>(1, 'conversation', $pb.PbFieldType.OM, $13.ConversationDto.getDefault, $13.ConversationDto.create)
    ..hasRequiredFields = false
  ;

  CreateConversationResponse() : super();
  CreateConversationResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateConversationResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateConversationResponse clone() => new CreateConversationResponse()..mergeFromMessage(this);
  CreateConversationResponse copyWith(void Function(CreateConversationResponse) updates) => super.copyWith((message) => updates(message as CreateConversationResponse));
  $pb.BuilderInfo get info_ => _i;
  static CreateConversationResponse create() => new CreateConversationResponse();
  CreateConversationResponse createEmptyInstance() => create();
  static $pb.PbList<CreateConversationResponse> createRepeated() => new $pb.PbList<CreateConversationResponse>();
  static CreateConversationResponse getDefault() => _defaultInstance ??= create()..freeze();
  static CreateConversationResponse _defaultInstance;
  static void $checkItem(CreateConversationResponse v) {
    if (v is! CreateConversationResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $13.ConversationDto get conversation => $_getN(0);
  set conversation($13.ConversationDto v) { setField(1, v); }
  bool hasConversation() => $_has(0);
  void clearConversation() => clearField(1);
}

class CloseConversationRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CloseConversationRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'conversationId')
    ..hasRequiredFields = false
  ;

  CloseConversationRequest() : super();
  CloseConversationRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CloseConversationRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CloseConversationRequest clone() => new CloseConversationRequest()..mergeFromMessage(this);
  CloseConversationRequest copyWith(void Function(CloseConversationRequest) updates) => super.copyWith((message) => updates(message as CloseConversationRequest));
  $pb.BuilderInfo get info_ => _i;
  static CloseConversationRequest create() => new CloseConversationRequest();
  CloseConversationRequest createEmptyInstance() => create();
  static $pb.PbList<CloseConversationRequest> createRepeated() => new $pb.PbList<CloseConversationRequest>();
  static CloseConversationRequest getDefault() => _defaultInstance ??= create()..freeze();
  static CloseConversationRequest _defaultInstance;
  static void $checkItem(CloseConversationRequest v) {
    if (v is! CloseConversationRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get conversationId => $_getS(0, '');
  set conversationId(String v) { $_setString(0, v); }
  bool hasConversationId() => $_has(0);
  void clearConversationId() => clearField(1);
}

class CloseConversationResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CloseConversationResponse', package: const $pb.PackageName('api'))
    ..a<$13.ConversationDto>(1, 'conversation', $pb.PbFieldType.OM, $13.ConversationDto.getDefault, $13.ConversationDto.create)
    ..hasRequiredFields = false
  ;

  CloseConversationResponse() : super();
  CloseConversationResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CloseConversationResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CloseConversationResponse clone() => new CloseConversationResponse()..mergeFromMessage(this);
  CloseConversationResponse copyWith(void Function(CloseConversationResponse) updates) => super.copyWith((message) => updates(message as CloseConversationResponse));
  $pb.BuilderInfo get info_ => _i;
  static CloseConversationResponse create() => new CloseConversationResponse();
  CloseConversationResponse createEmptyInstance() => create();
  static $pb.PbList<CloseConversationResponse> createRepeated() => new $pb.PbList<CloseConversationResponse>();
  static CloseConversationResponse getDefault() => _defaultInstance ??= create()..freeze();
  static CloseConversationResponse _defaultInstance;
  static void $checkItem(CloseConversationResponse v) {
    if (v is! CloseConversationResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $13.ConversationDto get conversation => $_getN(0);
  set conversation($13.ConversationDto v) { setField(1, v); }
  bool hasConversation() => $_has(0);
  void clearConversation() => clearField(1);
}

class CreateMessageRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CreateMessageRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'conversationId')
    ..a<$7.MessageDto>(2, 'message', $pb.PbFieldType.OM, $7.MessageDto.getDefault, $7.MessageDto.create)
    ..hasRequiredFields = false
  ;

  CreateMessageRequest() : super();
  CreateMessageRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateMessageRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateMessageRequest clone() => new CreateMessageRequest()..mergeFromMessage(this);
  CreateMessageRequest copyWith(void Function(CreateMessageRequest) updates) => super.copyWith((message) => updates(message as CreateMessageRequest));
  $pb.BuilderInfo get info_ => _i;
  static CreateMessageRequest create() => new CreateMessageRequest();
  CreateMessageRequest createEmptyInstance() => create();
  static $pb.PbList<CreateMessageRequest> createRepeated() => new $pb.PbList<CreateMessageRequest>();
  static CreateMessageRequest getDefault() => _defaultInstance ??= create()..freeze();
  static CreateMessageRequest _defaultInstance;
  static void $checkItem(CreateMessageRequest v) {
    if (v is! CreateMessageRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get conversationId => $_getS(0, '');
  set conversationId(String v) { $_setString(0, v); }
  bool hasConversationId() => $_has(0);
  void clearConversationId() => clearField(1);

  $7.MessageDto get message => $_getN(1);
  set message($7.MessageDto v) { setField(2, v); }
  bool hasMessage() => $_has(1);
  void clearMessage() => clearField(2);
}

class CreateMessageResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CreateMessageResponse', package: const $pb.PackageName('api'))
    ..a<$7.MessageDto>(1, 'message', $pb.PbFieldType.OM, $7.MessageDto.getDefault, $7.MessageDto.create)
    ..hasRequiredFields = false
  ;

  CreateMessageResponse() : super();
  CreateMessageResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CreateMessageResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CreateMessageResponse clone() => new CreateMessageResponse()..mergeFromMessage(this);
  CreateMessageResponse copyWith(void Function(CreateMessageResponse) updates) => super.copyWith((message) => updates(message as CreateMessageResponse));
  $pb.BuilderInfo get info_ => _i;
  static CreateMessageResponse create() => new CreateMessageResponse();
  CreateMessageResponse createEmptyInstance() => create();
  static $pb.PbList<CreateMessageResponse> createRepeated() => new $pb.PbList<CreateMessageResponse>();
  static CreateMessageResponse getDefault() => _defaultInstance ??= create()..freeze();
  static CreateMessageResponse _defaultInstance;
  static void $checkItem(CreateMessageResponse v) {
    if (v is! CreateMessageResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $7.MessageDto get message => $_getN(0);
  set message($7.MessageDto v) { setField(1, v); }
  bool hasMessage() => $_has(0);
  void clearMessage() => clearField(1);
}

