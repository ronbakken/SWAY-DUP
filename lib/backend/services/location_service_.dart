class Coordinate {
  final double latitude;
  final double longitude;

  const Coordinate(this.latitude, this.longitude);
}

abstract class LocationService {
  Stream<Coordinate> get onLocationChanged;

  Coordinate get lastLocation;
}
