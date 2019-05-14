import 'dart:async';

import 'package:inf/domain/domain.dart';

abstract class ListManager {
  Stream<List<InfItem>> get listItems;

  void resetFilter();

  LocationFilter get filter;

  set filter(LocationFilter filter);

  void setMapBoundary(double nwLatitude, double nwLongitude, double seLatitude, double seLongitude, int zoomLevel);
}
