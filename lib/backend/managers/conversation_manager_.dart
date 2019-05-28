import 'dart:async';

import 'package:inf/domain/domain.dart';

abstract class ConversationManager {
  Stream<List<ConversationHolder>> get applied;

  Stream<List<ConversationHolder>> get deals;

  Stream<List<ConversationHolder>> get done;

  Stream<List<ConversationHolder>> listenForMyConversations();

  Future<ConversationHolder> createConversationForOffer(BusinessOffer offer, Message firstMessage);

  Future<Conversation> closeConversation(Conversation conversation);

  Future<Message> sendMessage(String conversationId, Message message);

  Stream<Conversation> listenToConversation(String conversationId);

  Stream<List<Message>> listenForMessages(String conversationId);

  Optional<ConversationHolder> getConversationHolderFromCache(String topicId);

  Future<Optional<ConversationHolder>> findConversationHolderWithTopicId(String topicId);

  void clearConversationHolderCache();
}
