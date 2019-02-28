

import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

abstract class ListManager {

  Observable<List<InfItem>> get filteredListItems;

  Observable<List<InfItem>> get userCreatedItems;
  
  void setFilter(Filter filter);

}