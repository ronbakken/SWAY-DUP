import 'dart:async';

import 'package:inf/backend/services/location_service_.dart';
import 'package:rxdart/rxdart.dart';

class LocationServiceMock implements LocationService {
  final Coordinate _lastLocation = Coordinate(34.047259, -118.324178);

  @override
  Stream<Coordinate> get onLocationChanged => _onLocationChangedSubject;

  final BehaviorSubject<Coordinate> _onLocationChangedSubject =
      new BehaviorSubject<Coordinate>();

  LocationServiceMock() {
    _onLocationChangedSubject.add(_lastLocation);
  }

  @override
  Coordinate get lastLocation => _lastLocation;
}
