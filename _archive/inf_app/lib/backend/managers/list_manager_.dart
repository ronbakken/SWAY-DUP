import 'dart:async';

import 'package:inf/domain/domain.dart';

abstract class ListManager {
  Stream<List<InfItem>> get listItems;

  void resetFilter();

  MapViewportFilter get filter;

  set filter(MapViewportFilter filter);

  void setMapBoundary(double nwLatitude, double nwLongitude, double seLatitude, double seLongitude, int zoomLevel);
}
