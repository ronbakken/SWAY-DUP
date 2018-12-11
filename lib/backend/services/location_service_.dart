class Coordinate {
  final double latitude;
  final double longitude;

  const Coordinate(this.latitude, this.longitude);
}


class GeoCodingResult{
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
