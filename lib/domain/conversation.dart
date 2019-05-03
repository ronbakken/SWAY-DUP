import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';
import 'dart:typed_data';

import 'package:inf/backend/backend.dart';
import 'package:inf/domain/business_offer.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:meta/meta.dart';
import 'package:mime/mime.dart' as mime;

class ConversationHolder {
  ConversationHolder(this.conversation, this.offer);

  final Conversation conversation;
  final BusinessOffer offer;

  Stream<List<Message>> get messages {
    return backend<ConversationManager>().listenForMessages(conversation.id);
  }

  Message get latestMessage => conversation.latestMessage;

  MessageAction get latestAction => MessageAction.accept;
}

class Conversation implements Comparable<Conversation> {
  const Conversation._({
    @required this.dto,
    @required this.id,
    @required this.topicId,
    @required this.status,
    @required this.latestMessage,
    @required this.latestMessageWithAction,
    @required this.metadata,
  });

  factory Conversation.fromDto(ConversationDto dto) {
    return Conversation._(
      dto: dto,
      id: dto.id,
      topicId: dto.topicId,
      status: dto.status,
      latestMessage: dto.hasLatestMessage() ? Message.fromDto(dto.latestMessage) : null,
      latestMessageWithAction: dto.hasLatestMessageWithAction() ? Message.fromDto(dto.latestMessageWithAction) : null,
      metadata: Map.unmodifiable(dto.metadata),
    );
  }

  final ConversationDto dto;

  final String id;

  final String topicId;

  final ConversationDto_Status status;

  final Message latestMessage;

  final Message latestMessageWithAction;

  final Map<String, String> metadata;

  String get offerId => topicId.startsWith('offer-') ? topicId.substring('offer-'.length) : null;

  @override
  String toString() => 'Conversation{'
      'dto: ${dto != null}, '
      'id: $id, '
      'topicId: $topicId, '
      'status: $status, '
      'latestMessage: $latestMessage, '
      'latestMessageWithAction: $latestMessageWithAction, '
      'metadata: $metadata, '
      '}';

  @override
  int compareTo(Conversation other) {
    if (latestMessage == null || other.latestMessage == null) {
      return -1;
    }
    return other.latestMessage.timestamp.compareTo(latestMessage.timestamp);
  }
}

abstract class MessageTextProvider {
  String get id;

  User get user;

  DateTime get timestamp;

  String get text;
}

class MessageGroup implements MessageTextProvider, Comparable<MessageTextProvider> {
  MessageGroup(this._messages);

  List<Message> _messages;

  void append(Message message) {
    _messages.add(message);
  }

  @override
  String get id => _messages.map((message) => message.id).join(':');

  @override
  User get user => _messages[0].user;

  @override
  DateTime get timestamp => _messages.reduce((el1, el2) => el1.compareTo(el2) > 0 ? el1 : el2).timestamp;

  @override
  String get text => _messages.map((message) => message.text).join('\n');

  @override
  int compareTo(MessageTextProvider other) => timestamp.compareTo(other.timestamp);

  static List<MessageTextProvider> collapseMessages(List<Message> messages) {
    final providers = <MessageTextProvider>[];
    Message lastMessage;
    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];
      if (lastMessage != null) {
        if (message.user == lastMessage.user) {
          // collapse
          MessageTextProvider group = providers.last;
          if (group is MessageGroup) {
            group.append(message);
          } else {
            providers.removeLast();
            providers.add(MessageGroup([lastMessage, message]));
          }
          lastMessage = message;
          continue;
        }
      }
      providers.add(message);
      lastMessage = message;
    }
    return providers;
  }
}

class Message implements MessageTextProvider, Comparable<MessageTextProvider> {
  Message._({
    this.dto,
    this.id,
    this.user,
    this.action,
    DateTime timestamp,
    this.text,
    this.attachments,
  }) : this.timestamp = timestamp ?? DateTime.now().toUtc();

