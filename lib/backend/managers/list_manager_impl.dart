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
  BehaviorSubject<Filter> filterCreatedOffersSubject = BehaviorSubject<Filter>();

  StreamSubscription listAllOffersSubscription;
  StreamSubscription listenAllOffersSubscription;
  StreamSubscription listCreatedOffersSubscription;
  StreamSubscription listenCreatedOffersSubscription;

  final userCreateOfferFilter = Filter(offeringBusinessId: backend.get<UserManager>().currentUser.id);

  ListManagerImplementation() {
    backend.get<InfApiClientsService>().connectionChanged.listen((connected) {
      if (connected) {
        updateListeners();
      } else {
        listAllOffersSubscription?.cancel();
        listenAllOffersSubscription?.cancel();
        listCreatedOffersSubscription?.cancel();
        listenCreatedOffersSubscription?.cancel();
      }
    });

    // for filter debug
    filterSubject.listen((f) {
      print(f);
    });
  }

  @override
  void updateListeners() {
    listAllOffersSubscription?.cancel();
    listenAllOffersSubscription?.cancel();
    listCreatedOffersSubscription?.cancel();
    listenCreatedOffersSubscription?.cancel();

    listAllOffersSubscription = backend.get<InfListService>().listItems(filterSubject).listen(
      (items) {
        allOffersCache.addInfItems(items);
      },
      onError: (error) => print('Error in listAllOffersSubscription $error'),
    );

    listenAllOffersSubscription = backend.get<InfListService>().listenItemChanges(filterSubject).listen(
      (items) {
        allOffersCache.addInfItems(items);
        print("Listen update ${items.length} items");
      },
      onError: (error) => print('Error in listenAllOffersSubscription $error'),
    );

    listCreatedOffersSubscription =
        backend.get<InfListService>().listItems(filterCreatedOffersSubject).listen(
      (items) {
        userCreatedOffers.addInfItems(items);
      },
      onError: (error) => print('Error in listCreatedOffersSubscription $error'),
    );

    listenCreatedOffersSubscription =
        backend.get<InfListService>().listenItemChanges(filterCreatedOffersSubject).listen(
      (items) {
        print("Listen my offers update ${items.length} items");
        userCreatedOffers.addInfItems(items);
      },
      onError: (error) => print('Error in listenCreatedOffersSubscription $error'),
    );

     filterCreatedOffersSubject.add(userCreateOfferFilter);
  }

  @override
  void setFilter(Filter filter) {
    allOffersCache.clear();
    filterSubject.add(filter);
  }

  @override
  void flushCaches()
  {
      allOffersCache.clear();
      allOffersCache.updateOutput();
      userCreatedOffers.clear();
      userCreatedOffers.updateOutput();
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
