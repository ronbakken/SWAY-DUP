import 'dart:async';

class Coordinate {
  final double latitude;
  final double longitude;

  const Coordinate(this.latitude, this.longitude);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coordinate &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}

class GeoCodingResult {
  final Coordinate coordinate;
  final String name;

  GeoCodingResult(this.coordinate, this.name);
}

abstract class LocationService {
  Stream<Coordinate> get onLocationChanged;

  Coordinate get lastLocation;

  Future<List<GeoCodingResult>> lookUpPlaces({Coordinate nearby, String searchText});

  Future<List<GeoCodingResult>> lookUpCoordinates({Coordinate position, bool onlyAdresses});
}
