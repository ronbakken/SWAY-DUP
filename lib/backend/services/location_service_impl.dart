import 'dart:async';

import 'package:inf/backend/services/location_service_.dart';
import 'package:location/location.dart' as location;

class LocationServiceImplementation implements LocationService {
  final location.Location _plugin = location.Location();
  StreamController<Coordinate> _locationData;
  StreamSubscription<Map<String, double>> _locationSub;
  Coordinate _lastLocation;

  @override
  Stream<Coordinate> get onLocationChanged => _locationData.stream;

  @override
  Coordinate get lastLocation => _lastLocation;

  LocationServiceImplementation() {
    _locationData = StreamController<Coordinate>.broadcast(onListen: () {
      _locationSub = _plugin.onLocationChanged.listen(_onLocationChanged);
    }, onCancel: () {
      _locationSub.cancel();
    });
  }

  void _onLocationChanged(Map<String, double> location) {
    _lastLocation = Coordinate(location['latitude'], location['longitude']);
    _locationData.add(_lastLocation);
  }
}
