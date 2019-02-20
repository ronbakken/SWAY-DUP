

import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/managers/list_manager_.dart';
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

class ListManagerImplementation  implements ListManager {


  @override
  Observable<List<InfItem>> get filteredListItems => filteredListItemSubject;
  BehaviorSubject<List<InfItem>> filteredListItemSubject = BehaviorSubject<List<InfItem>>();

  BehaviorSubject<Filter> filterSubject = BehaviorSubject<Filter>();

  StreamSubscription listSubscription;


  ListManagerImplementation()
  {
    backend.get<InfApiClientsService>().connectionChanged.listen((connected) {
      if (connected) {
        listSubscription =
            backend.get<InfListService>().listItems(filterSubject.startWith(Filter())).listen( (items) {
              filteredListItemSubject.add(items);
            }); 
       } else {
        listSubscription?.cancel();
      }
    });

  }
  
}