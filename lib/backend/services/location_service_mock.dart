import 'dart:async';

import 'package:inf/backend/services/location_service_.dart';

class LocationServiceMock implements LocationService {
  Coordinate _lastLocation = Coordinate(34.047259, -118.324178);

  @override
  Stream<Coordinate> get onLocationChanged =>
      _onLocationChangedController.stream;

  final StreamController<Coordinate> _onLocationChangedController =
      new StreamController.broadcast();

  LocationServiceMock() {
    _onLocationChangedController.add(_lastLocation);
  }

  @override
  Coordinate get lastLocation => _lastLocation;
}