  factory Message.fromDto(MessageDto dto) {
    return Message._(
      dto: dto,
      id: dto.id,
      user: User.fromDto(dto.user),
      action: MessageAction.fromString(dto.action),
      timestamp: dto.timestamp.toDateTime(),
      text: dto.text,
      attachments: List.unmodifiable(dto.attachments.map(
        (dto) => MessageAttachment.fromDto(dto),
      )),
    );
  }

  factory Message.forAction(User user, MessageAction action, [List<MessageAttachment> attachments]) {
    return Message._(
      user: user.copyWith(dataType: UserDto_Data.handle),
      action: action,
      attachments: List.unmodifiable(attachments ?? []),
    );
  }

  factory Message.forText(User user, String text, [List<MessageAttachment> attachments]) {
    return Message._(
      user: user.copyWith(dataType: UserDto_Data.handle),
      text: text,
      attachments: List.unmodifiable(attachments ?? []),
    );
  }

  final MessageDto dto;

  @override
  final String id;

  @override
  final User user;

  final MessageAction action;

  @override
  final DateTime timestamp;

  @override
  final String text;

  final List<MessageAttachment> attachments;

  @override
  int compareTo(MessageTextProvider other) => timestamp.compareTo(other.timestamp);

  MessageDto toDto() {
    return MessageDto()
      ..id = id ?? ''
      ..user = user?.toDto()
      ..text = text ?? ''
      ..action = action?.value ?? ''
      ..timestamp = Timestamp.fromDateTime(timestamp)
      ..attachments.addAll(attachments.map(
        (attachment) => attachment.toDto(),
      ));
  }

  @override
  String toString() => 'Message{'
      'dto: ${dto != null}, '
      'id: $id, '
      'user: $user, '
      'action: $action, '
      'timestamp: $timestamp, '
      'text: $text, '
      'attachments: $attachments'
      '}';
}

class MessageAction {
  static const text = MessageAction._('text');
  static const accept = MessageAction._('accept');
  static const counter = MessageAction._('counter');
  static const reject = MessageAction._('reject');
  static const completed = MessageAction._('completed');
  static const values = [text, accept, counter, reject, completed];

  factory MessageAction.fromString(String value) {
    return values.firstWhere((action) => action.value == value, orElse: () => null);
  }

  const MessageAction._(this.value);

  final String value;

  @override
  String toString() => 'MessageAction{'
      'value: $value'
      '}';
}

class MessageAttachment {
  const MessageAttachment._({
    this.dto,
    @required this.contentType,
    @required this.data,
    this.metadata,
  });

  static Future<MessageAttachment> toJson(dynamic object) async {
    return MessageAttachment._(
      contentType: ContentType.json,
      data: utf8.encode(json.encode(object)),
      metadata: {
        'type': object.runtimeType.toString(),
      },
    );
  }

  static Future<MessageAttachment> forFile(File file) async {
    String contentType = mime.lookupMimeType(file.path);
    return MessageAttachment._(
      contentType: ContentType.parse(contentType),
      data: await file.readAsBytes(),
    );
  }

  factory MessageAttachment.fromDto(MessageAttachmentDto dto) {
    return MessageAttachment._(
      dto: dto,
      contentType: ContentType.parse(dto.contentType),
      data: UnmodifiableUint8ListView(dto.data),
      metadata: Map.unmodifiable(dto.metadata),
    );
  }

  final MessageAttachmentDto dto;

  final ContentType contentType;

  final Uint8List data;

  final Map<String, String> metadata;

  MessageAttachmentDto toDto() {
    return MessageAttachmentDto()
      ..contentType = '${contentType.primaryType}/${contentType.subType}'
      ..data = data
      ..metadata.addAll(metadata);
  }

  @override
  String toString() => 'MessageAttachment{'
      'dto: ${dto != null}, '
      'contentType: $contentType, '
      'data: $data, '
      'metadata: $metadata'
      '}';
}
