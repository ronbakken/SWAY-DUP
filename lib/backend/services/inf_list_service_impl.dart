import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/inf_list_service_.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';

class InfListServiceImplementation implements InfListService {
  /*
   * 1. connect to list api
   * 2. retrieve all results
   * 3. connect to listen api
   * 4. continue to listen for changes
   * 5. allow stream to be paused
   * 6. allow stream to be resumed
   */

  @override
  Stream<List<InfItem>> listMyOffers() {
    final user = backend.get<UserManager>().currentUser;
    final offerFilter = ItemFilterDto_OfferFilterDto()..businessAccountId = user.id;
    final request = ListRequest()
      ..filter = (ItemFilterDto()..offerFilter = offerFilter)
      ..state = ListRequest_State.resumed;
    final listClient = backend.get<InfApiClientsService>().listClient;
    StreamController<ListRequest> controller;
    controller = StreamController<ListRequest>(onListen: () => controller.add(request));
    return listClient.list(controller.stream).map((response) => mapItemList(response.items));
  }

  @override
  Stream<List<InfItem>> listItems(Stream<Filter> filterStream) {
    final listClient = backend.get<InfApiClientsService>().listClient;
    return listClient
        .list(filterStream.map<ListRequest>(mapFilterToListRequest))
        .map((response) => mapItemList(response.items));
  }

  ListRequest mapFilterToListRequest(Filter filter) {
    return ListRequest()
      ..state = ListRequest_State.resumed
      ..filter = filter.toDto();
  }

  @override
  Stream<List<InfItem>> listenForOfferChanges(Stream<Filter> filterStream) {
    final listenClient = backend.get<InfApiClientsService>().listenClient;
    return listenClient
        .listen(filterStream.map<ListenRequest>(mapFilterToListenRequest))
        .map((response) => mapItemList(response.items));
  }

  ListenRequest mapFilterToListenRequest(Filter filter) {
    return ListenRequest()
      ..action = ListenRequest_Action.register
      ..filter = filter.toDto();
  }

  List<InfItem> mapItemList(List<ItemDto> items) {
    return items.map((item) => InfItem.fromDto(item)).toList();
  }
}
