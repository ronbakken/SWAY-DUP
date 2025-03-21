import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/business_offer.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:meta/meta.dart';
import 'package:mime/mime.dart' as mime;

class ConversationHolder extends ChangeNotifier {
  ConversationHolder(this._conversation, this.offer);

  Conversation _conversation;

  Conversation get conversation => _conversation;

  set conversation(Conversation value) {
    _conversation = conversation;
    notifyListeners();
  }

  final BusinessOffer offer;

  Stream<List<Message>> get messages {
    return backend<ConversationManager>().listenForMessages(conversation.id);
  }

  Message get latestMessage => conversation.latestMessage;

  Message get latestMessageWithAction => conversation.latestMessageWithAction;

  Proposal get proposal => Message.findProposalAttachment(conversation.latestMessageWithAction?.attachments);

  Stream<Conversation> get stream {
    StreamSubscription<Conversation> sub;
    StreamController<Conversation> latest;
    latest = StreamController.broadcast(
      onListen: () {
        latest.add(_conversation);
        sub = backend<ConversationManager>().listenToConversation(offer, _conversation.id).listen((data) {
          latest.add(data);
          conversation = data;
        });
      },
      onCancel: () {
        sub?.cancel();
      },
    );
    return latest.stream;
  }
}

@immutable
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

  MessageAction get action;

  DateTime get timestamp;

  String get text;

  List<MessageAttachment> get attachments;

  bool get hasProposal;
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

  /// MessageGroup's can only be made from text items, so no-action.
  @override
  MessageAction get action => null;

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
      if (lastMessage != null &&
          message.user == lastMessage.user &&
          // ignore: deprecated_member_use_from_same_package
          (message.action == null || message.action == MessageAction.text) &&
          // ignore: deprecated_member_use_from_same_package
          (lastMessage.action == null || lastMessage.action == MessageAction.text)) {
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
      providers.add(message);
      lastMessage = message;
    }
    return providers;
  }

  @override
  List<MessageAttachment> get attachments {
    return List.unmodifiable(
      _messages.map((m) => m.attachments).fold<List<MessageAttachment>>(
        [],
        (prev, el) {
          prev.addAll(el);
          return prev;
        },
      ),
    );
  }

  @override
  bool get hasProposal => false;
}

@immutable
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

  factory Message(User user, {String text, MessageAction action, List<MessageAttachment> attachments}) {
    assert(text != null || action != null, 'Missing text or action.');
    return Message._(
      user: user.copyWith(dataType: UserDto_Data.handle),
      action: action,
      text: text,
      attachments: List.unmodifiable(attachments ?? []),
      timestamp: DateTime.now().toUtc(),
    );
  }

  final MessageDto dto;

  @override
  final String id;

  @override
  final User user;

  @override
  final MessageAction action;

  @override
  final DateTime timestamp;

  @override
  final String text;

  @override
  final List<MessageAttachment> attachments;

  @override
  bool get hasProposal {
    if (attachments != null) {
      for (final attachment in attachments) {
        if (attachment.isProposal) {
          return true;
        }
      }
    }
    return false;
  }

  static Proposal findProposalAttachment(List<MessageAttachment> attachments) {
    if (attachments != null) {
      for (final attachment in attachments) {
        if (attachment.isProposal) {
          return Proposal.fromJson(attachment.object);
        }
      }
    }
    return null;
  }

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

@immutable
class MessageAction {
  @deprecated
  static const text = MessageAction._('text');

  static const offer = MessageAction._('offer');
  static const accept = MessageAction._('accept');
  static const counter = MessageAction._('counter');
  static const reject = MessageAction._('reject');
  static const completed = MessageAction._('completed');

  // ignore: deprecated_member_use_from_same_package
  static const values = [text, offer, accept, counter, reject, completed];

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

@immutable
class MessageAttachment {
  const MessageAttachment._({
    this.dto,
    @required this.contentType,
    @required this.data,
    this.metadata,
  });

  static MessageAttachment forObject(Object object) {
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
      metadata: const {
        'type': 'File',
      },
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

  String get type => metadata['type'];

  bool get isProposal => type == stringType<Proposal>();

  Map<String, dynamic> get object => json.decode(utf8.decode((data)));

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
      'data: ${data != null}, '
      'metadata: $metadata'
      '}';
}

class AttachmentLink {
  const AttachmentLink({this.value});

  factory AttachmentLink.fromJson(Map<String, dynamic> data) {
    return AttachmentLink(
      value: data['value'],
    );
  }

  final String value;

  @override
  String toString() {
    return 'AttachmentLink{'
        'value: $value, '
        '}';
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
    };
  }
}
