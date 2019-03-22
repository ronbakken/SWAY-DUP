import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';


class InfMessagingServiceImplementation extends InfMessagingService {
  @override
  Stream<List<Message>> listenForMessages(String conversationId) {
    final itemFilter = ItemFilterDto()
        ..messageFilter = (ItemFilterDto_MessageFilterDto()
          ..conversationId = conversationId);
    final requests = StreamController<ListenRequest>();
    final controller = StreamController<List<Message>>.broadcast(
      onListen: (){
        requests.add(ListenRequest()
          ..action = ListenRequest_Action.register
          ..filter = itemFilter);
      },
      onCancel: (){
        requests.add(ListenRequest()
          ..action = ListenRequest_Action.deregister
          ..filter = itemFilter);
      },
    );
    controller.addStream(
      backend.get<InfApiClientsService>().listenClient
        .listen(requests.stream)
        .map((response) {
          return response.items
            .where((item) => item.hasMessage())
            .map((item) => Message.fromDto(item.message, conversationId));
        }),
    );
    return controller.stream;
  }

  @override
  Stream<List<Conversation>> listenForMyConversations() {
    final currentUser = backend<UserManager>().currentUser;
    final itemFilter = ItemFilterDto()
        ..conversationFilter = (ItemFilterDto_ConversationFilterDto()
          ..participatingUserId = currentUser.id);
    final requests = StreamController<ListenRequest>();
    final controller = StreamController<List<Conversation>>.broadcast(
      onListen: (){
        requests.add(ListenRequest()
          ..action = ListenRequest_Action.register
          ..filter = itemFilter);
      },
      onCancel: (){
        requests.add(ListenRequest()
          ..action = ListenRequest_Action.deregister
          ..filter = itemFilter);
      },
    );
    controller.addStream(
      backend.get<InfApiClientsService>().listenClient
        .listen(requests.stream)
        .map((response) {
          return response.items
            .where((item) => item.hasConversation())
            .map((item) => Conversation.fromDto(item.conversation));
        }),
    );
    return controller.stream;
  }
}
