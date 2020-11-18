import 'dart:async';

import 'package:inf/domain/domain.dart';

export 'package:inf/domain/filters.dart';

abstract class InfListService {
  Stream<List<BusinessOffer>> listMyOffers();

  Stream<List<InfItem>> listItems(Stream<Filter> filterStream);

  Stream<InfItem> listenForChanges(SingleItemFilter filter);

  Stream<List<InfItem>> listenForItems(Filter itemFilter);
}
