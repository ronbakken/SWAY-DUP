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
              ..filter = (ItemFilterDto()
                ..northWest = (GeoPointDto()
                  ..latitude = 0.0
                  ..longitude = 0.0)
                ..southEast = (GeoPointDto()
                  ..latitude = 1.0
                  ..longitude = 2.0)),
          ),
        )
        .map<List<InfItem>>((items) => items.items
            .map(
              (item) => InfItem.fromDto(item),
            )
            .toList());
  }
}
