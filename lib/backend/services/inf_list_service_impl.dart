import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/inf_list_service_.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';

class InfListServiceImplementation implements InfListService {
  @override
  Stream<List<InfItem>> listItems(Stream<Filter> filterStream) {
    final listClient = backend.get<InfApiClientsService>().listClient;
    return listClient
        .list(filterStream.map<ListRequest>(mapFilterToListRequest))
        .map((response) => mapItemList(response.items));
    //.transform(streamTransformer);
  }

  @override
  Stream<List<InfItem>> listenForOfferChanges(Stream<Filter> filterStream) {
    final listenClient = backend.get<InfApiClientsService>().listenClient;
    return listenClient
        .listen(filterStream.map<ListenRequest>(mapFilterToListenRequest))
        .map((response) => mapItemList(response.items));
  }

  List<InfItem> mapItemList(List<ItemDto> items) {
    return items.map((item) => InfItem.fromDto(item)).toList();
  }

  ItemFilterDto mapFilter(Filter filter) {
    final filterDto = ItemFilterDto();

    final userType = backend<UserManager>().currentUser.userType;
    if (userType == UserType.influencer) {
      // if Influencers search with free text they get businesses and offers back
      if (filter.freeText != null && filter.freeText.isNotEmpty) {
        filterDto.userFilter = ItemFilterDto_UserFilterDto()..userTypes.add(UserType.business);
      }
    } else if (userType == UserType.business) {
      filterDto.userFilter = ItemFilterDto_UserFilterDto()..userTypes.add(UserType.influencer);
      /*
      if (filter.offeringBusinessId != null && filter.offeringBusinessId.isNotEmpty) {
        filterDto.offerFilter = ItemFilterDto_OfferFilterDto();
        filterDto.offerFilter.businessAccountId = filter.offeringBusinessId;
      }
      */
    } else {
      throw Exception('Unsupported user type');
    }

    return filterDto;
  }

  ListRequest mapFilterToListRequest(Filter filter) {
    return ListRequest()
      ..state = ListRequest_State.resumed
      ..filter = mapFilter(filter);
  }

  ListenRequest mapFilterToListenRequest(Filter filter) {
    return ListenRequest()
      ..action = ListenRequest_Action.register
      ..filter = mapFilter(filter);
  }
}
