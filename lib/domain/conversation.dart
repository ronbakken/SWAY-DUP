import 'package:inf/domain/timestamp.dart';
import 'package:inf_api_client/inf_api_client.dart';

class Conversation {
  const Conversation.fromDto(this.dto);

  final ConversationDto dto;

  String get id => dto.id;

  String get topicId => dto.topicId;

  ConversationDto_Status get status => dto.status;
}

class Message {
  const Message._(this.dto, this.conversationId, this.attachments);

  factory Message.fromDto(MessageDto dto, [String conversationId]) {
    return Message._(
      dto,
      conversationId,
      List.unmodifiable(dto.attachments.map(
        (dto) => MessageAttachment.fromDto(dto),
      )),
    );
  }

  final MessageDto dto;

  final String conversationId;

  final List<MessageAttachment> attachments;

  String get id => dto.id;

  String get action => dto.action;

  DateTime get timestamp => dateTimeFromTimestamp(dto.timestamp);

  String get text => dto.text;
}

class MessageAttachment {
  const MessageAttachment.fromDto(this.dto);

  final MessageAttachmentDto dto;

  String get contentType => dto.contentType;

  List<int> get data => dto.data;

  Map<String, String> get metadata => dto.metadata;
}
