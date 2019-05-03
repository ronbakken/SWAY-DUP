import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/managers/conversation_manager_.dart';
import 'package:inf/domain/conversation.dart';
import 'package:rxdart/subjects.dart' show BehaviorSubject;

class ConversationManagerImplementation extends ConversationManager {
  final _appliedSubject = BehaviorSubject<List<Conversation>>();
  final _dealsSubject = BehaviorSubject<List<Conversation>>();
  final _doneSubject = BehaviorSubject<List<Conversation>>();

  ConversationManagerImplementation() {
    //
  }

  @override
  Stream<List<Conversation>> get applied => _appliedSubject.stream;

  @override
  Stream<List<Conversation>> get deals => _dealsSubject.stream;

  @override
  Stream<List<Conversation>> get done => _doneSubject.stream;

  @override
  Stream<List<ConversationHolder>> listenForMyConversations() {
    final conversationFilter = ItemFilterDto_ConversationFilterDto()
      ..participatingUserId = backend<UserManager>().currentUser.id;
    final itemFilter = ItemFilterDto()..conversationFilter = conversationFilter;
    final offerManager = backend<OfferManager>();
    final listService = backend<InfListService>();
    return listService.listenForItems(itemFilter).map((items) {
      return items
          .where((item) => item.type == InfItemType.conversation)
          .map((item) => item.conversation)
          .toList(growable: false);
    }).asyncMap((conversations) async {
      conversations.sort();
      final holders = await Future.wait(conversations.map((conversation) async {
        final offerId = conversation.offerId;
        if (offerId == null) {
          print('Server provided conversation without offerId');
          return null;
        }
        return ConversationHolder(conversation, await offerManager.getFullOffer(conversation.offerId));
      }));
      return holders.where((holder) => holder != null).toList();
    });
  }

  @override
  Future<Conversation> createConversationForOffer(BusinessOffer offer, String firstMessageText) async {
    // 1. check if we already have a conversation.. widget.offer.topicId.
    // 2. open existing, or create a new conversation?
    final messagingService = backend<InfMessagingService>();
    final currentUser = backend<UserManager>().currentUser;
    final firstMessage = Message.forText(currentUser, firstMessageText);
    final conversation = await messagingService.createConversation(
      [currentUser.id, offer.businessAccountId],
      offer.topicId,
      firstMessage,
      {
        'offerId': offer.id,
      },
    );
    print('sent message: ${conversation.latestMessage}');
    return conversation;
  }

  @override
  Future<Message> sendMessage(String conversationId, Message message) async {
    final messagingService = backend<InfMessagingService>();
    final sentMessage = await messagingService.sendMessage(conversationId, message);
    print('sending $message, sent message: $sentMessage');
    return sentMessage;
  }

  @override
  Stream<List<Message>> listenForMessages(String conversationId) {
    final messageFilter = ItemFilterDto_MessageFilterDto()..conversationId = conversationId;
    final itemFilter = ItemFilterDto()..messageFilter = messageFilter;
    final listService = backend<InfListService>();
    return listService.listenForItems(itemFilter).map((items) {
      return items
          .where((item) => item.type == InfItemType.message)
          .map((item) => item.message)
          .toList(growable: false);
    });
  }
}
