import 'dart:async';
import 'package:inf/backend/services/inf_api_clients_service_.dart';
import 'package:inf/domain/domain.dart';

export 'package:inf/backend/services/inf_api_clients_service_.dart';

abstract class InfListService {
  Stream<List<BusinessOffer>> listMyOffers();
  Stream<List<InfItem>> listItems(Stream<Filter> filterStream);
  Stream<List<InfItem>> listenForOfferChanges(Stream<Filter> filterStream);
  Stream<List<InfItem>> listenForItems(ItemFilterDto itemFilter);
}