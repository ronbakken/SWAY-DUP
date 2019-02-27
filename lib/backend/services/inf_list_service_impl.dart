import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/inf_list_service_.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';

class InfListServiceImplementation implements InfListService {
  @override
  Stream<List<InfItem>> listItems(Stream<Filter> filterStream) {
    return backend
        .get<InfApiClientsService>()
        .listClient
        .list(
            filterStream.map<ListRequest>(
              (f) => ListRequest()
                ..state =ListRequest_State.resumed
                ..filter = (ItemFilterDto()
                  ..itemTypes.addAll([ItemFilterDto_ItemType.offers])
                  ..offerFilter = (ItemFilterDto_OfferFilterDto())),
            ),
            options: backend.get<AuthenticationService>().callOptions)
        .map<List<InfItem>>((items) => items.items
            .map(
              (item) {
                return InfItem.fromDto(item);
              },
            )
            .toList());
  }
}
