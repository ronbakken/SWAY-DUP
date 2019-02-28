import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/managers/list_manager_.dart';
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

class ListManagerImplementation implements ListManager {
  final InfItemCache allOffersCache = InfItemCache();
  final InfItemCache userCreatedOffers = InfItemCache();

  @override
  Observable<List<InfItem>> get filteredListItems => allOffersCache.itemUpdates;
  @override
  Observable<List<InfItem>> get userCreatedItems => userCreatedOffers.itemUpdates;

  BehaviorSubject<Filter> filterSubject = BehaviorSubject<Filter>();

  StreamSubscription listAllOffersSubscription;
  StreamSubscription listCreatedOffersSubscription;

  ListManagerImplementation() {
    final userCreateOfferFilter = Filter(offeringBusinessId: backend.get<UserManager>().currentUser.id);

    backend.get<InfApiClientsService>().connectionChanged.listen((connected) {
      if (connected) {
        listAllOffersSubscription = backend.get<InfListService>().listItems(filterSubject).listen((items) {
          allOffersCache.addInfItems(items);
        });

        listCreatedOffersSubscription =
            backend.get<InfListService>().listItems(Observable.just(userCreateOfferFilter)).listen((items) {
          userCreatedOffers.addInfItems(items);
        });
      } else {
        listAllOffersSubscription?.cancel();
        listCreatedOffersSubscription?.cancel();
      }
    });

    // for filter debug
    filterSubject.listen((f) {
      print(f);
    });
  }

  @override
  void setFilter(Filter filter) {
    allOffersCache.clear();
    filterSubject.add(filter);
  }
}

class InfItemCache {
  final itemMap = <String, InfItem>{};

  Observable<List<InfItem>> get itemUpdates => _itemUpdateSubject;
  BehaviorSubject<List<InfItem>> _itemUpdateSubject = BehaviorSubject<List<InfItem>>();

  void clear() {
    itemMap.clear();
  }

  void addInfItems(List<InfItem> items) {
    for (var item in items) {
      var cacheItem = itemMap[item.id];
      // if the item in the cache is newer than the one we received do nothing
      if (cacheItem != null && cacheItem.revision > item.revision) {
        continue;
      }
      itemMap[item.id] = item;
    }
    updateOutput();
  }

  void updateOutput() {
    _itemUpdateSubject.add(itemMap.values.toList(growable: false));
  }
}
