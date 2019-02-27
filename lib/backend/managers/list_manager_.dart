

import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

abstract class ListManager {

  Observable<List<InfItem>> get filteredListItems;
  
  void setFilter(Filter filter);

}