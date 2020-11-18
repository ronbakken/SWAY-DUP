import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';

class InfMessagingServiceImplementation extends InfMessagingService {
  @override
  Future<Conversation> createConversation(List<String> participantIds, String topicId, Message firstMessage, Map<String, String> metadata) async {
    assert(topicId != null && firstMessage != null && firstMessage.dto == null);
    final client = backend<InfApiClientsService>().messagingClient;
    final response = await client.createConversation(
      CreateConversationRequest()
        ..participantIds.addAll(participantIds)
        ..topicId = topicId
        ..firstMessage = firstMessage.toDto()
        ..metadata.addAll(metadata),
    );
    return Conversation.fromDto(response.conversation);
  }

  @override
  Future<Message> sendMessage(String conversationId, Message message) async {
    assert(message.dto == null);
    final client = backend<InfApiClientsService>().messagingClient;
    final response = await client.createMessage(
      CreateMessageRequest()
        ..conversationId = conversationId
        ..message = message.toDto(),
    );
    return Message.fromDto(response.message);
  }

  @override
  Future<Conversation> closeConversation(Conversation conversation) async {
    assert(conversation != null && conversation.dto != null);
    final client = backend<InfApiClientsService>().messagingClient;
    final response = await client.closeConversation(
      CloseConversationRequest()..conversationId = conversation.id,
    );
    return Conversation.fromDto(response.conversation);
  }
}
