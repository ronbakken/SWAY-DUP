import 'dart:async';

import 'package:inf/domain/domain.dart';

abstract class ConversationManager {
  Stream<List<Conversation>> get applied;

  Stream<List<Conversation>> get deals;

  Stream<List<Conversation>> get done;

  Stream<List<ConversationHolder>> listenForMyConversations();

  Future<Conversation> createConversationForOffer(BusinessOffer offer, String firstMessageText);

  Future<Message> sendMessage(String conversationId, Message message);

  Stream<List<Message>> listenForMessages(String conversationId);
}
