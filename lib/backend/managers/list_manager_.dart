import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

abstract class ListManager {
  Observable<List<InfItem>> get filteredListItems;

  Observable<List<InfItem>> get userCreatedItems;

  void setFilter(Filter filter);

  void updateListeners();

  // clears caches and pushes an empty list to the UI
  void flushCaches();

  void setMapBoundary(double nwLatitude, double nwLongitude, double seLatitude, double seLongitude, double zoomLevel);
}
