import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/inf_list_service_.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';

class InfListServiceImplementation implements InfListService {
  @override
  Stream<List<InfItem>> listItems(Stream<Filter> filterStream) {
    try {
    return backend
        .get<InfApiClientsService>()
        .listClient
        .list(
          filterStream.map<ListRequest>(mapFilterToListRequest),
          options: backend<AuthenticationService>().callOptions,
        )
        .map<List<InfItem>>((items) => items.items
            .map(
              (item) => InfItem.fromDto(item),
            )
            .toList());
      
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Stream<List<InfItem>> listenItemChanges(Stream<Filter> filterStream)
  {
    return backend
        .get<InfApiClientsService>()
        .listenClient
        .listen(
          filterStream.map<ListenRequest>(mapFilterToListenRequest),
          options: backend<AuthenticationService>().callOptions,
        )
        .map<List<InfItem>>((items) => items.items
            .map(
              (item) => InfItem.fromDto(item),
            )
            .toList());

  }

  ListRequest mapFilterToListRequest(Filter filter) {
      return ListRequest()
      ..state = ListRequest_State.resumed
      ..filter = mapFilter(filter);
  }

  ListenRequest mapFilterToListenRequest(Filter filter) {
      return ListenRequest()
      ..action =ListenRequest_Action.register
      ..filter = mapFilter(filter);
  }

  ItemFilterDto mapFilter(Filter filter) {
    var filterDto = ItemFilterDto();
    ItemFilterDto_OfferFilterDto offerFilter;
    ItemFilterDto_UserFilterDto userFilter;

    var itemTypes = <ItemFilterDto_ItemType>[];
    var userType = backend<UserManager>().currentUser.userType;

    if (filter.freeText != null && filter.freeText.isNotEmpty && userType == UserType.influencer) {
      // if influencers search with free text they get businesses and offers back
      itemTypes.add(ItemFilterDto_ItemType.offers);
      userFilter = ItemFilterDto_UserFilterDto()..userTypes.add(UserType.business);

      // TODO continue
    }
    if (userType == UserType.influencer) {
      itemTypes.add(ItemFilterDto_ItemType.offers);
      offerFilter = ItemFilterDto_OfferFilterDto();
    } else if (userType == UserType.business) {
      userFilter = ItemFilterDto_UserFilterDto()..userTypes.add(UserType.influencer);
      if (filter.offeringBusinessId != null && filter.offeringBusinessId.isNotEmpty)
      {
        itemTypes=[ItemFilterDto_ItemType.offers];
        offerFilter = ItemFilterDto_OfferFilterDto();
        //offerFilter.businessAccountId = filter.offeringBusinessId;
      }
      else
      {
        itemTypes.add(ItemFilterDto_ItemType.users);
      }
    } else {
      throw Exception('Unsupported user type');
    }

    filterDto.itemTypes.addAll(itemTypes);
    if (offerFilter != null) {
      filterDto.offerFilter = offerFilter;
    }
    if (userFilter != null) {
      filterDto.userFilter = userFilter;
    }
    return filterDto;
  }
}
