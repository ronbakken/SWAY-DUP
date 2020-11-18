import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/lru_cache.dart';
import 'package:inf/backend/managers/conversation_manager_.dart';
import 'package:inf/domain/conversation.dart';
import 'package:rxdart/subjects.dart' show BehaviorSubject;

class ConversationManagerImplementation extends ConversationManager {
  final _conversationHolderCache = LruCache<ConversationHolder>(10);

  final _appliedSubject = BehaviorSubject<List<ConversationHolder>>();
  final _dealsSubject = BehaviorSubject<List<ConversationHolder>>();
  final _doneSubject = BehaviorSubject<List<ConversationHolder>>();

  ConversationManagerImplementation() {
    //
  }

  @override
  Stream<List<ConversationHolder>> get applied => _appliedSubject.stream;

  @override
  Stream<List<ConversationHolder>> get deals => _dealsSubject.stream;

  @override
  Stream<List<ConversationHolder>> get done => _doneSubject.stream;

  @override
  Stream<List<ConversationHolder>> listenForMyConversations() {
    final offerManager = backend<OfferManager>();
    final listService = backend<InfListService>();
    return listService.listenForItems(ConversationFilter(participant: backend<UserManager>().currentUser)).map((items) {
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
  Future<ConversationHolder> createConversationForOffer(BusinessOffer offer, Message firstMessage) async {
    final messagingService = backend<InfMessagingService>();
    final currentUser = backend<UserManager>().currentUser;
    final conversation = await messagingService.createConversation(
      [currentUser.id, offer.businessAccountId],
      offer.topicId,
      firstMessage,
      {
        'offerId': offer.id,
      },
    );
    print('sent message: ${conversation.latestMessage}');
    final conversationHolder = ConversationHolder(conversation, offer);
    _conversationHolderCache[offer.topicId] = Optional.of(conversationHolder);
    return conversationHolder;
  }

  @override
  Future<Conversation> closeConversation(Conversation conversation) async {
    final result = await backend<InfMessagingService>().closeConversation(conversation);
    _conversationHolderCache.invalid(result.topicId);
    return result;
  }

  @override
  Future<Message> sendMessage(String conversationId, Message message) async {
    final messagingService = backend<InfMessagingService>();
    final sentMessage = await messagingService.sendMessage(conversationId, message);
    print('sending $message, sent message: $sentMessage');
    return sentMessage;
  }

  @override
  Stream<Conversation> listenToConversation(BusinessOffer offer, String conversationId) {
    return backend<InfListService>()
        .listenForChanges(SingleItemFilter(conversationId, SingleItemType.conversation))
        .where((item) => item.type == InfItemType.conversation)
        .map((item) {
      final conversation = item.conversation;
      final cached = _conversationHolderCache[conversation.topicId];
      if (cached != null && cached.isPresent) {
        cached.value.conversation = conversation;
      } else {
        _conversationHolderCache[conversation.topicId] = Optional.of(ConversationHolder(conversation, offer));
      }
      return conversation;
    });
  }

  @override
  Stream<List<Message>> listenForMessages(String conversationId) {
    final listService = backend<InfListService>();
    return listService.listenForItems(MessageFilter(conversationId: conversationId)).map((items) {
      return items
          .where((item) => item.type == InfItemType.message)
          .map((item) => item.message)
          .toList(growable: false);
    });
  }

  @override
  Optional<ConversationHolder> getConversationHolderFromCache(String topicId) {
    return _conversationHolderCache[topicId];
  }

  @override
  Future<Optional<ConversationHolder>> findConversationHolderWithTopicId(String topicId) async {
    Optional<ConversationHolder> conversationHolder = _conversationHolderCache[topicId];
    if (conversationHolder == null) {
      final currentUser = backend<UserManager>().currentUser;
      final conversationFilter = ConversationFilter(
        participant: currentUser,
        topicId: topicId,
        status: ConversationDto_Status.open,
      );
      final listService = backend<InfListService>();
      final items = await listService.listItems(Stream.fromIterable([conversationFilter])).first;
      if (items.isNotEmpty && items[0].type == InfItemType.conversation) {
        final offer = await backend<OfferManager>().getFullOffer(items[0].conversation.offerId);
        conversationHolder = Optional.of(ConversationHolder(items[0].conversation, offer));
      } else {
        conversationHolder = const Optional.absent();
      }
      _conversationHolderCache[topicId] = conversationHolder;
    }
    return conversationHolder;
  }

  @override
  void clearConversationHolderCache() {
    _conversationHolderCache.clear();
  }
}
