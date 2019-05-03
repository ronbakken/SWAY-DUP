import 'dart:async';

import 'package:inf/domain/conversation.dart';
import 'package:inf/domain/domain.dart';

abstract class InfMessagingService {
  Future<Conversation> createConversation(List<String> participantIds, String topicId, Message firstMessage, Map<String, String> metadata);

  Future<Message> sendMessage(String conversationId, Message message);

  Future<Conversation> closeConversation(Conversation conversation);
}
