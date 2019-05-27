import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/inf_list_service_.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';

class InfListServiceImplementation implements InfListService {
  @override
  Stream<List<BusinessOffer>> listMyOffers() {
    final currentUser = backend.get<UserManager>().currentUser;
    return listenForItems(OfferFilter(offeringBusinessId: currentUser.id)).map(
      (items) {
        assert(!items.any((item) => item.type != InfItemType.offer));
        return items.map((item) => item.offer).toList();
      },
    );
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
  Stream<InfItem> listenForChanges(SingleItemFilter filter) {
    final filterDto = filter.toDto();
    final listenClient = backend.get<InfApiClientsService>().listenClient;
    final listenRequests = StreamController<ListenRequest>();

    StreamSubscription<List<InfItem>> sub;
    StreamController<InfItem> results;

    results = StreamController<InfItem>.broadcast(
      onListen: () {
        sub = listenClient
            .listen(listenRequests.stream)
            .map((response) => response.items)
            .map(mapItemList)
            .listen((items) => results.add(items.last));
        listenRequests.add(ListenRequest()
          ..action = ListenRequest_Action.register
          ..singleItemFilter = filterDto);
      },
      onCancel: () {
        listenRequests.add(ListenRequest()
          ..action = ListenRequest_Action.deregister
          ..singleItemFilter = filterDto);
        sub?.cancel();
        sub = null;
      },
    );

    return results.stream;
  }

  List<InfItem> mapItemList(List<ItemDto> items) {
    return items.map<InfItem>((item) => InfItem.fromDto(item)).toList();
  }

  @override
  Stream<List<InfItem>> listenForItems(Filter filter) {
    final filterDto = filter.toDto();
    final clients = backend.get<InfApiClientsService>();

    final data = <InfItem>{};
    final listenRequests = StreamController<ListenRequest>();

    StreamSubscription<List<InfItem>> _subList;
    StreamSubscription<List<InfItem>> _subListen;

    StreamController<List<InfItem>> resultController;
    resultController = StreamController<List<InfItem>>.broadcast(
      onListen: () {
        data.clear();
        final listRequests = Stream.fromIterable([
          ListRequest()
            ..filter = filterDto
            ..state = ListRequest_State.resumed
        ]);
        _subList = clients.listClient
            .list(listRequests)
            .map(
              (response) => response.items,
            )
            .map(mapItemList)
            .listen((listItems) {
          for (final item in listItems) {
            if (data.contains(item)) {
              data.remove(item);
            }
            data.add(item);
          }
          resultController.add(data.toList());
        }, onDone: () {
          _subList = null;
          _subListen = clients.listenClient
              .listen(listenRequests.stream)
              .map((response) => response.items)
              .map(mapItemList)
              .listen((listenItems) {
            for (final item in listenItems) {
              if (data.contains(item)) {
                data.remove(item);
              }
              data.add(item);
            }
            resultController.add(data.toList());
          });
          listenRequests.add(ListenRequest()
            ..action = ListenRequest_Action.register
            ..filter = filterDto);
        });
      },
      onCancel: () {
        if (_subListen != null) {
          listenRequests.add(ListenRequest()
            ..action = ListenRequest_Action.deregister
            ..filter = filterDto);
          _subListen.cancel();
          _subListen = null;
        }
        _subList?.cancel();
      },
    );

    return resultController.stream; // pause/resume stream? broadcast?
  }
}
