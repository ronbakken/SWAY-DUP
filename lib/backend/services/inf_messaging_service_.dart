import 'dart:async';

import 'package:inf/domain/conversation.dart';

abstract class InfMessagingService {
  Stream<List<Conversation>> listenForMyConversations();

  Stream<List<Message>> listenForMessages(String conversationId);
}
